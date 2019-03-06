﻿Function Remove-PVFolder {

	<#
    .SYNOPSIS
    	Deletes a folder from an open Safe. A folder can only be deleted if the
        Safe History retention period has expired for all activity in the folder.

    .DESCRIPTION
    	Exposes the PACLI Function: "DELETEFOLDER"

    .PARAMETER vault
        The name of the Vault containing the appropriate Safe.

    .PARAMETER user
        The Username of the User who is carrying out the task.

    .PARAMETER safe
        The name of the Safe in which the folder will be deleted.

    .PARAMETER folder
        The name of the folder to delete.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
    	Remove-PVFolder -vault lab -user administrator -safe Reports -folder root\2017

		Deletes folder "2017" from Reports safe
    .NOTES
    	AUTHOR: Pete Maan

    #>

	[CmdLetBinding(SupportsShouldProcess)]
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
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli DELETEFOLDER $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			elseif($Return.ExitCode -eq 0) {

				Write-Verbose "Folder $folder Deleted"

				[PSCustomObject] @{

					"vault"     = $vault
					"user"      = $user
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}