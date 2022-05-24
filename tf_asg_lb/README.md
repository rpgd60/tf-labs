



Sample bash script to exercise the ALB

export ALBURL=$(terraform output -json | jq -r .alb_url.value)
echo URL: $ALBURL
while true;  do curl -s -o /dev/null -w "%{url_effective}, %{response_code}, %{time_total}\n" $ALBURL ; done


KEY_NAME=$(terraform output  -json | jq -r .key_name.value)
PUB_IP=$(terraform output  -json | jq -r .public_ip.value)
echo "connecting to: $PUB_IP"
echo "with key $KEY_NAME"
ssh -i ~/.ssh/$KEY_NAME.pem ec2-user@$PUB_IP