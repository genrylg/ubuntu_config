$url = "https://download.microsoft.com/download/8/4/9/849DBCF2-DFD9-49F5-9A19-9AEE5B29341A/WebPlatformInstaller_x64_en-US.msi"
$output = ".\WebPlatformInstaller_amd64_en-US.msi"
Invoke-WebRequest -Uri $url -OutFile $output
.\WebPlatformInstaller_amd64_en-US.msi /quiet
WebPICMD.exe /Install /Products:"PHP 7.4.13 (x64)" /AcceptEULA