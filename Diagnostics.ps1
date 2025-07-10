# Functions --------------------------------------------------------------------


# General functions --------------------------
function tobecontinued{
      Write-Host ""
      Read-Host "=====>>  Enter any key to continue  :-) "
      #clear

}

function USBformatAdmin{

    Get-ExecutionPolicy -List
    #Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force


    #Set-ExecutionPolicy -ExecutionPolicy Restricted   -Scope CurrentUser -Force 
    #Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope CurrentUser
    #Start-Sleep -s 5

    # Self-elevate the script if required

    if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
       # https://powershellcommands.com/powershell-start-process-with-arguments
        
#        Start-Process powershell -FilePath $location"\Test_2.ps1"  
  
        Start-Process -FilePath "powershell.exe" -ArgumentList "-File $location\PS_GUI\USBclean.ps1" -Verb RunAs
        #exit
    } 
}

function  errorinfo {

    param (
        [Parameter(Mandatory=$true)]
        [string]$result,
        [string]$fl,
        [string]$eqp,
        [string]$devID
    )

    if ( $result -ieq  'y' )
    {     
        Add-Content -Path $fl -Value "`n$eqp Test for [ $devID ] is OK !!!`n"     
    }else{

        Add-Content -Path $fl -Value "`n$eqp Test for [ $devID ] is NOT OK !!!`n`n$WhatWasWrong"
        Start-Process 'C:\WINDOWS\system32\notepad.exe' $fl
        cmd /c start /wait notepad $fl
    }

  
}



# 1 *****************************
function getbatteryinfo {
    Clear-Host
    $file= $report_dir+'/batteryreport.html'
    Write-Host "  ==> Starting Battery report"
    powercfg /batteryreport /output $file
#    Start-Process $file    

}

# 2 *****************************
function getdisplay {
    Clear-Host
    $file= $report_dir+'\DisplayTest.txt'
    Remove-Item $file

    Clear-Host 

    Write-Host "  ==> Starting Checking Display"

    #cmd /c start  "https://testmyscreen.com/" -Wait
    Start-Process -FilePath "chrome.exe" -ArgumentList "https://testmyscreen.com/" -Wait

    #Start-Process -FilePath "https://keyboard-tester.com/swedish-keyboard" -Wait

    Write-Host ""
    $displayresult = Read-Host "      Was Display checking OK [Y/N] ?"
    errorinfo -result $displayresult -fl $file -eqp 'Display' -devID $deviceID

}

# 3 *****************************
function getkeyboard {
    Clear-Host
    $file= $report_dir+'/KeyboardTest.txt'
    Remove-Item $file
      #Start-Transcript -Path "$report_dir/KeyboardTest.txt"
      #Stop-Transcript 

    Clear-Host
    Write-Host "  ==> Starting Checking Keyboard"

    #cmd /c start /wait "https://keyboard-tester.com/swedish-keyboard"
    Start-Process -FilePath "chrome.exe" -ArgumentList "https://keyboard-tester.com/swedish-keyboard" -Wait

    Write-Host ""
    $keybopardresult = Read-Host "      Was Keyboard checking OK [Y/N] ?"
    errorinfo -result $keybopardresult -fl $file -eqp 'Keyboard' -devID $deviceID

}

# 4 *****************************
function getwifi {
    mkdir $report_dir\wifi -Force  
    Clear-Host
    Write-Host "  ==> Starting Checking WiFi & Bluetooth "
    Write-Host ""
    Write-Host "      Wait until checkings are done... "
    # https://www.comparitech.com/net-admin/network-troubleshooting-tools/

    Write-Host "  ->  NetAdapter_A"
    Get-NetAdapter -Name * > $report_dir\wifi\NetAdapter_A.txt

    Write-Host "  ->  NetAdapter_B"
    Get-NetAdapter -Name '*' -IncludeHidden | Format-List -Property 'Name', 'InterfaceDescription', 'InterfaceName' > $report_dir\wifi\NetAdapter_B.txt
    
    Write-Host "  ->  NetIPConfiguration"
    Get-NetIPConfiguration > $report_dir\wifi\NetIPConfiguration.txt

    Write-Host "  ->  netsh_wlan"
    netsh wlan show all > $report_dir\wifi\netsh_wlan.txt
    #Get-PnpDevice -Class usb
    #Get-PnpDevice -Class Net 

    Write-Host "  ->  PnpDevices"
    Get-PnpDevice  > $report_dir\wifi\PnpDevices.txt          
}


