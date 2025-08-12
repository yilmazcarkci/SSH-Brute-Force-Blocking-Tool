# SSH Brute Force Blocking Tool 🔒

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

A powerful and user-friendly SSH brute force attack detection and blocking tool. This script automatically protects your SSH server from brute force attacks and dynamically manages IP addresses.

## 🌟 Features

- **Automatic Attack Detection**: Automatically detects brute force attacks by analyzing SSH logs
- **Dynamic IP Blocking**: Automatically blocks suspicious IP addresses using iptables
- **Whitelist/Blacklist Management**: Add trusted IPs to whitelist and dangerous IPs to blacklist
- **Multi-Log Support**: Support for `/var/log/auth.log`, `/var/log/secure`, and `journalctl`
- **User-Friendly Interface**: Terminal-based menu system
- **Real-Time Protection**: Continuously running protection system

## 📋 Requirements

- Linux operating system
- Bash shell
- sudo privileges
- iptables (usually installed by default)

## 🚀 Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/ssh-brute-force-blocking.git
cd ssh-brute-force-blocking
```

2. **Make the script executable:**
```bash
chmod +x ssh-blacklist.sh
```

3. **Run the script:**
```bash
sudo ./ssh-blacklist.sh
```

## 📖 Usage

### Main Menu

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

### Menu Options

#### 1. Add White List IP
Adds trusted IP addresses to the whitelist. These IPs are never blocked.

#### 2. Add Black List IP
Manually adds IP addresses to the blacklist and blocks them immediately.

#### 3. Show White List IP
Displays all IP addresses in the whitelist.

#### 4. Show Black List IP
Displays all IP addresses in the blacklist and their blocking dates.

#### 5. Detect & Block Brute Force IPs
Analyzes SSH logs to detect brute force attacks and automatically blocks them.

## 🔧 Configuration

### Threshold Value Adjustment

The script blocks IPs after 10 failed login attempts by default. To change this value:

```bash
# Find line 75 in ssh-blacklist.sh and change it:
if [[ "$count" -gt 10 && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
```

### Log File Location

The script automatically detects the following log files:
- `/var/log/auth.log` (Ubuntu/Debian)
- `/var/log/secure` (CentOS/RHEL)
- `journalctl` (systemd-based systems)

## 📁 File Structure

```
ssh-brute-force-blocking/
├── ssh-blacklist.sh          # Main script file
├── blacklist.txt             # Blocked IPs (auto-generated)
├── whitelist.txt             # Trusted IPs (auto-generated)
├── screenshot/               # Usage screenshots
│   ├── SSH Black List Menu.JPG
│   ├── Add White List IP.JPG
│   ├── Detect & Block Brute Force IPs.JPG
│   ├── Show White List IP.JPG
│   └── show black list.JPG
└── README.md                 # This file
```

## 🛡️ Security Features

- **IP Validation**: Only valid IPv4 addresses are accepted
- **Whitelist Priority**: IPs in whitelist are never blocked
- **Double Check**: Prevents re-blocking of the same IP
- **Secure Log Analysis**: Only analyzes "Failed password" entries

## 📸 Screenshots

### Main Menu
![SSH Black List Menu](screenshot/SSH%20Black%20List%20Menu.JPG)

### Adding Whitelist IP
![Add White List IP](screenshot/Add%20White%20List%20IP.JPG)

### Brute Force Detection
![Detect & Block Brute Force IPs](screenshot/Detect%20%26%20Block%20Brute%20Force%20IPs.JPG)

### Viewing Whitelist
![Show White List IP](screenshot/Show%20White%20List%20IP.JPG)

### Viewing Blacklist
![Show Black List](screenshot/show%20black%20list.JPG)

## ⚠️ Important Notes

1. **Sudo Privileges**: Script requires sudo privileges to run iptables commands
2. **Log Files**: SSH logs must be readable
3. **iptables**: iptables must be installed on the system
4. **Backup**: Take backups before using on important systems

## 🔄 Automatic Execution

To run the script automatically on system startup:

```bash
# Add to crontab (check every 5 minutes)
sudo crontab -e

# Add the following line:
*/5 * * * * /path/to/ssh-blacklist.sh
```

## 🐛 Troubleshooting

### Log File Not Found
```bash
# Check SSH log file location
ls -la /var/log/auth.log
ls -la /var/log/secure

# Check if journalctl is working
journalctl --version
```

### iptables Error
```bash
# Check if iptables is installed
iptables --version

# Install if needed (Ubuntu/Debian)
sudo apt-get install iptables

# CentOS/RHEL
sudo yum install iptables
```

### Permission Error
```bash
# Make sure script is executable
chmod +x ssh-blacklist.sh

# Check sudo privileges
sudo -l
```

## 🤝 Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Yasin Çarkçı**

- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Linux community
- SSH protocol developers
- iptables developers

## 📊 Statistics

![GitHub stars](https://img.shields.io/github/stars/yourusername/ssh-brute-force-blocking)
![GitHub forks](https://img.shields.io/github/forks/yourusername/ssh-brute-force-blocking)
![GitHub issues](https://img.shields.io/github/issues/yourusername/ssh-brute-force-blocking)

---

⭐ If you like this project, don't forget to give it a star! 