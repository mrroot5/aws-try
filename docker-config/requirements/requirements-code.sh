echo "\e[33mMoving to opt...[0m"
cd /opt/
echo -e "\e[32mDone\n\e[0m"
echo "\e[33mCreating postgres folder...[0m"
sudo mkdir postgres_data_english_dictionary
echo -e "\e[32mDone\n\e[0m"
echo "\e[33mClonning repo...[0m"
sudo git clone git@github.com:mrroot5/english-dictionary.git
if [ -d english-dictionary ]
then
  cd english-dictionary
  sudo git checkout my-personal-dic
fi
echo -e "\e[32mDone\n\e[0m"
