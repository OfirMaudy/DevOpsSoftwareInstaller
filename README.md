# Software Installer Application - Documentation

**Version:** 1.0

## Overview

The Software Installer is a comprehensive Bash-based interactive application designed to simplify the installation, management, and removal of commonly used DevOps and development tools on Ubuntu/Debian-based Linux systems. The application provides a user-friendly text-based interface using `whiptail` that allows seamless navigation with arrow keys and easy multi-selection capabilities.

## Features

### 1. **Interactive Menu System**
   - User-friendly interface powered by `whiptail`
   - Navigate using arrow keys
   - Return to main menu after each action for continuous operation
   - All operations are non-destructive with confirmation dialogs

### 2. **Install Specific Software**
   - Select one or multiple applications to install simultaneously
   - Use **Space** to select/deselect items
   - Use **Arrow keys** to navigate through the list
   - Press **Enter** to confirm selections
   - Application detects and skips already-installed software

### 3. **Install All Software**
   - Install all supported applications with a single click
   - Automatically skips applications that are already installed
   - Useful for setting up a complete development environment

### 4. **Check Installed Versions**
   - View all installed software on your system
   - Display version information for each installed application
   - Shows "Not installed" message if no software is currently installed
   - Helps track what's deployed on your system

### 5. **Update Repositories**
   - Refreshes package lists from configured repositories
   - Uses: `sudo apt update`
   - Essential before installing or updating packages

### 6. **Update System**
   - Updates both repositories and installed packages
   - Uses: `sudo apt update && sudo apt upgrade -y`
   - Keeps your system current with security patches and new features

### 7. **Uninstall Software**
   - Remove one or multiple applications simultaneously
   - Pre-selects installed software for easy identification
   - Cleans up configuration files and repositories where applicable
   - Safely removes services and systemd configurations

### 8. **View README**
   - Access documentation directly within the application
   - No need to open external files
   - Quick reference for features and usage

### 9. **Exit with Confirmation**
   - Prevents accidental application closure
   - Confirms user intent with a yes/no dialog
   - Graceful shutdown

## Supported Applications

The application manages the following 10 tools:

| Application | Purpose | Type |
|-------------|---------|------|
| **git** | Version control system | Development |
| **docker** | Container management platform | DevOps |
| **ansible** | Configuration management & automation | DevOps |
| **jenkins** | CI/CD automation server | DevOps |
| **minikube** | Local Kubernetes cluster | Container Orchestration |
| **kubectl** | Kubernetes command-line tool | Container Orchestration |
| **terraform** | Infrastructure as Code tool | DevOps |
| **vscode** | Visual Studio Code editor | Development |
| **grafana** | Monitoring & visualization platform | DevOps |
| **nvim** | Neovim text editor | Development |

## Installation Instructions

### Prerequisites
- Ubuntu or Debian-based Linux distribution
- Sudo access (required for package installation)
- Internet connection for downloading packages
- `whiptail` utility (automatically installed if missing)

### Setup

1. **Navigate to the application directory:**
   ```bash
   cd /home/ofir/Desktop/Projects/Projects_Portfolio/SoftwareInstaller
   ```

2. **Ensure the script is executable:**
   ```bash
   chmod +x installer.sh
   ```

3. **Run the application:**
   ```bash
   ./installer.sh
   ```

## Usage Guide

### General Navigation
- **Arrow Keys:** Move up/down in menus and checklists
- **Tab:** Switch between dialog elements
- **Space:** Select/deselect items in checklists
- **Enter:** Confirm selections
- **Esc:** Cancel or go back

### Menu Options

#### Option 1: Install Specific Software
- Displays a checklist of all 10 applications
- Select the ones you want to install
- The script will skip already-installed applications
- Provides feedback on each installation

#### Option 2: Install All Software
- Installs all 10 applications without confirmation
- Automatically detects and skips installed applications
- Perfect for initial environment setup

#### Option 3: Check Installed Versions
- Shows a popup with all installed applications
- Displays version numbers for each application
- Useful for troubleshooting and documentation

