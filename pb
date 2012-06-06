#!/bin/bash
# Crouse's sqlite+bash phonebook 
# Shows how to use sqlite in a bash script.
# 06-05-2012 crouse@usalug.net

# Check if requirements are installed. 
clear
if [[ -z $( type -p sqlite ) ]]; then echo -e "REQUIRED: sqlite ver 3 or higher -- NOT INSTALLED !";exit ;fi

# Check if database already exists, if not, create it.
database="/home/$USER/.phonebook.db"
 if [ -e "$database" ];then
     echo ""
 else
     echo "Datase does not exist - Creating now"
sqlite $database "create table phonebook (id INTEGER PRIMARY KEY,First TEXT,Last TEXT,Street TEXT,City TEXT,State TEXT,Zip TEXT,Phone TEXT,Email TEXT, Notes);"
    echo "Database created at $database"
 fi

# Check options given to the program and "do stuff".
case ${1} in
 
# oops--you didn't give me anything
"") echo "Crouse's sqlite+bash phonebook"
    echo "================================"
    echo "Usage: ${0##*/} <option>";
    echo "";
    echo "  --------------------"    
    echo " Create an entry"
    echo "   $0 -c"
    echo "  --------------------"
    echo " Search by last name \"-l";
    echo "       -l Smith";
    echo "";
    echo " Search by phone number";
    echo "       -p 515-555-5555";
    echo ""
    echo " Search by email address";
    echo "       -em davec@netins.net";
    echo ""
    echo " Search by first name with no flags";
    echo "   $0 dave";
    echo "  --------------------"
    echo " Edit an entry"
    echo "   $0 -e"
    echo "================================"
    echo ""
;;

# Create an entry
"-c")
clear
echo "Phone Book - Insert data into database"
echo "--------------------------------------"
echo "FORMAT: First Name,Last Name,Street,City,State,Zip,Phone,Email,Notes"
echo " "

#Insert data into database
read -p "First Name: " First
read -p " Last Name: " Last
read -p "    Street: " Street
read -p "      City: " City
read -p "     State: " State
read -p "       Zip: " Zip
read -p "     Phone: " Phone
read -p "     Email: " Email
read -p "     Notes: " Notes
 
sqlite $database "insert into phonebook (First,Last,Street,City,State,Zip,Phone,Email,Notes) values ('$First','$Last','$Street','$City','$State','$Zip','$Phone','$Email','$Notes');"
 
#clear
echo "-----------------------------"
echo "Data Entered into Database"
;;

 
# Edit an entry
"-e")
clear
# reset all variables to null
First=""
Last=""
Street=""
City=""
State=""
Zip=""
Phone=""
Email=""
Notes=""

read -p  "Enter id# to edit: " idnum
echo ""

sqlite $database<<EOF
.header off
.mode line
select id,First,Last,Street,City,State,Zip,Phone,Email,Notes from phonebook WHERE id = '${idnum}';
.quit
EOF

echo ""
echo "Hitting enter will just leave that line as is."
echo ""
echo "-----------------------------------------------"
#Insert data into database
read -p "First Name: " First
read -p " Last Name: " Last
read -p "    Street: " Street
read -p "      City: " City
read -p "     State: " State
read -p "       Zip: " Zip
read -p "     Phone: " Phone
read -p "     Email: " Email
read -p "     Notes: " Notes
 
echo ""

if [[ "$First" != "" ]]; then
  sqlite $database "UPDATE phonebook SET First = '${First}' WHERE id='${idnum}';"
fi

if [[ "$Last" != "" ]]; then
  sqlite $database "UPDATE phonebook SET Last = '${Last}' WHERE id='${idnum}';"
fi

if [[ "$Street" != "" ]]; then
  sqlite $database "UPDATE phonebook SET Street = '${Street}' WHERE id='${idnum}';"
fi

if [[ "$City" != "" ]]; then
  sqlite $database "UPDATE phonebook SET City = '${City}' WHERE id='${idnum}';"
fi

if [[ "$State" != "" ]]; then
  sqlite $database "UPDATE phonebook SET State = '${State}' WHERE id='${idnum}';"
fi

if [[ "$Zip" != "" ]]; then
  sqlite $database "UPDATE phonebook SET Zip = '${Zip}' WHERE id='${idnum}';"
fi

if [[ "$Phone" != "" ]]; then
  sqlite $database "UPDATE phonebook SET Phone = '${Phone}' WHERE id='${idnum}';"
fi

if [[ "$Email" != "" ]]; then
  sqlite $database "UPDATE phonebook SET Email = '${Email}' WHERE id='${idnum}';"
fi

if [[ "$Notes" != "" ]]; then
  sqlite $database "UPDATE phonebook SET First = '${Notes}' WHERE id='${idnum}';"
fi
;;



# Search by last name
"-l")
echo ""
sqlite $database<<EOF
.header off
.mode line
select id,First,Last,Street,City,State,Zip,Phone,Email,Notes from phonebook WHERE Last LIKE '%${2}%';
.quit
EOF
;;
 
# Search by phone
"-p")
echo ""
sqlite $database<<EOF
.header off
.mode line
select id,First,Last,Street,City,State,Zip,Phone,Email,Notes from phonebook WHERE Phone LIKE '%${2}%';
.quit
EOF
;;
 
# Search by email
"-em")
echo ""
sqlite $database<<EOF
.header off
.mode line
select id,First,Last,Street,City,State,Zip,Phone,Email,Notes from phonebook WHERE Email LIKE '%${2}%';
.quit
EOF
;;
 
# Search by first name for all others
*)
echo "";
sqlite $database<<EOF
.header off
.mode line 
select id,First,Last,Street,City,State,Zip,Phone,Email,Notes from phonebook WHERE First LIKE '%${1}%';
.quit
EOF
;;
 
esac
echo ""
exit 0

