#!/bin/bash
# init
function pause(){
   read -p "$*"
}
 
#  change the keyboard layout in Windows 11
    Get-WinUserLanguageList
    Set-WinUserLanguageList sv-SE
    

#pause 'Press [Enter] key to continue...'



powershell -File "C:\Users\tests\Desktop\Diagnostics\Diagnostics.ps1"

#start-process powershell -verb runas 