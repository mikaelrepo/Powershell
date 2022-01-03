Function Send-WakeOnLan {
    <#
    .SYNOPSIS
    Sends a Wake On LAN magic packet.
    .DESCRIPTION
    Sends a Wake On LAN magic packet.  Sending and receiving computer must be on the same network.
    .PARAMETER ComputerName
    Try to get the MAC address of the destination computer.
    .PARAMETER MacAddress
    Enter the MAC address of the destination computer in these formats... "10-20-30-40-50-60" or "10:20:30:40:50:60"
    .PARAMETER Packet
    Optional parameter that returns the magic packet.
    .INPUTS
    <Inputs if any, otherwise state None>
    .OUTPUTS
    <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
    .NOTES
    Version:        1.0
    .EXAMPLE
    Send-WakeOnLan -ComputerName DestinationComputer
    #>
    #-----------------------------------------------------------[Functions]------------------------------------------------------------
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName="Computer")]
        [string]$ComputerName,
    
        [Parameter(ParameterSetName="Mac")]
        [string]$MacAddress,

        [switch]$Packet
    )
    BEGIN {

    }
    PROCESS {
        try{
            if($ComputerName){
                $MacAddress = Invoke-Command -ComputerName $ComputerName -ErrorAction SilentlyContinue -scriptblock{
                    (Get-NetAdapter).MacAddress[0]
                }
            }
            if($MacAddress){
                $MacByteArray = $MacAddress -split "[:-]" | ForEach-Object { [Byte] "0x$_"}
                [Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray  * 16)
                $UdpClient = New-Object System.Net.Sockets.UdpClient
                $UdpClient.Connect(([System.Net.IPAddress]::Broadcast),7)
                $BytesSent = $UdpClient.Send($MagicPacket,$MagicPacket.Length)
                $UdpClient.Close()
                if($Packet){
                    $MagicPacket
                }else{
                    Write-Host -ForegroundColor Green "Wake On Lan magic packet sent $BytesSent bytes!"
                }

            }else{
                if(!$MagicPacket){
                    Write-Host -ForegroundColor Red "Connection to $ComputerName failed!"
                }
            }
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
