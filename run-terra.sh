file=./test-key
if [ ! -e "$file" ]; then
    ssh-keygen -b 2048 -t rsa -f test-key -q -N ""
fi

export GOOGLE_APPLICATION_CREDENTIALS="/home/ibrez/Documents/keys/zeta-yen-319702-c936989d17fc.json"

terraform init
(($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }
terraform plan -out terraform.out
(($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }
terraform apply terraform.out
(($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }