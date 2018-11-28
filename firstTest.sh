#! /bin/bash

#Colors
GN='\033[0;32m' #Green
RD='\033[0;31m' #Red
MG='\033[0;95m' #Magenta
NC='\033[0m' # No Color

#Checking user from who was started script.
CURRENT_USER=$(logname)
USER=$(logname)

#Telling user the script is starting
echo -e "${MG} \n"
echo -e "VM Test Initializing . . ."
echo -e "${NC} \n"

#Check if directory exists
if [ -d "/Users/${CURRENT_USER}/VMBoxes/" ];  then
echo -e "${GN}\nI am going to place you new VM here: /Users/${CURRENT_USER}/VMBoxes/\n${NC}"
else 
cd ~/
mkdir -p VMBoxes
echo -e "/Users/${CURRENT_USER}/VMBoxes/ has been created. This is where your VMs will live."
fi

#Capture name for VM
echo -e "${GN} \n"
read -p "Enter the name for your VM: " NAME
echo -e "${NC} \n"
 
#Checking if VM already exists
if [ -d "/Users/${CURRENT_USER}/VMBoxes/${NAME}" ]; then
echo -e "${RD}\nPlease use a unique name to avoid conflicts${NC}\n"
echo -e "${RD}\n/Users/${CURRENT_USER}/VMBoxes/${NAME} already exists${NC}\n"
echo -e "${RD}\nExiting . . .${NC}\n"
exit 1
else

# Go into the directory to create the vm folder
cd ~/VMBoxes/
mkdir -p $NAME

# Go into the new folder and init Vagrant 
cd ~/VMBoxes/${NAME}
vagrant init ubuntu/xenial64
vagrant up
#Capture path to licenses and copy them to the path /VMBoxes/${NAME} and same for oracle
echo -e "${MG}"
read -p 'Do you have licenses? [Yy/Nn] ' LICENSE_ANSWER
echo -e "${NC}"

if [[ -z $LICENSE_ANSWER ]]
then
    LICENSE_ANSWER=N
fi

if [[ $LICENSE_ANSWER =~ ^[Yy]$ ]]
then
    echo -e "${MG}"
    read -p "Enter path to license files: [./] " LICENSE_PATH
    if [[ -z $LICENSE_PATH ]]
    then
            LICENSE_PATH="."
    fi
    echo -e "${NC}"
    cp $LICENSE_PATH/composer.{json,lock,json-dist} /Users/${CURRENT_USER}/VMBoxes/${NAME}
    if (( $? >= 1 ))
    then
            echo -e  "${RD}\nLicenses not found. Skipping.\n${NC}"
    else
            echo -e "\n${GN}Licenses copied. ${NC}\n"
    fi
fi

echo -e "${MG}"
read -p 'Do you have Oracle Drivers(18.3)? [Yy/Nn] ' ORACLE_ANSWER
echo -e "${NC}"

if [[ -z $ORACLE_ANSWER ]]
then
    ORACLE_ANSWER=N
fi

if [[ $ORACLE_ANSWER =~ ^[Yy]$ ]]
then
    echo -e "${MG}"
    read -p "Enter path to Oracle drivers: [./] " ORACLE_PATH
    if [[ -z $ORACLE_PATH ]]
    then
            ORACLE_PATH="."
    fi
    echo -e "${NC}"
    cp $ORACLE_PATH/instantclient-*.zip /Users/${CURRENT_USER}/VMBoxes/${NAME}
    if (( $? >= 1 ))
    then
            echo -e  "${RD}\nOracle drivers not found. Skipping.\n${NC}"
    else
            echo -e "\n${GN}Oracle drivers copied. ${NC}\n"
    fi
fi

cd /Users/${CURRENT_USER}/VMBoxes/${NAME}
ssh $(vagrant ssh-config | awk 'NR>1 {print " -o "$1"="$2}') localhost << HERE
whoami
CURRENT_USER=$(logname)
USER=$(logname)
TESTIN=Hello
echo ${CURRENT_USER}
echo ${USER}
echo ${SUDO_USER}
echo ${TESTIN}
read -p "Enter username for installation DreamFactory:" CURRENT_USER
# wget -O DFScript.sh https://raw.githubusercontent.com/dreamfactorysoftware/df-genie/vadimt-updated-script-ubuntu/DreamFactory_Ubuntu.sh?token=AixQO6LbWDdAqtrf7-umy2sXDOnYB8JRks5b-GVnwA%3D%3D
# sudo chmod +x DFScript.sh
# sudo ./DFScript.sh --with-mysql
#Prerequisites and PHP 7.2 install
# sudo apt-get -y install zip unzip
# sudo apt-get -y install software-properties-common python-software-properties
# sudo add-apt-repository -y ppa:ondrej/php
# sudo apt-get -y update
# sudo apt-get -y install php7.2 php7.2-cli php7.2-common
# sudo apt-get -y install php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip
# php -v
#Composer and Laravel install
# curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
HERE
#End of script. Tell them where to run vagrant up
echo -e "${GN}\nGo to${NC} ${MG}\n/Users/${CURRENT_USER}/VMBoxes/${NAME}${NC} ${GN}\nto SSH into your VM.${NC}" 
fi