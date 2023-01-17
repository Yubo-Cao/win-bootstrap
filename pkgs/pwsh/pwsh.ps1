Import-Module $PSScriptRoot\..\..\lib\common.psm1

# install pwsh 7
scoop install pwsh

# install oh-my-posh
scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json

# link to profile
Copy-Item -Force "$PSScriptRoot\profile.ps1" $profile