Import-Module $PSScriptRoot\lib\common.psm1

# request admin
Request-Admin
# install choco
Write-Output "Installing choco"
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 307
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# install scoop
Invoke-RestMethod get.scoop.sh | Invoke-Expression
# add extras
scoop install git
git config --global user.name 'Yubo-Cao'
git config --global user.email 'cao2006721@gmail.com'
scoop bucket add extras