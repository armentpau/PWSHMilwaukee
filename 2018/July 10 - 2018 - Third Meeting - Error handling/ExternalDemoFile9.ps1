if (get-aduser pdearmen -erroraction silentlycontinue)
{
	write-output "Found user account for Paul -- we should never get here!"
}
else
{
	write-output "No user account for Paul was found - we should get here!"
}