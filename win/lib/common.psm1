function Request-Admin() {
    # https://stackoverflow.com/questions/7690994/running-a-command-as-administrator-using-powershell
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        Break
    }
}

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

Export-ModuleMember -Function Request-Admin
Export-ModuleMember -Function Invoke-Elevated