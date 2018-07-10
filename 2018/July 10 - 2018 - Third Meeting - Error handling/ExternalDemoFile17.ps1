$processName = "InvalidProcess"
try
{
	Get-Process -Name $processName -ErrorAction Stop
}
catch
{
	Write-Output "Could not find process named $($processName) to stop"
}