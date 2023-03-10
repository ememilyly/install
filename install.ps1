if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

$softwareList =
    "googlechrome",
    "discord",
    "spotify",
    "sharex",
    "teracopy",
    "7zip",
    "notepadplusplus",
    "firefox",
    "zoom",
    "steam",
    "foobar2000",
    "k-litecodecpackfull",
    "gimp",
    "irfanview",
    "barrier"

foreach ($software in $softwareList) {
    choco install $software -y
}

Read-Host "done"

<#
- Check for home disk, change to H
- fix explorer to this pc, extensions, hidden files
- Point userprofile folders to H:\folder
- clean all the shit from start menu
- Fix taskbar
- Hide recycling bin
- enable admin share h$?
- enable and install wsl
- enable hyperv

things to install

nvidia drivers?

xivlauncher
#>
