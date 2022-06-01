#!/usr/bin/env bash

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

  ${Green}${0##*/}${Color_Off} ${Cyan}[-u=USERNAME -s=IP:PORT] [FLAGS] | [-d] [FLAGS] ${Color_Off}

  If do not expecify an environmet flag, the proxy config will set for all of then.

Options:

  -u, --username=WORD.WORD  username for proxy.
  -s, --server=IP:PORT      proxy url. 

Flags:

  -h, --help          display this help and exit.
  -d, --delete        delete proxy configuration for all environment.
  -f, --force         force the proxy config.

  -e, --environment   Set proxy variables for /etc/environment
  -b, --bash          Export proxy env variables for bash
  -z, --zsh           Export proxy env variables for zsh
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

set_proxy_msg () {
    printf "\n\--> Set proxy config for ${Green}$1${Color_Off}: "
    if [[ $2 == true ]]; then
        printf "${BGreen}OK${Color_Off}\n"
    else
        printf "${BRed}FAIL${Color_Off}\n"
        case $3 in
            "yet_exist") 
                printf ".... Allready exist a proxy config for ${Green}${1}${Color_Off}:\n";
                printf ".... ${Red}${4}${Color_Off}\n";
                use_force_msg
                ;;
            "no_create_file") 
                printf ".... Canceled by user.\n"
                ;;
        esac
    fi
}

delete_proxy_msg () {
    printf "... Delete proxy config for ${Green}$1${Color_Off}: "
    if [[ $2 == true ]]; then
        printf "${BGreen}OK${Color_Off}\n"
    else
        printf "${BRed}FAIL${Color_Off}\n"
        case $3 in
            "no_config") 
                printf ".... There is no proxy config defined for ${Green}${1}${Color_Off}.\n"
                ;;
            "no_file") 
                printf "... The file ${BRed}${4}${Color_Off} not exist or is empty.\n"
                ;;
        esac

    fi
}

use_force_msg () {
    printf ".... If you want to force override this config use ${Cyan}[-f]${Color_Off} flag.\n"
}

command_exist (){
    printf "The command ${BRed}$1${Color_Off} is not installed in your system."
}

handle_zsh () {
    if [[ $1 == "set" ]]; then
        echo "#! /usr/bin/env zsh

[[ ! -f ~/.zshrc ]] || source ~/.zshrc
" > ~/.tmp-zshsource.zsh

        chmod 0700 ~/.tmp-zshsource.zsh
        ~/.tmp-zshsource.zsh
        rm ~/.tmp-zshsource.zsh
    fi

    if [[ $1 == "delete" ]]; then
        echo "#! /usr/bin/env zsh

[[ ! -f ~/.zshrc ]] || source ~/.zshrc
" > ~/.tmp-zshsource.zsh

        chmod 0700 ~/.tmp-zshsource.zsh
        ~/.tmp-zshsource.zsh
        rm ~/.tmp-zshsource.zsh
    fi

}

#######################################################################################################
#######################################################################################################
#######################################################################################################

set_environmet_proxy () {
    printf "http_proxy=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "HTTP_PROXY=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "https_proxy=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "HTTPS_PROXY=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "no_proxy=\"127.0.0.10/8, localhost, 10.20.0.0/15, 172.16.0.0/12, 192.168.0.0/16\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "NO_PROXY=\"127.0.0.10/8, localhost, 10.20.0.0/15, 172.16.0.0/12, 192.168.0.0/16\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "HTTP_PROXY_REQUEST_FULLURI=0\n" | sudo tee -a /etc/environment > /dev/null
    printf "HTTPS_PROXY_REQUEST_FULLURI=0\n" | sudo tee -a /etc/environment > /dev/null
    printf "ftp_proxy=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "dns_proxy=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "rsync_proxy=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null
    printf "all_proxy=\"${URL}\"\n" | sudo tee -a /etc/environment > /dev/null

    source /etc/environment

    set_proxy_msg "${1}" true
}

