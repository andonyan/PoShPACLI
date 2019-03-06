﻿Function Rename-PVUser {

	<#
    .SYNOPSIS
    	Renames a CyberArk User

    .DESCRIPTION
    	Exposes the PACLI Function: "RENAMEUSER"

    .PARAMETER vault
        The name of the Vault.

    .PARAMETER user
        The Username of the User who is logged on.

    .PARAMETER destUser
        The current name of the User to rename.

    .PARAMETER newName
        The new name of the User.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Rename-PVUser -vault Lab -user administrator -destUser Then -newName Now

		Renames user "Then" to user "Now"

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
		[string]$destUser,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $False)]
		[string]$newName,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli RENAMEUSER $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				Write-Verbose "User Renamed to $newName"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}