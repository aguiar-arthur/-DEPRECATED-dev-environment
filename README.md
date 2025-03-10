# DEPRECATED dev-environment
[![Docker Publish](https://github.com/Aguiar575/dev-environment/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Aguiar575/dev-environment/actions/workflows/docker-publish.yml)
![No Maintenance Intended](https://img.shields.io/maintenance/no/2025.svg)

This Docker image, based on Ubuntu, incorporates various development tools and utilities to enhance your development environment. The image is complemented by a Docker Compose file that includes cAdvisor, a container monitoring tool. The development tools encompass Git, LuaJIT, Rust, Clang, Lazygit, NVM, .NET, Pyenv, Neovim, and more.

## First things firts! 
- Hey! Why are you using npm and python3 since you have nvm and pyenv?
- Please, this is easier to manage packages. This is a docker, you can burn this if you want to! Feel free to change.

## Usage
```bash
docker/podman exec -it env-container /bin/bash
```
4. In docker-compose you can access cAdvisor's web interface at `http://localhost:8080` to monitor container metrics.

## Installed Tools and Components
- **Lazygit:** A simple terminal UI for Git commands.
- **Rust:** Programming language and package manager.
- **Clangd:** Language server for Clang.
- **NVM:** Node Version Manager for managing Node.js versions.
- **.NET:** Cross-platform framework for building modern, cloud-based, and internet-connected applications.
- **Pyenv:** Python version manager.
- **Neovim:** Extensible text editor.
- **cAdvisor:** Container monitoring tool.

## Custom Configurations
- **Debugpy Virtual Environment:** Python virtual environment named 'debugpy' in /root/virtualenvs.
