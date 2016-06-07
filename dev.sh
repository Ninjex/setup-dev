#!/bin/bash

mv ../setup-dev ~/
cd ~/
mkdir dev-area
cd dev-area

echo "Attempting to clone the repository."
git clone git@libroot.com:libroot.git

cd libroot

echo "Attempting to update Composer."
sudo composer self-update

echo "Attempting to install composer"
composer install

cd www
cp .env.example .env

echo "Getting APP_KEY"
rm_key=$(cat .env | grep 'APP_KEY')
app_key=$(cat .env.example | grep 'APP_KEY')
echo "Replacing $rm_key with $app_key"
sed -i "s/$rm_key/$app_key/g" .env

cd ../../
echo "Adding the Vagrant Box."
vagrant box add laravel/homestead

echo "Cloning Homestead."
git clone https://github.com/laravel/homestead.git Homestead

cd Homestead
echo "Attempting Homestead initialization."
bash init.sh

echo "Populating ~/.homestead/Homestead.yaml with correct settings."
cp ~/setup-dev/homestead.example ~/.homestead/Homestead.yaml

echo "Attempting to add libroot.app to /etc/hosts"
sudo sh -c "echo '192.168.10.10 libroot.app' >> /etc/hosts"

echo "Attemping to run Vagrant!"
vagrant up

echo "Test the instance!"
xdg-open http://libroot.app

echo "Register with the Phabricator instance."
xdg-open http://git.libroot.com/auth/register/