# 5 *****************************
function getcpustress {
    $file= $report_dir+'/CPUstress.txt'
    Remove-Item $file -Force
    $test= $false

    Clear-Host

    Write-Host ""
    Write-Host " [1] OCCT        *"
    Write-Host " [2] Prime95     *"
    Write-Host " [3] CPUSTRES64  *"
    Write-Host ""
    switch (Read-Host "  What test to perform ?") {
        '1' {
            Write-Host "  ==> Starting OCCT tests"
            Write-Host "      Save images as : OCCT_1.png  / OCCT_2.png  / OCCT_3.png "
            Write-Host " "
            Write-Host "      Wait until program loads... "
            #& $location"\tools\StressTest\OCCT\OCCT.exe"
            Start-Process -FilePath $location"\tools\StressTest\OCCT\OCCT.exe"  -Wait 
            $test= $true

              # Get-ChildItem  -Name '*.png'
        }
        '2' {
            Write-Host "  ==> Starting Prime95 tests"
            Write-Host "      Wait until program loads... "
            #& $location"\tools\StressTest\Prime95\prime95.exe"
            Start-Process -FilePath $location"\tools\StressTest\Prime95\prime95.exe" -verb runas -Wait  
            $test= $true
        }
        '3' {
            Write-Host "  ==> Starting CPUSTRES64 tests"
            Write-Host "      Wait until program loads... "
            #& $location"\tools\SystemInternals\CPUSTRES64.EXE"
            Start-Process $location"\tools\SystemInternals\CPUSTRES64.EXE" -Wait -verb runas

            $test= $true
        }

        default {
         Write-Host "** Not a valid choise :-( "
         $test= $false
        }
    }
    Write-Host ""


    if ($test){
        $keybopardresult = Read-Host "      Was Checking CPU/RAM Stress OK ? [Y/N]"
        errorinfo -result $keybopardresult -fl $file -eqp 'CPU/RAM Stress' -devID $deviceID
    }
                  
}


# 6 *****************************
function getramtest {
    Clear-Host
    $file= $report_dir+'/RAMtest.txt'
    $file_csv = $report_dir+'/RAMtest.csv'
    #Remove-Item $file
    #Remove-Item $file_csv
    Write-Host "  ==> Starting Checking RAM "


    Write-Host "    Run mdsched.exe "
    # https://windowsreport.com/mdsched-exe-windows-10/
    # https://www.wintips.org/how-to-check-ram-size-speed-manufacturer-and-other-specs-in-windows-10-11/

    mdsched.exe
    "Latest memory test results 
*********************************************" > $file
    Get-WinEvent -FilterHashTable @{LogName='System'; Id=1101,1201} -ErrorAction Ignore | Where {$_.ProviderName -Match 'MemoryDiagnostics-Results'} >> $file
    "Win32_PhysicalMemory 
*********************************************" >> $file
    Get-WmiObject Win32_PhysicalMemory >> $file    

    Get-CimInstance -ClassName Win32_PhysicalMemory | Export-Csv -Path $file_csv -NoTypeInformation

             
 
}



# 7 *****************************
function getstorage {
    $file= $report_dir+'/Storage.txt'
    Remove-Item $file -Force
    $test= $false
    Clear-Host
    Write-Host "  ==> Starting Checking Storage"
    Write-Host ""
    Write-Host " [1] DiskWipe                             *"
    Write-Host " [2] System Information and Diagnostics   *"
    Write-Host " [3]                                      *"
    Write-Host ""
    switch (Read-Host "  What test to perform ?") {
        '1' {
            # https://diskwipe.org/ 
            #& $location"\tools\Diskhandling\DiskWipe\DiskWipe.exe" 
            Start-Process -FilePath $location"\tools\Diskhandling\DiskWipe\DiskWipe.exe"  -Wait -verb runas
            $test= $true
        }

        '2' {
            # https://www.hwinfo.com/ 
            #& $location"\tools\systemdiagnostics\HWInfo\HWiNFO64.exe" 
            Start-Process -FilePath $location"\tools\systemdiagnostics\HWInfo\HWiNFO64.exe"  -Wait -verb runas
            $test= $true
        }

    default {
            Write-Host "** Not a valid choise :-( "
            $test= $false
            }
    }
    Write-Host ""


    if ($test){
        $keybopardresult = Read-Host "      Was Storage Checking OK ? [Y/N]"
        errorinfo -result $keybopardresult -fl $file -eqp 'Storage check' -devID $deviceID
    }
                  
}


