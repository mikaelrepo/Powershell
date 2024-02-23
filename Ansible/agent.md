# WinRM configuration

Create a self signed cert.

```powershell
$newCert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "$env:computername" -FriendlyName "WinRM HTTPS Certificate" -NotAfter (Get-Date).AddYears(5)
```
Set WinRM service to automatic and start.
```powershell
Set-Service -StartupType Automatic -Name WinRM
Start-Service -Name WinRM
```
Configure WinRM listener.
```powershell
$selector_set = @{
    Address = "*"
    Transport = "HTTPS"
}
$value_set = @{
    CertificateThumbprint = $newCert.Thumbprint
}
New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set
```

Allow incoming traffic for WinRM port 5986
```powershell
New-NetFirewallRule -DisplayName "WinRM HTTPS Management" -Profile Domain,Private,Public -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986
```
Set authentication to basic (not recommended!)
```powershell
Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $true
```
---

Set authentication to CredSSP and remove the HTTP listener.
```powershell
wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -outfile "ConfigureRemotingForAnsible.ps1"
.\ConfigureRemotingForAnsible.ps1 -EnableCredSSP -DisableBasicAuth -Verbose
winrm enumerate winrm/config/Listener
Get-ChildItem -Path WSMan:\localhost\Listener | Where-Object {$_.Keys -eq "Transport=HTTP"} | Remove-Item -Recurse -Force
Restart-Service winrm
```
Add these parameters to the inventory file.
```text
ansible_connection: winrm
ansible_winrm_transport: credssp
ansible_winrm_server_cert_validation: ignore
```

Configure for Kerberos.
```text
winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="false"}
New-NetFirewallRule -DisplayName "WinRM HTTPS Management" -Profile Domain,Private,Public -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986
winrm set winrm/config/client/auth @{Digest="false"}
winrm set winrm/config/service/auth @{Kerberos="true"}
winrm set winrm/config/client @{TrustedHosts="*"}
winrm set winrm/config/service/auth @{Basic="false"}
winrm get winrm/config/service/auth
```

```powershell
wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -outfile "ConfigureRemotingForAnsible.ps1" .\ConfigureRemotingForAnsible.ps1 -EnableCredSSP -DisableBasicAuth -Verbose
winrs -r:https://windowsagent:5986/wsman -u:user@ansible.local -p:Password ipconfig/all
```
