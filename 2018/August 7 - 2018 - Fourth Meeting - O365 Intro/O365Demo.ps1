$credential = Get-Credential

#Azure Active Directory PowerShell for Graph module

Connect-AzureAD -Credential $credential

#Azure Active Directory Module for Windows PowerShell module

Connect-MsolService -Credential $credential

#Sharepoint online

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://<domainhost>-admin.sharepoint.com -credential $credential

#Skype for Business

Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $credential
Import-PSSession $sfboSession

#Exchange online

$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $exchangeSession

#Security and compliance

$SccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $SccSession -Prefix cc


#AzureAD module can be installed via PS Gallery

Install-module azuread

Connect-azuread

#MSOnline module can be installed via PS Galley

Install-module msonline 

Connect-msolservice

Get-command -module azuread
Get-command -module msonline

#create onprem AD users

function New-ADUserMass_V1 {	
	
	$ImportFile = Read-Host "Enter the Name of your CSV File"
	
	
	Import-Csv $ImportFile | foreach-object {
	
	New-ADUser -SamAccountName $_.samAccountName -UserPrincipalName $_.Userprincipalname -Name $_.Name -DisplayName $_.Name -surname $_.surname -GivenName $_.givenname -Initials $_.initials -Department $_.Department -Description "AD User Account Created $(Get-Date)" -Path $_.Path -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) -Enabled $True -ChangePasswordAtLogon $True -PassThru
	
	
	    }
	
	
	}

#create cloud user
New-MsolUser -UserPrincipalName clouduser2@mmdesigntech.com -DisplayName CloudUser2

#get cloud users
Get-MsolUser


#create cloud group
New-MsolGroup -DisplayName E3Users2 -Description "Users in this group get access to E3 license"

#add cloud member
Add-MsolGroupMember -GroupObjectId 65a66b2a-16de-4886-a565-10c7f30a3858 -GroupMemberType User -GroupMemberObjectId 181079b0-5b04-4fda-981a-346162f0bedd

#get cloud membership
Get-MsolGroupMember -GroupObjectId 65a66b2a-16de-4886-a565-10c7f30a3858


#create onpremise group
New-ADGroup -DisplayName E3Users3 -Name E3Users1 -Description "Licenses users with E3" -GroupCategory Security -GroupScope Global -Path "OU=Groups,OU=MMDesign,DC=mmdesign,DC=local"

#add members
Add-ADGroupMember -Identity E3users3 -Members demo1userg,demo1userh,demo1useri

#configure groups OU in synchronization manager
#Select groups OU
#Save

#csexport
cd "C:\Program Files\Microsoft Azure AD Sync\bin"
.\csexport.exe "mnmdesign.onmicrosoft.com - AAD" c:\users\administrator\desktop\export.xml /f:x
.\CSExportAnalyzer.exe c:\users\administrator\desktop\export.xml > c:\users\administrator\desktop\export.csv

#manual sync, run import onprem ad connector, then cloud connector, then sync


#run full delta sync including export to azure ad
Start-ADSyncSyncCycle -PolicyType Delta

#configure group for group licensing
#Access portal site for this
