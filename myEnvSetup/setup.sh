#!/bin/bash
echo "Starting Setup...  ###################################################################################################################################################"
echo "BORAAAAA! É HORA DO SHOOOOOOOOOOOOOOOOOWWWWWWW!!!"

# Variables
echo "Loading variables... #################################################################################################################################################"
# Everything else will get their last stable versions.
git_username=''
git_email=''
# Search for the documentation if you want to change Java's version. Because it sucks :/
java_version='openjdk-8-jdk'
ruby_version='2.6.4'
rails_version='6.0.1'
elasticsearch_version='7.x'
postgresql_version='10'
postgresql_password=''
echo "Ready."

# Update and upgrade
echo "Updating repositories... #############################################################################################################################################"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "Ready."

# Chrome
echo "Installing Chrome... #################################################################################################################################################"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
echo "Ready."

# Other stuff
echo "Other Stuff... #######################################################################################################################################################"
sudo apt-get install -y build-essential autoconf bison libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev
echo "Ready."

# Curl and Wget
echo "Installing Curl and Wget... ##########################################################################################################################################"
sudo apt-get install curl -y && sudo apt-get install wget -y
echo "Ready."

# Git and its conf
echo "Git... ###############################################################################################################################################################"
sudo apt-get install git -y
git config --global user.name "${git_username}"
git config --global user.email "${git_email}"
sudo apt-get install -y gitk
echo "Ready."

# NVM
echo "NVM... ###############################################################################################################################################################"
mkdir ~/.nvm
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
echo "Ready."

# Node.js
echo "Node... ##############################################################################################################################################################"
nvm install --lts
nvm use --lts
echo "Ready."

# Yarn
echo "Yarn... ##############################################################################################################################################################"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn
echo "Ready."

# Java
echo "Java... ##############################################################################################################################################################"
sudo apt-get install ${java_version} -y
echo "Ready."

# RVM
echo "RVM... ###############################################################################################################################################################"
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash
source ~/.rvm/scripts/rvm
echo "Ready."

# Ruby
echo "Ruby... ##############################################################################################################################################################"
rvm install "ruby-${ruby_version}"
rvm --default use ${ruby_version}
echo "Ready."

# Rails
echo "Rails... #############################################################################################################################################################"
gem install rails -v ${rails_version}
echo "Ready."

# Postgres
echo "Postgres... ##########################################################################################################################################################"
sudo apt-get install postgresql-${postgresql_version} -y
sudo apt-get install libpq-dev -y
sudo sed -i '/^local   all/s/peer/trust/' /etc/postgresql/${postgresql_version}/main/pg_hba.conf
sudo service postgresql restart
psql -U postgres -c "ALTER USER postgres WITH ENCRYPTED PASSWORD '${postgresql_password}'";
sudo sed -i '/^local   all/s/trust/md5/' /etc/postgresql/${postgresql_version}/main/pg_hba.conf
sudo service postgresql restart
sudo systemctl disable postgresql
echo "Ready."

# Redis
echo "Redis... #############################################################################################################################################################"
sudo apt-get install redis -y
sudo systemctl disable redis-server
echo "Ready."

# Elasticsearch
echo "Elasticsearch... #####################################################################################################################################################"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/${elasticsearch_version}/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-${elasticsearch_version}.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo systemctl disable elasticsearch
echo "Ready."

# Regolith
echo "Regolith... ###########################################################################################################################################################"
sudo add-apt-repository -y ppa:kgilmer/regolith-stable
sudo apt-get install regolith-desktop -y
mkdir -p ~/.config/regolith/i3
cp /etc/regolith/i3/config ~/.config/regolith/i3/config
sudo sed -i 's,^set $terminal_path.*,set $terminal_path /usr/bin/gnome-terminal,g' ~/.config/regolith/i3/config
sudo sed -i 's,^i3xrocks.date.format:.*,i3xrocks.date.format:       + %d/%m %H:%M %p,g' /etc/regolith/styles/i3xrocks
echo "Ready."

