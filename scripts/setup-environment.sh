#!/bin/bash

echo "🚀 Setting up CVE Course Environment..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check Node.js version
if command_exists node; then
    node_version=$(node --version)
    echo -e "${GREEN}✓${NC} Node.js found: $node_version"
else
    echo -e "${RED}✗${NC} Node.js not found. Please install Node.js 18+"
    exit 1
fi

# Check npm
if command_exists npm; then
    npm_version=$(npm --version)
    echo -e "${GREEN}✓${NC} npm found: $npm_version"
else
    echo -e "${RED}✗${NC} npm not found"
    exit 1
fi

# Install dependencies
echo -e "${BLUE}📦${NC} Installing dependencies..."
npm install

# Check for GitHub CLI
if command_exists gh; then
    gh_version=$(gh --version | head -1)
    echo -e "${GREEN}✓${NC} GitHub CLI found: $gh_version"
    
    # Check if authenticated
    if gh auth status >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} GitHub CLI authenticated"
    else
        echo -e "${YELLOW}⚠${NC} GitHub CLI not authenticated. Run 'gh auth login'"
    fi
else
    echo -e "${YELLOW}⚠${NC} GitHub CLI not found. Install with: https://cli.github.com/"
fi

# Check for Python
if command_exists python3; then
    python_version=$(python3 --version)
    echo -e "${GREEN}✓${NC} Python found: $python_version"
    
    # Install Python dependencies
    echo -e "${BLUE}🐍${NC} Installing Python dependencies..."
    pip3 install --user requests openai google-generativeai
else
    echo -e "${YELLOW}⚠${NC} Python3 not found. Some AI features may not work."
fi

# Create necessary directories
echo -e "${BLUE}📁${NC} Creating directories..."
mkdir -p course/{analytics,assets,docs}
mkdir -p src/{components,utils,api}

# Set permissions
chmod +x scripts/ai_automation.py

# Environment check
echo ""
echo -e "${BLUE}🔧 Environment Configuration:${NC}"
echo "NODE_ENV: ${NODE_ENV:-development}"
echo "Platform: $(uname -s)"
echo "Architecture: $(uname -m)"
echo ""

# Browser detection and recommendations
echo -e "${BLUE}🌐 Browser Optimization Tips:${NC}"
echo "• Safari: Enable WebGL and disable tracking protection for development"
echo "• Chrome: Use --disable-web-security flag for local testing if needed"
echo "• Edge: Enable developer mode for enhanced debugging"
echo ""

# Quick start instructions
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo -e "${BLUE}Quick Start Commands:${NC}"
echo "  Development server: npm run dev"
echo "  Build production:   npm run build"
echo "  AI automation:      npm run ai-automation"
echo "  GitHub Copilot:     gh copilot suggest '<your query>'"
echo ""
echo -e "${BLUE}🚀 Access your course at:${NC}"
echo "  Local: http://localhost:3000"
echo "  Codespace: Use the forwarded port URL"
echo ""

# Environment-specific instructions
if [[ -n "$CODESPACES" ]]; then
    echo -e "${GREEN}🚀 GitHub Codespace detected!${NC}"
    echo "Your environment is pre-configured with all tools."
    echo "Port 3000 will be automatically forwarded."
elif [[ -n "$SSH_CONNECTION" ]]; then
    echo -e "${BLUE}🔐 SSH connection detected${NC}"
    echo "Make sure to forward port 3000 for web access."
else
    echo -e "${YELLOW}💻 Local development environment${NC}"
    echo "All features available locally."
fi

echo ""
echo -e "${GREEN}Ready for AI-powered CVE learning! 🎓${NC}"