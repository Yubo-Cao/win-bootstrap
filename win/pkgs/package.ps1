Import-Module $PSScriptRoot\..\lib\common.psm1

# install 7zip
scoop install 7zip
# install nodejs
scoop install nodejs
# install jdk
scoop install openjdk
# install tectonic and tex
scoop install perl
scoop install tectonic miktex latexindent
# install python
scoop install pyenv
pyenv install 3.11.0b4 # latest version
pyenv install 3.9.13 # autogluon needs 3.9.13
# install pip
pyenv global 3.11.0b4 # latest version
pip install --upgrade pip # update pip
pip install --upgrade wheel # build deps
pip install --upgrade black pygments # formatter and latex code block
pip install --upgrade jupyterlab notebook # jupyter
pip install --upgrade playwright # playwright/web automatically
playwright install
# install adb
scoop install adb
# install hibit uninstaller
scoop install hibit-uninstaller
# let's uninstall edge and onedrive
Write-Output "Please uninstall edge and onedrive"
Request-Continue
C:\Users\yubo\scoop\apps\hibit-uninstaller\current\HiBitUninstaller-Portable.exe
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
    # rclone & winfsp
    choco install rclone winfsp -y
    # powertoys
    choco install powertoys -y
    # windows terminal
    choco install microsoft-windows-terminal --pre -y
    # vmware
    choco install vmwareworkstation -y
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