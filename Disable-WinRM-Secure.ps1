<#
.SYNOPSIS
    Disables WinRM service and reverts firewall/user configurations made by the secure setup script.

.DESCRIPTION
    - Optionally removes HTTP listeners
    - Stops and disables the WinRM service
    - Deletes the firewall rule created for limited WinRM access
    - Removes the authorized user from the "Remote Management Users" group

.AUTHOR
    Alperen Teke

.LAST UPDATED
    2025-04-07

.NOTES
    - Must be run with administrative privileges on the local machine.
    - Replace the user and firewall rule name with your own values if needed.
#>

# 1. OPTIONAL: Delete all HTTP listeners (only if needed)
Write-Host "🚫 Deleting all HTTP listeners (optional)..." -ForegroundColor Cyan
try {
    Get-WSManInstance -ResourceURI winrm/config/Listener -Enumerate | Where-Object { $_.Transport -eq "HTTP" } | ForEach-Object {
        Remove-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Address="*"; Transport="HTTP"}
    }
} catch {
    Write-Host "⚠️ Could not delete listeners. WinRM might already be stopped. Skipping..." -ForegroundColor Yellow
}

# 2. Stop and disable WinRM service
Write-Host "🛑 Stopping and disabling WinRM service..." -ForegroundColor Cyan
Stop-Service -Name WinRM -Force -ErrorAction SilentlyContinue
Set-Service -Name WinRM -StartupType Disabled

# 3. Remove firewall rule (update this if you used a custom rule name)
$ruleName = "Allow WinRM from Admin IPs Only"
Write-Host "🧱 Removing firewall rule: $ruleName" -ForegroundColor Cyan
Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

# 4. Remove authorized user from Remote Management Users group
# Replace with your domain and username
$allowedUser = "DOMAIN\UserName"
Write-Host "🔒 Removing user '$allowedUser' from 'Remote Management Users' group..." -ForegroundColor Yellow
try {
    Remove-LocalGroupMember -Group "Remote Management Users" -Member $allowedUser -ErrorAction Stop
} catch {
    Write-Host "⚠️ User could not be removed or was not in the group." -ForegroundColor Yellow
}

# ✅ Final confirmation
Write-Host "`n✅ WinRM and related configurations have been disabled and cleaned up." -ForegroundColor Green
