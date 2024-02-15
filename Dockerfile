FROM --platform=linux/amd64 ubuntu:latest

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    git tar luajit curl wget unzip make \
    clang clang-tools jq cron ripgrep python3.10-venv \
    lsb-release software-properties-common gnupg 

# Install Lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && echo "Lazygit version: $LAZYGIT_VERSION" \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && mv lazygit /usr/local/bin \
    && rm -rf lazygit.tar.gz

RUN lazygit --version

# Install ClamAV
RUN apt-get install -y clamav clamav-daemon && \
    freshclam

COPY files/clamd.conf /etc/clamd.conf
COPY files/clamscan.sh /path/to/clamscan.sh

RUN chmod +x /path/to/clamscan.sh && \
    echo "0 */5 * * * /path/to/clamscan.sh" | crontab - && \
    cron

# Install rust 
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo 'export PATH="/root/.cargo/bin:${PATH}"' >> /root/.bashrc

# Clangd
RUN apt-get install -y clangd-12 && \
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100

# Download the llvm.sh script
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh all

# Install NVM
ENV NVM_DIR="/root/.nvm"
RUN git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" \
    && cd "$NVM_DIR" \
    && git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)) \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install node \
    && nvm use node

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# Install .NET
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --version latest && \
    rm ./dotnet-install.sh && \
    echo 'export PATH="${PATH}:/root/.dotnet:/root/.dotnet/tools"' >> /root/.bashrc

# Install pyenv
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y python3-openssl build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev 

RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/bin:$PATH"

RUN echo 'export PATH="/root/.pyenv/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc

RUN eval "$(pyenv init --path)" && \
    pyenv install --list | grep -E '^  [0-9]+\.[0-9]+\.[0-9]+$' | tail -n 1 | xargs pyenv install && \
    pyenv global $(pyenv versions --bare)

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz

ENV PATH="/opt/nvim-linux64/bin:${PATH}"

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim && \
    git clone https://github.com/Aguiar575/nvim /root/.config/nvim && \
    echo 'export PATH="/opt/nvim-linux64/bin:${PATH}"' >> /root/.bashrc && \
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' && \
    nvim --headless -c ':TSUpdate' -c ':TSUpdateSync' -c 'q' && \
    nvim --headless -c ':MasonUpdate' -c 'q'

# Manual installation of the Mason plugins
COPY files/plugins.sh /root/plugins.sh
RUN chmod +x /root/plugins.sh && \
    /root/plugins.sh

RUN eval "$(pyenv init --path)" && \
    mkdir /root/virtualenvs && \
    cd /root/virtualenvs && \
    python -m venv debugpy && \
    ./debugpy/bin/python -m pip install debugpy

COPY files/variables.lua /root/.config/nvim/lua/arthur/variables.lua

# Start a command that doesn't exit immediately
CMD ["tail", "-f", "/dev/null"]
