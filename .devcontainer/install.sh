#!/bin/bash

## Shorthands for git
git config --global alias.slog 'log --pretty=oneline --abbrev-commit'
git config --global alias.co checkout

## Patches VSCode extensions for TLA+
wget https://github.com/alygin/vscode-tlaplus/releases/download/v1.6.0-alpha.1/vscode-tlaplus-1.6.0.vsix -P /tmp
wget https://github.com/alygin/better-comments/releases/download/v2.0.5_tla/better-comments-2.0.5.vsix -P /tmp

## Place to install TLC, TLAPS, Apalache, ...
mkdir -p tools

## PATH below has two locations because of inconsistencies between Gitpod and Codespaces.
## Gitpod:     /workspace/...
## Codespaces: /workspaces/...

## Install TLA+ Tools
wget https://nightly.tlapl.us/dist/tla2tools.jar -P tools/
echo "alias tlcrepl='java -cp /workspace/ewd998/tools/tla2tools.jar:/workspaces/ewd998/tools/tla2tools.jar tlc2.REPL'" >> $HOME/.bashrc
echo "alias tlc='java -cp /workspace/ewd998/tools/tla2tools.jar:/workspaces/ewd998/tools/tla2tools.jar tlc2.TLC'" >> $HOME/.bashrc

## Install TLAPS (proof system)
wget https://github.com/tlaplus/tlapm/releases/download/v1.4.5/tlaps-1.4.5-x86_64-linux-gnu-inst.bin -P /tmp
chmod +x /tmp/tlaps-1.4.5-x86_64-linux-gnu-inst.bin
/tmp/tlaps-1.4.5-x86_64-linux-gnu-inst.bin -d tools/tlaps
echo 'export PATH=$PATH:/workspace/ewd998/tools/tlaps/bin:/workspaces/ewd998/tools/tlaps/bin' >> $HOME/.bashrc

## Install Apalache
wget https://github.com/informalsystems/apalache/releases/latest/download/apalache.tgz -P /tmp
mkdir -p tools/apalache
tar xvfz /tmp/apalache.tgz --directory tools/apalache/
echo 'export PATH=$PATH:/workspace/ewd998/tools/apalache/bin:/workspaces/ewd998/tools/apalache/bin' >> $HOME/.bashrc

## Install the VSCode extensions (if this is moved up, it appears to be racy and cause Bad status code: 404: Not found.)
code --install-extension /tmp/vscode-tlaplus-1.6.0.vsix
code --install-extension /tmp/better-comments-2.0.5.vsix

## (Moved to the end to let it run in the background while we get started)
## - graphviz to visualize TLC's state graphs
## - htop to show system load
## - texlive-latex-recommended to generate pretty-printed specs
## - z3 for Apalache (TLAPS brings its own install)
## - r-base iff tutorial covers statistics (TODO)
sudo apt-get install -y graphviz htop
sudo apt-get install -y z3 libz3-java 
sudo apt-get install -y --no-install-recommends texlive-latex-recommended
#sudo apt-get install -y r-base

## Activate the aliases above
source ~/.bashrc
