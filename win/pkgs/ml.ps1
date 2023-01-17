Import-Module $PSScriptRoot\..\lib\common.psm1

Invoke-Elevated {
    # install cuda
    choco install cuda -y
}