function Invoke-Elevated($scriptblock) {
    $sh = new-object -com 'Shell.Application'
    $sh.ShellExecute('powershell', "-NoExit -Command $scriptblock", '', 'runas')
}

function Request-Continue() {
    Write-Host -NoNewLine 'Press any key to continue...'
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

function Get-File($url, $filename = "") {
    New-Item ..\..\downloads -ErrorAction SilentlyContinue 
    if ($filename -eq "") {
        $filename = $url.Split("/")[-1]
    }
    $target = "..\..\downloads\$filename"
    Invoke-WebRequest -Uri $url -OutFile $target # download directory
    return $target
}

function Get-Secret($name) {
    return Get-Item $PSScriptRoot\..\secret\$name
}

function Get-Passwords() {
    return Get-Secret "passwords.json" | Get-Content -Raw | ConvertFrom-Json
}

Export-ModuleMember -Function Invoke-Elevated
Export-ModuleMember -Function Request-Continue
Export-ModuleMember -Function Get-File
Export-ModuleMember -Function Get-Secret
Export-ModuleMember -Function Get-Passwords