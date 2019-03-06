﻿Function Get-PVTrustedNetworkArea {

	<#
    .SYNOPSIS
    	Lists Trusted Network Areas

    .DESCRIPTION
    	Exposes the PACLI Function: "TRUSTEDNETWORKAREASLIST"

    .PARAMETER vault
	   The name of the Vault in which the Trusted Network Area is defined.

    .PARAMETER user
	   The name of the User carrying out the task.

    .PARAMETER trusterName
	   The User who has access to the Trusted Network Area

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
    	Get-PVTrustedNetworkArea -vault lab -user administrator -trusterName lydia

		Lists Trusted Network Areas for user lydia

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
		[Alias("Username")]
		[string]$trusterName,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			#execute pacli with parameters
			$Return = Invoke-PACLICommand $pacli TRUSTEDNETWORKAREASLIST "$($PSBoundParameters.getEnumerator() |
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
					For($i = 0 ; $i -lt $Results.length ; $i += 6) {

						#Get Range from array
						$values = $Results[$i..($i + 6)]

						#Output Object
						[PSCustomObject] @{

							"NetworkArea"       = $values[0]
							"FromHour"          = $values[1]
							"ToHour"            = $values[2]
							"Active"            = $values[3]
							"MaxViolationCount" = $values[4]
							"ViolationCount"    = $values[5]
							"Username"          = $trusterName

						} | Add-ObjectDetail -TypeName pacli.PoShPACLI.NetworkArea.Trusted -PropertyToAdd @{
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