# 8 *****************************
function getcamera {
    #https://www.thewindowsclub.com/use-powershell-to-find-and-disable-webcams

    Clear-Host
    $file= $report_dir+'\Camera.txt'
    Remove-Item $file
    Write-Host "  ==> Starting Checking Camera"

    Start-Transcript -Path $file -UseMinimalHeader
        Get-CimInstance Win32_PnPEntity | Where-Object caption -match 'camera'
   
    
    #$camera2 = 
        Get-CimInstance Win32_PnPEntity | ? { $_.service -eq "usbvideo" } | Select-Object -Property PNPDeviceID, Name
    #Add-Content -Path $file -Value "`n$camera2"

     Stop-Transcript

}

# 9 *****************************        
function getautopilot {
    Clear-Host
    $file= $report_dir+'\Autopilot_info.txt'
    Remove-Item $file
        Write-Host "  ==> Starting Checking AutoPilot "

    #<#
    Start-Transcript -Path $file -UseMinimalHeader
        dsregcmd /status
     Stop-Transcript 
    ##>
             
     dsregcmd /status > $file
    
}

# A *****************************
function debloat {
    Clear-Host
    Write-Host "  ==> Win Debloater "
    Invoke-RestMethod -Uri 'https://christitus.com/win'  | Invoke-Expression  

    Write-Host "      Wait until program starts... "  
    Pause
}

# B *****************************
function activwin {
    Clear-Host
    Write-Host "  ==> Win Activation license"
    Invoke-RestMethod -Uri 'https://get.activated.win' | Invoke-Expression 
    
    Write-Host "      Wait until program starts... "  
    Pause

}

# C *****************************
function upgPowershell {
   
    
}


