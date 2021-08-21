<# FW Logging Test Automation v0.1 WIP - https://wiki.ith.intel.com/display/LADSW/Windows+FW+Logging #>
$AdapterName = "YourTestAdapterHere"
$LoggingConfig = @("C000","C001","C002","C003","C004","C005","C006","C007","F008","C009","C00A","C00B","C00C","C00D","C00E","C00F","C010","C011","C012","F013","C014","C015","C016","C017","C018","C019","C01A","C01B")
$NegLoggingConfig = @("0000","0001","0002","0003","0004","0005","0006","0007","0008","0009","000A","000B","000C","000D","000E","000F","0010","0011","0012","0013","0014","0015","0016","0017","0018","0019","001A","001B")
Disable-NetAdapter -name $AdapterName -confirm:$false
logman start test -o c:\temp\fw_log.etl -ets -p {BDD04ED8-F4BB-4B36-BB76-D2FFC123EC67} 0xFFFFFFFF 4
New-NetAdapterAdvancedProperty -Name $AdapterName -RegistryKeyword FwLoggingMode -RegistryDataType REG_DWORD -RegistryValue 1
New-NetAdapterAdvancedProperty -Name $AdapterName -RegistryKeyword FwLoggingConfigs -RegistryDataType REG_MULTI_SZ -RegistryValue $LoggingConfig
Enable-NetAdapter -name $AdapterName
logman stop test -ets'