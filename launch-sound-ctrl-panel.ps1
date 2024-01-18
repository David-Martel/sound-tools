# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script as an administrator
    Start-Process -FilePath PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Function to check if Sound Control Panel is open
function IsSoundControlPanelOpen() {
    return (Get-Process | Where-Object { $_.MainWindowTitle -eq "Sound" }).Count -gt 0
}

# Open the Sound Control Panel as an administrator
try {
    Start-Process control.exe -ArgumentList "mmsys.cpl" -Verb RunAs -ErrorAction Stop
}
catch {
    Write-Host "Error: Failed to open Sound Control Panel. Ensure that the 'control.exe' is accessible and try again."
    Exit 1
}

# Check if the Sound Control Panel is open and close the script
while (-not (IsSoundControlPanelOpen)) {
    Start-Sleep -Seconds 1
}

# Notify user and close the script
Write-Host "Sound Control Panel is now open. This script will now exit."
Exit 0
