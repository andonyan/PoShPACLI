Function Disable-TrustedNetworkArea{

    <#
    .SYNOPSIS
    	Deactivates a Trusted Network Area.

    .DESCRIPTION
    	Exposes the PACLI Function: "DEACTIVATETRUSTEDNETWORKAREA"

    .PARAMETER vault 
	   The name of the Vault in which the Trusted Network Area is defined.
       
    .PARAMETER user 
	   The name of the User carrying out the task.
    
    .PARAMETER trusterName 
	   The User who will not have access to the Trusted Network Area.

    .PARAMETER networkArea 
	   The name of the Network Area to deactivate.
           
    .PARAMETER sessionID
    	The ID number of the session. Use this parameter when working
        with multiple scripts simultaneously. The default is ‘0’.

    .EXAMPLE
    	A sample command that uses the function or script, optionally followed
    	by sample output and a description. Repeat this keyword for each example.

    .NOTES
    	AUTHOR: Pete Maan
    	LASTEDIT: July 2017
    #>
    
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$vault,
        [Parameter(Mandatory=$True)][string]$user,
        [Parameter(Mandatory=$True)][string]$trusterName,
        [Parameter(Mandatory=$True)][string]$networkArea,
        [Parameter(Mandatory=$False)][int]$sessionID
    )

    If(!(Test-ExePreReqs)){

            #$pacli variable not set or not a valid path

    }

    Else{

        #$PACLI variable set to executable path
                        
        $Return = Invoke-PACLICommand $pacli DEACTIVATETRUSTEDNETWORKAREA $($PSBoundParameters.getEnumerator() | ConvertTo-ParameterString)
        
        if($Return.ExitCode){
            
            Write-Debug $Return.StdErr
            $FALSE

        }
        
        else{
        
            $TRUE
            
        }
        
    }

}