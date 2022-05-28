#! /usr/bin/env bash

URL="http://anisabel.galvez:Bebe-2013@10.20.0.21:3128"


# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

help_menu() {
  echo -e "Usage:

  ${Green}${0##*/}${Color_Off} ${Cyan}-u=USERNAME -p=PASSWORD -s=IP:PORT [FLAGS] | -d ${Color_Off}

Options:

  -u, --username=WORD.WORD  username for proxy.
  -p, --password=PASSWORD   user password for proxy.
  -s, --server=IP:PORT      proxy url. 

Flags:

  -h, --help          display this help and exit.
  -d, --delete        delete proxy configuration for all environment.
  -a, --all-env       Config proxy for all environments
  -e, --environment   Export proxy variables for environment
      --apt           Config proxy for apt
      --git           Config proxy for git
      --wget          Config proxy for wget
      --curl          Config proxy for curl
      --composer      Config proxy for composer
      --npm           Config proxy for npm
      --yarn          Config proxy for yarn
      --symfony       Config proxy for symfony
  "
}

view_help_msg () {
    printf "View ${Cyan}[-h]${Color_Off} help for more details.\n\n"
}

file_error_msg () {
    printf "${BRed}... The file $1 not exist or is empty.${Color_Off}\n"
}

delete_proxy_msg () {
    printf "... Delete proxy config for $1: "
    if [[ $2 == true ]]; then
        printf "${BGreen}OK${Color_Off}\n"
    else
        printf "${BRed}FAIL${Color_Off}\n"
        printf "$3\n"
    fi
}

if git config --global --unset attp.proxy; then 
    delete_proxy_msg "git" true
else 
    delete_proxy_msg "git" false "... ... There is no proxy config defined for git."
fi