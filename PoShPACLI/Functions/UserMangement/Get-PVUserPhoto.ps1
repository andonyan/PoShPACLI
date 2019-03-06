﻿Function Get-PVUserPhoto {

	<#
    .SYNOPSIS
    	Retrieves the photograph of the specified CyberArk User from the Vault

    .DESCRIPTION
    	Exposes the PACLI Function: "GETUSERPHOTO"

    .PARAMETER vault
    	The name of the Vault to which the User has access.

    .PARAMETER user
    	The Username of the User who is carrying out the command.

    .PARAMETER destUser
    	The name of the User whose photo you wish to retrieve.

    .PARAMETER localFolder
    	The path of the folder in which the photograph is stored

    .PARAMETER localFile
    	The name of the file in which the photograph is stored

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Get-PVUserPhoto -vault Lab -user administrator -destUser user1 -localFolder D:\userphotos `
		-localFile userphoto.jpg

		Saves photo set on user account user1 to local drive

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
		[string]$localFolder,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $False)]
		[string]$localFile,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli GETUSERPHOTO $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				Write-Verbose "User Photo Retrieved"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}