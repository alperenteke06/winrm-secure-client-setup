<#
.SYNOPSIS
    Securely enables WinRM on a client machine over HTTP (no SSL), restricted to specific IP addresses and authorized users.

.DESCRIPTION
    This script configures the Windows Remote Management (WinRM) service in a production-safe way:
    - Starts and configures the WinRM listener on HTTP (port 5985)
    - Limits access to specific admin IP addresses via firewall
    - Adds only a specific domain user to the "Remote Management Users" group
    - Ensures WinRM service is set to auto-start

.AUTHOR
    Alperen Teke

.LAST UPDATED
    2025-04-07

.NOTES
    - Must be run with administrative privileges.
    - Intended to be executed locally on the client machine (e.g., panel PCs).
    - Replace domain, user, and IP values with your own before use.
#>

# 1. Enable and configure WinRM service
Write-Host "🚀 Starting WinRM service..." -ForegroundColor Cyan
winrm quickconfig -quiet

# 2. Allow incoming WinRM connections ONLY from authorized admin IPs
# 👉 Replace with your admin machine's IP addresses
$allowedIPs = "192.168.1.100", "192.168.1.101"

Write-Host "🧱 Configuring firewall rule for restricted WinRM access..." -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "Allow WinRM from Admin IPs Only" `
    -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985 `
    -RemoteAddress $allowedIPs -Profile Domain,Private -Enabled True

# 3. Allow only a specific domain user to access via WinRM
# 👉 Replace with a domain user who should have WinRM access
$allowedUser = "DOMAIN\UserName"

Write-Host "🔒 Adding authorized user to 'Remote Management Users' group..." -ForegroundColor Yellow
Add-LocalGroupMember -Group "Remote Management Users" -Member $allowedUser

# 4. Ensure WinRM service is set to auto-start
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# ✅ Success message
Write-Host "`n✅ WinRM has been securely configured." -ForegroundColor Green
Write-Host "   Allowed IPs: $($allowedIPs -join ', ')" -ForegroundColor DarkGray
Write-Host "   Authorized user: $allowedUser" -ForegroundColor DarkGray
