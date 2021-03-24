#COMMAND LINE TEST

#!/bin/bash`

#*****************************************************************************************************************************************
#                                        function to prompt the user to give username to signup
#*****************************************************************************************************************************************

function signup_username
{
    unset name  
    echo -e "\e[1mUsername\e[0m :" # prompt the user to give username
    read name
    if [ "$name" == "`echo $name | grep -e "[a-zA-Z]" -e "[a-ZA-Z]" `" ] # to check if username alphabet characters
    then
        user_unique ${name} #check if username already exists
        echo -n "$name"  >> user.csv #save unique username to user.csv
        return 1
    else
        echo -e "\e[1;31mInvalid input. Try again\e[0m"
        signup_username #ask user to enter username again as it is not unique
    fi
}

#*****************************************************************************************************************************************
#                                                 function to take password to signup
#*****************************************************************************************************************************************

function signup_password
{
    unset pass
    # prompt user to enter password
    echo -e "\e[1mPassword\e[0m\e[1;91m(should contain atleast a number and a symbol and min. 8 characters)\e[0m:"
    read -s pass
    if [[ $pass =~ ^.*[0-9].*$ ]] && [[ $pass =~ ^.*[!@#$%^\&\*].*$ ]] && [[ ${#pass} -ge 8 ]]
        #to check if password has atleast one number,one special character and atleast 8 characters long
    then
        echo
        echo Re-enter the password
        read -s repass
        echo
        if [ "$repass" == "$pass" ] # enter when the password and re entered password is matching
        then
            echo -n ",$pass" >> user.csv
            #add password to database with respective username
            echo >> user.csv
            echo -e "\e[36;1mSignup Successful\e[0m" #password and username meet requirements
            sleep 2  
        else
            echo -e "\e[1;31mInvalid input!!Try again (password not matching re-entered password)\e[0m"
            signup_password #ask user to enter password again as not matching re-entered password
        fi
    else
        echo -e "\e[1;31mInvalid input!!Try again (password not matching requirements)\e[0m"
        signup_password #ask user to enter password again as not matching requirements
    fi
}

#*****************************************************************************************************************************************
#                                             function to check if username is unique 
#*****************************************************************************************************************************************

function user_unique
{
    match=0 # initialize varible to zero
    num=`cat user.csv | wc -l` #number of users that have signed up
    existname=(`cut -d "," -f 1 user.csv`) #usernames stored in an array
    for user in ${existname[@]}
    do
        if [ "$1" == "$user" ] #match user input with names in database
        then
            match=`expr $match + 1` #increament if match
        fi
    done
    if [ $match -eq 0 ] # enter when username is unique
    then
        return 1
    else   # enter when username is not unique and ask for the username again
        echo -e "\e[1;31mUsername already exists.Please enter a different username\e[0m"
        signup_username
    fi
}

#*****************************************************************************************************************************************
#                       function to check if username entered by user to sign in present in user.csv
#*****************************************************************************************************************************************

function signin_valid
{
    match=0 # initialize variable to zero
    num=`cat user.csv | wc -l` 
    existname=(`cut -d "," -f 1 user.csv`) # usernames stored in an array

    for user in ${existname[@]} # check if the entered username exists 
    do
        if [ "$1" == "$user" ]   # enter when username exists
        then
            respass=`grep $1 user.csv | cut -d "," -f 2`
            #password to the respective user

            return 1 #exit function as username matches entry in database
        else
            match=`expr $match + 1` #increament if name doesnt match entry in database
            continue
        fi
    done

    if [ $match -gt 0 ] # enter when username not present
    then
        echo -e "\e[1;31mUsername not present!!Try again\e[0m"
        signin_username # ask user to follow signin procedure again as name doesnt match
        #entry in data base
    fi
}

#*****************************************************************************************************************************************
#                                                       function for signin
#*****************************************************************************************************************************************

function signin_username
{
    unset name
    echo -e "\e[1mUsername:\e[0m" # prompt user to enter username
    read name
    signin_valid ${name}  # to validate user based on presence in data base
}

#*****************************************************************************************************************************************
#                                                     function password for signin 
#*****************************************************************************************************************************************

function signin_pass
{
    echo -e "\e[1mPassword:\e[0m" # prompt user to enter password
    read -s pass
    if [ $pass == $respass ] #to match password with password given
        #  at the time of signup
    then
        echo
        echo -e "\e[36;1mSignin Successfull\e[0m"
        sleep 2
        return 1 # exit function if passwords match
    else
        echo -e "\e[1;31mIncorrect!!Try again\e[0m"
        signin_pass #ask user to give password again as doesnt match entry in data base
    fi
}

#*****************************************************************************************************************************************
#                                                         function of timer
#*****************************************************************************************************************************************

function timer()
{

    count=10 # initalize count with 10, 10 seconds time given for each answer
    while (( count > 0 )) # when count greater than zero enter loop
    do
        sleep 1 # one second gap
        count=$(($count-1)) # decrement the count
        echo -ne "                                                                                         :Time Remaining:$count\033[0K\r"
    done
}

#*****************************************************************************************************************************************
#                                                 function to ask user after sign in 
#*****************************************************************************************************************************************

function signin_option
{
    echo -e "\e[1mWould you like to take the test?\e[0m" # prompt user to enter option
    echo  "          1-Take test "
    echo  "          2-Exit to main Menu(Signout)     "
    read opt
    case $opt in
        1) echo "Press enter to start the test" # start test
            exam
            ;;
        2) exit  #exit program
            ;;
        *) echo "Please select option 1 or 2" # when invalid option is given
            clear
            signin_option
            ;;
    esac
}

