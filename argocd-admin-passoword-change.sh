#!/usr/bin/env bash

cluster_name=$1
region=$2

# encrypt password by using bcrypt-cli and then encode by base64
function password_encyption() {
    echo -n "Please enter the password which would like to keep as admin password:: ";
    read -s pass

# perform bcrypt hash task by running docker container

    git clone https://github.com/bitnami/bcrypt-cli.git
    sudo docker build -t bcrypt bcrypt-cli/.
    BCRYPT_HASH=$(echo -n "$pass" |sudo docker run --rm -i bcrypt)
      
# redirecting argocd secret in a file

    kubectl get secrets argocd-secret -n argocd -o yaml >argocd-secret-v1.yaml

# encoding bcrypt hash encrypted value in base64
      
    BASE64_ENCODE=$(echo -n $BCRYPT_HASH | base64)

}
      
function update_secret() {

# formatting base64 value

    BASE64_NEW=$(echo $BASE64_ENCODE | tr -d ' ')
      
# fetching existing base64 value

    BASE64_OLD=$(cat argocd-secret-v1.yaml | head -n 3|grep -w admin.password|awk -F ' ' '{print $2}')
    sed -i "s/$BASE64_OLD/$BASE64_NEW/g" argocd-secret-v1.yaml
}

function connect_to_cluster() {
    password_encyption
    update_secret
    aws eks update-kubeconfig --name $cluster_name --region $region
    kubectl apply -f argocd-secret-v1.yaml
    echo "<<::::password has been changed::::>>"
}
connect_to_cluster
rm -rf bcrypt-cli
