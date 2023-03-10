# Install Chocolatey if it's not already installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Define list of software to install
$softwareList = "googlechrome", "firefox", "7zip", "notepadplusplus"

# Loop through list and install software using Chocolatey
foreach ($software in $softwareList) {
    choco install $software -y
}
