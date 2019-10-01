#!/bin/bash
echo "Starting Setup..."
echo "BORAAAAA! É HORA DO SHOOOOOOOOOOOOOOOOOWWWWWWW!!!"

# Variables
echo "Loading variables... ##########################################################################################################################################################################"
git_username='edddjunior'
git_email='edsonbergamojunior@gmail.com'
nvm_version='v0.34.0'
node_version='10.16.3'
ruby_version='2.6.4'
rails_version='6.0.0'
postgresql_version='10'
postgresql_password=''
echo "Ready."

# Update and upgrade
echo "Updating repositories... ##########################################################################################################################################################################"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "Ready."

# Other stuff
sudo apt-get install build-essential -y
echo "Updating repositories... ##########################################################################################################################################################################"

# Curl and Wget
echo "Installing Curl and Wget"
sudo apt-get install curl -y && sudo apt-get install wget -y
echo "Ready."

# Git and its conf
echo "Git... ##########################################################################################################################################################################"
sudo apt-get install git -y
git config --global user.name "${git_username}"
git config --global user.email "${git_email}"
echo "Ready."

# NVM
echo "NVM... ##########################################################################################################################################################################"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
echo "Ready."

# Node.js
echo "Node... ##########################################################################################################################################################################"
nvm install ${node_version}
nvm alias default ${node_version}
nvm use default
echo "Ready."

# Yarn
echo "Yarn... ##########################################################################################################################################################################"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn
echo "Ready."

# Java
echo "Java... ##########################################################################################################################################################################"
sudo apt-get install openjdk-8-jdk -y
echo "Ready."

# RVM
echo "RVM... ##########################################################################################################################################################################"
\curl -sSL https://get.rvm.io | bash
source ~/.rvm/scripts/rvm
echo "Ready."

# Ruby
echo "Ruby... ##########################################################################################################################################################################"
rvm install "ruby-${ruby_version}"
rvm --default use ${ruby_version}
echo "Ready."

# Rails
echo "Rails... ##########################################################################################################################################################################"
gem install rails -v ${rails_version}
echo "Ready."

# Elasticsearch
echo "Elasticsearch... ##########################################################################################################################################################################"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo systemctl start elasticsearch.service && sudo systemctl stop elasticsearch.service
echo "Ready."

# Postgres
echo "Postgres... ##########################################################################################################################################################################"
sudo apt-get install postgresql-${postgresql_version} -y
sudo apt-get install libpq-dev -y

sudo sed -i '/^local   all/s/peer/trust/' /etc/postgresql/${postgresql_version}/main/pg_hba.conf
sudo service postgresql restart
psql -U postgres -c "ALTER USER postgres WITH ENCRYPTED PASSWORD '${postgresql_password}'";
sudo sed -i '/^local   all/s/trust/md5/' /etc/postgresql/${postgresql_version}/main/pg_hba.conf
sudo service postgresql restart
echo "Ready."

# Redis
echo "Redis... ##########################################################################################################################################################################"
sudo apt-get install redis -y
sudo systemctl start redis-server && sudo systemctl status redis
sudo systemctl stop redis

# Regolith
sudo add-apt-repository -y ppa:kgilmer/regolith-stable
sudo apt-get install regolith-desktop -y

# Tmux
echo "Tmux... ##########################################################################################################################################################################"
sudo apt-get install tmux -y
wget -O ~/.tmux.conf https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.tmux.conf
sudo apt-get install xclip
echo "Ready."

# Vim
echo "Vim... ##########################################################################################################################################################################"
sudo apt-get install vim -y && sudo apt-get install vim-gnome -y
curl -L https://bit.ly/janus-bootstrap | bash

cd ~/.vim/janus/vim/tools/
git clone https://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/yggdroot/indentline.git
git clone https://github.com/dyng/ctrlsf.vim.git
git clone https://github.com/rking/ag.vim.git
git clone https://github.com/kien/ctrlp.vim.git
git clone https://github.com/tpope/vim-rails.git
git clone https://github.com/tpope/vim-ragtag.git
sudo apt-get install silversearcher-ag -y

cd ~
wget -O ~/.vimrc.after https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.after
wget -O ~/.vimrc.before https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.before
echo "Ready."

# Zsh and OhMyZsh
echo "Zsh & OhMyZsh... ##########################################################################################################################################################################"
cd ~
sudo apt-get install fonts-powerline
sudo apt-get install zsh -y

yes | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -rf ~/.zshrc && wget -O ~/.zshrc https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.zshrc

echo "Ready."

# Tools
npm install -g vtop
sudo apt install neofetch

# TRIM SSD
echo "TRIM SSD... ##########################################################################################################################################################################"
sudo fstrim -v /
sudo wget -O /etc/cron.daily/TRIM_ssd https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/TRIM_ssd
sudo chmod +x /etc/cron.daily/TRIM_ssd

echo "Finished!"

read -p "Press Enter to finish it. The computer will reboot now."
sudo reboot
