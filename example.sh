#! /usr/bin/env bash

URL="http://anisabel.galvez:Bebe-2013@10.20.0.21:3128"

yarn config set proxy ${URL} > /dev/null
yarn config set https-proxy ${URL} > /dev/null
yarn config set strict-ssl false > /dev/null
printf "Set proxy config for yarn: ${BGreen}OK${Color_Off}\n"