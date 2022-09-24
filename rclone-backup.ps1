# Take shadowcopy
$s1 = (Get-WmiObject -List Win32_ShadowCopy).Create("C:\\", "ClientAccessible")
$shadowId = $s1.ShadowId
$s2 = Get-WmiObject Win32_ShadowCopy | Where-Object { $_.ID -eq $s1.ShadowID }
$d  = $s2.DeviceObject + "\\"

# Make symbolic directory link
cmd /c "mklink $env:SYSTEMDRIVE\shadowcopy $d /d"

# Perform sync backup to cloud
.\rclone.exe sync $env:SYSTEMDRIVE\shadowcopy compress-rclone-dtc-b2:21152-366-372/$hostName --config=$env:SYSTEMDRIVE\Windows\LTsvc\Bin\rclone.conf --exclude=**Windows** --exclude=**OneDrive** --exclude=**WindowsApps** --exclude=**Packages** --exclude=**temp* --exclude=*.iso --exclude=*.vhdx --exclude=*.vhd --exclude=*.vmdk --exclude=*.vdi --exclude=*.img --exclude=**Downloads** --exclude=**Cache** --exclude=*.avhdx --exclude=**MBS** --exclude=*.ost --ignore-case --b2-chunk-size=10M --transfers=10 --exclude='**Microsoft Office**' --exclude=**$** --exclude=**pagefile.sys** --exclude=**swapfile.sys** --exclude=**hiberfil.sys** --exclude=**AMD --exclude=**Adobe --exclude='**K-Lite Codec Pack' --exclude='**Internet Explorer' --exclude='**Advanced IP Scanner' --exclude='**Advanced Port Scanner'

# Remove symbolic link
Remove-Item "$env:SYSTEMDRIVE\shadowcopy" -Force

# Remove ShadowCopy
vssadmin delete shadows /shadow=$shadowId