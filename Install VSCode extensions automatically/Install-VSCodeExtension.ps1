Function Install-VSCodeExtension {
    <#
    .SYNOPSIS
    Install VSCode extensions automatically
    .DESCRIPTION
    Install VSCode extensions automatically
    .PARAMETER ExtensionId
    Specify the VSCode extension Id.
    .NOTES
    Version:        1.0
    .EXAMPLE
    Install-VSCodeExtension "ms-vscode.powershell", "vscode-icons-team.vscode-icons"
    #>

    #-----------------------------------------------------------[Functions]------------------------------------------------------------
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, HelpMessage="Enter VSCode extension id!")]
        [string[]]$ExtensionId
    )
    BEGIN {

    }
    PROCESS {
        try{
        # Get installed VSCode extensions...
        $cmdInstalledExtensions = "code --list-extensions"
        Invoke-Expression $cmdInstalledExtensions -OutVariable outputInstalledExtensions | Out-Null
        $InstalledExtensions = $outputInstalledExtensions -split "\s"

        # If not installed, install VSCode extension/s
        foreach ($extension in $extensionID) {
            if ($InstalledExtensions.Contains($extension)) {
                Write-Host "$extension is already installed." -ForegroundColor DarkYellow
            } else {
                Write-Host "Installing $extension ..." -ForegroundColor Green
                code --install-extension $extension
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