Function Get-Something {
    <#
    .SYNOPSIS
    <Overview of script>
    .DESCRIPTION
    <Brief description of script>
    .PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
    .INPUTS
    <Inputs if any, otherwise state None>
    .OUTPUTS
    <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
    .NOTES
    Version:        1.0
    Author:         <Name>
    Creation Date:  <Date>
    Purpose/Change: Initial script development
    .EXAMPLE
    <Example goes here. Repeat this attribute for more than one example>
    #>

    #---------------------------------------------------------[Initialisations]--------------------------------------------------------
    # Dot Source required Function Libraries
    # . "C:\Scripts\Functions\Logging_Functions.ps1"

    #----------------------------------------------------------[Declarations]----------------------------------------------------------
    # Script Version
    # $sScriptVersion = "1.0"

    #-----------------------------------------------------------[Functions]------------------------------------------------------------
    [CmdletBinding()]
    param(
        [String]$FirstParameter,

        [Parameter(ParameterSetName="MySetName1")]
        [String]$SecondParameter = "MyDefaultValue",
        
        [Parameter(Mandatory=$true, HelpMessage="Enter correct value!")]
        [string]$ThirdParameter
    )
    BEGIN {

    }
    PROCESS {
        try{
            # <code goes here>
        }
        Catch{
            # <error handling code goes here>
            Break
        }
    }
    END {

    }
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------