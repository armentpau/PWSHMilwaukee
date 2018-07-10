trap
{
	Write-Output "We experienced an error"
}

Stop-Process -Name "InvalidProcess1" -ErrorAction Continue
Stop-Process -Name "InvalidProcess1" -ErrorAction SilentlyContinue