<# CPK/CVL Script to search for newest directory and copy over latest release to local disk for installation and test execution
To Do: Add support for each SW project as implemented
#>

gci x:\"Columbia Park SW2 C0 Beta" | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1 | % {
Write-Output $_.FullName
$toFolder = "c:\temp\work"
ForEach-Object {
         Copy-Item -Path $_.FullName -Destination $toFolder -Recurse -Force
	}
}

# Run defined regression tests.
Invoke-Item CPKReg.bat