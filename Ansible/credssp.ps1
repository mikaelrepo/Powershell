# Create a self-signed certificate.
$newCert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "$env:computername" -FriendlyName "WinRM HTTPS Certificate" -NotAfter (Get-Date).AddYears(5)

# Set WinRM service to Automatic and start it.
Set-Service -StartupType Automatic -Name WinRM
Start-Service -Name WinRM

# Configure WinRM listener for HTTPS.
$selector_set = @{
    Address = "*"
    Transport = "HTTPS"
}
$value_set = @{
    CertificateThumbprint = $newCert.Thumbprint
}
New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set

# Allow incoming traffic for WinRM port 5986.
New-NetFirewallRule -DisplayName "WinRM HTTPS Management" -Profile Domain,Private,Public -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986

# Enable CredSSP Authentication on the WinRM service.
Set-Item -Path "WSMan:\localhost\Service\Auth\CredSSP" -Value $true
