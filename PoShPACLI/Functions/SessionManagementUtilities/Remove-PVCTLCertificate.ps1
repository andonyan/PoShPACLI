﻿Function Remove-PVCTLCertificate {

	<#
    .SYNOPSIS
    	Removes a certificate from the Certificate Trust List store.

    .DESCRIPTION
    	Exposes the PACLI Function: "CTLREMOVECERT"

    .PARAMETER ctlFileName
    	The name of the CTL file to remove from the CTL store. If this
        parameter is not supplied, the CTL file name that was supplied in
        the INIT function is used.

    .PARAMETER certFileName
        The full path and name of the certificate file.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
    	Remove-PVCTLCertificate -ctlFileName CTL.FILE -certFileName cert.File

		Deletes Certificate cert.File from Certificate Trust List store CTL.FILE

    .NOTES
    	AUTHOR: Pete Maan

    #>

	[CmdLetBinding(SupportsShouldProcess)]
	param(

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$ctlFileName,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$certFileName,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli CTLREMOVECERT $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			elseif($Return.ExitCode -eq 0) {

				Write-Verbose "Certificate $certFileName Deleted from CTL"

				[PSCustomObject] @{

					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}