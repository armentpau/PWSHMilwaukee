try
{
	get-aduser pdearmen
	write-output "Found user account for Paul -- we should never get here!"
}
catch
{
	write-output "No user account for Paul was found - we should get here."
}
