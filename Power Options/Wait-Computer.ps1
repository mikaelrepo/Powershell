Function Wait-Computer {
    <#
    .SYNOPSIS
    Put the computer to sleep and/or turn off the display.
    .DESCRIPTION
    Put the computer to sleep and/or turn off the display.
    .PARAMETER Display
    Turn off the display.
    .PARAMETER Sleep
    Put the computer to sleep.
    .NOTES
    Version:        0.1
    Creation Date:  2021-12-23
    Purpose/Change: Initial script development
    .EXAMPLE
    Turn off display and put the computer to sleep.

    Wait-Computer
    .EXAMPLE
    Only turn off the display.

    Wait-Computer -Display
    #>

    #-----------------------------------------------------------[Functions]------------------------------------------------------------
    [CmdletBinding()]
    Param(
        [Parameter()][Switch]$Display,
        [Parameter()][Switch]$Sleep
    )
    BEGIN {
        function Wait-Display {
            # Turn off the display.
            (Add-Type -MemberDefinition "[DllImport(""user32.dll"")]`npublic static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);" -Name "Win32SendMessage" -Namespace Win32Functions -PassThru)::SendMessage(0xffff, 0x0112, 0xF170, 2)
        }
        function Wait-SleepComputer {
            # Put the computer to sleep
            Add-Type -Assembly System.Windows.Forms
            $state = [System.Windows.Forms.PowerState]::Suspend
            [System.Windows.Forms.Application]::SetSuspendState($state, $false, $false) | Out-Null
        }
    }

    PROCESS {
        try{
            if($Display) {
                Wait-Display
            }
            elseif ($Sleep) {
                Wait-SleepComputer
            }else {
                Wait-Display
                Wait-SleepComputer
            }
        }
        Catch{
            # <error handling code goes here>
            Break
        }
    }
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------

