# dev-environment
[![Docker Publish](https://github.com/Aguiar575/dev-environment/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Aguiar575/dev-environment/actions/workflows/docker-publish.yml)

This Docker image, based on Ubuntu, incorporates various development tools and utilities to enhance your development environment. The image is complemented by a Docker Compose file that includes cAdvisor, a container monitoring tool. The development tools encompass Git, LuaJIT, Rust, Clang, Lazygit, ClamAV, NVM, .NET, Pyenv, Neovim, and more.

## Usage
```bash
docker exec -it env-container /bin/bash
```

4. Access cAdvisor's web interface at `http://localhost:8080` to monitor container metrics.

## Installed Tools and Components
- **Lazygit:** A simple terminal UI for Git commands.
- **ClamAV:** Antivirus software for detecting malicious software. The only path not scanned by ClamAV is `/root/Development` (defined in `clamd.conf`).
- **Rust:** Programming language and package manager.
- **Clangd:** Language server for Clang.
- **NVM:** Node Version Manager for managing Node.js versions.
- **.NET:** Cross-platform framework for building modern, cloud-based, and internet-connected applications.
- **Pyenv:** Python version manager.
- **Neovim:** Extensible text editor.
- **cAdvisor:** Container monitoring tool.

## Custom Configurations
- **Crontab:** Scheduled job for ClamAV scans.
- **Debugpy Virtual Environment:** Python virtual environment named 'debugpy' in /root/virtualenvs.
