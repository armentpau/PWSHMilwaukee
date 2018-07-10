try
{
	Get-Item c:\nonexistant -ErrorAction Stop
}
catch [System.Management.Automation.ItemNotFoundException]
{
	Write-Output "The error was item could not be found exception."
}
catch
{
	Write-Output "The error was not item could not be found exception."
}