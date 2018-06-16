function New-ADUserMass_V1 {
	
	$ImportFile = Read-Host "Enter the Name of your CSV File"

	
	Import-Csv $ImportFile | foreach-object {
	
		New-ADUser -SamAccountName $_.samAccountName -UserPrincipalName $_.Userprinicpalname -Name $_.Name -DisplayName $_.Name -surname $_.surname -GivenName $_.givenname -Initials $_.initials -Department $_.Department -Description "AD User Account Created $(Get-Date)" -Path $_.Path -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) -Enabled $True -ChangePasswordAtLogon $True -PassThru

	
    }
	

}


function New-ADUserMass_V2 {
	
	param (
	    [Parameter(
	    HelpMessage = "Enter the name of the csv file you intend to use for import.",
	    Mandatory = $true,
	    ValueFromPipeline = $true,
	    ValueFromPipelineByPropertyName = $true)][string]
	    $ImportFile
		
	)

	
	Import-Csv $ImportFile | foreach-object {
	
		 New-ADUser -SamAccountName $_.samAccountName `
		-UserPrincipalName $_.userprinicpalname `
		-Name $_.Name `
		-DisplayName $_.Name `
		-surname $_."Last Name" `
		-GivenName $_."First Name" `
		-Initials $_."Middle Initial" `
		-Department $_.Department `
		-Description "AD User Account Created $(Get-Date)" `
		-Path $_.Path `
		-AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) `
		-Enabled $True `
		-ChangePasswordAtLogon $True `
		-PassThru

	
    }
	
	
}


function New-ADUserMass_V3 {
	
	[cmdletbinding()]
	param (
	    [Parameter(
	    HelpMessage = "Enter the name of the csv file you intend to use for import ",
	    Mandatory = $true,
	    ValueFromPipeline = $true,
	    ValueFromPipelineByPropertyName = $true)][string]
	    $ImportFile
		
	)



<#

help about_Functions_CmdletBindingAttribute

-Verbose
-Debug
-ErrorAction
-WarningAction
-ErrorVariable
-WarningVariable
-OutVariable
-OutBuffer
-PipeLineVariable

#>
    #Import-Module ADProvisioning

	Import-Csv $ImportFile | foreach-object {
	
        $Password = Get-PasswordRandom

        $NewADUserParams = @{
        
        
            'SamAccountName'        = $_.samAccountName
		    'UserPrincipalName'     = $_.userprinicpalname
		    'Name'                  = $_.Name
		    'DisplayName'           = $_.Name
		    'surname'               = $_.surname
		    'GivenName'             = $_.givenname
		    'Initials'              = $_.initials
		    'Department'            = $_.Department
		    'Description'           = "AD User Account Created $(Get-Date)"
		    'Path'                  = $_.Path
		    'AccountPassword'       = (ConvertTo-SecureString $Password -AsPlainText -force)
		    'Enabled'               = $true 
		    'ChangePasswordAtLogon' = $true
		    'PassThru'              = $true
           #'Server'                = $Server  (Listing a Server can help with replication)
        
        }

        Try {

            $Name = $_.Name
            Write-Verbose "Creating account $Name"
            New-ADUser @NewADUserParams | Out-Null

        }

        Catch {

            Write-Error "There was an Error creating account $Name"

        }
	
    }
	
}


function Get-PasswordRandom  {	
	
	[Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
	[System.Web.Security.Membership]::GeneratePassword(15, 2) | Out-Null
	
	do {
		$Script:Password = [System.Web.Security.Membership]::GeneratePassword(15, 2)
	}
	until ($Script:Password -match '\d')
	
        $Script:Password
	
}


#New-ADUserMass_V1


#".\testusers2.csv" | New-ADUserMass_V2

<#
Write-Output "`n"
Get-PasswordRandom
#>

 #New-ADUserMass_V3 -ImportFile ".\testusers3.csv" -Verbose

