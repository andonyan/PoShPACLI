﻿Function Add-PVPasswordObject {

	<#
    .SYNOPSIS
    	Stores a password object in the specified safe.

    .DESCRIPTION
    	Exposes the PACLI Function: "STOREPASSWORDOBJECT"

    .PARAMETER vault
        The name of the Vault where the password object is stored.

    .PARAMETER user
        The Username of the User who is carrying out the task.

    .PARAMETER safe
        The name of the Safe where the password object is stored

    .PARAMETER folder
        The name of the folder where the password object is stored.

    .PARAMETER file
        The name of the password object.

    .PARAMETER password
        The password being stored in the password object.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Add-PVPasswordObject -vault lab -user administrator -safe Dev_Team -folder Root `
		-file devpass -password (read-host -AsSecureString)

		Adds password object with specified value to Dev_Team safe

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
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True)]
		[string]$folder,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $False)]
		[string]$file,

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $False)]
		[securestring]$password,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			#deal with password SecureString
			if($PSBoundParameters.ContainsKey("password")) {

				$PSBoundParameters["password"] = ConvertTo-InsecureString $password

			}

			$Return = Invoke-PACLICommand $pacli STOREPASSWORDOBJECT $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				Write-Verbose "Password Object Stored"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}