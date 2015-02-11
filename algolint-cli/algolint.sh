#!/bin/bash

if [ $# -eq 0 ]
then
    file=".altoken"
    if [ -f "$file" ]
    then
	echo "You are already loggedin in Algolint, \nUse 'algolint <filename>' to compile and test your code"
    else
	echo "Algolint is online code practice tool, please login with your credential to use"
	echo -n "Enter Your Email: " 
	read email
	echo -n "Enter Your Password: "
	stty -echo
	read password
	stty echo
	echo "\nChecking Credentials on Algolint.com"
	stty -echo
	curl -X POST "http://localhost:3001/login.json" -d "user[email]=$email&user[password]=$password" -s -o $file
	stty echo
	echo "\nWelcome $email,\nUse 'algolint <filename>' to compile and test your code"
    fi
else
    clear
    file=$1 
    auth=`cat .altoken`
    ext="${file##*.}"
    filetype=0
    ext=$(echo $ext | tr '[:upper:]' '[:lower:]')
    if [ "$ext" = "cpp"  ]
    then
	filetype=10
    fi
    if [ "$ext" = "java"  ]
    then
	filetype=20
    fi
    if [ "$ext" = "rb"  ]
    then
	filetype=30
    fi
    if [ "$ext" = "py"  ]
    then
	filetype=40
    fi

    db=".al-$file"
    code="$(cat $file)"

    op=".al-op"
    if [ -f "$db" ]
    then
	echo "Updating this file in algolint"
	fileid="$(cat $db)"
	curl -X PUT "http://localhost:3001/contents/$fileid.json?auth_token=$auth&compile=0&desc=&file_type=$filetype&folder_id=0&name=$file&sharability=0&status=0&cli=true" --data-urlencode "content=$code"
	echo "File updated in your algolint account"
	echo "compiling $file\n"
	curl -X GET "http://localhost:3001/compile-code?auth_token=$auth" -d "file_id=$fileid&cli=true" -s -o $op
	echo "\nOutput:\n"
	echo `cat $op`
	echo "\n\n"
    else	
	echo "Saving this file in algolint"
	curl -X POST "http://localhost:3001/contents.json?auth_token=$auth&compile=0&desc=&file_type=$filetype&folder_id=0&name=$file&sharability=0&status=0&cli=true" --data-urlencode "content=$code" -s -o $db
	echo "File saved in your algolint account"
	echo "compiling $file\n"
	fileid="$(cat $db)"
	curl -X GET "http://localhost:3001/compile-code?auth_token=$auth" -d "file_id=$fileid&cli=true" -s -o $op
	echo "\nOutput:\n"
	echo `cat $op`
	echo "\n\n"
    fi    
fi

