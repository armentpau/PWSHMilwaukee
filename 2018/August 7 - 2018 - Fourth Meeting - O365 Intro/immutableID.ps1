function get-ImmutableIDfromADObject
{
    [CmdletBinding()] Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]$ADObject) 
   process{ 
        if (!$ADObject.objectguid){$ADObject = get-adobject $AdObject -properties objectGuid}
        [system.convert]::ToBase64String($ADObject.objectguid.tobytearray())
    }
}

function get-ADObjectFromImmutableID{
      [CmdletBinding()] Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)][string]$ImmutableID)
   process { get-adobject  ([guid]([system.convert]::FromBase64String($ImmutableID)))}
}

<#
get-aduser shane.wright | get-ImmutableIDfromADObject
6WuADX7LfUa8DVAQGxuZcA==

get-aduser shane.wright | get-ImmutableIDfromADObject | get-ADObjectFromImmutableID

DistinguishedName                          Name         ObjectClass ObjectGUID                          
-----------------                          ----         ----------- ----------                          
CN=Shane Wright,OU=Staff,DC=contoso,DC=com Shane Wright user        0d806be9-cb7e-467d-bc0d-50101b1b9970


get-ADObjectFromImmutableID 6WuADX7LfUa8DVAQGxuZcA==
DistinguishedName                          Name         ObjectClass ObjectGUID                          
-----------------                          ----         ----------- ----------                          
CN=Shane Wright,OU=Staff,DC=contoso,DC=com Shane Wright user        0d806be9-cb7e-467d-bc0d-50101b1b9970
#>