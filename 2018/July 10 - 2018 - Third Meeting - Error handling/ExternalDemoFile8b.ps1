try
{
	New-NonTerminatingError -erroraction stop
}
catch
{
	write-output "We got here because the error in the try block was a terminating error."
}