# D *****************************
function formatUSB{
    $file= $report_dir+'\USBlist.txt'
    Clear-Host 

    Write-Host "  ==> USB clear list" 
    (Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"} ) > $file
    
    USBformatAdmin


    #diskmgmt.msc
    
    #Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"} 
<#
   $drive1= (Get-Disk | Where-Object -FilterScript {($_.Bustype -Eq "USB" -and $_.number -Ne '0') } ).DiskNumber
    $drive2= (Get-Disk | Where-Object -FilterScript {($_.Bustype -Eq "USB" -and $_.number -Ne '0') } ).BusType
    $drive3= (Get-Disk | Where-Object -FilterScript {($_.Bustype -Eq "USB" -and $_.number -Ne '0') } ).AllocatedSize
    $drive4= (Get-Disk | Where-Object -FilterScript {($_.Bustype -Eq "USB" -and $_.number -Ne '0') } ).Model 

    #$drive = (get-disk -Number "1").BusType
    Write-Host "      $drive2 [ $drive1 ]  $drive3  $drive4"


    (
    

    Write-Host ""
    Write-Host "**** Starting USB Formating ******"
    Write-Host ""


        switch ($disk= Read-Host "==>  Please enter your USB Number") {
        '0' {
             'Disk 0 CAN NOT be formated'
             }
        '1' {
            Write-Host "Formating disk: "$disk

            Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false  
            New-Partition -DiskNumber $disk -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel myUSBDrive  
            Get-Partition -DiskNumber $disk | Set-Partition -NewDriveLetter D 
            }

        '2' {
            Write-Host "Formating disk: "$disk

            Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false 
            New-Partition -DiskNumber $disk -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel myUSBDrive
            Get-Partition -DiskNumber $disk | Set-Partition -NewDriveLetter F
            }
        '3' {
            Write-Host "Formating disk: "$disk

            Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false 
            New-Partition -DiskNumber $disk -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel myUSBDrive
            Get-Partition -DiskNumber $disk | Set-Partition -NewDriveLetter G
            }
         default {
             Write-Host " == " $disk" is not a valid choise - Bye  :-( "

            }
        }
#>
       
       
       # pause

 
}


# z *****************************
function clearResults {
        param (
            [string]$phase
        )

    $file= $report_dir
    Write-Host "  ==> Remove all files  $phase"

    if ($phase -eq 'clearall'){
        Remove-Item $file\wifi -Recurse
        Remove-Item $file\*.*  
        New-Item  -Path $report_dir'\SystemInfo.html' -ItemType File -Value "System Information and Diagnostics not performed yeat :-( )" -Force
        Copy-Item -Path $location'\results.draft' -Destination $report_dir'\Results.html' -Recurse -Force
    }else{
        New-Item  -Path $report_dir'\SystemInfo.html' -ItemType File -Value "System Information and Diagnostics not performed yeat :-( )" 
        Copy-Item -Path $location'\results.draft' -Destination $report_dir'\Results.html' -Recurse

    }
    
}


# R *****************************
function TestResults {

    Write-Host "  ==> Show Test Results"

    Start-Process $report_dir'/batteryreport.html'
    Start-Process $report_dir'/Results.html'

<#  convert to pdf
    https://www.softwaresagacity.com/2014/06/how-to-convert-hmtl-to-pdf-using-powershell/
#>    

}

# Running program  --------------------------------------------------------------------------------

$Value=0
#$current_directory = $pwd.Path
$WhatWasWrong = "=================================`n        What was wrong ?`n=================================`n"


# Get existing drivers
#$driver = (Get-PSDrive).Name -match '^[a-z]$'
$driver = $pwd.drive.name
#Write-Host $driver

if ( $driver -ine  'c' ){
    $desktop = ''
    Write-Host "Directory Not Equal C: "$desktop
}else{
    #$desktop = [Environment]::GetFolderPath([Environment+SpecialFolder]::Desktop)
    $Desktop = [Environment]::GetFolderPath("Desktop")
    Write-Host "usind Directory: "$desktop
}

    Clear-Host
    Write-Host ""
    $location   = "$desktop\Diagnostics"
    $deviceID = Read-Host "Enter Device Article ID or Serial"

    $report_dir = "$location\Reports\"+$deviceID
    #mkdir $report_dir
    New-Item $report_dir -ItemType "Directory" -Force

    #Set-Location $location
    Set-Location -Path $report_dir
    #Get-ChildItem

    clearResults -phase "newitem"

while($Value -ne 'x')
{
  Clear-Host

  Write-Host ""
  #Write-Host $location
  Write-Host "*** TESTS ******************************************************" -F DarkMagenta
  Write-Host "*== Device : [ " $deviceID " ]`t                      "           -F DarkMagenta
  Write-Host "*--Options-----------------------------------------------------*" -F DarkMagenta
  Write-Host "* [1] Battery info               [A] Win Debloater             *"
  Write-Host "* [2] Display                    [B] MS Activation Script      *"
  Write-Host "* [3] Keyboard                   [C]                           *"            
  Write-Host "* [4] WiFi and Bluetoouth        [D] Clear USB                 *"            
  Write-Host "* [5] CPU/RAM Stress & Health    [E]                           *"
  Write-Host "* [6] RAM tests                  [F]                           *"
  Write-Host "* [7] Storage                    [G]                           *"
  Write-Host "* [8] Camera                     [H]                           *"
  Write-Host "* [9] Autopilot                                                *"
  Write-Host "*                                [Z] Clear Results Report      *"
  Write-Host "* [X] eXit                       [R] Show Test Results         *"
  Write-Host "****************************************************************" -F DarkMagenta
  Write-Host "                                                GedeAlm 2025/07 " -F DarkMagenta 

  #Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White"
  #Write-Host "" 

    
   # $Value = Read-Host "Please enter your value"

    switch (Read-Host "Please enter your value") {
        'x' {
            Write-Host "bye  ! :-( "
            Clear-Host
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
            #'Debloater'
            debloat 
            Pause
        }

        'b' {
            #'Win Activation script'
            activwin
            Pause
        }
  
        'c' {
            #
			
        }

        'd' {
            #'Format disk'
			formatUSB

        }

       'z' {
            #'TestResults'
			clearResults -phase "clearall"

        }

        'r' {
            #'TestResults'
			TestResults

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
