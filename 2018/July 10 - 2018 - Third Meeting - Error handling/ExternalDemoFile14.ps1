try
{
	New-TerminatingError
	Write-Output "There was no error"
}
catch
{
	write-output "We got here because the error in the try block was a terminating error."`
	
}
finally
{
	Write-Output "Continuing on with the code"
}