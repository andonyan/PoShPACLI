﻿Function Disconnect-PVVault {

	<#
	.SYNOPSIS
	This command enables log off from the Vault

	.DESCRIPTION
	Exposes the PACLI Function: "LOGOFF"

	.PARAMETER vault
	The name of the Vault to log off from.

	.PARAMETER user
	The name of the User who is logging off.

	.PARAMETER sessionID
	The ID number of the session. Use this parameter when working
	with multiple scripts simultaneously. The default is ‘0’.

	.EXAMPLE
	Disconnect-PVVault -vault VaultA -user administrator

	Logs off administrator from defined vault VaultA

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
		[int]$sessionID
	)

	PROCESS {

		

		$Return = Invoke-PACLICommand $Script:PV.ClientPath LOGOFF $($PSBoundParameters.getEnumerator() |
				ConvertTo-ParameterString)

		if($Return.ExitCode -eq 0) {

			

			[PSCustomObject] @{

				"vault"     = $vault
				"user"      = $user
				"sessionID" = $sessionID

			} | Add-ObjectDetail -TypeName pacli.PoShPACLI

		}

	}

}
