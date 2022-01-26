sudo apt-get install cf-cli

# Download Docker Compose, move it to usr bin and make executable
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version



# Download the Concourse Compose yaml and rename to a file which Compose with recognize
cd /tmp
wget -O docker-compose.yml https://concourse-ci.org/docker-compose.yml

# Sets the external URL to be the IP address of the machine
ipaddr=$(wget -O - -q https://icanhazip.com/)
sed -i "s/localhost/$ipaddr/g" docker-compose.yml
docker-compose up -d


docker ps
echo -e "\n"
cat docker-compose.yml |grep EXTERNAL_URL | sed -e 's/^[[:space:]]*- //'
echo "Waiting 30 seconds for Concourse to start"
sleep 30 # wait for the container to start. Can tune down if needed.

# Download and install the fly cli
wget -O /tmp/fly "http://$ipaddr:8080/api/v1/cli?arch=amd64&platform=linux"
mkdir -p /usr/local/bin
mv /tmp/fly /usr/local/bin
chmod 0755 /usr/local/bin/fly
sudo ln -s /usr/local/bin/fly /usr/bin/fly
git clone https://github.com/starkandwayne/concourse-tutorial.git

git clone https://github.com/ibrezm1/cf-HelloWorld.git
sudo chown -R user ./cf-HelloWorld/
sudo chown -R user ./concourse-tutorial/


# Fly login, create target main and display targets
exec sudo -u user /bin/sh - << eof
ipaddr=$(wget -O - -q https://icanhazip.com/)
fly --target main login --concourse-url http://$ipaddr:8080 -u test -p test
fly --target tutorial login --concourse-url http://$ipaddr:8080 -u test -p test
fly targets
touch completed.txt
eof

