Import-Module $PSScriptRoot\lib\common.psm1

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
# install adb
scoop install adb
# install hibit uninstaller
scoop install hibit-uninstaller
# let's uninstall edge and onedrive
Write-Output "Please uninstall edge and onedrive"
C:\Users\yubo\scoop\apps\hibit-uninstaller\current\HiBitUninstaller-Portable.exe

Invoke-Elevated {
    # install vscode
    choco install vscode -y
    # install android studio
    choco install androidstudio -y
    # keepass xc
    choco install keepassxc -y
    # rclone
    choco install rclone -y
    # chrome
    choco install googlechrome -y
    # exit
    exit
}