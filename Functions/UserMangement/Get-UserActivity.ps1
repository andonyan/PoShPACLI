Function Get-UserActivity{

    <#
    .SYNOPSIS
    	This command generates a list of activities carried out in the specified 
        Vault for the user who issues this command. 
        The Safes included in the output are those to which the User carrying out 
        the command has authorization.

    .DESCRIPTION
    	Exposes the PACLI Function: "INSPECTUSER"

    .PARAMETER vault
        The name of the Vault to which the User has access
        
    .PARAMETER user
        The Username of the User issuing the command
        
    .PARAMETER logDays
        The number of days to include in the list of activities.
        
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
        [Parameter(Mandatory=$False)][string]$vault,
        [Parameter(Mandatory=$False)][string]$user,
        [Parameter(Mandatory=$False)][int]$logDays,
        [Parameter(Mandatory=$False)][int]$sessionID
    )

    If(!(Test-ExePreReqs)){

            #$pacli variable not set or not a valid path

    }

    Else{

        #$PACLI variable set to executable path
            
        #execute pacli with parameters
        $Return = Invoke-PACLICommand $pacli INSPECTUSER "$($PSBoundParameters.getEnumerator() | 
            ConvertTo-ParameterString -donotQuote logDays) OUTPUT (ALL,ENCLOSE)"
        
        if($Return.ExitCode){
            
            Write-Debug $Return.StdErr

        }
        
        else{
        
            #if result(s) returned
            if($Return.StdOut){
                
                #Convert Output to array
                $Results = (($Return.StdOut | Select-String -Pattern "\S") | ConvertFrom-PacliOutput)
                
                #loop through results
                For($i=0 ; $i -lt $Results.length ; $i+=9){
                    
                    #Get Range from array
                    $values = $Results[$i..($i+9)]
                    
                    #Output Object
                    [PSCustomObject] @{

                        #assign values to properties
                        "Time"=$values[0]
                        "User"=$values[1]
                        "Safe"=$values[2]
                        "Activity"=$values[3]
                        "Location"=$values[4]
                        "NewLocation"=$values[5]
                        "RequestID"=$values[6]
                        "RequestReason"=$values[7]
                        "Code"=$values[8]
                    
                    }
                        
                }
            
            }
            
        }
        
    }
    
}