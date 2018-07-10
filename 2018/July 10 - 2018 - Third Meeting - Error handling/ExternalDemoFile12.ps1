if (get-aduser -filter { samaccount -eq "pdearmen" } -erroraction SilentlyContinue)
{
	write-output "Found user account for Paul -- we should never get here!"
}
else
{
	write-output "No user account for Paul was found - we should get here!"
}