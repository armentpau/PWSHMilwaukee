function Get-ADGroupMembers_Demo {
	
	[cmdletbinding()]
	param (
		[Parameter(
			Mandatory   = $true,
			HelpMessage = "Enter the name of the AD Group.")][string]
		$ADGroup

	)
	
    begin {}
	
    process {
		
	    $Members = Get-ADGroup $ADGroup -Properties member | 
                   Select-Object -ExpandProperty member | 
	               Get-ADObject 
	
	    foreach ($member in $Members) {
			
		    $GroupMember = Get-ADObject $Member | Get-ADObject -properties samaccountname 

            $Script:GroupMembersObj = [PSCustomObject]@{

		        Group    = $ADGroup 
                Type     = $GroupMember.ObjectClass 
                Username = $GroupMember.SamAccountName 
                Name     = $GroupMember.Name 

                }

            $GroupMembersObj 

	    }

    }

    end {}
	
}

#Get-ADGroupMembers_Demo -ADGroup Security-Group1



$Date = $(Get-Date -f yyyyMMdd-hhmmss)
$OutFile = "C:\Users\945571\Documents\$ADGroup _Members _$Date.csv"
Get-ADGroupMembers_Demo -ADGroup Security-Group1 | Export-Csv $Outfile -Append -NTI

