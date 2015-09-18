#!/bin/bash

# VIP Access Security Code to Clipboard ( simplified shell script ) 
# Jason Godsey
# Based on expect script by Aaron Meriwether https://gist.github.com/p120ph37/8213727
# I bind this to option+command+v, so I can simply type my password and press option+command+v, command+v to enter my token when needed.

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/bin
export aes_key=D0D0D0E0D0D0DFDFDF2C34323937D7AE
export keychain="/Users/$USER/Library/Keychains/VIPAccess.keychain"
export serial=$( ioreg -c IOPlatformExpertDevice -d 2 2>/dev/null | grep \"IOPlatformSerialNumber\" | sed 's/"$//; s/.*"//;' )
security unlock-keychain -p "${serial}SymantecVIPAccess${USER}" $keychain
export sarray=( $( security find-generic-password -gl CredentialStore $keychain 2>&1 | egrep 'acct"<blob|password:' | sed 's/ //g;'| sort | sed 's/"$//; s/.*"//;' | paste - - ) )
export id_crypt=${sarray[0]}
export key_crypt=${sarray[1]}
#export id_plain=$( openssl enc -aes-128-cbc -d -K $aes_key -iv 0 -a <<< "$id_crypt" )
export key_plain=$( openssl enc -aes-128-cbc -d -K $aes_key -iv 0 -a <<< "$key_crypt" | xxd -p )
oathtool --totp $key_plain | tr -d '\n' | pbcopy

