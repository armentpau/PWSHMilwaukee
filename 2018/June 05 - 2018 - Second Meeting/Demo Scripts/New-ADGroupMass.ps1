function New-ADGroupMass_Demo {

    [cmdletbinding()]
	param (
	    [Parameter(
	    HelpMessage = "Enter the name of the csv file you intend to use for import.",
	    Mandatory = $true,
	    ValueFromPipeline = $true,
	    ValueFromPipelineByPropertyName = $true)][string]
	    $ImportFile
		
	)

    Import-CSV $ImportFile | foreach {

        $Name = $_.Name

        $NewADGroupParams = @{

            'Samaccountname' = $_.samaccountname
            'Name'           = $_.Name
            'Path'           = $_.Path
            'Description'    = $_.Description
            'GroupScope'     = $_.GroupScope
            'GroupCategory'  = $_.GroupCategory
            'OtherAttributes'= @{info="Created $(Get-Date)"}
        
        }

        try {
            
            Write-Verbose "Creating AD Group $Name"
            New-ADGroup @NewADGroupParams
        }

        catch {
 
        
            Write-Error "Error Creating AD Group $Name" 

        }

    }

}

New-ADGroupMass_Demo -ImportFile "newadgroups.csv" -Verbose