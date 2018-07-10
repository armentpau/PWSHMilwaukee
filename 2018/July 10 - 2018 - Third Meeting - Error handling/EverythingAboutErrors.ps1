Clear-Host

#region setup for remote connection

####### winrm host data in case of new server #######

winrm quickconfig
Set-Item wsman:\localhost\client\trustedhosts -value "192.168.3.10"

######################################################
$credential = get-credential
#enter into the remote session
#endregion

#region support functions
function New-TerminatingError
{
	throw "This is a terminating Error"
}

function New-NonTerminatingErrorWithoutCmdletBinding
{
	write-error "Non terminating error"
}

function New-NonTerminatingError
{
	[CmdletBinding()]
	param ()
	write-error "Non terminating error"
}

function test-trap
{
	trap
	{
		Write-Output "An error was thrown and we got here."
	}
	New-TerminatingError
}
#endregion

#region Show How The Above Code Segments Work

New-TerminatingError

New-NonTerminatingError

#endregion

#region automatic variables

#region error variable
#clear the error array
$Error.clear()
#Generate an error by looking for a non-existent file
Get-Item c:\fileDoesntexist.txt
#Check the contents of the error array
$Error
#Generate a new error by looking for a non-existent file
Get-Item c:\filedoesntexist2.txt
#Check the contents of the error array
$Error
#Let's get the most recently returned error
$error[0]
#Get the properties of the error object
$Error | Get-Member
#Simplified error message
$Error[0].tostring()
#Get the target object of the command that generated the error
$Error[0].TargetObject
#A little more details and an easier to read error message
$Error[0].categoryinfo
#A little deception sometimes - remember we are dealing with objects not strings
$Error[0].Exception
$Error[0].Exception | Get-Member
#Knowing this we can look for the full name of the exception
$Error[0].Exception.GetType().fullname
#You can get the stack trace of the command that generated the error if
#the error was created by a script - this does not work from an interactive console
# unless you run a script
$Error[0].scriptstacktrace
Start-Process powershell
#endregion

#region $?

#$? can be used to determine if the previous command completed successfully
#Example
Test-Connection localhost -Count 1
#What is the status of the command?
$?
#But this isn't always accurate
Get-Content .\ExternalDemoFile3a.ps1
.\ExternalDemoFile3a.ps1

#And you need to be careful about subsequent commands
Get-Content .\ExternalDemoFile5.ps1
#Let's execute the script
.\ExternalDemoFile5.ps1

#endregion

#region LastExitCode
#This one is quick
Get-Content .\ExternalDemoFile2.ps1
.\ExternalDemoFile2.ps1
#Let's look at the exit code now
$LastExitCode
#Ok thats nice and all....
#But how can it be used?
Get-Content .\ExternalDemoFile4.ps1
.\ExternalDemoFile4.ps1 -path1
$LastExitCode
.\ExternalDemoFile4.ps1 -path2
$LastExitCode
#Awww that's nice and all but...
#How does this help me?
#What is exit code 0?
Read-Host
#Exit code 0 is the exit code meaning success
#Anything else likely indicates an error
#Using this with $?
Get-Content .\ExternalDemoFile6.ps1
.\ExternalDemoFile6.ps1

#endregion

#endregion

#region ErrorAction
$Error.clear()
#The default action is the same as specifying continue
Get-Item c:\nonexistantfile -ErrorAction Continue
$error[0]

#Setting erroraction to ignore
$Error.clear()
Get-Item c:\nonexistantfile -ErrorAction Ignore
$error[0]

#Setting erroraction to inquire
$Error.clear()
Get-Item c:\nonexistantfile -ErrorAction Inquire
$error[0]


#Setting erroraction to SilentlyContinue - you should not see an error message
$Error.clear()
Get-Item c:\nonexistantfile -ErrorAction SilentlyContinue
$error[0]

#Setting erroraction to Stop - the command would stop - and creates a terminating error
$Error.clear()
Get-Item c:\nonexistantfile -ErrorAction Stop
$error[0]

#we can't do suspend unless we did a workflow - workflows are rare to find out in the wild - and is an advanced ability
Read-Host
#endregion

#region ErrorVariable
#You can use the errorVariable to store a value and use it later on
#This is particularly useful when you may have mutliple commands which COULD error
#Before your logic statement
$Error.clear()
Stop-Process -Name invalidprocess -ErrorAction SilentlyContinue -ErrorVariable ProcessError
Stop-Process -Name invalidProcess2 -ErrorAction stop
#If we look at the error variable
$error
#Notice that if we tried to do a logic process on $error[0] it would
#Be going against the second error - not the first
#Value of ProcessError
$ProcessError
#And if we use that variable to evaluate if we encountered an error
#On the first command...
if ($ProcessError) { Write-Output "Something is not right here....." }

