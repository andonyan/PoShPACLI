﻿Function Get-PVRule {

	<#
    .SYNOPSIS
    	Lists all the service rules in a specified Safe.

    .DESCRIPTION
    	Exposes the PACLI Function: "RULESLIST"

    .PARAMETER vault
        The name of the Vault.

    .PARAMETER user
        The Username of the User who is logged on.

    .PARAMETER safeName
        The Safe where the rules are applied.

    .PARAMETER fullObjectName
        The file, password, or folder that the rule applies to.

    .PARAMETER isFolder
        Whether the rule applies to files and passwords or for folders.
            NO – Indicates files and passwords
            YES – Indicates folders

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Get-PVRule -vault lab -user administrator -safeName UNIX -fullObjectname root\rootpass -isFolder $false

		Lists OLAC rules for rootpass

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
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$safeName,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$fullObjectname,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$isFolder,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli RULESLIST "$($PSBoundParameters.getEnumerator() |
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
					For($i = 0 ; $i -lt $Results.length ; $i += 7) {

						#Get Range from array
						$values = $Results[$i..($i + 7)]

						#Output Object
						[PSCustomObject] @{

							"RuleID"           = $values[0]
							"Username"         = $values[1]
							"Safename"         = $values[2]
							"FullObjectName"   = $values[3]
							"Effect"           = $values[4]
							"RuleCreationDate" = $values[5]
							"AccessLevel"      = $values[6]

						} | Add-ObjectDetail -TypeName pacli.PoShPACLI.Rule -PropertyToAdd @{
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