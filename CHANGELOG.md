# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standard.

## [Unreleased]

### Added
- Comprehensive README.md for GitHub
- Detailed usage guide (USAGE.md)
- MIT license file
- .gitignore file
- Changelog file

### Changed
- Documentation improvements
- Added code comments

## [1.0.0] - 2024-12-15

### Added
- SSH brute force attack detection system
- Automatic IP blocking (with iptables)
- Whitelist/Blacklist management
- Multi-log file support
  - `/var/log/auth.log` (Ubuntu/Debian)
  - `/var/log/secure` (CentOS/RHEL)
  - `journalctl` (systemd-based systems)
- User-friendly terminal menu system
- IP validation system
- Double-check mechanism (whitelist priority)
- Threshold value adjustment (default: 10 failed attempts)
- Screenshots and documentation

### Features
- **Automatic Attack Detection**: Automatically detects brute force attacks by analyzing SSH logs
- **Dynamic IP Blocking**: Automatically blocks suspicious IP addresses using iptables
- **Whitelist/Blacklist Management**: Add trusted IPs to whitelist and dangerous IPs to blacklist
- **Multi-Log Support**: Support for different Linux distributions
- **User-Friendly Interface**: Terminal-based menu system
- **Real-Time Protection**: Continuously running protection system

### Security
- IP validation (only valid IPv4 addresses)
- Whitelist priority (trusted IPs are never blocked)
- Double-check (prevents re-blocking of the same IP)
- Secure log analysis (only "Failed password" entries)

### Technical Details
- **Script Language**: Bash
- **Dependencies**: iptables, sudo
- **Supported OS**: Linux (Ubuntu, CentOS, RHEL, Debian, etc.)
- **Log Sources**: auth.log, secure, journalctl
- **Firewall**: iptables integration
- **Threshold**: Configurable (default: 10 failed attempts)

---

## Version Numbering

This project follows [Semantic Versioning](https://semver.org/) standard:

- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible new features
- **PATCH**: Backward-compatible bug fixes

## Contributing

For new features or bug fixes:

1. Open an issue
2. Create a feature branch
3. Commit your changes
4. Send a pull request
5. Update the changelog

## Future Versions

### Planned Features
- [ ] Web interface
- [ ] Email notifications
- [ ] API support
- [ ] Docker container support
- [ ] IPv6 support
- [ ] Fail2ban integration
- [ ] Grafana dashboard
- [ ] Machine learning-based attack detection
- [ ] Cloud provider integrations (AWS, Azure, GCP)
- [ ] Multi-server management
- [ ] Automatic update system
- [ ] Backup and restore features
- [ ] Performance monitoring
- [ ] Rate limiting features
- [ ] Geo-blocking support
- [ ] Custom rule engine
- [ ] Integration with SIEM systems
- [ ] Real-time monitoring dashboard
- [ ] Automated threat intelligence feeds
- [ ] Compliance reporting (GDPR, HIPAA, etc.)

### Technical Improvements
- [ ] Unit test coverage
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Memory usage optimization
- [ ] Better error handling
- [ ] Logging improvements
- [ ] Configuration management
- [ ] Security hardening
- [ ] Code documentation
- [ ] API documentation 