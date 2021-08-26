<#
.SYNOPSIS
    Checks if the driver version from the sys file matches its inf    
.EXAMPLE
    Check-DriverVersion.ps1 drivers
    Recursively search in directory named 'folders' for sys files and corresponding inf, run version check and report,
.INPUTS
    $DRIVERS_FOLDER - the path to search from; current folder by default
.OUTPUTS
    If versions do not match: sys & inf file names, their versions
    sets $LASTEXITCODE to 1
.NOTES
    None
#>

Param
(
    [Parameter(Position=1)]
    [string]$DRIVERS_FOLDER = '.'
)


$exitcode = 0

Get-ChildItem $DRIVERS_FOLDER -recurse | where {$_.extension -eq ".sys"} | % {
    $sys = $_.FullName
    $inf = $_.DirectoryName + "\" + $_.BaseName + ".inf"
    if (Test-Path -Path $inf -PathType Leaf)
    {
        $sysver = (Get-Item $sys).VersionInfo.ProductVersion
        foreach($line in Get-Content $inf)
        {
            if($line -match "DriverVer")
            {
                $infver = $line.Split(',')[1]
                if ($sysver -eq $infver)
                {
                    #Write-Host "sys & inf versions match:" $sysver $infver
                }
                else
                {
                    Write-Host $sys
                    Write-Host $inf
                    Write-Host "sys & inf versions do not match:" $sysver $infver
                    $exitcode = 1
                }
            }
        }
    }
}

exit $exitcode
