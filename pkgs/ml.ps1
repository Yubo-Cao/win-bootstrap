Import-Module $PSScriptRoot\..\lib\common.psm1

Invoke-Elevated {
    # install cuda
    choco install cuda -y
    # install julia
    choco install julia -y
}

# pytorch
pyenv global 3.10.9
pip install torch torchvision torchaudio --force-reinstall --index-url https://download.pytorch.org/whl/nightly/cu117
# tensorflow
pip install tensorflow