#### Option 4: Update Repositories
- Refreshes package lists from all configured repositories
- Should be run before major updates or installations
- No additional user interaction required

#### Option 5: Update System
- Performs both repository update and package upgrade
- Updates all installed packages to latest versions
- Includes security patches and feature updates

#### Option 6: Uninstall Software
- Displays a checklist with all applications
- Pre-selects installed software (easier to identify)
- Remove unwanted applications cleanly
- Cleans up associated repositories and services

#### Option 7: View README
- Display the full documentation within the application
- Scrollable dialog for easy navigation
- Contains all features and usage information

#### Option 8: Exit
- Safely closes the application
- Requires confirmation to prevent accidental exit

## Technical Details

### Functions

#### `is_installed()`
Checks if a specific application is installed on the system using:
- `command -v` for binary executables
- `systemctl is-active` for system services (Jenkins, Grafana)

#### `get_version()`
Retrieves version information for installed applications using:
- Command-line version flags (`--version`, `version`)
- API calls for service-based applications (Jenkins, Grafana)
- Package information queries

#### `install_software()`
Handles installation of each application with:
- Repository setup where needed
- Package dependencies
- Service enablement and startup

#### `uninstall_software()`
Safely removes applications with:
- Service stopping and disabling
- Package removal
- Repository cleanup

### Installation Methods

Different applications use different installation methods:

- **APT Packages:** git, docker, ansible, minikube, kubectl, nvim
- **Third-party Repositories:** Jenkins, VS Code, Grafana, Terraform
- **Direct Downloads:** Minikube, kubectl (latest versions)

## Troubleshooting

### Issue: "whiptail is not installed"
**Solution:** The script automatically installs whiptail. If it fails:
```bash
sudo apt update && sudo apt install -y whiptail
```

### Issue: Permission Denied
**Solution:** Make the script executable:
```bash
chmod +x installer.sh
```

### Issue: Installation Fails
**Solution:** Update repositories first:
```bash
./installer.sh
# Select Option 4: Update Repositories
```

### Issue: Version Check Shows "No software installed"
**Solution:** Run "Check Installed Versions" again, or ensure applications are properly installed by running their version commands manually:
```bash
git --version
docker --version
ansible --version
```

### Issue: Cannot Remove an Application
**Solution:** Use the uninstall option which handles cleanup better than manual removal. Alternatively:
```bash
sudo apt remove -y <package-name>
```

## System Requirements

- **OS:** Ubuntu 18.04 LTS or later, Debian 10 or later
- **Memory:** 2GB RAM minimum (4GB+ recommended)
- **Disk Space:** 5GB+ free space for all applications
- **Network:** Internet connection required for downloads
- **Privileges:** Sudo access required

## File Structure

```
SoftwareInstaller/
├── installer.sh          # Main application script
├── README.md             # Full documentation
```

## Configuration Files Modified

During installation, the script may create or modify:
- `/etc/apt/sources.list.d/` - Repository configurations
- `/etc/systemd/system/` - System service configurations
- `~/.local/share/` - User-level configurations

## Security Considerations

1. **Sudo Usage:** The script requires sudo for system-wide installations. Review before running with sudo.
2. **Third-party Repositories:** Some applications (Jenkins, Grafana, Terraform) use third-party repositories. Verify their authenticity.
3. **Package Verification:** APT automatically verifies package signatures.

## Performance Notes

- Initial installation of all applications may take 30+ minutes depending on internet speed
- Updates are checked but skipped for already-installed applications
- Version checking requires network access for some applications

## Future Enhancements

Potential improvements for future versions:
- Support for additional applications
- Custom installation configurations
- Backup and restore functionality
- Application dependency management
- Rollback capabilities

## Support & Issues

For bugs, feature requests, or issues:
1. Check the Troubleshooting section
2. Verify system requirements are met
3. Review application installation logs
4. Test individual installations manually

## License & Attribution

Created as part of the Projects Portfolio collection.

### Created By

- **Ofir Maudy** - Application Developer & Designer

---

**Last Updated:** January 27, 2026
**Version:** 1.0