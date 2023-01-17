Import-Module $PSScriptRoot\..\lib\common.psm1

Invoke-Elevated {
    # rclone & winfsp
    choco install rclone winfsp -y
}

$config = "C:\Users\yubo\AppData\Roaming\rclone\rclone.conf"
if (Test-Path $config) {
    Write-Output "rclone config already exists"
}
else {
    Write-Output "rclone config does not exist"
    $stored = "..\..\secret\rclone.conf"
    if (Test-Path $stored) {
        Write-Output "rclone config stored"
        Copy-Item $stored $config
    }
    else {
        Write-Output "rclone config not stored"
        Write-Output "Please configure rclone"
        Request-Continue
        rclone config
    }
}