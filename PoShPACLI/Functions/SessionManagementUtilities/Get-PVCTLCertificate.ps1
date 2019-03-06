﻿Function Get-PVCTLCertificate {

	<#
    .SYNOPSIS
    	Lists all the certificates in the Certificate Trust List store.

    .DESCRIPTION
    	Exposes the PACLI Function: "CTLLIST"

    .PARAMETER ctlFileName
    	The name of the CTL file that contains the certificates to list. If this
        parameter is not supplied, the CTL file name that was supplied in
        the INIT function is used.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

	.EXAMPLE
		Get-PVCTLCertificate

		lists all the certificates in the Certificate Trust List store/file
		using the CTL file provided as parameter value to Start-PVPacli function.

    .NOTES
    	AUTHOR: Pete Maan

    #>

	[CmdLetBinding()]
	param(

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$ctlFileName,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			$Return = Invoke-PACLICommand $pacli CTLLIST "$($PSBoundParameters.getEnumerator() |
				ConvertTo-ParameterString) OUTPUT (ALL,ENCLOSE)"

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				#if result(s) returned
				if($Return.StdOut) {

					#Convert Output to array
					$Results = (($Return.StdOut | Select-String -Pattern "\S") | ConvertFrom-PacliOutput)

					#loop through results
					For($i = 0 ; $i -lt $Results.length ; $i += 3) {

						#Get Range from array
						$values = $Results[$i..($i + 3)]

						#Output Object
						[PSCustomObject] @{

							#Add elements to hashtable
							"Subject"  = $values[0]
							"Issuer"   = $values[1]
							"FromDate" = $values[2]
							"ToDate"   = $values[3]

						} | Add-ObjectDetail -TypeName pacli.PoShPACLI.CTL.Certificate -PropertyToAdd @{
							"sessionID" = $sessionID
						}

					}

				}

			}

		}

	}

}