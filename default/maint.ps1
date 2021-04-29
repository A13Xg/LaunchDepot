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
$Date = TimeStamp
#endregion GLOBAL-VARIABLES

#region FUNCTIONS
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
        [STRING] $Path = $LogLocation
    )
    $Date = (TimeStamp)
    "[$Date] ~   $Message" | Out-File -FilePath $Path -Append
}

function RunDISM {
    Loginator -Message "Beginning DISM Operation"
    Write-CmdLine -Message "DISM Operation Started"
    DISM /Online /Cleanup-Image /RestoreHealth
    Loginator -Message "DISM Operation Complete"
    Loginator -Message " "
}

function RunSFC {
    Loginator -Message "Beginning SFC Operation"
    Write-CmdLine -Message "SFC Operation Started"
    SFC /scannow
    Loginator -Message "SFC Operation Complete"
    Loginator -Message " "
}

function RunDefrag {
    Loginator -Message "Beginning Defrag Operation"
    Write-CmdLine -Message "Defrag Operation Started"
    Defrag /h /u /v /c
    Loginator -Message "Defrag Operation Complete"
    Loginator -Message " "
}

function schedRestart {
    [CmdletBinding()]
    param (
        [string]$time
    )
    shutdown -r -t $time
}
#endRegion FUNCTIONS