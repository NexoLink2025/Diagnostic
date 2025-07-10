
function upgPowershell {

    Clear-Host 
    Write-Host "  ==> Powershell version" 
    #$PSVersionTable

    $newPS = $PSVersionTable.PSVersion.Major
    if ($newPS -Like 7) {
        #$PSVersionTable.PSVersion
        #pause
    }
    else{
		Write-Host ""
        $getnewPS = Read-Host "Do you whant to install the latest PowerShell ? [Y/N]"
        if ($getnewPS -icontains  'Y'){
            Write-Host "  ==> Upgrading Powershell" 
                winget install --id Microsoft.Powershell --source winget
            pause
        }
    }
}

#  change the keyboard layout in Windows 11
   # Get-WinUserLanguageList
   # Set-WinUserLanguageList sv-SE


Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
#Get-ExecutionPolicy -List

upgPowershell

#Start-Process powershell -File "Diagnostics.ps1" -verb runas

$PSScriptRoot
& "$PSScriptRoot\Diagnostics.ps1"  -verb runas