delete_environmet_proxy () {
    sudo sed -i '/http_proxy/d' /etc/environment
    sudo sed -i '/HTTP_PROXY/d' /etc/environment
    sudo sed -i '/https_proxy/d' /etc/environment
    sudo sed -i '/HTTPS_PROXY/d' /etc/environment
    sudo sed -i '/no_proxy/d' /etc/environment
    sudo sed -i '/NO_PROXY/d' /etc/environment
    sudo sed -i '/HTTP_PROXY_REQUEST_FULLURI/d' /etc/environment
    sudo sed -i '/HTTPS_PROXY_REQUEST_FULLURI/d' /etc/environment
    sudo sed -i '/ftp_proxy/d' /etc/environment
    sudo sed -i '/dns_proxy/d' /etc/environment
    sudo sed -i '/rsync_proxy/d' /etc/environment
    sudo sed -i '/all_proxy/d' /etc/environment

    source /etc/environment

    delete_proxy_msg "${1}" true
}

set_shell_proxy () {
    printf "export http_proxy=\"${URL}\"\n" >> ~/.${1}rc
    printf "export HTTP_PROXY=\"${URL}\"\n" >> ~/.${1}rc
    printf "export https_proxy=\"${URL}\"\n" >> ~/.${1}rc
    printf "export HTTPS_PROXY=\"${URL}\"\n" >> ~/.${1}rc
    printf "export no_proxy=\"127.0.0.10/8,localhost,10.20.0.0/15,.reduc.edu.cu,172.16.0.0/12,192.168.0.0/16\"\n" >> ~/.${1}rc
    printf "export NO_PROXY=\"127.0.0.10/8,localhost,10.20.0.0/15,.reduc.edu.cu,172.16.0.0/12,192.168.0.0/16\"\n" >> ~/.${1}rc
    printf "export HTTP_PROXY_REQUEST_FULLURI=0\n" >> ~/.${1}rc
    printf "export HTTPS_PROXY_REQUEST_FULLURI=0\n" >> ~/.${1}rc
    printf "export ftp_proxy=\"${URL}\"\n" >> ~/.${1}rc
    printf "export dns_proxy=\"${URL}\"\n" >> ~/.${1}rc
    printf "export rsync_proxy=\"${URL}\"\n" >> ~/.${1}rc
    printf "export all_proxy=\"${URL}\"\n" >> ~/.${1}rc

    if [[ $1 == "zsh" ]]; then
        handle_zsh "set"
    else
        source ~/.${1}rc
    fi

    set_proxy_msg "${1}" true
}

delete_shell_proxy () {
    sed -i '/http_proxy/d' ~/.${1}rc
    sed -i '/HTTP_PROXY/d' ~/.${1}rc
    sed -i '/https_proxy/d' ~/.${1}rc
    sed -i '/HTTPS_PROXY/d' ~/.${1}rc
    sed -i '/no_proxy/d' ~/.${1}rc
    sed -i '/NO_PROXY/d' ~/.${1}rc
    sed -i '/HTTP_PROXY_REQUEST_FULLURI/d' ~/.${1}rc
    sed -i '/HTTPS_PROXY_REQUEST_FULLURI/d' ~/.${1}rc
    sed -i '/ftp_proxy/d' ~/.${1}rc
    sed -i '/dns_proxy/d' ~/.${1}rc
    sed -i '/rsync_proxy/d' ~/.${1}rc
    sed -i '/all_proxy/d' ~/.${1}rc

    if [[ $1 == "zsh" ]]; then
        handle_zsh "delete"
    else
        source ~/.${1}rc
    fi

    delete_proxy_msg "${1}" true
}

set_apt_proxy () {
    printf "Acquire::http::Proxy \"${URL}\";\n" | sudo tee /etc/apt/apt.conf > /dev/null
    printf "Acquire::https::Proxy \"${URL}\";\n" | sudo tee -a /etc/apt/apt.conf > /dev/null
    set_proxy_msg "apt" true
}

delete_apt_proxy () {
    sudo sed -i '/Acquire::http::Proxy/d' /etc/apt/apt.conf
    sudo sed -i '/Acquire::https::Proxy/d' /etc/apt/apt.conf
}

