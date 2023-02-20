Import-Module $PSScriptRoot\..\lib\common.psm1

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# rclone & winfsp
choco install rclone winfsp -y

# ensure configuration
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

function Install-RcloneService($src, $dst = "$home\Documents\mount\$src") {
    # Create a rclone service that mounts $src to $dst

    $name = "rclone-mount-$src"
    $service = Get-Service -Name $name -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Output "rclone service does not exist. Creating..."
        nssm install $name (Get-Command rclone).path 'mount' "${src}:/" $dst '--vfs-cache-mode' 'full'
        nssm set $name AppDirectory $home
        nssm set $name AppStdout $home\Documents\mount\log\${name}.log
        nssm set $name AppStderr $home\Documents\mount\log\${name}.log
        nssm set $name DisplayName "Rclone mount $src"
        nssm set $name Description "This mount $src drive using rclone to $dst"
        nssm set $name Start SERVICE_AUTO_START
        nssm set $name ObjectName ".\$((Get-Passwords).local.username)" (Get-Passwords).local.password
    }
    else {
        Write-Output "rclone service already exists"
    }
    $service = Get-Service -Name $name
    if ($service.Status -eq "Running") {
        Write-Output "rclone service already running"
    }
    else {
        Write-Output "rclone service not running. Starting..."
        mkdir (Split-Path $dst) -ErrorAction SilentlyContinue
        mkdir "$(Split-Path $dst)\log" -ErrorAction SilentlyContinue
        nssm start $name
    }
}

# start service
Install-RcloneService "personal"

# wait
Request-Continue