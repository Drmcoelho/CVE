#!/bin/bash

# CVE Course Environment Setup Script
echo "🚀 Setting up CVE Course Environment..."

# Update system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install additional tools
sudo apt-get install -y curl wget git jq tree htop

# Install GitHub CLI if not already installed
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
fi

# Install Google AI CLI (Gemini)
if ! command -v gemini &> /dev/null; then
    echo "Installing Gemini CLI..."
    npm install -g @google-ai/generativelanguage
fi

# Set up Python environment
python -m pip install --upgrade pip
pip install --user requests openai google-generativeai jupyter notebook

# Set up Node.js environment
npm install -g typescript ts-node nodemon create-next-app

# Create course structure
mkdir -p ~/course/{modules,assets,scripts,docs}

# Set up SSH configuration
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Configure Git for better integration
git config --global init.defaultBranch main
git config --global pull.rebase false

echo "✅ CVE Course Environment setup completed!"
echo "🔧 Available tools:"
echo "  - GitHub CLI: $(gh --version | head -1)"
echo "  - Node.js: $(node --version)"
echo "  - Python: $(python --version)"
echo "  - TypeScript: $(tsc --version)"

# Display helpful information
echo ""
echo "📚 Getting Started:"
echo "  1. Run 'gh auth login' to authenticate with GitHub"
echo "  2. Use 'gh copilot' for AI assistance"
echo "  3. Access course materials in ~/course/"
echo "  4. Start development server with npm/python commands"