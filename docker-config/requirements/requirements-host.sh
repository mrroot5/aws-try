sudo apt-get update
sudo apt-get install curl git
echo -e "Installling Docker...\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
echo -e "Run docker without sudo...\n"
sudo usermod -aG docker ${USER}
echo -e "Creating docker swam cluster (https://docs.docker.com/engine/swarm/)...\n"
docker swarm init
echo -e "Please, exit ssh session and reenter to get the changes to take effect"
echo -e "Installing Docker compose...\n"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo -e "Adding docker compose to path...\n"
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
