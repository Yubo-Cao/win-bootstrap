Import-Module $PSScriptRoot\..\lib\common.psm1

# install 7zip
scoop install 7zip
# install non-sucking service manager
scoop install nssm
# install nodejs
scoop install nodejs
# install adb
scoop install adb
# install hibit uninstaller
scoop install hibit-uninstaller
# let's uninstall edge and onedrive
C:\Users\yubo\scoop\apps\hibit-uninstaller\current\HiBitUninstaller-Portable.exe
Write-Output "Please uninstall edge and onedrive"
Request-Continue
# snipaste
scoop install snipaste-beta

# choco installs
Invoke-Elevated {
    # install vscode
    choco install vscode -y
    # install android studio
    choco install androidstudio -y
    # keepass xc
    choco install keepassxc -y
    # chrome
    choco install googlechrome -y
    # powertoys
    choco install powertoys -y
    # windows terminal
    choco install microsoft-windows-terminal -y
    # vmware
    choco install vmwareworkstation -y
    # zotero/citiation
    choco install zotero -y
    # pyenv
    choco install pyenv -y
    # openjdk
    choco install openjdk -y
    # exit
    exit
}

# lockdown browser
$installer = Get-File "https://downloads.respondus.com/OEM/LockDownBrowserOEMSetup.exe"
Invoke-Expression -Command $installer
Write-Output "Go through the lockdown browser installation"
Request-Continue
Remove-Item $installer

# office
python office.py

# freefilesync
python freefilesync.py

# fonts
scoop install FiraCode
scoop install FiraCode-NF

# update repository first
pyenv update
# install python
pyenv install 3.11.0 # latest version
pyenv install 3.10.9 # some packages don't support 3.11.0
pyenv install 3.9.13 # autogluon needs 3.9.13
# install pip
function Install-BasicPackages($version) {
    pyenv global $version
    python -m pip install --upgrade pip # update pip
    pip install --upgrade wheel # build deps
    pip install --upgrade black pygments # formatter and latex code block
    pip install --upgrade jupyterlab notebook # jupyter
    pip install --upgrade playwright # playwright/web automatically
    playwright install
}
Install-BasicPackages 3.11.0
Install-BasicPackages 3.10.9
Install-BasicPackages 3.9.13
pyenv global 3.11.0 # set global version