set_snap_proxy () {
    sudo snap set system proxy.http="${URL}"
    sudo snap set system proxy.https="${URL}"
    set_proxy_msg "snap" true
}

delete_snap_proxy () {
    sudo snap unset system proxy.http
    sudo snap unset system proxy.https
    delete_proxy_msg "snap" true
}

set_git_proxy () {
    git config --global http.proxy ${URL}
    set_proxy_msg "git" true
}

set_wget_proxy () {
    printf "https_proxy=${URL}/\n" >> ~/.wgetrc
    printf "http_proxy=${URL}/\n" >> ~/.wgetrc
    printf "ftp_proxy=${URL}/\n" >> ~/.wgetrc
    printf "use_proxy=on\n" >> ~/.wgetrc
    set_proxy_msg 'wget' true
}

delete_wget_proxy () {
    sed -i '/proxy/d' ~/.wgetrc
}

set_curl_proxy () {
    printf "proxy=${URL}/\n" >> ~/.curlrc
    set_proxy_msg 'curl' true
}


delete_curl_proxy () {
    sed -i '/proxy/d' ~/.curlrc
}

set_npm_proxy () {
    npm config set registry http://registry.npmjs.org/
    npm config set proxy "${URL}"
    npm config set http-proxy "${URL}"
    npm config set http_proxy "${URL}"
    npm config set https-proxy "${URL}"
    npm config set https_proxy "${URL}"
    npm config set strict-ssl false
    # echo "registry=http://registry.npmjs.org/" > ~/.npmrc
    # echo "proxy=${URL}" >> ~/.npmrc
    # echo "strict-ssl=false" >> ~/.npmrc
    # echo "http-proxy=${URL}" >> ~/.npmrc
    # echo "http_proxy=${URL}" >> ~/.npmrc
    # echo "https_proxy=${URL}" >> ~/.npmrc
    # echo "https-proxy=${URL}" >> ~/.npmrc
    set_proxy_msg 'npm' true
}


delete_npm_proxy () {
    npm config delete proxy
    npm config delete http_proxy
    npm config delete http-proxy
    npm config delete https_proxy
    npm config delete https-proxy
    npm config delete registry
    npm config delete strict-ssl
    delete_proxy_msg "npm" true
}

set_yarn_proxy () {
    yarn config delete proxy > /dev/null
    yarn config delete https-proxy > /dev/null
    yarn config delete strict-ssl > /dev/null
    set_proxy_msg 'yarn' true
}


delete_yarn_proxy () {
    yarn config set proxy ${URL} > /dev/null
    yarn config set https-proxy ${URL} > /dev/null
    yarn config set strict-ssl false > /dev/null
    delete_proxy_msg "yarn" true
}

#######################################################################################################
#######################################################################################################
#######################################################################################################

# defaul for all env
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
         -s=*|--proxy=*) proxy="${param#*=}";;
         
         -h|--help) help_menu 
              exit 0;;
         -d|--delete) delete=true;;
         -f|--force) force=true;;

         # binary flags
        #  -a|--all-env) all_env=true;;
         -e|--environment) environment=true; all_env=false;;
         -b|--bash) bash=true; all_env=false;;
         -z|--zsh) zsh=true; all_env=false;;
            --apt) apt=true; all_env=false;;
            --snap) snap=true; all_env=false;;
            --git) git=true; all_env=false;;
            --wget) wget=true; all_env=false;;
            --curl) curl=true; all_env=false;;
            # --composer) composer=true; all_env=false;;
            --npm) npm=true; all_env=false;;
            --yarn) yarn=true; all_env=false;;
            # --symfony) symfony=true; all_env=false;;

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

######################
# Controll no empty params
######################
if [[ $param_count == 0 ]]; then
    printf "Bad usage for ${Green}${0##*/}${Color_Off}\n"
    view_help_msg
    exit 1
fi

######################
# Set true fo all Env
######################
if [[ $all_env == true ]]; then
    environment=true
    bash=true
    zsh=true
    apt=true
    snap=true
    curl=true
    wget=true
    git=true
    npm=true
    yarn=true
    # composer=true
    # symfony=true
