# Functions --------------------------------------------------------------------

function tobecontinued{
      Write-Host ""
      Read-Host "=====>>  Enter any key to continue  :-) "
      #clear

}

# 1 *****************************
function getbatteryinfo {
    $file= $report_dir+'/batteryreport.html'
    Write-Host "  ==> Starting Battery report"
    powercfg /batteryreport /output $file
    Start-Process $file    
    #tobecontinued
}

# 2 *****************************
function getdisplay {
    $file= $report_dir+'/DisplayTest.txt'
    Remove-Item $file
      #Start-Transcript -Path "$report_dir/DisplayTest.txt"
      #Stop-Transcript 

    clear 
    Write-Host "  ==> Starting Checking Display"

    cmd /c start /wait "https://testmyscreen.com/"


    $displayresult = Read-Host "  Was Display checking OK [Y/N] ?"
    if ( $displayresult -ieq  'y' )
    {     
         Add-Content -Path $file -Value "`nDispaly Test for [ $deviceID ] is OK !!!`n"
     
    }else{
    
         Add-Content -Path $file -Value "`nDispaly Test for [ $deviceID ] is NOT OK !!!`n`n$WhatWasWrong"
         #Start-Process 'C:\WINDOWS\system32\notepad.exe' $file
         cmd /c start /wait notepad $file
    }
}

# 3 *****************************
function getkeyboard {
    
    $file= $report_dir+'/KeyboardTest.txt'
    Remove-Item $file
      #Start-Transcript -Path "$report_dir/KeyboardTest.txt"
      #Stop-Transcript 

    clear
    Write-Host "  ==> Starting Checking Keyboard"
    #Start-Process "https://keyboard-tester.com/swedish-keyboard" -Wait
    cmd /c start /wait "https://keyboard-tester.com/swedish-keyboard"


    
    $keybopardresult = Read-Host "  Was Keyboard checking OK [Y/N] ?"
    if ( $keybopardresult -ieq  'y' )
    {     
         #Out-File -FilePath $report_dir/DisplayTest.txt
         Add-Content -Path $file -Value "`nKeyboard Test for [ $deviceID ] is OK !!!`n"
     
    }else{
    
         Add-Content -Path $file -Value "`nKeyboard Test for [ $deviceID ] is NOT OK !!!`n`n$WhatWasWrong"
         #Start-Process 'C:\WINDOWS\system32\notepad.exe' $file
         cmd /c start /wait notepad $file
    }
                  
}

# 4 *****************************
function getwifi {
    Write-Host "  ==> Starting Checking WiFi & Bluetooth "

    # https://www.comparitech.com/net-admin/network-troubleshooting-tools/


    Get-NetAdapter -Name * > $report_dir/NetAdapter_A.txt

    Get-NetAdapter -Name '*' -IncludeHidden | Format-List -Property 'Name', 'InterfaceDescription', 'InterfaceName' > $report_dir/NetAdapter_B.txt

    Get-NetIPConfiguration > $report_dir/NetIPConfiguration.txt

    netsh wlan show all > $report_dir/netsh_wlan.txt

    #Get-PnpDevice -Class usb
    #Get-PnpDevice -Class Net 
    Get-PnpDevice  > $report_dir/PnpDevices.txt          
}


# 5 *****************************
function getcpustress {
 
    $file= $report_dir+'/CPUstress.txt'
    Remove-Item $file

    clear
    Write-Host "  ==> Starting Checking CPU/RAM Stress"

     #Start-Transcript -Path "$report_dir/CPUstress.txt"
     #Stop-Transcript 


    #& $location"\tools\SystemInternals\CPUSTRES64.EXE"
    # Start-Process $location"\tools\SystemInternals\CPUSTRES64.EXE" -NoNewWindow -Wait
    #cmd /c start /wait $location"\tools\SystemInternals\CPUSTRES64.EXE" 



    & $location"\tools\StressTest\OCCT\OCCT.exe"


#    & $location"\tools\StressTest\Prime95\prime95.exe"

      
      
    $keybopardresult = Read-Host "  Was Checking CPU/RAM Stress [Y/N] ?"
    if ( $keybopardresult -ieq  'y' )
    {     
         Out-File -FilePath $report_dir/CPUstress.txt
         Add-Content -Path "$report_dir/CPUstress.txt" -Value "
     
         CPUstress for [ $deviceID ] is OK !!!" 

    }else{
    
        Add-Content -Path $file -Value "`nCPUstress for [ $deviceID ] is not OK !!!`n`n$WhatWasWrong"

        #Start-Process 'C:\WINDOWS\system32\notepad.exe' $file
        cmd /c start /wait notepad $file
    }
    
          
                  
}


