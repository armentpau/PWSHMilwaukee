try
{
	Stop-Process -Name "InvalidProcess1" -ErrorAction stop
}
catch
{
	Write-Output "Guess this process isn't found...."
}
try
{
	Stop-Process -Name "InvalidProcess2" -ErrorAction Stop
}
catch
{
	Start-Process notepad
}