﻿Function Disable-PVTrustedNetworkArea {

	<#
    .SYNOPSIS
    	Deactivates a Trusted Network Area.

    .DESCRIPTION
    	Exposes the PACLI Function: "DEACTIVATETRUSTEDNETWORKAREA"

    .PARAMETER vault
	   The name of the Vault in which the Trusted Network Area is defined.

    .PARAMETER user
	   The name of the User carrying out the task.

    .PARAMETER trusterName
	   The User who will not have access to the Trusted Network Area.

    .PARAMETER networkArea
	   The name of the Network Area to deactivate.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Disable-PVTrustedNetworkArea -vault lab -user administrator -trusterName user2 -networkArea All

		Disables the "All" Trusted Network Area for user2

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
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$networkArea,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli DEACTIVATETRUSTEDNETWORKAREA $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				Write-Verbose "Trusted Network Area $networkArea Disabled for $trusterName"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}