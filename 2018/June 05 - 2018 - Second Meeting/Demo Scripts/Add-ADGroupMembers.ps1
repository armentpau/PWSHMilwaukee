function Add-ADGroupMember_Demo {

	[cmdletbinding()]
	param (
		[Parameter(
			Mandatory = $true,
			HelpMessage = "Enter the samaccountname(s) of the AD Object where access is being added")][string[]]
		$Members,
		[Parameter(
			Mandatory = $true,
			HelpMessage = "Enter the samaccountname of the AD Group where membership is being added")][string]
		$ADGroup

	)
	
	begin {

		$Global:Error.Clear()
		ApproveUptime
		$Script:AddedtoGroup   = @()
		$Script:ExistedinGroup = @()
		$Script:InactiveUsers  = @()
		$Function = "Add-AHCADGroupMember"
				
		Set-AHCMonthlyDirectory -Folders $LogDir, $ErrorDir -Function $Function -Temp 
		
		$Script:Logfile 		   = "$LogDir\$Function\$year\$Month - $Monthname\$Ticket-AD Group Membership Updates-$(Get-Date -f "yyMMdd-hhmmss").txt"
		$Script:ErrorLog 		   = "$ErrorDir\$Function\$year\$Month - $Monthname\ErrorLog-$Function-$(Get-Date -f "yyMMdd-hhmmss").txt"
		$Script:Tmp_Additions      = "$LogDir\$Function\$year\$Month - $Monthname\Tmp\$Ticket $(Get-Date -f yyyyMMdd) Adds.txt"
		$Script:Tmp_ExistingAccess = "$LogDir\$Function\$year\$Month - $Monthname\Tmp\$Ticket $(Get-Date -f yyyyMMdd) Existing Access.txt"
		$Script:Tmp_Inactives 	   = "$LogDir\$Function\$year\$Month - $Monthname\Tmp\$Ticket $(Get-Date -f yyyyMMdd) Inactives.txt"


    }
			
	process {

		foreach ($Member in $Members) {

            ### Exclude Inactive Users from Group Membership Addition
			
			if (((Get-ADObject -Filter { sAMAccountname -eq $Member } | 
                 select -ExpandProperty objectclass) -eq "user")`
                 -and (Get-ADUser -identity $member | 
                 select -ExpandProperty enabled) -eq $false) {
				
				Write-ColorOutput "Inactive Account Not Updated: $Member" -ForegroundColor DarkGray | Tee-Object | Add-Content $Tmp_Inactives
				
					
			}
			
            
            else {  #Verify existing membership

                Get-ADObject -filter {samaccountname -eq $member} -properties Memberof | foreach {
                $Membership = $_.memberof | Get-ADGroup -ErrorAction SilentlyContinue  
					
			    }

											
				$Group = Get-ADGroup -Identity $ADGroup -Properties canonicalname
					
				if ($Membership.samaccountname -contains $Group.samaccountname) {
					
					Write-ColorOutput "$($Group.samaccountname) : Security pre-existed for $Member" -ForegroundColor DarkGray
						
				}
				
				else {
				
					try {
						
						Write-Verbose "Adding Group"
						Add-ADGroupMember -Identity $ADGroup -Members $Member -Confirm:$false -ErrorAction Stop
						Write-Output "$($Group.samaccountname) : Security Updated. Member Added: $Member" 
							
					}
								
					catch {
						
						Write-Error "Could not add $Member to Group: $ADGroup"
							
					}

								
					Set-AHCADUserDescription_Demo -Identity $Member -Description "$(Get-Date) mod "
							
		
					}
							
				}
												
			}	
							
	} #process block

	end {

    Write-Output "`n"
    
    }

}

function Set-AHCADUserDescription_Demo {
	
	[cmdletbinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[String]
		$Identity,
		[Parameter(
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[String]
		$Description
		
	)
	
	begin {}
	
	process {
		
		$ExistingDesc = Get-ADUser -Identity $Identity -Properties Description | Select-Object -ExpandProperty Description
		
		try {
			
			if ($ExistingDesc) {
				[int]$DescChars       = $ExistingDesc| Measure-Object -Character | foreach { $_.characters }
				[int]$AppendDataChars = $Description | Measure-Object -Character | foreach { $_.characters }
				
				if ($DescChars + $AppendDataChars -ge "1024") {
					
					$ExistingDesc = $ExistingDesc.Substring(0, $ExistingDesc.Length - $AppendDataChars)
					
				}
				
				Set-ADUser -Identity $Identity -Description "$Description, $ExistingDesc"
				
			}
			else {
				Set-ADUser -Identity $Identity -Description "$Description"
				
			}
			
		}
		
		catch {
			
			"$Identity : Error setting Description in Active Directory." | Add-Content $ErrorLog
			
		}
		
	}
	
}

function Write-ColorOutput {

	param(

		[Parameter(
		           ValueFromPipeline = $true,
		           ValueFromPipelineByPropertyName = $true,
		           Position = 0)]
		[string]$Text,
		[Parameter(Mandatory = $true,
		           Position = 1)]
		[string]$ForegroundColor
		

	)
	
    # save the current color
    $forecolor = $host.UI.RawUI.ForegroundColor
    # set the new color
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    # output
    if ($Text) {
        Write-Output $Text
    }
    else {
        $input | Write-Output
    }
    # restore the original color
    $host.UI.RawUI.ForegroundColor = $forecolor
	
}


Add-ADGroupMember_Demo -Members Demo1userA,Demo1userB,Demo1userc  -ADGroup Security-Group1

Add-ADGroupMember_Demo -Members Demo1userA,Demo1userB,Demo1userc  -ADGroup Security-Group2

Add-ADGroupMember_Demo -Members Demo1userA,Demo1userB,Demo1userc  -ADGroup Security-Group3

Add-ADGroupMember_Demo -Members Demo1userA,Demo1userB,Demo1userc  -ADGroup Security-Group1