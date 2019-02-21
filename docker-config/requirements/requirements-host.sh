sudo apt-get update
sudo apt-get install curl git
echo -e "\e[33mInstallling Docker...\e[0m"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
echo -e "\e[32mDone\n\e[0m"
echo -e "\e[33mRun docker without sudo...\e[0m"
sudo usermod -aG docker ${USER}
echo -e "\e[32mDone\n\e[0m"
echo -e "\e[33mCreating docker swam cluster (https://docs.docker.com/engine/swarm/)...\e[0m"
docker swarm init
echo -e "\e[32mDone\n\e[0m"
echo -e "\e[31mPlease, exit ssh session and reenter to get the changes to take effect\e[0m"
echo -e "\e[33mInstalling Docker compose...\e[0m"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo -e "\e[32mDone\n\e[0m"
echo -e "\e[33mAdding docker compose to path...\e[0m"
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
echo -e "\e[32mDone\n\e[0m"
