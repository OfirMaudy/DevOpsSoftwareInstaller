#!/bin/bash

# Software Installer Application
# Version: 1.1
# Description: An interactive tool to manage software installations, updates, and removals

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Application version
APP_VERSION="1.1"
if ! command -v whiptail &> /dev/null; then
    echo "whiptail is not installed. Installing..."
    sudo apt update && sudo apt install -y whiptail
fi

# Function to install software
install_software() {
    case $1 in
        git)
            echo "Installing git..."
            sudo apt update && sudo apt install -y git
            ;;
        docker)
            echo "Installing docker..."
            sudo apt update && sudo apt install -y ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        ansible)
            echo "Installing ansible..."
            sudo apt update && sudo apt install -y ansible
            ;;
        jenkins)
            echo "Installing jenkins..."
            sudo apt update && sudo apt install -y fontconfig openjdk-17-jre
            wget -O- https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
            sudo apt update && sudo apt install -y jenkins
            sudo systemctl start jenkins
            sudo systemctl enable jenkins
            ;;
        minikube)
            echo "Installing minikube..."
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
            sudo install minikube-linux-amd64 /usr/local/bin/minikube
            rm minikube-linux-amd64
            ;;
        kubectl)
            echo "Installing kubectl..."
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install kubectl /usr/local/bin/kubectl
            rm kubectl
            ;;
        terraform)
            echo "Installing terraform..."
            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt update && sudo apt install -y terraform
            ;;
        vscode)
            echo "Installing vscode..."
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f packages.microsoft.gpg
            sudo apt update && sudo apt install -y code
            ;;
        grafana)
            echo "Installing grafana..."
            sudo apt install -y apt-transport-https software-properties-common wget
            wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/grafana-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/grafana-keyring.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null
            sudo apt update && sudo apt install -y grafana
            sudo systemctl start grafana-server
            sudo systemctl enable grafana-server
            ;;
        nvim)
            echo "Installing nvim..."
            sudo apt update && sudo apt install -y neovim
            ;;
        helm)
            echo "Installing helm..."
            curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
            ;;
        python)
            echo "Installing python..."
            sudo apt update && sudo apt install -y python3 python3-pip python3-venv
            ;;
        flask)
            echo "Installing flask..."
            if ! command -v pip3 &> /dev/null; then
                sudo apt update && sudo apt install -y python3 python3-pip
            fi
            pip3 install flask
            ;;
        gunicorn)
            echo "Installing gunicorn..."
            if ! command -v pip3 &> /dev/null; then
                sudo apt update && sudo apt install -y python3 python3-pip
            fi
            pip3 install gunicorn
            ;;
        pytest)
            echo "Installing pytest..."
            if ! command -v pip3 &> /dev/null; then
                sudo apt update && sudo apt install -y python3 python3-pip
            fi
            pip3 install pytest
            ;;
        flake8)
            echo "Installing flake8..."
            if ! command -v pip3 &> /dev/null; then
                sudo apt update && sudo apt install -y python3 python3-pip
            fi
            pip3 install flake8
            ;;
        openssh-client)
            echo "Installing openssh-client..."
            sudo apt update && sudo apt install -y openssh-client
            ;;
        openssh-server)
            echo "Installing openssh-server..."
            sudo apt update && sudo apt install -y openssh-server
            sudo systemctl start ssh
            sudo systemctl enable ssh
            ;;
        *)
            echo "Unknown software: $1"
            ;;
    esac
}

# Function to check if software is installed
is_installed() {
    case $1 in
        git) command -v git >/dev/null 2>&1 ;;
        docker) command -v docker >/dev/null 2>&1 ;;
        ansible) command -v ansible >/dev/null 2>&1 ;;
        jenkins) systemctl is-active jenkins >/dev/null 2>&1 ;;
        minikube) command -v minikube >/dev/null 2>&1 ;;
        kubectl) command -v kubectl >/dev/null 2>&1 ;;
        terraform) command -v terraform >/dev/null 2>&1 ;;
        vscode) command -v code >/dev/null 2>&1 ;;
        grafana) systemctl is-active grafana-server >/dev/null 2>&1 ;;
        nvim) command -v nvim >/dev/null 2>&1 ;;
        helm) command -v helm >/dev/null 2>&1 ;;
        python) command -v python3 >/dev/null 2>&1 ;;
        flask) pip3 show flask >/dev/null 2>&1 ;;
        gunicorn) pip3 show gunicorn >/dev/null 2>&1 ;;
        pytest) pip3 show pytest >/dev/null 2>&1 ;;
        flake8) pip3 show flake8 >/dev/null 2>&1 ;;
        openssh-client) command -v ssh >/dev/null 2>&1 ;;
        openssh-server) systemctl is-active ssh >/dev/null 2>&1 ;;
        *) false ;;
    esac
}

