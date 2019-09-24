#!/bin/bash
echo "Starting Setup..."
# little joke in Portuguese, nothing to be afraid
echo "É HORA DO SHOOOOOOOOOOOOOOOOOWWWWWWW!!!"
echo ""

# Variables
echo "Loading variables..........................................................................................................................................................................."
git_username='edddjunior'
git_email='edsonbergamojunior@gmail.com'
nvm_version='v0.34.0'
node_version='10.16.3'
ruby_version='2.6.4'
rails_version='6.0.0'
postgresql_version='10'
postgresql_password='81035810'
echo "Ready."

# Update and upgrade
echo "Updating repositories..........................................................................................................................................................................."
sudo apt update -y
sudo apt upgrade -y
echo "Ready."

# Curl and Wget
echo "Installing Curl and Wget..........................................................................................................................................................................."
sudo apt install curl -y && apt-get install wget -y
echo "Ready."

# Git and its conf
echo "Git..........................................................................................................................................................................."
sudo apt install git -y
git config --global user.name "${git_username}"
git config --global user.email "${git_email}"
echo "Ready."

# NVM
echo "NVM..........................................................................................................................................................................."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
echo "Ready."

# Node.js
echo "Node..........................................................................................................................................................................."
nvm install ${node_version}
nvm alias default ${node_version}
nvm use default
echo "Ready."

# Yarn
echo "Yarn..........................................................................................................................................................................."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn -y
echo "Ready."

# Java
echo "Java..........................................................................................................................................................................."
sudo apt install openjdk-8-jdk -y
echo "Ready."

# RVM
echo "RVM..........................................................................................................................................................................."
\curl -sSL https://get.rvm.io | bash
source ~/.rvm/scripts/rvm
echo "Ready."

# Ruby
echo "Ruby..........................................................................................................................................................................."
rvm install ${ruby_version}
rvm --default use ${ruby_version}
echo "Ready."

# Rails
echo "Rails..........................................................................................................................................................................."
gem install rails -v ${rails_version}
echo "Ready."

# Elasticsearch
echo "Elasticsearch..........................................................................................................................................................................."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
sudo apt install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update && sudo apt install elasticsearch

systemctl start elasticsearch.service && systemctl stop elasticsearch.service
systemctl stop elasticsearch.service
echo "Ready."

# Postgres
echo "Postgres..........................................................................................................................................................................."
sudo apt install postgresql-${postgresql_version} -y
sudo apt install libpq-dev -y

sudo sed -e '/^local   all/s/peer/trust/' /etc/postgresql/${postgresql_version}/main/pg_hba.conf
sudo service postgresql restart
psql -U postgres
ALTER USER postgres WITH ENCRYPTED PASSWORD '${postgresql_password}';
sed -e '/^local   all/s/trust/md5/' /etc/postgresql/${postgresql_version}/main/pg_hba.conf
sudo service postgresql restart
echo "Ready."

# Zsh and OhMyZsh
echo "Zsh & OhMyZsh..........................................................................................................................................................................."
sudo apt install fonts-powerline
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -rf ~/.zshrc && wget -O ~/.zshrc https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.zshrc
echo "Ready."

# Tmux
echo "Tmux..........................................................................................................................................................................."
sudo apt install tmux -y
wget -O ~/.tmux.conf https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.tmux.conf
sudo apt install xclip
echo "Ready."

# Vim
echo "Vim............................................................................................................................................................................"
sudo apt install vim -y && sudo apt install vim-gnome -y
curl -L https://bit.ly/janus-bootstrap | bash

git clone https://github.com/jiangmiao/auto-pairs.git ~/.vim/janus/vim/tools/
git clone https://github.com/yggdroot/indentline.git ~/.vim/janus/vim/tools/
git clone https://github.com/dyng/ctrlsf.vim.git ~/.vim/janus/vim/tools/
git clone https://github.com/rking/ag.vim.git ~/.vim/janus/vim/tools/
git clone https://github.com/kien/ctrlp.vim ~/.vim/janus/vim/tools/
git clone https://github.com/tpope/vim-rails.git ~/.vim/janus/vim/tools/
git clone https://github.com/tpope/vim-ragtag.git ~/.vim/janus/vim/tools/

sudo apt install silversearcher-ag -y

rm -rf ~/.vimrc && wget -O ~/.vimrc https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc
wget -O ~/.vimrc.after https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.after
wget -O ~/.vimrc.before https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.before
echo "Ready."

echo "Finished!"
