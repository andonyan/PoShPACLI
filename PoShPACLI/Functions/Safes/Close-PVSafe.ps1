﻿Function Close-PVSafe {

	<#
	.SYNOPSIS
		Closes a Safe

	.DESCRIPTION
		Exposes the PACLI Function: "CLOSESAFE"

	.PARAMETER vault
		The name of the Vault containing the Safes to close.

	.PARAMETER user
		The Username of the User carrying out the task.

	.PARAMETER safe
		The name of the Safe to close.

	.PARAMETER sessionID
		The ID number of the session. Use this parameter when working
		with multiple scripts simultaneously. The default is ‘0’.

	.EXAMPLE
		Close-PVSafe -vault Lab -user administrator -safe system

		Closes the SYSTEM safe

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
		[Alias("Safename")]
		[string]$safe,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli CLOSESAFE $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				Write-Verbose "Safe Closed: $safe"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}