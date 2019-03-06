﻿Function Add-PVExternalUser {

	<#
    .SYNOPSIS
    	Adds a new user from an external directory

    .DESCRIPTION
    	Exposes the PACLI Function: "ADDUPDATEEXTERNALUSERENTITY"

    .PARAMETER vault
    	The name of the Vault.

    .PARAMETER user
    	The Username of the User who is carrying out the task.

    .PARAMETER destUser
    	The name (samaccountname) of the external User or Group that will be created
        in the Vault.

    .PARAMETER ldapFullDN
    	The full DN of the user in the external directory.

    .PARAMETER ldapDirectory
    	The name of the external directory where the user or group is defined.

    .PARAMETER UpdateIfExists
    	Whether or not existing external Users and Groups definitions will be updated
        in the Vault.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Add-PVExternalUser -vault Lab -user Administrator -destUser admin01 -ldapDirectory VIRTUALREAL.IT `
		-UpdateIfExists

		Updates user admin01 in vault from domain VIRTUALREAL.IT
    .NOTES
    	AUTHOR: Pete Maan

        Work required to support LDAPFullDN & Parameter Validation / Parameter Sets
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
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[Alias("DN", "distinguishedName")]
		[string]$ldapFullDN,


		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$ldapDirectory,


		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$UpdateIfExists,


		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path
			$Return = Invoke-PACLICommand $pacli ADDUPDATEEXTERNALUSERENTITY "$($PSBoundParameters.getEnumerator() |
				ConvertTo-ParameterString) OUTPUT (ALL,ENCLOSE)"

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				#if result(s) returned
				if($Return.StdOut) {

					Write-Verbose "External User $destUser added."

					#Convert Output to array
					$Results = (($Return.StdOut | Select-String -Pattern "\S") | ConvertFrom-PacliOutput)

					#Output Object
					[PSCustomObject] @{

						"Username" = $Results

					} | Add-ObjectDetail -TypeName pacli.PoShPACLI.User.External -PropertyToAdd @{
						"vault"     = $vault
						"user"      = $user
						"sessionID" = $sessionID
					}

				}

			}

		}

	}

}