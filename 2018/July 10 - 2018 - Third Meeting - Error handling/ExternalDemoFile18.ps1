trap
{
	Write-Output "We experienced an error"
}

Stop-Process -Name "InvalidProcess1" -ErrorAction stop
Stop-Process -Name "InvalidProcess2" -ErrorAction Stop