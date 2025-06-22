#!/bin/bash
# init
function pause(){
   read -p "$*"
}
 
#  change the keyboard layout in Windows 11
    Get-WinUserLanguageList
    Set-WinUserLanguageList sv-SE
    

#pause 'Press [Enter] key to continue...'

pwd

Start-Process powershell -File "Y:\Diagnostics\Diagnostics.ps1" -verb runas

#start-process powershell -verb runas 

