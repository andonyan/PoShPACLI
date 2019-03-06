﻿Function Restore-PVFile {

	<#
    .SYNOPSIS
    	Undelete a file or password that has been previously deleted.

    .DESCRIPTION
    	Exposes the PACLI Function: "UNDELETEFILE"

    .PARAMETER vault
        The name of the Vault in which the file was stored.

    .PARAMETER user
        The Username of the User who is carrying out the task.

    .PARAMETER safe
        The name of the Safe in which the file was stored.

    .PARAMETER folder
        The name of the folder in which the file was stored.

    .PARAMETER file
        The name of the file or password to undelete.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
    	Restore-PVFile -vault lab -user administrator -safe US_Region -folder root -file deletedFile

		"Un-deletes"/Restores deletedFile

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
			ValueFromPipelineByPropertyName = $True)]
		[Alias("Filename")]
		[string]$file,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli UNDELETEFILE $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				Write-Verbose "File $file Restored"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID
					"Safename"  = $safe
					"Folder"    = $folder
					"Filename"  = $file

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}