#Kinda a less known thing with ErrorVariable
#Putting a + in front of the ErrorVariable name will append the value to the variable
#Example:
$CustomErrorVariable
Stop-Process -Name invalidprocess -ErrorAction SilentlyContinue -ErrorVariable CustomErrorVariable

#Let's look at the value here
$customErrorVariable

#Let's append to the error variable
Stop-Process -Name invalidNewprocess -ErrorAction SilentlyContinue -ErrorVariable +CustomErrorVariable

#BUT!
$CustomErrorVariable

#endregion


#### Try/Catch Basics
#We have some support functions to help with this
#The following helper function creates a terminating error
New-TerminatingError
#The following helper function creates a non-terminating error
New-NonTerminatingError


#region Terminating Error In Try/Catch Block
Get-Content .\ExternalDemoFile13.ps1
.\ExternalDemoFile13.ps1
#endregion

#region Non Terminating Error In Try/Catch Block
Get-Content .\ExternalDemoFile7.ps1
.\ExternalDemoFile7.ps1
#endregino

#region Make A Non Terminating Error A Terminating Error pt1
Get-Content .\ExternalDemoFile8a.ps1
.\ExternalDemoFile8a.ps1
#endregion

#region Make A Non Terminating Error A Terminating Error pt2
Get-Content .\ExternalDemoFile8b.ps1
.\ExternalDemoFile8b.ps1
#endregion

#now we are connecting to the domain controller
Enter-PSSession -ComputerName "192.168.3.10" -Credential $credential

#region Commands that doesn't respect erroraction - get-aduser
Get-Content .\ExternalDemoFile9.ps1
.\ExternalDemoFile9.ps1
#endregion

#region Alternatives
Get-Content .\ExternalDemoFile11.ps1
.\ExternalDemoFile11.ps1

Get-Content .\ExternalDemoFile12.ps1
.\ExternalDemoFile12.ps1

#endregion

########END DEMO FILE 2############


#Trap - This is what we had for error handling in PowerShell v1
#It has uses....but.....its not as flexible as everything else
#Trap only triggers on terminating errors
Get-Content .\ExternalDemoFile15.ps1
.\ExternalDemoFile15.ps1

#If we use silentlycontinue or continue.....
Get-Content .\ExternalDemoFile16.ps1
.\ExternalDemoFile16.ps1
#The trap never caught....

#Thankfully we are no longer on PowerShell V1 anymore....
#We can now use Try/Catch
Get-Content .\ExternalDemoFile17.ps1
.\ExternalDemoFile17.ps1

#Now why is this better than Trap?
Get-Content .\ExternalDemoFile18.ps1
.\ExternalDemoFile18.ps1

Get-Content .\ExternalDemoFile19.ps1
.\ExternalDemoFile19.ps1

#### Try/Catch Advanced

#Specific exception try/catch
Get-Content .\ExternalDemoFile10.ps1
.\ExternalDemoFile10.ps1

#What happens when you don't have the exception listed?
Get-Content .\ExternalDemoFile10a.ps1
.\ExternalDemoFile10a.ps1

#Try\Catch\Finally
#what's the difference between standard try/catch and try/catch/finally?
Get-Content .\ExternalDemoFile14.ps1
.\ExternalDemoFile14.ps1

#PSItem automatic variable
#PSItem -eq $_
#This is the current item in the pipeline....aka - $Error[0]
Get-Content .\ExternalDemoFile20.ps1
.\ExternalDemoFile20.ps1

#To prove this here is the same command but using $_ instead of $PSItem
Get-Content .\ExternalDemoFile21.ps1
.\ExternalDemoFile21.ps1

#### Debugging - when standard error catching doesn't work exactly how you want.
<#
Interactive Demo
Use the file DebugDemo.ps1
1. set-psbreakpoint -script .\DebugDemo.ps1 -variable "Data"
2. set-psbreakpoint -script .\debugDemo.ps1 -command "get-item"
3. set-psbreakpoint -script .\debugDemo.ps1 -line 2

get-psbreakpoint | remove-psbreakpoint
#>


####REMOTE DEBUGGING
<#
Almost impossible to automate this information - so need to do this manually
connect two consoles to ad server
get the pid (automatic variable $pid) of console 1
run the script c:\admin\RemoteDebug.ps1 in console 1

in the second console
enter-pshostprocess -Id
get-runspace
debug-runspace -id

l - list the code that is being debugged
notice the * - this shows the line/command that the debugger was called on


#>
