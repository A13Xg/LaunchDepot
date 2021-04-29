<#
Code written by A13Xg
Property of Alexander Goodman
A13Xg Industries
#>

## ABOUT
#This script's purpose is to allow an easier perform quick repair tasks across many computers.

#region GLOBAL-VARIABLES
$RunningDir = (Get-Location).Path
$UseVerification = $True
$LogLocation = "C:\Windows\Logs\A13Xg\initMain.log"
#endregion GLOBAL-VARIABLES


#region FUNCTIONS

#Compare the hash of a running script to that of a saved 'Control' hash to ensure script has not been modified. *Hash is stored in MD5*
        #Inputs -ControlHashPath <Path to a file containing your expected correct hash>
        #       -RunningPath <Path to current script that is being ran to compare against control hash>
        #Outputs [BOOLEAN] True / False 

    #//Usage: PS:\> VerifyIntegrity -ControlHashPath <Path to File> -RunningPath <Path to script>
function HashItem {
    param (
        [STRING] $FilePath,
        [STRING] $HashType
    )
    Certutil.exe -HashFile $FilePath $HashType
}
function VerifyIntegrity {
    IF ($UseVerification -eq $True) {
         $testHash = HashItem -FilePath "initMain.ps1" -HashType MD5
         $testHash1 = $testHash[1]
         $realHash = Get-Content -Path "VerifyIntegrity.dat"
         Write-CmdLine -Message "File Hash: $testHash1" -Color "Cyan"
         Loginator -Message "File Hash: $testHash1" -Path "$LogLocation"
         IF ($testHash1 -eq $realHash[3]) {
             Write-CmdLine -Message "Hash Verification: Success" -Color "Green"
             Loginator -Message "Hash Verification: Success" -Path "$LogLocation"
         }
         ELSE {
             Write-CmdLine -Message "Hash Verification: FAILURE" -Color "Red"
             Loginator -Message "Hash Verification: FAILURE" -Path "$LogLocation"
             Exit
         }
    }
    ELSE {
        $testHash = HashItem -FilePath "initMain.ps1" -HashType MD5
        $testHash1 = $testHash[1]
        Write-CmdLine -Message "File Hash: $testHash1" -Color "Cyan"
        Write-Host "Verification Disabled"
        Write-CmdLine "Warning: Verification Disabled" -Color "RED"
        Loginator -Message "File Hash: $testHash1" -Path "$LogLocation"
        Loginator -Message "Warning: Verification Disabled" -Path "$LogLocation"
        
    }
}
function Write-CmdLine {
    param(
        [string] $Message,
        [string] $FColor = 'White',
        [string] $BColor = 'DarkCyan'
    )
   # Colors "Black","Blue","Cyan","DarkBlue","DarkCyan","DarkGray","DarkGreen","DarkMagenta","DarkRed","DarkYellow","Gray","Green","Magenta","Red","White","Yellow"
   Write-Host $Message -ForegroundColor $FColor -BackgroundColor $BColor
}
function TimeStamp {
    Get-Date -Format "MM/dd/yyyy-HH:mm"
}
function Loginator {
    param (
        [STRING] $Message,
        [STRING] $Path
    )
    $Date = (TimeStamp)
    "[$Date] ~   $Message" | Out-File -FilePath $Path -Append
}

function UpdateRepo {
    [CmdletBinding()]
    param (
        [string] $fileName,
        [string] $filePath,
        [string] $url
    )
    mkdir $filePath
    Set-Location $filePath
    Invoke-WebRequest "$url" -OutFile $fileName
}
#endregion FUNCTIONS

UpdateRepo -filePath "C:\service\A13Xg\repo\" -fileName "initMain.ps1" -url "https://raw.githubusercontent.com/A13Xg/LaunchDepot/main/default/initMain.ps1"
UpdateRepo -filePath "C:\service\A13Xg\repo\" -fileName "maint.ps1" -url "https://raw.githubusercontent.com/A13Xg/LaunchDepot/main/default/maint.ps1"