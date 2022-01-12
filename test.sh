touch /tmp/test123.txt
apt update && sudo apt -y install apache2
echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/htm
l/index.html
# if port needs to be changed 
#nano /etc/apache2/ports.conf 