# Parameter Attribute
Param(
    [Parameter(Argument="value")]
    $ParameterName
)

# Mandatory argument
Param(
    [Parameter(Mandatory)]
    [string[]]$ComputerName
)

# Position argument
Param(
    [Parameter(Position=0)]
    [string[]]$ComputerName
)

# ParameterSetName argument
Param(
    [Parameter(Mandatory,
    ParameterSetName="Computer")]
    [string[]]$ComputerName,

    [Parameter(Mandatory,
    ParameterSetName="User")]
    [string[]]$UserName,

    [Parameter()]
    [switch]$Summary
)

# ValueFromPipeline argument
Param(
    [Parameter(Mandatory,
    ValueFromPipeline)]
    [string[]]$ComputerName
)

# ValueFromPipelineByPropertyName argument
Param(
    [Parameter(Mandatory,
    ValueFromPipelineByPropertyName)]
    [string[]]$ComputerName
)

# ValueFromRemainingArguments argument
function Test-Remainder
{
    param(
        [string]
        [Parameter(Mandatory, Position=0)]
        $Value,
        [string[]]
        [Parameter(Position=1, ValueFromRemainingArguments)]
        $Remaining)
    "Found $($Remaining.Count) elements"
    for ($i = 0; $i -lt $Remaining.Count; $i++)
    {
    "${i}: $($Remaining[$i])"
    }
}
Test-Remainder first one,two

# HelpMessage argument
Param(
    [Parameter(Mandatory,
    HelpMessage="Enter one or more computer names separated by commas.")]
    [string[]]$ComputerName
)

# Alias attribute
Param(
    [Parameter(Mandatory)]
    [Alias("CN","MachineName")]
    [string[]]$ComputerName
)