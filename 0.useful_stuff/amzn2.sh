KEY_NAME=$(terraform output  -json | jq -r .key_name.value)
PUB_IP=$(terraform output  -json | jq -r .public_ip.value)
echo "with key $KEY_NAME"
echo "connecting to: $PUB_IP"
ssh -i ~/.ssh/$KEY_NAME.pem ec2-user@$PUB_IP