fi

######################
# Control delete use
######################
if [[ -n $delete ]]; then
    if [[ -n $username || -n $proxy ]]; then
        printf "If ${Red}[-d]${Color_Off} flag is active, then options ${Red}[-u -p -s]${Color_Off} can't be used.\n"
        view_help_msg
        exit 1
    fi

    if [[ $delete == true && $all_env == true ]]; then
        printf "Delete proxy config for all environments:\n"
    fi
######################
# Control set use
######################
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
        else
            read -s -p "Insert the password for this user: " password
            printf "\n"
        fi
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
        if grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' /etc/environment > /dev/null; then
            delete_environmet_proxy "environment"
        else
            delete_proxy_msg "environment" false "no_config"
        fi
    else
        if grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' /etc/environment > /dev/null; then
            if [[ $force == true ]]; then
                (delete_environmet_proxy "environment") > /dev/null 
                set_environmet_proxy "environment"
            else
                environment_aux=$(grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' /etc/environment)
                set_proxy_msg "environment" false "yet_exist" "${environment_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
            fi
        else
            set_environmet_proxy "environment"
        fi
    fi
fi

######################
# Bash Variables
######################
if [[ -n $bash && $bash == true ]]; then
    if [[ $delete == true ]]; then
        if grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' ~/.bashrc > /dev/null; then
            delete_shell_proxy "bash"
        else
            delete_proxy_msg "bash" false "no_config"
        fi
    else
        if grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' ~/.bashrc > /dev/null; then
            if [[ $force == true ]]; then
                (delete_shell_proxy "bash") > /dev/null
                set_shell_proxy "bash"
            else
                bash_aux=$(grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' ~/.bashrc)
                set_proxy_msg "bash" false "yet_exist" "${bash_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
            fi
        else
            set_shell_proxy "bash"
        fi
    fi
fi

######################
# Zsh Variables
######################
if [[ -n $zsh && $zsh == true ]]; then
    if [[ $delete == true ]]; then
        if grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' ~/.zshrc > /dev/null; then
            delete_shell_proxy "zsh"
        else
            delete_proxy_msg "zsh" false "no_config"
        fi
    else
        if grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' ~/.zshrc > /dev/null; then
            if [[ $force == true ]]; then
                (delete_shell_proxy "zsh") > /dev/null
                set_shell_proxy "zsh"
            else
                zsh_aux=$(grep -P 'http_proxy|HTTP_PROXY|https_proxy|HTTPS_PROXY|HTTP_PROXY_REQUEST_FULLURI|HTTPS_PROXY_REQUEST_FULLURI|no_proxy|NO_PROXY|ftp_proxy|dns_proxy|rsync_proxy|all_proxy' ~/.zshrc)
                set_proxy_msg "zsh" false "yet_exist" "${zsh_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
            fi
        else
            set_shell_proxy "zsh"
        fi
    fi
fi

######################
# APT SETTINGS
######################
if [[ -n $apt && $apt == true ]]; then
    if [[ $delete == true ]]; then
        if grep 'Proxy' /etc/apt/apt.conf > /dev/null ; then
            delete_apt_proxy
            delete_proxy_msg "apt" true
        else
            delete_proxy_msg "apt" false "no_config"
        fi
    else
        if grep 'Proxy' /etc/apt/apt.conf > /dev/null ; then 
            if [[ $force == true ]]; then
                delete_apt_proxy
                set_apt_proxy
            else
                apt_aux=$(grep 'Proxy' /etc/apt/apt.conf)
                set_proxy_msg "apt" false "yet_exist" "${apt_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
            fi
        else 
            set_apt_proxy
        fi
    fi
fi

######################
# SNAP SETTINGS
######################
if [[ -n $snap && $snap == true ]]; then
    if command -v git > /dev/null ; then
        snap_aux=$(sudo snap get system proxy)
        snap_aux=${snap_aux//Key\ \ Value/}
        if [[ $delete == true ]]; then
            if [[ -n $snap_aux ]] ; then
                delete_snap_proxy
            else
                delete_proxy_msg "snap" false "no_config"
            fi
        else
            if [[ -n $snap_aux ]] ; then
                if [[ $force == true ]]; then
                    delete_snap_proxy
                    set_snap_proxy
                else
                    set_proxy_msg "snap" false "yet_exist" "${snap_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
                fi
            else
                set_snap_proxy
            fi
        fi
    else
        command_exist "git"
    fi
fi

######################
# GIT SETTINGS
######################
if [[ -n $git && $git == true ]]; then
    if command -v git > /dev/null ; then
        if [[ $delete == true ]]; then
            if git config --global --unset http.proxy > /dev/null; then
                delete_proxy_msg "git" true
            else
                delete_proxy_msg "git" false "no_config"
            fi
        else
            if git config --global --list | grep http.proxy > /dev/null ; then
                if [[ $force == true ]]; then
                    set_git_proxy
                else
                    set_proxy_msg "git" false "yet_exist" $(git config --global --list | grep http.proxy)
                fi
            else
                set_git_proxy
            fi
        fi
    else
        command_exist "git"
    fi
fi

######################
# WGET SETTINGS
######################
if [[ -n $wget && $wget == true ]]; then
    if command -v wget > /dev/null ; then
        if [[ $delete == true ]]; then
            if [[ -s ~/.wgetrc ]]; then
                if grep 'proxy' ~/.wgetrc > /dev/null; then
                    delete_wget_proxy
                    delete_proxy_msg "wget" true
                else
                    delete_proxy_msg "wget" false "no_config"
                fi
            else
                delete_proxy_msg "wget" false "no_file" "~/.wgetrc" 
            fi
        else
            if [[ -s ~/.wgetrc ]]; then
                if grep 'proxy' ~/.wgetrc > /dev/null; then
                    if [[ $force == true ]]; then
                        delete_wget_proxy
                        set_wget_proxy
                    else
                        wget_aux=$(grep 'proxy' ~/.wgetrc)
                        set_proxy_msg "wget" false "yet_exist" "${wget_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
                    fi
                else
                    set_wget_proxy
                fi
            else
                printf "\n"
                read -r -p "The file ~/.wgetrc do not exist, do you wish to create it? [y|n]: " yn
                case $yn in
                    [Yy]* ) set_wget_proxy;;
                    [Nn]* ) set_proxy_msg "wget" false "no_create_file";;
                esac
            fi
        fi
    else
        command_exist "wget"
    fi
fi

######################
# CURL SETTINGS
######################
if [[ -n $curl && $curl == true ]]; then
    if command -v curl > /dev/null ; then
        if [[ $delete == true ]]; then
            if [[ -s ~/.curlrc ]]; then
                if grep 'proxy' ~/.curlrc > /dev/null; then
                    delete_curl_proxy
                    delete_proxy_msg "curl" true
                else
                    delete_proxy_msg "curl" false "no_config"
                fi
            else
                delete_proxy_msg "curl" false "no_file" "~/.curlrc" 
            fi
        else
            if [[ -s ~/.curlrc ]]; then
                if grep 'proxy' ~/.curlrc > /dev/null; then
                    if [[ $force == true ]]; then
                        delete_curl_proxy
                        set_curl_proxy
                    else
                        curl_aux=$(grep 'proxy' ~/.curlrc)
                        set_proxy_msg "curl" false "yet_exist" "${curl_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
                    fi
                else
                    set_curl_proxy
                fi
            else
                printf "\n"
                read -r -p "The file ~/.curlrc do not exist, do you wish to create it? [y|n]: " yn
                case $yn in
                    [Yy]* ) set_curl_proxy;;
                    [Nn]* ) set_proxy_msg "curl" false "no_create_file";;
                esac
            fi
        fi
    else
        command_exist "curl"
    fi
fi

######################
# COMPOSER SETTINGS     /TODO
######################
# if [[ -n $composer && $composer == true ]]; then
#     if command -v composer > /dev/null ; then
#         if [[ $delete == true ]]; then
#             if [[ -z $environment ]]; then
#                 # unset http_proxy
#                 # unset HTTP_PROXY
#                 # unset https_proxy
#                 # unset HTTPS_PROXY
#                 # unset HTTP_PROXY_REQUEST_FULLURI
#                 # unset HTTPS_PROXY_REQUEST_FULLURI
#                 # unset no_proxy
#                 # unset NO_PROXY
#                 echo
#             fi
#             printf "... Delete proxy config for composer: ${BGreen}OK${Color_Off}\n"
#         else
#             if [[ -z $environment ]]; then
#                 # export http_proxy="${URL}"
#                 # export HTTP_PROXY="${URL}"
#                 # export https_proxy="${URL}"
#                 # export HTTPS_PROXY="${URL}"
#                 # export HTTP_PROXY_REQUEST_FULLURI=0 # or false
#                 # export HTTPS_PROXY_REQUEST_FULLURI=0 #
#                 # export no_proxy="127.0.0.10/8, localhost, 10.20.0.0/8, 172.16.0.0/12, 192.168.0.0/16"
#                 # export NO_PROXY="127.0.0.10/8, localhost, 10.20.0.0/8, 172.16.0.0/12, 192.168.0.0/16"
#                 echo
#             fi
#             printf "... Set proxy config for composer: ${BGreen}OK${Color_Off}\n"
#         fi
#     else
#         command_exist "composer"
#     fi
# fi

