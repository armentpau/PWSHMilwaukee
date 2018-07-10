Write-Output "test"
Get-Item "c:\nonexistantfile" -ErrorVariable myVariable
exit 123