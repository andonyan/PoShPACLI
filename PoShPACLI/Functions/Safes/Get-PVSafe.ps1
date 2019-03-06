﻿Function Get-PVSafe {

	<#
    .SYNOPSIS
    	Lists Safe details

    .DESCRIPTION
    	Exposes the PACLI Function: "SAFEDETAILS"

    .PARAMETER vault
        The name of the Vault to which the Safe Owner has access.

    .PARAMETER user
        The Username of the User carrying out the task

    .PARAMETER safe
        The name of the Safe whose details will be listed.

    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
		Get-PVSafe -vault lab -user administrator -safe system

		Lists details of the SYSTEM safe

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
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			#execute pacli
			$Return = Invoke-PACLICommand $pacli SAFEDETAILS "$($PSBoundParameters.getEnumerator() |
				ConvertTo-ParameterString) OUTPUT (ALL,ENCLOSE,OEM)"

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			else {

				#if result(s) returned
				if($Return.StdOut) {

					#Convert Output to array
					$Results = (($Return.StdOut | Select-String -Pattern "\S") | ConvertFrom-PacliOutput)

					#loop through results
					For($i = 0 ; $i -lt $Results.length ; $i += 29) {

						#Get Range from array
						$values = $Results[$i..($i + 29)]

						#Output Object
						[PSCustomObject] @{

							"Safename"                  = $safe
							"Description"               = $values[0]
							"Delay"                     = $values[1]
							"Retention"                 = $values[2]
							"ObjectsRetention"          = $values[3]
							"MaxSize"                   = $values[4]
							"CurrSize"                  = $values[5]
							"FromHour"                  = $values[6]
							"ToHour"                    = $values[7]
							"DailyVersions"             = $values[8]
							"MonthlyVersions"           = $values[9]
							"YearlyVersions"            = $values[10]
							"QuotaOwner"                = $values[11]
							"Location"                  = $values[12]
							"RequestsRetention"         = $values[13]
							"ConfirmationType"          = $values[14]
							"SecurityLevel"             = $values[15]
							"DefaultAccessMarks"        = $values[16]
							"ReadOnlyByDefault"         = $values[17]
							"UseFileCategories"         = $values[18]
							"VirusFree"                 = $values[19]
							"TextOnly"                  = $values[20]
							"RequireReason"             = $values[21]
							"EnforceExclusivePasswords" = $values[22]
							"RequireContentValidation"  = $values[23]
							"ShareOptions"              = $values[24]
							"ConfirmationCount"         = $values[25]
							"MaxFileSize"               = $values[26]
							"AllowedFileTypes"          = $values[27]
							"SupportOLAC"               = $values[28]

						} | Add-ObjectDetail -TypeName pacli.PoShPACLI.Safe -PropertyToAdd @{
							"vault"     = $vault
							"user"      = $user
							"sessionID" = $sessionID
						}

					}

				}

			}

		}

	}

}