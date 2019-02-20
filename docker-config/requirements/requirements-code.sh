echo "Moving to opt..."
cd /opt/
echo -e "Done\n"
echo "Creating postgres folder..."
sudo mkdir postgres_data_english_dictionary
echo -e "Done\n"
echo "Clonning repo..."
sudo git clone git@github.com:mrroot5/english-dictionary.git
cd english-dictionary
sudo git checkout my-personal-dic
echo -e "Done\n"
