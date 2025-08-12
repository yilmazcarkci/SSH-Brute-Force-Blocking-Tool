# SSH Brute Force Blocking - Detailed Usage Guide 📚

This document explains the detailed usage of the SSH Brute Force Blocking tool.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Basic Usage](#basic-usage)
3. [Advanced Features](#advanced-features)
4. [Configuration Options](#configuration-options)
5. [Security Best Practices](#security-best-practices)
6. [Frequently Asked Questions](#frequently-asked-questions)
7. [Example Scenarios](#example-scenarios)

## 🚀 Quick Start

### 1. Check System Requirements

```bash
# Check Linux distribution
cat /etc/os-release

# Check Bash version
bash --version

# Check sudo privileges
sudo -l

# Check if iptables is installed
iptables --version
```

### 2. Download and Prepare the Script

```bash
# Download the script
wget https://raw.githubusercontent.com/yourusername/ssh-brute-force-blocking/main/ssh-blacklist.sh

# Make it executable
chmod +x ssh-blacklist.sh

# Test it
./ssh-blacklist.sh --help
```

### 3. First Run

```bash
# Run the script with sudo
sudo ./ssh-blacklist.sh
```

## 📖 Basic Usage

### Main Menu Navigation

When the script runs, the following menu is displayed:

```
--------------------------------------------------------------------------------
| SSH Black List Menu                                                          |
--------------------------------------------------------------------------------
1. Add White List IP
2. Add Black List IP
3. Show White List IP
4. Show Black List IP
5. Detect & Block Brute Force IPs
6. Exit
```

### Detailed Menu Options Explanation

#### 1. Add White List IP (Whitelist IP Addition)

**What it does:**
- Adds trusted IP addresses to the system
- These IPs are never blocked
- SSH connections continue uninterrupted

**Usage:**
```bash
# Select 1 from menu
1

# Enter IP address
192.168.1.100

# Success message is displayed
192.168.1.100 added to whitelist.
```

**Example Usage Scenarios:**
- Office IP addresses
- Home IP addresses
- Trusted server IPs
- VPN IP addresses

#### 2. Add Black List IP (Blacklist IP Addition)

**What it does:**
- Manually blocks IP addresses
- Immediately adds iptables rule
- Blocks all future connections

**Usage:**
```bash
# Select 2 from menu
2

# Enter IP address
203.0.113.45

# Success message is displayed
203.0.113.45 blocked.
```

**Example Usage Scenarios:**
- Known attacker IPs
- IPs showing suspicious activity
- Test blocking

#### 3. Show White List IP (Whitelist Display)

**What it does:**
- Lists all IPs in whitelist
- Shows current trusted IPs

**Output Example:**
```
--------------------------------------------------------------------------------
| SSH White List                                                               |
--------------------------------------------------------------------------------
192.168.1.100
10.0.0.50
172.16.0.25
```

#### 4. Show Black List IP (Blacklist Display)

**What it does:**
- Lists all IPs in blacklist
- Shows blocking dates

**Output Example:**
```
--------------------------------------------------------------------------------
| SSH Black List                                                               |
--------------------------------------------------------------------------------
203.0.113.45    15-12-2024 14:30
198.51.100.123  15-12-2024 13:45
192.0.2.78      15-12-2024 12:20
```

#### 5. Detect & Block Brute Force IPs (Automatic Detection)

**What it does:**
- Analyzes SSH logs
- Detects brute force attacks
- Automatically blocks suspicious IPs

**How it works:**
1. Reads SSH logs (`/var/log/auth.log` or `/var/log/secure`)
2. Counts "Failed password" attempts
3. Blocks IP if more than 10 failed attempts
4. Checks whitelist
5. Adds to blacklist and creates iptables rule

**Output Example:**
```
--------------------------------------------------------------------------------
| Brute Force IP Detection                                                     |
--------------------------------------------------------------------------------
203.0.113.45 blocked (attempts: 15)
198.51.100.123 blocked (attempts: 23)
192.0.2.78 blocked (attempts: 12)
```

## 🔧 Advanced Features

### Log File Detection

The script automatically detects the following log files:

```bash
# Ubuntu/Debian systems
/var/log/auth.log

# CentOS/RHEL systems
/var/log/secure

# systemd-based systems
journalctl -u ssh -u sshd --no-pager
```

### IP Validation

The script only accepts valid IPv4 addresses:

```bash
# Valid IP formats
192.168.1.1
10.0.0.1
172.16.0.1
203.0.113.1

# Invalid formats (rejected)
192.168.1.256
10.0.0
192.168.1.1.1
abc.def.ghi.jkl
```

### Double Check System

- **Whitelist Priority**: IPs in whitelist are never blocked
- **Re-blocking Prevention**: Prevents re-blocking of the same IP
- **Secure Log Analysis**: Only analyzes "Failed password" entries

## ⚙️ Configuration Options

### Threshold Value Adjustment

The default threshold is 10. To change this value:

```bash
# Edit ssh-blacklist.sh file
nano ssh-blacklist.sh

# Find line 75 and change it
# Original:
if [[ "$count" -gt 10 && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then

# New value (e.g., 5):
if [[ "$count" -gt 5 && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
```

### Custom Log File Specification

To use a different log file:

```bash
# Edit detect_log_source() function
detect_log_source() {
    # Custom log file
    if [ -f /var/log/ssh_custom.log ]; then
        LOGCMD="cat /var/log/ssh_custom.log"
    elif [ -f /var/log/auth.log ]; then
        LOGCMD="cat /var/log/auth.log"
    # ... other checks
}
```

### iptables Rule Customization

To add different iptables rules:

```bash
# Change in add_blacklist_ip() function
# Original:
sudo iptables -A INPUT -s $ip -j DROP

# Custom rule examples:
sudo iptables -A INPUT -s $ip -p tcp --dport 22 -j DROP  # SSH port only
sudo iptables -A INPUT -s $ip -j REJECT --reject-with icmp-host-unreachable
sudo iptables -A INPUT -s $ip -j LOG --log-prefix "SSH_BLOCKED: "
```

## 🛡️ Security Best Practices

### 1. Whitelist Management

```bash
# Add important IPs to whitelist
# Office IP range
192.168.1.0/24

# Home IP address
203.0.113.100

# VPN IP address
10.0.0.50
```

### 2. Regular Monitoring

```bash
# Add to crontab (check every 5 minutes)
sudo crontab -e

# Add the following line:
*/5 * * * * /path/to/ssh-blacklist.sh
```

### 3. Log Rotation

```bash
# Prevent log files from growing too large
sudo nano /etc/logrotate.d/ssh-blacklist

# Content:
/var/log/ssh-blacklist.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
```

### 4. Backup

```bash
# Backup whitelist and blacklist files
sudo cp whitelist.txt whitelist.txt.backup
sudo cp blacklist.txt blacklist.txt.backup

# Automatic backup script
#!/bin/bash
cp whitelist.txt "whitelist_$(date +%Y%m%d_%H%M%S).txt"
cp blacklist.txt "blacklist_$(date +%Y%m%d_%H%M%S).txt"
```

## ❓ Frequently Asked Questions

### Q: Which log files does the script read?
A: The script automatically reads `/var/log/auth.log`, `/var/log/secure`, or `journalctl` output.

### Q: How can I change the threshold value?
A: Change the `10` value on line 75 of `ssh-blacklist.sh` to your desired number.

### Q: Why are IPs in whitelist never blocked?
A: For security reasons, IPs in whitelist are never blocked. This prevents you from locking yourself out.

### Q: How can I run the script automatically?
A: You can run it automatically by adding to crontab: `*/5 * * * * /path/to/ssh-blacklist.sh`

### Q: How can I remove blocked IPs?
A: Remove the IP from the blacklist file and remove the iptables rule:
```bash
sudo sed -i '/IP_ADDRESS/d' blacklist.txt
sudo iptables -D INPUT -s IP_ADDRESS -j DROP
```

### Q: On which operating systems does the script work?
A: It works on Linux operating systems (Ubuntu, CentOS, RHEL, Debian, etc.).

## 📋 Example Scenarios

### Scenario 1: New Server Setup

```bash
# 1. Download the script
wget https://raw.githubusercontent.com/yourusername/ssh-brute-force-blocking/main/ssh-blacklist.sh
chmod +x ssh-blacklist.sh

# 2. Add trusted IPs
sudo ./ssh-blacklist.sh
# Select 1 from menu and add IPs

# 3. Run first scan
# Select 5 from menu

# 4. Set up automatic execution
sudo crontab -e
# */5 * * * * /path/to/ssh-blacklist.sh
```

### Scenario 2: Existing Attack Detection

```bash
# 1. Check current status
sudo ./ssh-blacklist.sh
# Select 4 from menu (view blacklist)

# 2. Detect new attacks
# Select 5 from menu

# 3. Analyze results
# View blocked IPs and attempt counts
```

### Scenario 3: Security Audit

```bash
# 1. Check all whitelist IPs
# Select 3 from menu

# 2. Check all blacklist IPs
# Select 4 from menu

# 3. Manually check log files
sudo tail -f /var/log/auth.log | grep "Failed password"

# 4. Check iptables rules
sudo iptables -L INPUT -n --line-numbers
```

### Scenario 4: Troubleshooting

```bash
# 1. Check log file access
ls -la /var/log/auth.log

# 2. Check if iptables is working
sudo iptables --version

# 3. Check script permissions
ls -la ssh-blacklist.sh

# 4. Add test IP
sudo ./ssh-blacklist.sh
# Select 2 from menu and enter test IP
```

## 📞 Support

If you encounter issues:

1. **Check Log Files:**
```bash
sudo tail -f /var/log/auth.log
```

2. **Check Script Output:**
```bash
sudo ./ssh-blacklist.sh 2>&1 | tee debug.log
```

3. **Check System Status:**
```bash
sudo systemctl status ssh
sudo iptables -L
```

4. **Get support from GitHub Issues** page.

---

This guide comprehensively explains all features of the SSH Brute Force Blocking tool. If you have any questions, please open an issue on the GitHub repository. 