#*****************************************************************************************************************************************
#----------------------------------------------------------main function------------------------------------------------------------------
#*****************************************************************************************************************************************

function menu
{
    clear
    echo
    echo -e " \e[1;32m-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-\e[0m  "
    echo
    echo -e "                                                                \e[1;5;96mWELCOME\e[0m                                        "
    echo
    echo -e "                                                           \e[1;5;31mCOMMAND LINE TEST\e[0m            "
    echo
    echo -e " \e[1;32m-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-\e[0m  "
    echo
    echo -e "\e[1mPlease select an option\e[0m :" # ask user to enter option
    echo
    echo "            1-Signup"
    echo "            2-Signin"
    echo "            3-Exit"
    echo
    read -s -t 10 option
    echo

    # cases for the option entered
    case $option in
        1) clear   # when user entered 1
            echo -e "                                                     \e[1;32mSIGN UP PAGE\e[0m"
            echo
            signup_username  #call functions related to signup
            echo
            signup_password
            echo
            clear
            bash code.sh 
            ;;
        2)  clear # when user is entered 2
            echo -e "                                                     \e[1;32mSIGN IN\e[0m"
            echo
            signin_username  #call functions related to signin
            echo
            signin_pass # function call
            echo
            signin_option # function call
            ;;
        3) exit # when user enters 2
            ;;
        *) echo "Please enter valid option"
            sleep 2
            bash code.sh  # execute the code again
            ;;
    esac
}
menu

#*****************************************************************************************************************************************
#                                                    function for taking up the test
#*****************************************************************************************************************************************

function exam
{
    random=(`shuf -i 1-10 -n  10`) # shuffle the questions
    originalans=(`sed 's/;/ /g' answers.txt`) # answers for the questions
    total=0
    count=1 # question number count


    for i in `seq 0 $((${#random[@]}-1))` # loop for all the questions
    do
        clear
        echo -n "($count)"
        cat ./question_bank/question${random[i]}.txt # select and display a random question
        echo 
        echo -e "\e[36m______________________________________________________________________________________________________________________________________________\e[0m"
        echo "Your answer:"
        count=$(($count+1)) # increment the count of the question number
        echo " "

        timer &  # call functioon timer
        read -t 30 answer # answer given by the user
        kill $!
        clear

        if [[ $answer =~ ^[a-d]+$ ]] # answer entered by the user
        then

            echo $answer >> userans.txt
        else # when user gives invalid option
            echo -e "Invalid Input Marks awarded will be 0"
            echo 0 >> userans.txt
        fi
        clear
    done

    #User answer text file renamed with another file to access the data
    userans=(`cat userans.txt`)

    #Declare an array for correct answer
    correctans=()

    #Comparing the answers with random questions
    #Comparing the user answer with correct answer

    for j in `seq 0 $((${#random[@]}-1))`
    do
        index=${random[j]}
        correctans+=(${originalans[$index-1]}) # storing the correct answers in an array

    done

    for k in `seq 0 $((${#random[@]}-1))` 
    do
        if [ "${correctans[k]}" == "${userans[k]}" ] # comapring answers given bythe user with original  answers
        then
            total=$(($total+1)) # increment when answer is correct
        fi
    done

    #Removing the user answer after taking the test
    rm userans.txt

    clear


    echo -e "  \e[36m####################################################################################################################\e[0m"
    echo -e "                                                       \e[1;32m TEST COMPLETED\e[0m   "
    echo -e "  \e[33m--------------------------------------------------------------------------------------------------------------------\e[0m"
    echo -e "                                                 ***  You scored \e[1;5;91m$total/10\e[0m  ***         "
    echo -e "  \e[36m####################################################################################################################:\e[0m"
    echo
    sleep 2 
}
exam

#*****************************************************************************************************************************************
#                                               Prompt the user to view and retake the test
#*****************************************************************************************************************************************

function endmenu( )
{

    echo "Please Select your option: " # prompt user to enter option
    echo "1.View test"
    echo "2.Retake test"
    echo "3.Exit"
    echo -n "choice :"
    read n

    case $n in
        1)
            echo "View the test:"
            echo -e "\e[33m--------------------------------------------------------------------------------------------------------------------\e[0m"
            for (( i=0; i<10; i++ ))
            do
                echo -n "$(($i+1))." #to print question number
                cat ./question_bank/question${random[i]}.txt
                echo "correct answer:"
                echo "${correctans[i]}" # displays the correct answer
                echo "Your answer:"
                echo "${userans[i]}" # displays the answer given by user
                echo " "
            done

            echo -e "\e[33m--------------------------------------------------------------------------------------------------------------------\e[0m"
            ;;

        2)bash code.sh #execute the code again
            ;;

        *)exit
            ;;

        esac
        while [ 1 ] # ask if the user wants to continue
        do
            echo -e "\e[1mDo you want continue ?\e[0m" # user wants to execute procedure again
            echo
            echo *Enter 'y' to continue
            echo *Enter 'n' to exit
            echo
            read opt
            if [ $opt == "y" ] # enter when user gives y
            then
                clear
                endmenu
            else  #exit the test
                clear
                echo " "
                echo -e " \e[1;36m##########################################################################################################\e[0m "
                echo -e "                                              \e[1;91mTHANK YOU\e[0m                                 "
                echo -e " \e[1;36m##########################################################################################################\e[0m "         
                sleep 2
                clear
                exit
            fi
        done
}
endmenu

#****************************************************************************************************************************************
#-------------------------------------------------------------END OF CODE----------------------------------------------------------------
#****************************************************************************************************************************************