# Function to get software version
get_version() {
    case $1 in
        git) git --version 2>/dev/null | awk '{print $3}' ;;
        docker) docker --version 2>/dev/null | awk '{print $3}' | sed 's/,//' ;;
        ansible) ansible --version 2>/dev/null | head -1 | awk '{print $2}' ;;
        jenkins) curl -s http://localhost:8080 2>/dev/null | grep -o "Jenkins [0-9.]*" | awk '{print $2}' || echo "Running (version unavailable)" ;;
        minikube) minikube version 2>/dev/null | grep -o "v[0-9.]*" ;;
        kubectl) kubectl version --client 2>/dev/null | grep -o '"v[0-9.]*"' | sed 's/"//g' ;;
        terraform) terraform version 2>/dev/null | head -1 | awk '{print $2}' ;;
        vscode) code --version 2>/dev/null | head -1 ;;
        grafana) curl -s http://localhost:3000/api/health 2>/dev/null | grep -o '"version":"[^"]*"' | cut -d'"' -f4 || echo "Running (version unavailable)" ;;
        nvim) nvim --version 2>/dev/null | head -1 | awk '{print $2}' ;;
        helm) helm version --short 2>/dev/null ;;
        python) python3 --version 2>/dev/null | awk '{print $2}' ;;
        flask) pip3 show flask 2>/dev/null | grep Version | awk '{print $2}' ;;
        gunicorn) pip3 show gunicorn 2>/dev/null | grep Version | awk '{print $2}' ;;
        pytest) pytest --version 2>/dev/null | awk '{print $2}' ;;
        flake8) flake8 --version 2>/dev/null | awk '{print $1}' ;;
        openssh-client) ssh -V 2>&1 | awk '{print $1}' | sed 's/OpenSSH_//' ;;
        openssh-server) sshd -V 2>&1 | head -1 | awk '{print $1}' | sed 's/OpenSSH_//' ;;
        *) echo "Unknown" ;;
    esac
}

# Function to uninstall software
uninstall_software() {
    case $1 in
        git)
            echo "Uninstalling git..."
            sudo apt remove -y git
            ;;
        docker)
            echo "Uninstalling docker..."
            sudo systemctl stop docker
            sudo systemctl disable docker
            sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo rm -f /etc/apt/sources.list.d/docker.list
            sudo rm -f /etc/apt/keyrings/docker.asc
            ;;
        ansible)
            echo "Uninstalling ansible..."
            sudo apt remove -y ansible
            ;;
        jenkins)
            echo "Uninstalling jenkins..."
            sudo systemctl stop jenkins
            sudo systemctl disable jenkins
            sudo apt remove -y jenkins
            sudo rm -f /etc/apt/sources.list.d/jenkins.list
            sudo rm -f /usr/share/keyrings/jenkins-keyring.gpg
            ;;
        minikube)
            echo "Uninstalling minikube..."
            sudo rm -f /usr/local/bin/minikube
            ;;
        kubectl)
            echo "Uninstalling kubectl..."
            sudo rm -f /usr/local/bin/kubectl
            ;;
        terraform)
            echo "Uninstalling terraform..."
            sudo apt remove -y terraform
            sudo rm -f /etc/apt/sources.list.d/hashicorp.list
            ;;
        vscode)
            echo "Uninstalling vscode..."
            sudo apt remove -y code
            sudo rm -f /etc/apt/sources.list.d/vscode.list
            ;;
        grafana)
            echo "Uninstalling grafana..."
            sudo systemctl stop grafana-server
            sudo systemctl disable grafana-server
            sudo apt remove -y grafana
            sudo rm -f /etc/apt/sources.list.d/grafana.list
            sudo rm -f /usr/share/keyrings/grafana-keyring.gpg
            ;;
        nvim)
            echo "Uninstalling nvim..."
            sudo apt remove -y neovim
            ;;
        helm)
            echo "Uninstalling helm..."
            sudo rm -f /usr/local/bin/helm
            ;;
        python)
            echo "Uninstalling python..."
            sudo apt remove -y python3 python3-pip python3-venv
            ;;
        flask)
            echo "Uninstalling flask..."
            pip3 uninstall -y flask
            ;;
        gunicorn)
            echo "Uninstalling gunicorn..."
            pip3 uninstall -y gunicorn
            ;;
        pytest)
            echo "Uninstalling pytest..."
            pip3 uninstall -y pytest
            ;;
        flake8)
            echo "Uninstalling flake8..."
            pip3 uninstall -y flake8
            ;;
        openssh-client)
            echo "Uninstalling openssh-client..."
            sudo apt remove -y openssh-client
            ;;
        openssh-server)
            echo "Uninstalling openssh-server..."
            sudo systemctl stop ssh
            sudo systemctl disable ssh
            sudo apt remove -y openssh-server
            ;;
        *)
            echo "Unknown software: $1"
            ;;
    esac
}

