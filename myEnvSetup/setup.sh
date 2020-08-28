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
node_version='12.16.0'
elasticsearch_version='7.x'
postgresql_version='10'
postgresql_password=''
echo "Ready."

# Update and upgrade
echo "Updating repositories... #############################################################################################################################################"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "Ready."

# Other stuff
echo "Other Stuff... #######################################################################################################################################################"
sudo apt-get install -y build-essential automake autoconf bison libssl-dev libyaml-dev libreadline-dev libxslt-dev libtool unixodbc-dev unzip zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev
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

# Chrome
echo "Installing Chrome... #################################################################################################################################################"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
echo "Ready."

# Zsh
echo "Zsh... ###############################################################################################################################################################"
cd ~
sudo apt-get install fonts-powerline -y
sudo apt-get install zsh -y
chsh -s $(which zsh)
sed -i 's/bash/zsh/g' /etc/passwd
echo "Ready."

# OhMyZsh
echo "OhMyZsh... ###########################################################################################################################################################"
yes | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -rf ~/.zshrc && wget -O ~/.zshrc https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.zshrc
echo "Ready."

# Java
echo "Java... ##############################################################################################################################################################"
sudo apt-get install ${java_version} -y
echo "Ready."

# VirtualBox
echo "VirtualBox... ########################################################################################################################################################"
sudo apt-get install virtualbox virtualbox-ext-pack -y
echo "Ready."

# ASDF
echo "ASDF... ##############################################################################################################################################################"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
source ~/.zshrc
asdf --version
sudo chown -R $USER ~/.asdf/
sudo chown -R $USER:$(id -gn $USER) /home/edddjunior/.config
echo "Ready."

# Node.js
echo "Node... ##############################################################################################################################################################"
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs ${node_version}
asdf global nodejs ${node_version}
echo "Ready."

# React
echo "React... #############################################################################################################################################################"
npm install -g create-react-app

# Yarn
echo "Yarn... ##############################################################################################################################################################"
npm install --global yarn
echo "Ready."

# Ruby
echo "Ruby... ##############################################################################################################################################################"
asdf plugin-add ruby
asdf install ruby ${ruby_version}
asdf global ruby ${ruby_version}
echo "Ready."

# Rails
echo "Rails... #############################################################################################################################################################"
sudo apt-get install sqlite3 libsqlite3-dev
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
sudo apt-get install rake
sudo curl -L https://bit.ly/janus-bootstrap | bash
cd ~/.vim/janus/vim/tools/

# General Plugins (very useful)
git clone https://github.com/mattn/emmet-vim.git
git clone https://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/yggdroot/indentline.git
git clone https://github.com/dyng/ctrlsf.vim.git
git clone https://github.com/rking/ag.vim.git
git clone https://github.com/kien/ctrlp.vim.git

cd ~
wget -O ~/.vimrc.after https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.after
wget -O ~/.vimrc.before https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/.vimrc.before
echo "Ready."

# Tools
echo "Tools... #############################################################################################################################################################"
npm install -g vtop
sudo apt install synaptic -y
sudo apt-get install neofetch -y
sudo apt-get install imagemagick -y
sudo apt-get install net-tools -y
echo "Ready."

# Allows to remove apps from automatic start
echo "This allows to remove apps from automatic start... ###################################################################################################################"
cd ~
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
echo "Ready."

# SSH keys
echo "Generate SSH Keys... #################################################################################################################################################"
ssh-keygen -t rsa -b 4096 -C "${git_email}"
echo "Ready."

# TRIM SSD
echo "TRIM SSD... ##########################################################################################################################################################"
sudo fstrim -v /
sudo wget -O /etc/cron.daily/TRIM_ssd https://raw.githubusercontent.com/edddjunior/dotfiles/master/myEnvSetup/TRIM_ssd
sudo chmod +x /etc/cron.daily/TRIM_ssd
echo "Ready."

# Firewall and SSH server
echo "FIrewall and SSH server. #############################################################################################################################################"
sudo ufw enable
sudo apt-get install openssh-server -y
sudo ufw allow OpenSSH
sudo sed -i "s/#LoginGraceTime 2m/LoginGraceTime 30/g" /etc/ssh/sshd_config
sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo sed -i "s/#MaxSessions 10/MaxSessions 2/g" /etc/ssh/sshd_config
sudo sed -i "s/#@student        -       maxlogins       4/@edddjunior      -       maxlogins       2/g" /etc/security/limits.conf
sudo systemctl restart sshd.service
echo "Ready."

# MFA for SSH server
echo "Wanna setup Multi-Factor-Authentication for the SSH server? Pay attention."
read -p "Yes will setup MFA. No will continue installation setup. (y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Setting up 2fa for SSH server... ###################################################################################################################################"
  sudo apt-get install libpam-google-authenticator -y
  sudo sed -i "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config
  sudo su -c "echo -e '\n#Token authentication\nauth required pam_google_authenticator.so' >> /etc/pam.d/sshd"
  google-authenticator
  sudo systemctl restart sshd.service
  echo "Ready."
elif [[ $REPLY =~ ^[Nn]$ ]]
then
	read -p "Press Enter to finish it."
	echo "Finished!"
else
	read -p "Press Enter to finish it."
	echo "Finished!"
fi

# Checking results
echo "Wanna check if everything is working? You may need to interact with terminal (just close and stop stuff if needed)."
read -p "Yes will check. No will finish setup. (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Checking results... ################################################################################################################################################"
	echo "Git:"
	git config --list
 	echo "Your public SSH key (~/.ssh/id_ed25519.pub):"
	cat ~/.ssh/id_ed25519.pub
	echo "Share it with the services you want. BE CAREFUL!"
	echo "Java:"
	java -version
	echo "VirtualBox:"
	vboxmanage --version
	echo "ASDF:"
	asdf --version
	echo "Node:"
	node -v
	echo "Npm:"
	npm -v
	echo "Yarn:"
	yarn -v
	echo "Ruby:"
	ruby -v
	echo "Rails:"
	rails -v

	sudo systemctl start postgresql.service && sudo systemctl start redis-server.service && sudo systemctl start elasticsearch.service

	echo "Postgres:"
  PGPASSWORD=${postgresql_password} psql -U postgres -c "\du"

	echo "Redis:"
  echo "ping..."
  redis-cli -c "ping"

	echo "Elasticsearch:"
	curl -XGET 'localhost:9200'

	sudo systemctl stop postgresql.service && systemctl stop redis-server.service && systemctl stop elasticsearch.service

  echo "Neofetch:"
  neofetch
  echo "Vtop:"
  echo "There's no way to test here. Just type vtop in another terminal."

  echo "Firewall:"
  sudo ufw status numbered

	echo "Ready."

	echo "Finished!"
	read -p "Press Enter to finish it. The computer will reboot now!"
elif [[ $REPLY =~ ^[Nn]$ ]]
then
	read -p "Press Enter to finish it. The computer will reboot now!"
	echo "Finished!"
else
	read -p "Press Enter to finish it. The computer will reboot now!"
	echo "Finished!"
fi

sudo reboot
