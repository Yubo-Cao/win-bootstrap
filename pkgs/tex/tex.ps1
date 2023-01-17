Import-Module $PSScriptRoot\..\lib\common.psm1

# install tectonic and tex
scoop install perl
scoop install tectonic miktex latexindent
# link custom config
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.latexindent.yaml -Value $PSScriptRoot\..\secret\latexindent.yaml