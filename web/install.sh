#!/bin/bash

# Automated advanced install script to be run in container the first time it's launched.
# maintained by hkdb <hkdb@3df.io>

if [[ $USER != "magento" ]]; then
   echo "This script should be run by the magento user. To switch to that user, execute "su - magento" without the quotes..."
   exit
fi

echo -e "\nLet's get Magento 2 installed!\n\n"

read -p 'Use HTTPS for your shop? (Y/n): ' SECURE
if [[ $SECURE = "" ]] || [[ $SECURE = "Y" ]] || [[ $SECURE = "y" ]]; then
   ONE="1"
   SECURE="YES"
elif [[ $SECURE = "N" ]] || [[ $SECURE = "n" ]]; then
   ONE="0"
   SECURE="NO"
else
   read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' SECURE
   if [[ $SECURE = "" ]] || [[ $SECURE = "Y" ]] || [[ $SECURE = "y" ]]; then
      ONE="1"
      SECURE="YES"
   elif [[ $SECURE = "N" ]] || [[ $SECURE = "n" ]]; then
      ONE="0"
      SECURE="NO"
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

read -p "What would you like the base URL to be? (DEFAULT: https://$APP_DOMAIN): " BASE_URL 
if [[ $BASE_URL != "" ]]; then
   TWO=$BASE_URL
   NINE=$BASE_URL
else
   TWO="https://$APP_DOMAIN"
   NINE=$TWO
   BASE_URL=$TWO
fi
echo ""

read -p 'Use HTTPS for Admin Dashboard? (Y/n): ' SECURE_ADMIN
if [[ $SECURE_ADMIN = "" ]] || [[ $SECURE_ADMIN = "Y" ]] || [[ $SECURE_ADMIN = "y" ]]; then
   THREE="1"
   SECURE_ADMIN="YES"
elif [[ $SECURE_ADMIN = "N" ]] || [[ $SECURE_ADMIN = "n" ]]; then
   THREE="0"
   SECURE_ADMIN="NO"
else
   read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' SECURE_ADMIN
   if [[ $SECURE_ADMIN = "" ]] || [[ $SECURE_ADMIN = "Y" ]] || [[ $SECURE_ADMIN = "y" ]]; then
      THREE="1"
      SECURE_ADMIN="YES"
   elif [[ $SECURE_ADMIN = "N" ]] || [[ $SECURE_ADMIN = "n" ]]; then
      THREE="0"
      SECURE_ADMIN="NO"
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

read -p 'Admin First Name: ' ADMFN
if [[ $ADMFN != "" ]]; then
   FOUR=$ADMFN
else
   read -p 'Your answer must not be empty: ' ADMFN
   if [[ $ADMFN != "" ]]; then
      FOUR=$ADMFN
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

read -p 'Admin Last Name: ' ADMLN
if [[ $ADMLN != "" ]]; then
   FIVE=$ADMLN
else
   read -p 'Your answer must not be empty: ' ADMLN
   if [[ $ADMLN != "" ]]; then
      FIVE=$ADMLN
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

read -p 'Admin E-Mail: ' ADMEM
if [[ $ADMEM != "" ]]; then
   SIX=$ADMEM
else
   read -p 'Your answer must not be empty: ' ADMEM
   if [[ $ADMEM != "" ]]; then
      SIX=$ADMEM
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

read -p 'Admin Username: ' ADMU
if [[ $ADMU != "" ]]; then
   SEVEN=$ADMU
else
   read -p 'Your answer must not be empty: ' ADMU
   if [[ $ADMU != "" ]]; then
      SEVEN=$ADMU
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

read -sp 'Admin Password: ' ADMP
if [[ $ADMP != "" ]]; then
   echo ""
   read -sp 'Confirm Password: ' CADMP
   if [[ $CADMP = $ADMP ]]; then
      EIGHT=$ADMP
   else
      echo ""
      read -sp 'Your passwords did not match... try again: ' ADMP
      if [[ $ADMP != "" ]]; then
         echo ""
         read -sp 'Confirm Password: ' CADMP
         if [[ $CADMP = $ADMP ]]; then
            EIGHT=$ADMP
         else
            echo -e "\nToo many failed attempts... exiting..."
            exit
         fi
       else
         echo -e "\nToo many failed attempts... exiting..."
         exit
       fi
   fi