# Tmux
echo "Tmux... ##############################################################################################################################################################"
sudo apt-get install tmux -y
wget -O ~/.tmux.conf https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.tmux.conf
sudo apt-get install xclip
echo "Ready."

# Vim
echo "Vim... ###############################################################################################################################################################"
sudo apt-get install vim -y && sudo apt-get install vim-gnome -y
sudo apt-get install silversearcher-ag -y
curl -L https://bit.ly/janus-bootstrap | bash
cd ~/.vim/janus/vim/tools/
git clone https://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/yggdroot/indentline.git
git clone https://github.com/dyng/ctrlsf.vim.git
git clone https://github.com/rking/ag.vim.git
git clone https://github.com/kien/ctrlp.vim.git
git clone https://github.com/tpope/vim-rails.git
git clone https://github.com/tpope/vim-ragtag.git
cd ~
wget -O ~/.vimrc.after https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.after
wget -O ~/.vimrc.before https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.before
echo "Ready."

# Zsh
echo "Zsh... ###############################################################################################################################################################"
cd ~
sudo apt-get install fonts-powerline
sudo apt-get install zsh -y
sudo chsh -s $(which zsh)
echo "Ready."

# OhMyZsh
echo "OhMyZsh... ###########################################################################################################################################################"
yes | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -rf ~/.zshrc && wget -O ~/.zshrc https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.zshrc
echo "Ready."

# Tools
echo "Tools... #############################################################################################################################################################"
npm install -g vtop
sudo apt install neofetch
echo "Ready."

# Allows to remove apps from automatic start
echo "This allows to remove apps from automatic start... ###################################################################################################################"
cd ~
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
echo "Ready."

# SSH keys
echo "Generate SSH Keys... #################################################################################################################################################"
echo -e "\n\n\n" | ssh-keygen -t rsa
echo "Ready."

# TRIM SSD
echo "TRIM SSD... ##########################################################################################################################################################"
sudo fstrim -v /
sudo wget -O /etc/cron.daily/TRIM_ssd https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/TRIM_ssd
sudo chmod +x /etc/cron.daily/TRIM_ssd
echo "Ready."

echo "Wanna check if everything is working? You may need to interact with terminal (just close and stop stuff if needed)."
read -p "Yes will check. No will finish setup. (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# Checking results
	echo "Checking results... ##################################################################################################################################################"
	echo "Git:"
	git config --list
 	echo "Your public SSH key (~/.ssh/id_rsa.pub):"
	cat ~/.ssh/id_rsa.pub
	echo "Share it with the services you want. BE CAREFUL!"
	echo "NVM:"
	nvm
	echo "Node:"
	node -v
	echo "Npm:"
	npm -v
	echo "Yarn:"
	yarn -v
	echo "RVM:"
	rvm
	echo "Ruby:"
	ruby -v
	echo "Rails:"
	rails -v
	echo "Java:"
	java -version

	sudo systemctl start postgresql.service && sudo systemctl start redis-server.service && sudo systemctl start elasticsearch.service

	echo "Elasticsearch:"
	curl -XGET 'localhost:9200'

	echo "Postgres:"
  PGPASSWORD=${postgresql_password} psql -U postgres -c "\du"

	echo "Redis:"
  echo "ping..."
  redis-cli -c "ping"

	sudo systemctl stop postgresql.service && systemctl stop redis-server.service && systemctl stop elasticsearch.service

  echo "Neofetch:"
  neofetch
  echo "Vtop:"
  echo "There's no way to test here. Just type vtop in another terminal."

	echo "Ready."

	echo "Finished!"
	read -p "Press Enter to finish it. The computer will reboot now!"
elif [[ $REPLY =~ ^[Nn]$ ]]
then
	echo "Finished!"
	read -p "Press Enter to finish it. The computer will reboot now!"
else
	echo "Finished!"
	read -p "Press Enter to finish it. The computer will reboot now!"
fi

sudo reboot
