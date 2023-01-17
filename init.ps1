Import-Module $PSScriptRoot\lib\common.psm1

# install choco
Invoke-Elevated {
    Write-Output "Installing choco"
    Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 307
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    exit
}

# install scoop
Invoke-RestMethod get.scoop.sh | Invoke-Expression
# add buckets
scoop install git
git config --global user.name 'Yubo-Cao'
git config --global user.email 'cao2006721@gmail.com'

scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts

# enable developer mode
Invoke-Elevated {
    Write-Output "Enabling developer mode"
    if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
        Write-Host -ForegroundColor Red "The DeveloperMode is only supported on Windows 10"
        exit 1
    }

    $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    if (! (Test-Path -Path $RegistryKeyPath)) {
        New-Item -Path $RegistryKeyPath -ItemType Directory -Force
    }

    if (! (Get-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense)) {
        # Add registry value to enable Developer Mode
        New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
    }
    $feature = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online
    if ($feature -and ($feature.State -eq "Disabled")) {
        Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -LimitAccess -NoRestart
    }
}