﻿Function New-PVVaultDefinition {

	<#
	.SYNOPSIS
		Enables a Vault to be defined

	.DESCRIPTION
		Exposes the PACLI Function: "DEFINE"

	.PARAMETER vault
		The name of the Vault to create.

	.PARAMETER address
		The IP address of the Vault.

	.PARAMETER port
		The Vault IP port.

	.PARAMETER timeout
		The number of seconds to wait for a Vault to respond to a
		command before a timeout message is displayed.

	.PARAMETER behindFirewall
		Whether or not the Vault will be accessed via a Firewall.

	.PARAMETER reconnectPeriod
		The number of seconds to wait before the sessions with the
		Vault is re-established.

	.PARAMETER useOnlyHTTP1
		Use only HTTP 1.0 protocol. This parameter is valid either
		with proxy settings or with ‘behindfirewall’.

	.PARAMETER proxyType
		The type of proxy through which the Vault is accessed. Valid
		values for this parameter are: HTTP, HTTPS, SOCKS4, SOCKS5, NOPROXY

	.PARAMETER proxyAddress
		The proxy server IP address. This is mandatory when using
		a proxy server.

	.PARAMETER proxyPort
		The Proxy server IP Port

	.PARAMETER proxyUser
		User for Proxy server if NTLM authentication is required

	.PARAMETER proxyPassword
		User's Password for Proxy server

	.PARAMETER proxyAuthDomain
		The authentication domain of the proxy

	.PARAMETER numOfRecordsPerSend
		The number of file records to transfer together in a single
		TCP/IP send/receive commands.

	.PARAMETER numOfRecordsPerChunk
		The number of file records to transfer together in a single
		TCP/IP send/receive operation.

	.PARAMETER enhancedSSL
		Whether or not an Enhanced SSL-based connection (port
		443) is required.

	.PARAMETER preAuthSecuredSession
		Whether or not pre-authentication secured session is enabled.

	.PARAMETER trustSSC
		Whether or not self-signed certificates are trusted for preauthentication
		secured sessions.
		Note: This parameter can only be enabled if 'preauthsecuredsession' is specified.

	.PARAMETER allowSSCFor3PartyAuth
		Whether or not to allow 3rd party authentication with selfsigned certificates.
		Note: This parameter can only be enabled if 'trustssc' is specified.

	.PARAMETER sessionID
		The ID number of the session. Use this parameter when working
		with multiple scripts simultaneously. The default is ‘0’.

	.EXAMPLE
		New-PVVaultDefinition -vault VaultA -address 10.10.10.20

		Defines a connection to Vault (VaultA) with IP 10.10.10.20
		VaultA definition is used in subsequent executions of PACLI functions.

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
		[string]$address,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$port,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$timeout,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$behindFirewall,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$reconnectPeriod,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$useOnlyHTTP1,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[ValidateSet("HTTP", "HTTPS", "SOCKS4", "SOCKS5", "NOPROXY")]
		[string]$proxyType,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$proxyAddress,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$proxyPort,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$proxyUser,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[securestring]$proxyPassword,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[string]$proxyAuthDomain,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$numOfRecordsPerSend,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$numOfRecordsPerChunk,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$enhancedSSL,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$preAuthSecuredSession,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$trustSSC,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $False)]
		[switch]$allowSSCFor3PartyAuth,

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True)]
		[int]$sessionID
	)

	PROCESS {

		If(Test-PACLI) {

			#$PACLI variable set to executable path

			#deal with proxyPassword SecureString
			if($PSBoundParameters.ContainsKey("proxyPassword")) {

				$PSBoundParameters["proxyPassword"] = ConvertTo-InsecureString $proxyPassword

			}

			Write-Verbose "Defining Vault"

			$Return = Invoke-PACLICommand $pacli DEFINE $($PSBoundParameters.getEnumerator() |
					ConvertTo-ParameterString -doNotQuote proxyType, port, timeout, reconnectPeriod,
				proxyPort, numOfRecordsPerSend, numOfRecordsPerChunk)

			if($Return.ExitCode) {

				Write-Error $Return.StdErr

			}

			elseif($Return.ExitCode -eq 0) {

				Write-Verbose "Vault Defined. Name: $vault, Address: $address"

				[PSCustomObject] @{

					"vault"     = $vault
					"sessionID" = $sessionID

				} | Add-ObjectDetail -TypeName pacli.PoShPACLI

			}

		}

	}

}