# 6 *****************************
function getramtest {

    $file= $report_dir+'/RAMtest.txt'
    $file_csv = $report_dir+'/RAMtest.csv'
    Remove-Item $file
    Remove-Item $file_csv

    clear
    Write-Host "  ==> Starting Checking RAM "


    Get-CimInstance -ClassName Win32_PhysicalMemory | Export-Csv -Path $file_csv -NoTypeInformation
    Get-WmiObject Win32_PhysicalMemory > $file

    Write-Host " Run mdsched.exe "
    # https://windowsreport.com/mdsched-exe-windows-10/
    # https://www.wintips.org/how-to-check-ram-size-speed-manufacturer-and-other-specs-in-windows-10-11/
    mdsched.exe
                  
}


# 7 *****************************
function getstorage {
    Write-Host "  ==> Starting Checking Storage"
            
            
  # https://www.windowscentral.com/how-test-hard-drive-performance-diskspd-windows-10
  # https://www.techworm.net/2023/11/disk-speed-test-tool-windows-pc.html
                  
}


# 8 *****************************
function getcamera {

    $file= $report_dir+'/Camera.txt'
    Remove-Item $file

    Write-Host "  ==> Starting Checking Camera"

    (Get-CimInstance Win32_PnPEntity | where caption -match 'camera' ) > $file

    $camera2 = Get-CimInstance Win32_PnPEntity | ? { $_.service -eq "usbvideo" } | Select-Object -Property PNPDeviceID, Name
    Add-Content -Path $file -Value "`n$camera2"

                  
}

# 9 *****************************        
function getautopilot {
    Write-Host "  ==> Starting Checking AutoPilot "
                  
}


# a *****************************
function gettbd {
    Write-Host "  ==> Starting Checking TBD "

    
    cmd /c start /wait notepad $report_dir\DisplayTest.txt
                  
}


function scopeinfo{

    #Set-ExecutionPolicy -ExecutionPolicy Restricted   -Scope CurrentUser -Force 
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
    #Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope CurrentUser
    #Start-Sleep -s 5
    #tobecontinued

}

# Running program  --------------------------------------------------------------------------------

$Value=0
#$current_directory = $pwd.Path
$WhatWasWrong = "`n=================================`n        What was wrong ?`n=================================`n"


# Get existing drivers
$driver = (Get-PSDrive).Name -match '^[a-z]$'
Write-Host $driver
if ( $driver -icontains  'Y' ){
    $desktop = 'Y:\'
    Write-Host "Directory  Y:\"
}else{
    #$desktop = [Environment]::GetFolderPath([Environment+SpecialFolder]::Desktop)
    $Desktop = [Environment]::GetFolderPath("Desktop")
    Write-Host "ELSE Directory  C:\"
}

    clear

    $deviceID = Read-Host "Enter Device Article ID or Serial"

    $location   = "$desktop\Diagnostics"
    $report_dir = "$desktop\Diagnostics\Reports\"+$deviceID
    mkdir $report_dir
    cd $location
    cd $report_dir
    ls



while($Value -ne 'x')
{
  clear

  #echo $location

  Write-Host ""
  #Write-Host $location
  Write-Host "*** TESTS ***  Device: [ " $deviceID " ]"

  Write-Host "[1] Battery info"
  Write-Host "[2] Display"
  Write-Host "[3] Keyboard"
  Write-Host "[4] WiFi and Bluetoouth"
  Write-Host "[5] CPU/RAM Stress & Health  "
  Write-Host "[6] RAM tests"
  Write-Host "[7] TBD - Storage"
  Write-Host "[8] Camera"
  Write-Host "[9] TBD - Autopilot"
  Write-Host "[a] TBD - "




  Write-Host ""
  Write-Host "[x] eXit"
  Write-Host "*******************************"
  Write-Host ""

    
   # $Value = Read-Host "Please enter your value"

    switch (Read-Host "Please enter your value") {
        'x' {
            Write-Host "bye  ! :-( "
            exit
        }

        '1' {
            # 'get battery info'
            getbatteryinfo
        
        }

        '2' {
            #'Check Display'
            getdisplay 
            
            $displayresult     
        }

        '3' {
            #'Check Keyboard'
            getkeyboard  
          
        }

        '4' {
            #'Check WiFi & Bluetooth'
            getwifi
          
        }
        '5' {
            #'Check CPU/RAM Stress'
            getcpustress

        }
        '6' {
            #'Check RAM'
            getramtest
        }
        '7' {
            #'Check Storage'
            getstorage
        }
        '8' {
            #'Check Camera'
            getcamera
        }
        
        '9' {
            #'Check AutoPilot'
            getautopilot
        }

        'a' {
            #'Check tbd'
            gettbd
        }
  
        default {
             Write-Host "** Not a valid choise - Bye  :-( "
             #Write-Host "bye  ! :-( "
            exit
        }
    }


}




#___References_____

 # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-if?view=powershell-7.5#the-if-statement
