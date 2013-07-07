#bin/bash

gem install bundler --no-ri --no-rdoc

adduser --disabled-login --gecos 'GitLab' git

su git

# Go to home directory
cd /home/git

# Clone gitlab shell
git clone https://github.com/gitlabhq/gitlab-shell.git

cd gitlab-shell

# switch to right version
git checkout v1.4.0

cp config.yml.example config.yml

# Edit config and replace gitlab_url
# with something like 'http://domain.com/'
# overwrite the right config with puppet later
#-u git -H vim config.yml

# Do setup
./bin/install

# install gitlab into git home
cd /home/git

# Clone GitLab repository
git clone https://github.com/gitlabhq/gitlabhq.git gitlab

# Go to gitlab dir
cd /home/git/gitlab

# Checkout to stable release
git checkout 5-3-stable


# Copy the example GitLab config
cp config/gitlab.yml.example config/gitlab.yml

# Make sure to change "localhost" to the fully-qualified domain name of your
# host serving GitLab where necessary
# do it later with puppet
#sudo -u git -H vim config/gitlab.yml

# Make sure GitLab can write to the log/ and tmp/ directories
chown -R git log/
chown -R git tmp/
chmod -R u+rwX  log/
chmod -R u+rwX  tmp/

# Create directory for satellites
mkdir /home/git/gitlab-satellites

# Make config/database.yml readable to git only
# do with puppet later
chmod o-rwx config/database.yml

# Create directories for sockets/pids and make sure GitLab can write to them
mkdir tmp/pids/
mkdir tmp/sockets/
chmod -R u+rwX  tmp/pids/
chmod -R u+rwX  tmp/sockets/

# Create public/uploads directory otherwise backup will fail
mkdir public/uploads
chmod -R u+rwX  public/uploads

# Copy the example Puma config
cp config/puma.rb.example config/puma.rb

# Enable cluster mode if you expect to have a high load instance
# Ex. change amount of workers to 3 for 2GB RAM server
# do with puppet
#vim config/puma.rb

# Configure Git global settings for git user, useful when editing via web
# Edit user.email according to what is set in gitlab.yml
git config --global user.name "GitLab"
git config --global user.email "gitlab@localhost"