# install packer
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
# install config
$config = "$env:LOCALAPPDATA\nvim\init.lua"
$config_dir = Split-Path $config
if (!(Test-Path $config_dir)) {
    New-Item -ItemType Directory -Path $config_dir
}
if (!(Test-Path $config)) {
    Copy-Item "$PSScriptRoot\init.lua" $config
}