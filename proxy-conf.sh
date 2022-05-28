#! /usr/bin/env bash

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

command_exist () {
    if ! command -v $i > /dev/null ; then
        local command_exist_return="The command ${BRed}$1${Color_Off} is not installed in your system."
        printf "$command_exist_return"
    else
        local command_exist_return=""
        printf "$command_exist_return"
    fi
}

all_env=true

# process flags
pointer=1
param_count=0
while [[ $pointer -le $# ]]; do
   param=${!pointer}
   if [[ $param != "-"* ]]; then 
      ((pointer++)) # not a parameter flag so advance pointer
   else
      ((param_count++))
      case $param in
         # paramter-flags with arguments
         -u=*|--username=*) username="${param#*=}";;
         -p=*|--password=*) password="${param#*=}";;
         -s=*|--proxy=*) proxy="${param#*=}";;
         
         -h|--help) help_menu 
              exit 0;;
         -d|--delete) delete=true;;

         # binary flags
        #  -a|--all-env) all_env=true;;
         -e|--environment) environment=true; all_env=false;;
            --apt) apt=true; all_env=false;;
            --git) git=true; all_env=false;;
            --wget) wget=true; all_env=false;;
            --curl) curl=true; all_env=false;;
            --composer) composer=true; all_env=false;;
            --npm) npm=true; all_env=false;;
            --yarn) yarn=true; all_env=false;;
            --symfony) symfony=true; all_env=false;;

         -*) printf "Unknow or bad argument ${Red}${param}.${Color_Off}\n"
             view_help_msg
             exit 1;;
      esac

      # splice out pointer frame from positional list
      [[ $pointer -gt 1 ]] \
         && set -- ${@:1:((pointer - 1))} ${@:((pointer + 1)):$#} \
         || set -- ${@:((pointer + 1)):$#};
   fi
done

# if [[ -n $environment || -n $apt || -n $git || -n $wget || -n $curl || -n $composer || -n $npm || -n $yarn || -n $symfony ]]; then
#     all_env=false
# fi

if [[ $param_count == 0 ]]; then
    printf "Bad usage for ${Green}${0##*/}${Color_Off}\n"
    view_help_msg
    exit 1
fi

if [[ $all_env == true ]]; then
    environment=true
    apt=true
    curl=true
    wget=true
    git=true
    npm=true
    yarn=true
    composer=true
    symfony=true
fi


if [[ -n $delete ]]; then
    if [[ -n $username || -n $password || -n $proxy ]]; then
        printf "If ${Red}[-d]${Color_Off} flag is active, then options ${Red}[-u -p -s]${Color_Off} can't be used.\n"
        view_help_msg
        exit 1
    fi

    if [[ $delete == true && $all_env == true ]]; then
        printf "Delete proxy config for all environments:\n"
    fi
else
    if [[ -z $username ]]; then
        printf "The option ${Red}[-u=USERNAME]${Color_Off} is necesary.\n"
        view_help_msg
        exit 1
    else
        if [[ ! $username =~ ^[a-z]{2,30}\.[a-z]{2,30}$ ]]; then
            printf "The username ${Red}${username}${Color_Off} is not allow.\n"
            view_help_msg
            exit 1
        fi
    fi

    if [[ -z $password ]]; then
        printf "The option ${Red}[-p=PASSWORD]${Color_Off} is necesary.\n"
        view_help_msg
        exit 1
    fi

    if [[ -z $proxy ]]; then
        printf "The option ${Red}[-s=IP:PORT]${Color_Off} is necesary.\n"
        view_help_msg
        exit 1
    else
        if [[ ! $proxy =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}(\:[0-9]+)$ ]]; then
            printf "The ${Red}server=$proxy${Color_Off} is not allow.\n"
            view_help_msg
            exit 1
        fi
    fi

    if [[ -n $username && -n $password && -n $proxy ]]; then
        URL="http://$username:$password@$proxy"
        printf "Proxy URL:${On_IGreen} ${URL} ${Color_Off}\n"
    fi

    if [[ $all_env == true ]]; then
        printf "Setting proxy for all environments:\n"
    fi
fi


######################
# Environement Variables
######################
if [[ -n $environment && $environment == true ]]; then
    if [[ $delete == true ]]; then
        # unset http_proxy
        # unset HTTP_PROXY
        # unset https_proxy
        # unset HTTPS_PROXY
        # unset HTTP_PROXY_REQUEST_FULLURI
        # unset HTTPS_PROXY_REQUEST_FULLURI
        # unset no_proxy
        # unset NO_PROXY
        # unset ftp_proxy
        # unset dns_proxy
        # unset rsync_proxy
        # unset all_proxy
        printf "... Delete proxy variables from environment: ${BGreen}OK${Color_Off}\n"
    else
        # export http_proxy="${URL}"
        # export HTTP_PROXY="${URL}"
        # export https_proxy="${URL}"
        # export HTTPS_PROXY="${URL}"
        # export HTTP_PROXY_REQUEST_FULLURI=0 # or false
        # export HTTPS_PROXY_REQUEST_FULLURI=0
        # export no_proxy="127.0.0.10/8, localhost, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16"
        # export NO_PROXY="127.0.0.10/8, localhost, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16"
        # export ftp_proxy="${URL}"
        # export dns_proxy="${URL}"
        # export rsync_proxy="${URL}"
        # export all_proxy="${URL}"
        printf "... Set proxy variables for environment: ${BGreen}OK${Color_Off}\n"
    fi
fi

######################
# APT SETTINGS
######################
if [[ -n $apt && $apt == true ]]; then
    if [[ $delete == true ]]; then
        # sudo sed -i '/Proxy/d' /etc/apt/apt.conf
        printf "... Delete proxy config for apt: ${BGreen}OK${Color_Off}\n"
    else
        # printf "Acquire::http::Proxy \"${URL}\"\n" | sudo tee /etc/apt/apt.conf > /dev/null
        # printf "Acquire::https::Proxy \"${URL}\"\n" | sudo tee -a /etc/apt/apt.conf > /dev/null
        printf "... Set proxy for apt: ${BGreen}OK${Color_Off}\n"
    fi
fi

######################
# GIT SETTINGS
######################
if [[ -n $git && $git == true ]]; then
    if command -v git > /dev/null ; then
        if [[ $delete == true ]]; then
            if git config --global --unset attp.proxy > /dev/null; then
                delete_proxy_msg "git" true
            else
                delete_proxy_msg "git" false "... ... There is no proxy config defined for git."
            fi
        else
            if command -v git > /dev/null ; then
                # git config --global http.proxy ${URL}
                printf "... Set proxy config for git: ${BGreen}OK${Color_Off}\n"
            fi
        fi
    else
        printf "The command ${BRed}git${Color_Off} is not installed in your system."
    fi
fi

######################
# WGET SETTINGS
######################
if [[ -n $wget && $wget == true ]]; then
    if command -v wget > /dev/null ; then
        if [[ $delete == true ]]; then
            printf "... Delete proxy config for wget: "
            if [[ -s ~/.wgetrc ]]; then 
                # sed -i '/proxy/d' ~/.wget
                printf "${BGreen}OK${Color_Off}\n"
            else
                printf "${BRed}FAIL${Color_Off}\n"
                file_error_msg '~/.wgetrc'
            fi
        else
            # echo "https_proxy = ${URL}/" > ~/.wgetrc
            # echo "http_proxy = ${URL}/" >> ~/.wgetrc
            # echo "ftp_proxy = ${URL}/" >> ~/.wgetrc
            # echo "use_proxy = on" >> ~/.wgetrc
            printf "... Set proxy config for wget: ${BGreen}OK${Color_Off}\n"
        fi
    else
        printf "The command ${BRed}wget${Color_Off} is not installed in your system."
    fi
fi

######################
# CURL SETTINGS
######################
if [[ -n $curl && $curl == true ]]; then
    if command -v curl > /dev/null ; then
        if [[ $delete == true ]]; then
            printf "... Delete proxy config for curl: "

            if [[ -s ~/.curlrc ]]; then
                # sed -i '/proxy/d' ~/.curlrc
                printf "${BGreen}OK${Color_Off}\n"
            else
                printf "${BRed}FAIL${Color_Off}\n"
                file_error_msg '~/.curlrc'
            fi
        else
            # echo "proxy=${URL}" > ~/.curlrc
            printf "... Set proxy config for curl: ${BGreen}OK${Color_Off}\n"
        fi
    else
        printf "The command ${BRed}curl${Color_Off} is not installed in your system."
    fi
fi

######################
# COMPOSER SETTINGS
######################
if [[ -n $composer && $composer == true ]]; then
    if command -v composer > /dev/null ; then
        if [[ $delete == true ]]; then
            if [[ -z $environment ]]; then
                # unset http_proxy
                # unset HTTP_PROXY
                # unset https_proxy
                # unset HTTPS_PROXY
                # unset HTTP_PROXY_REQUEST_FULLURI
                # unset HTTPS_PROXY_REQUEST_FULLURI
                # unset no_proxy
                # unset NO_PROXY
                echo
            fi
            printf "... Delete proxy config for composer: ${BGreen}OK${Color_Off}\n"
        else
            if [[ -z $environment ]]; then
                # export http_proxy="${URL}"
                # export HTTP_PROXY="${URL}"
                # export https_proxy="${URL}"
                # export HTTPS_PROXY="${URL}"
                # export HTTP_PROXY_REQUEST_FULLURI=0 # or false
                # export HTTPS_PROXY_REQUEST_FULLURI=0 #
                # export no_proxy="127.0.0.10/8, localhost, 10.20.0.0/8, 172.16.0.0/12, 192.168.0.0/16"
                # export NO_PROXY="127.0.0.10/8, localhost, 10.20.0.0/8, 172.16.0.0/12, 192.168.0.0/16"
                echo
            fi
            printf "... Set proxy config for composer: ${BGreen}OK${Color_Off}\n"
        fi
    else
        printf "The command ${BRed}composer${Color_Off} is not installed in your system."
    fi
fi

######################
# NPM SETTINGS
######################
if [[ -n $npm && $npm == true ]]; then
    if command -v npm > /dev/null ; then
        if [[ $delete == true ]]; then
            # npm config delete proxy http_proxy http-proxy https_proxy https-proxy registry strict-ssl
            printf "... Delete proxy config for npm: ${BGreen}OK${Color_Off}\n"
        else
            # npm config set registry http://registry.npmjs.org/
            # npm config set proxy "${URL}"
            # npm config set https-proxy "${URL}"
            # npm config set strict-ssl false
            # echo "registry=http://registry.npmjs.org/" > ~/.npmrc
            # echo "proxy=${URL}" >> ~/.npmrc
            # echo "strict-ssl=false" >> ~/.npmrc
            # echo "http-proxy=${URL}" >> ~/.npmrc
            # echo "http_proxy=${URL}" >> ~/.npmrc
            # echo "https_proxy=${URL}" >> ~/.npmrc
            # echo "https-proxy=${URL}" >> ~/.npmrc
            printf "... Set proxy for npm: ${BGreen}OK${Color_Off}\n"
        fi
    else
        printf "The command ${BRed}npm${Color_Off} is not installed in your system."
    fi
fi

######################
# YARN SETTINGS
######################
if [[ -n $yarn && $yarn == true ]]; then
    if command -v yarn > /dev/null ; then
        if [[ $delete == true ]]; then
            # yarn config delete proxy > /dev/null
            # yarn config delete https-proxy > /dev/null
            # yarn config delete strict-ssl > /dev/null
            printf "... Delete proxy config for yarn: ${BGreen}OK${Color_Off}\n"
        else
            # yarn config set proxy ${URL} > /dev/null
            # yarn config set https-proxy ${URL} > /dev/null
            # yarn config set strict-ssl false > /dev/null
            printf "... Set proxy config for yarn: ${BGreen}OK${Color_Off}\n"
        fi
    else
        printf "The command ${BRed}yarn${Color_Off} is not installed in your system."
    fi
fi

######################
# SYMFONY SETTINGS
######################
if [[ -n $symfony && $symfony == true ]]; then
    if command -v symfony > /dev/null ; then
        if [[ $delete == true ]]; then
            if [[ -z $environment ]]; then
                # unset http_proxy
                # unset https_proxy
                echo
            fi
            printf "... Delete proxy config for symfony: ${BGreen}OK${Color_Off}\n"
        else
            if [[ -z $environment ]]; then
                # export http_proxy="${URL}"
                # export https_proxy="${URL}"
                echo
            fi
            printf "... Set proxy config for symfony: ${BGreen}OK${Color_Off}\n"
        fi
    else
        printf "The command ${BRed}symfony${Color_Off} is not installed in your system."
    fi
fi

printf "\n"
exit 0