######################
# NPM SETTINGS
######################
if [[ -n $npm && $npm == true ]]; then
    if command -v npm > /dev/null ; then
        npm_aux=$(npm config list | grep -P '^registry =|proxy =|http-proxy =|http_proxy =|https-proxy =|https_proxy =|strict-ssl =')
        if [[ $delete == true ]]; then
            if [[ -n $npm_aux ]] ; then
                delete_npm_proxy
            else
                delete_proxy_msg "npm" false "no_config"
            fi
        else
            if [[ -n $npm_aux ]] ; then
                if [[ $force == true ]]; then
                    set_npm_proxy
                else
                    set_proxy_msg "npm" false "yet_exist" "${npm_aux//$'\n'/$'\n'${Color_Off}....${Red} }"
                fi
            else
                set_npm_proxy
            fi
        fi
    else
        command_exist "npm"
    fi
fi

######################
# YARN SETTINGS
######################
if [[ -n $yarn && $yarn == true ]]; then
    if command -v yarn > /dev/null ; then
        yarn_aux=$(yarn config list | grep -P 'proxy|http-proxy|strict-ssl')
        yarn_aux2=$(yarn config list | grep -P 'info|proxy|http-proxy|strict-ssl')
        if [[ $delete == true ]]; then
            if [[ -n $yarn_aux ]] ; then
                delete_yarn_proxy
            else
                delete_proxy_msg "yarn" false "no_config"
            fi
        else
            if [[ -n $yarn_aux ]] ; then
                if [[ $force == true ]]; then
                    set_yarn_proxy
                else
                    set_proxy_msg "yarn" false "yet_exist" "${yarn_aux2//$'\n'/$'\n'${Color_Off}....${Red} }"
                fi
            else
                set_yarn_proxy
            fi
        fi
    else
        command_exist "yarn"
    fi
fi

######################
# SYMFONY SETTINGS
######################
# if [[ -n $symfony && $symfony == true ]]; then
#     if command -v symfony > /dev/null ; then
#         if [[ $delete == true ]]; then
#             if [[ -z $environment ]]; then
#                 # unset http_proxy
#                 # unset https_proxy
#                 echo
#             fi
#             printf "... Delete proxy config for symfony: ${BGreen}OK${Color_Off}\n"
#         else
#             if [[ -z $environment ]]; then
#                 # export http_proxy="${URL}"
#                 # export https_proxy="${URL}"
#                 echo
#             fi
#             printf "... Set proxy config for symfony: ${BGreen}OK${Color_Off}\n"
#         fi
#     else
#         command_exist "symfony"
#     fi
# fi

printf "\n"
exit 0
