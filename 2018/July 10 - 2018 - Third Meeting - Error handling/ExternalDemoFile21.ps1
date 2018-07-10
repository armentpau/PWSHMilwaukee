$processName = "InvalidProcess"
try
{
	Get-Process -Name $processName -ErrorAction Stop
}
catch
{
	Write-Output "Error: $($_.tostring())"
}