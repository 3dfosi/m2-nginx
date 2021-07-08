#!/bin/bash

# Script to bring up a Magento 2 instance
# maintined by: hkdb <hkdb@3df.io>

APP_DOMAIN=$(grep APP_DOMAIN test.env | xargs)
IFS='=' read -ra APP_DOMAIN <<< "$APP_DOMAIN"
APP_DOMAIN=${APP_DOMAIN[1]}

echo ""
echo "####################################"
echo "  Magento 2 Automated Installation  "
echo ""
echo "           by: 3DF OSI              "
echo "####################################"
echo ""

read -p "Do you want to build a standalone Varnish container? (Y/n): " VARNISH
echo -e "\nLaunching base containers...\n"
SA_VARNISH=0
if [[ $VARNISH = "" ]] || [[ $VARNISH = "Y" ]] || [[ $VARNISH = "y" ]]; then
   SA_VARNISH=1
   docker-compose --env-file test.env -f docker-compose-wv.yml up -d
elif [[ $VARNISH = "N" ]] || [[ $VARNISH = "n" ]]; then
   docker-compose --env-file test.env -f docker-compose-nv.yml up -d
else
   read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' LANDING
   if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
      docker-compose --env-file test.env -f docker-compose-wv.yml up -d
   elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
      docker-compose --env-file test.env -f docker-compose-nv.yml up -d
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

echo -e "\nWaiting 5 seconds for containers to fully come up...\n"
sleep 5

echo -e "\nCreating magento db and user..."
cd db && ./initdb.sh && cd ../
echo ""

read -p "Magento landing Page is loading at https://$APP_DOMAIN? (Y/n): " LANDING
if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
   echo -e "\nSweet!\n"
elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
   echo -e "\nExiting...\n"
   exit
else
   read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' LANDING
   if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
      echo -e "\nSweet!\n"
   elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
      echo -e "\nExiting...\n"
      exit
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

echo -e "\nInstalling Magento 2...\n"
docker exec -ti m2-web sh -c 'su - magento -c "export APP_DOMAIN=$APP_DOMAIN && ./install.sh"'

read -p 'Magento Installation Completed. Would you like to configure REDIS? (Y/n): ' LANDING
if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
   echo -e "\nSweet!\n"
elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
   echo -e "\nExiting...\n"
   exit
else
   read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' LANDING
   if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
      echo -e "\nSweet!\n"
   elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
      echo -e "\nExiting...\n"
      exit
   else
      echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
      exit
   fi
fi
echo ""

echo -e "\nConfiguring REDIS...\n"
cd redis && ./configure.sh && cd ..
echo ""

if [[ $SA_VARNISH = 1 ]]; then
   read -p 'REDIS Installation Completed.\nWould you like to configure Varnish? (Y/n): ' LANDING
   if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
      echo -e "\nSweet!\n"
      echo -e "\nConfiguring Varnish...\n"
      cd web && ./configure-varnish.sh && cd ..
      echo -e "\nVarnish installed!\n"
      echo -e "\nWaiting for stunnel to come up...\n"
      sleep 10
   elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
      echo -e "\nYour Magento instance might be broken...\n"
      echo -e "\nExiting...\n"
      exit
   else
      read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' LANDING
      if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
         echo -e "\nSweet!\n"
         echo -e "\nConfiguring Varnish\n"
         cd web && ./configure-varnish.sh && cd ..
         echo -e "\nVarnish installed!\n"
         echo -e "\nWaiting for stunnel to come up...\n"
         sleep 10
      elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
         echo -e "\nYour Magento instance might be broken...\n"
         echo -e "\nExiting...\n"
         exit
      else
         echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
         exit
      fi
   fi
else
   read -p 'REDIS Installation Completed.\n\nWould you like to configure Varnish? (Y/n): ' LANDING
   if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
      echo -e "\nSweet!\n"
      echo -e "\nConfiguring Varnish...\n"
      cd varnish && ./configure.sh && cd ..
      echo -e "\nVarnish installed!\n"
   elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
      echo -e "\nExiting...\n"
      exit
   else
      read -p 'You must type "Y" for "Yes" or "N" for "No" as an answer: ' LANDING
      if [[ $LANDING = "" ]] || [[ $LANDING = "Y" ]] || [[ $LANDING = "y" ]]; then
         echo -e "\nSweet!\n"
         echo -e "\nConfiguring Varnish\n"
         cd varnish && ./configure.sh && cd ..
         echo -e "\nVarnish installed!\n"
      elif [[ $LANDING = "N" ]] || [[ $LANDING = "n" ]]; then
         echo -e "\nExiting...\n"
         exit
      else
         echo -e "\nInvalid input... exiting... Restart the script and try again... \n"
         exit
      fi
   fi
fi

echo ""
echo -e "\nYour Magento 2 instance is up and running... Enjoy!\n"
echo -e "\nVisit the site now at: https://$APP_DOMAIN\n"

