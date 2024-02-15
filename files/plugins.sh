#!/bin/bash

plugins=("sqlls" "sqlfluff" "sql-formatter"
         "html-lsp" "flake8" "python-lsp-server"
         "black" "cpplint" "clangd" "clang-format"
         "yaml-language-server" "typescript-language-server"
         "prettier" "eslint-lsp" "dockerfile-language-server"
         "lua-language-server" "omnisharp" "rust-analyzer")

for plugin in "${plugins[@]}"; do
    nvim --headless -c ":MasonInstall $plugin" -c 'q'
done

nvim --headless -c ':MasonUpdate' -c 'q'
