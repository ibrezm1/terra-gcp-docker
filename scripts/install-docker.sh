# Remove anything which may clash with Docker
apt-get remove -y docker docker-engine docker.io containerd runc
apt-get update



# Add dependant libraries
apt-get install -y apt-transport-https ca-certificates curl software-properties-common wget htop


apt update
apt install --yes apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

sudo apt-get update
apt update
apt install --yes docker-ce
