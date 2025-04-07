# 🔐 Secure WinRM Setup Script (HTTP Only)

This project contains two PowerShell scripts to securely manage WinRM (Windows Remote Management) on client machines, such as panel PCs or workstations.

## ✅ Features

- Enables or disables WinRM over HTTP (port 5985)
- Limits incoming access by IP address
- Restricts usage to specific domain user
- Adds/removes user to/from "Remote Management Users" group
- Adds/removes firewall rule
- Configures service to auto-start or disables it

## 🚀 Usage

### Enable WinRM
Edit `Enable-WinRM-Secure.ps1`:
- Replace `$allowedIPs` with your admin machine IPs
- Replace `$allowedUser` with your domain\username

Run the script locally on the target machine with administrative privileges.

### Disable WinRM
Edit `Disable-WinRM-Secure.ps1` similarly and run it to clean up.

## ⚠️ Security Notes
- This script does **not** use SSL; it's limited to known IPs for security.
- For high-security environments, consider using HTTPS (port 5986) with certificates.

## 📜 Author
**Alperen Teke**  
Date: 2025-04-07
