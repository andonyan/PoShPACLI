﻿Function Get-PVUserList {

	<#
    .SYNOPSIS
    	Produces a list of Users who have access to the specified Vault.
        You can only generate this list if you have administrative permissions.

    .DESCRIPTION
    	Exposes the PACLI Function: "USERSLIST"

    .PARAMETER vault
	   The name of the Vault

    .PARAMETER user
	   The Username of the User who is logged on.

    .PARAMETER location
	   The location to search for users.
	   Note: A backslash ‘\’ must be added before the name of the location.

    .PARAMETER includeSubLocations
	   Whether or not the output will include the sublocation in which the User
       is defined.

    .PARAMETER includeDisabledUsers
	   Whether or not the output will include disabled users

    .PARAMETER onlyKnownUsers
	   Whether or not the output will include only Users who share Safes with
       the User carrying out the command or all Users known by the specified Vault

    .PARAMETER userPattern
	   The full name or part of the name of the User(s) to include in the report.
       A wildcard can also be used in this parameter.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Get-PVUserList -vault Lab -user administrator | Where-Object{$_.LDAPUser -eq "YES"}

		Returns all LDAP users/groups from vault

    .NOTES
    	AUTHOR: Pete Maan

    #>

	[CmdLetBinding()]
	param(

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$vault,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$user,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$location,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$includeSubLocations,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$includeDisabledUsers,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$onlyKnownUsers,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[string]$userPattern,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			#execute pacli with parameters
			$Return = Invoke-PACLICommand $pacli USERSLIST "$($PSBoundParameters.getEnumerator() |
				ConvertTo-ParameterString) OUTPUT (ALL,ENCLOSE)"

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				#if result(s) returned
				if($Return.StdOut) {

					#Convert Output to array
					$Results = (($Return.StdOut | Select-String -Pattern "\S") | ConvertFrom-PacliOutput)

					#loop through results
					For($i = 0 ; $i -lt $Results.length ; $i += 14) {

						#Get User Range from array
						$values = $Results[$i..($i + 14)]

						#output object for each user
						[PSCustomObject] @{

							"Username"                  = $values[0]
							"Quota"                     = $values[1]
							"UsedQuota"                 = $values[2]
							"Location"                  = $values[3]
							"FirstName"                 = $values[4]
							"LastName"                  = $values[5]
							"LDAPUser"                  = $values[6]
							"Template"                  = $values[7]
							"GWAccount"                 = $values[8]
							"Disabled"                  = $values[9]
							"Type"                      = $values[10]
							"UserID"                    = $values[11]
							"LocationID"                = $values[12]
							"EnableComponentMonitoring" = $values[13]

						} | Add-ObjectDetail -TypeName pacli.PoShPACLI.User -PropertyToAdd @{
							"vault"     = $vault
							"user"      = $user
							"sessionID" = $sessionID
						}

					}

				}

			}

		}

	}

}