else
   read -sp 'Your answer must not be empty, enter your password: ' ADMP
   if [[ $ADMP != "" ]]; then
      echo ""
      read -sp 'Confirm Password: ' CADMP
      if [[ $CADMP = $ADMP ]]; then
         EIGHT=$ADMP
      else
         echo ""
         read -sp 'Your passwords did not match... try again: ' ADMP
         if [[ $ADMP != "" ]]; then
            echo ""
            read -sp 'Confirm Password: ' CADMP
            if [[ $CADMP = $ADMP ]]; then
               EIGHT=$ADMP
            else
               echo ""
               echo -e "Too many failed attempts... exiting..."
               exit
            fi
         else
            echo ""
            echo -e "Too many failed attempts... exiting..."
            exit
         fi
      fi
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""
echo ""

read -p 'Admin Dashboard Frontname (ie. admin_jksljk or a unique word): ' ADM_URL
if [[ $ADM_URL != "" ]]; then
   TEN=$ADM_URL
else
   read -p 'Your answer must not be empty: ' ADM_URL
   if [[ $ADM_URL != "" ]]; then
      TEN=$ADM_URL
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

DBH="m2-db"
ELEVEN=$DBH
DBN="magento"
TWELVE=$DBN
DBU="magento"
THIRTEEN=$DBU
DBP="password"
FOURTEEN=$DBP

echo -e "\nDouble Check Your Config:\n\n"

echo "--use-secure: $SECURE"
echo "--base-url-secure: $BASE_URL"
echo "--use-secure-admin: $SECURE_ADMIN"
echo "--admin-firstname: $ADMFN"
echo "--admin-lastname: $ADMLN"
echo "--admin-email: $ADMEM"
echo "--admin-user: $ADMU"
echo "--base-url: $BASE_URL"
echo "--backend-frontname: $ADM_URL"
echo "--db-host: $DBH"
echo "--db-name: $DBN"
echo "--db-user: $DBU"
echo ""

EXEC=0

read -p 'Does everything look alright? (Y/n): ' CONFIRM
if [[ $CONFIRM = "" ]] || [[ $CONFIRM = "Y" ]] || [[ $CONFIRM = "y" ]]; then
   EXEC=1
elif [[ $CONFIRM = "N" ]] || [[ $CONFIRM = "n" ]]; then
   EXEC=0
else
   read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' CONFIRM
   if [[ $CONFIRM = "" ]] || [[ $CONFIRM = "Y" ]] || [[ $CONFIRM = "y" ]]; then
      EXEC=1
   elif [[ $CONFIRM = "N" ]] || [[ $CONFIRM = "n" ]]; then
      EXEC=0
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

if [[ EXEC = 0 ]]; then
   echo "O Oh... I guess you will have to start all over again... exiting..."
   exit
else
   echo -e "Here's the command we are about to execute. You may want to copy it for your records or maybe for if something goes wrong and you want to just tweak the command and run it again manually:\n\n"

   echo -e "bin/magento setup:install --use-secure $ONE --base-url-secure $TWO --use-secure-admin $THREE --admin-firstname $FOUR --admin-lastname $FIVE --admin-email $SIX --admin-user $SEVEN --admin-password <REPLACE ME> --base-url $NINE --backend-frontname $TEN --db-host $ELEVEN --db-name $TWELVE --db-user $THIRTEEN --db-password <REPLACE ME>"
fi
echo ""

bin/magento setup:install --use-secure $ONE \
                          --base-url-secure $TWO \
                          --use-secure-admin $THREE \
                          --admin-firstname $FOUR \
                          --admin-lastname $FIVE \
                          --admin-email $SIX \
                          --admin-user $SEVEN \
                          --admin-password $EIGHT \
                          --base-url $NINE \
                          --backend-frontname $TEN \
                          --db-host $ELEVEN \
                          --db-name $TWELVE \
                          --db-user $THIRTEEN \
                          --db-password $FOURTEEN

bin/magento mo:di Magento_TwoFactorAuth

echo -e "Installing cronjob..."

bin/magento cron:install