# Main loop
while true; do
    # Main menu
    choice=$(whiptail --title "Software Installer (Ver: $APP_VERSION)" --menu "Choose an option" 24 60 8 \
    "1" "Install Specific Software" \
    "2" "Install All Software" \
    "3" "Check Installed Versions" \
    "4" "Update Repositories" \
    "5" "Update System" \
    "6" "Uninstall Software" \
    "7" "View README" \
    "8" "Exit" 3>&1 1>&2 2>&3)

    case $choice in
        1)
            # Checklist for specific software
            selections=$(whiptail --title "Select Software to Install" --checklist \
            "Choose software to install:" 30 60 18 \
            "git" "Version control system" OFF \
            "docker" "Containerization platform" OFF \
            "ansible" "Automation tool" OFF \
            "jenkins" "CI/CD server" OFF \
            "minikube" "Local Kubernetes" OFF \
            "kubectl" "Kubernetes CLI" OFF \
            "terraform" "Infrastructure as Code" OFF \
            "helm" "Kubernetes package manager" OFF \
            "vscode" "Code editor" OFF \
            "grafana" "Monitoring dashboard" OFF \
            "nvim" "Text editor" OFF \
            "python" "Python 3 with pip" OFF \
            "flask" "Python web framework" OFF \
            "gunicorn" "Python WSGI HTTP server" OFF \
            "pytest" "Python testing framework" OFF \
            "flake8" "Python linting tool" OFF \
            "openssh-client" "SSH client" OFF \
            "openssh-server" "SSH server" OFF 3>&1 1>&2 2>&3)

            # Check if selections is not empty
            if [ -n "$selections" ]; then
                # Parse selections and install
                for sel in $selections; do
                    # Remove quotes
                    sel=$(echo $sel | sed 's/"//g')
                    if ! is_installed $sel; then
                        install_software $sel
                    else
                        echo "$sel is already installed, skipping."
                    fi
                done
                echo "Installation selections complete. Press Enter to continue."
                read
            fi
            ;;
        2)
            # Install all
            for sw in git docker ansible jenkins minikube kubectl terraform helm vscode grafana nvim python flask gunicorn pytest flake8 openssh-client openssh-server; do
                if ! is_installed $sw; then
                    install_software $sw
                else
                    echo "$sw is already installed, skipping."
                fi
            done
            ;;
        3)
            # Check installed versions
            version_info="Installed Software Versions:\n\n"
            for sw in git docker ansible jenkins minikube kubectl terraform helm vscode grafana nvim python flask gunicorn pytest flake8 openssh-client openssh-server; do
                if is_installed $sw; then
                    version=$(get_version $sw)
                    version_info="$version_info$sw: $version\n"
                fi
            done
            
            if [ "$version_info" = "Installed Software Versions:\n\n" ]; then
                whiptail --title "Installed Versions" --msgbox "No software is currently installed." 10 60
            else
                whiptail --title "Installed Versions" --msgbox "$(echo -e "$version_info")" 25 60
            fi
            ;;
        4)
            # Update repositories
            echo "Updating repositories..."
            sudo apt update
            echo "Repositories updated. Press Enter to continue."
            read
            ;;
        5)
            # Update system
            echo "Updating system..."
            sudo apt update && sudo apt upgrade -y
            echo "System update complete. Press Enter to continue."
            read
            ;;
        6)
            # Uninstall software
            selections=$(whiptail --title "Select Software to Uninstall" --checklist \
            "Choose software to uninstall:" 30 60 18 \
            "git" "Version control system" OFF \
            "docker" "Containerization platform" OFF \
            "ansible" "Automation tool" OFF \
            "jenkins" "CI/CD server" OFF \
            "minikube" "Local Kubernetes" OFF \
            "kubectl" "Kubernetes CLI" OFF \
            "terraform" "Infrastructure as Code" OFF \
            "helm" "Kubernetes package manager" OFF \
            "vscode" "Code editor" OFF \
            "grafana" "Monitoring dashboard" OFF \
            "nvim" "Text editor" OFF \
            "python" "Python 3 with pip" OFF \
            "flask" "Python web framework" OFF \
            "gunicorn" "Python WSGI HTTP server" OFF \
            "pytest" "Python testing framework" OFF \
            "flake8" "Python linting tool" OFF \
            "openssh-client" "SSH client" OFF \
            "openssh-server" "SSH server" OFF 3>&1 1>&2 2>&3)

            # Check if selections is not empty
            if [ -n "$selections" ]; then
                # Parse selections and uninstall
                for sel in $selections; do
                    # Remove quotes
                    sel=$(echo $sel | sed 's/"//g')
                    uninstall_software $sel
                done
                echo "Uninstallation selections complete. Press Enter to continue."
                read
            fi
            ;;
        7)
            # View README
            if [ -f "$SCRIPT_DIR/README.md" ]; then
                clear
                echo "=========================================="
                echo "   README - Software Installer Documentation"
                echo "=========================================="
                echo ""
                echo "Navigation Help:"
                echo "  • Arrow Up/Down: Scroll line by line"
                echo "  • Page Up/Down: Scroll by page"
                echo "  • Home/End: Jump to beginning/end"
                echo "  • q: Return to Main Menu"
                echo ""
                echo "Press any key to start reading..."
                read -n 1
                less -R "$SCRIPT_DIR/README.md"
            else
                whiptail --title "README" --msgbox "README.md file not found!" 10 60
            fi
            ;;
        8)
            # Confirm exit
            if whiptail --title "Exit Confirmation" --yesno "Are you sure you want to exit the app?" 10 60; then
                echo "Goodbye!"
                break
            fi
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done

echo "Installation process complete."