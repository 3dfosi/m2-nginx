#!/bin/bash

VERSION="v0.01"

POSITIONAL=()

if [[ "$#" -lt "2" || "$#" -gt "2" ]] || [[ "$1" != "-d" && "$1" != "-h" ]]; then
    echo -e '\nSomething is missing... Type "./gencert.sh -h" without the quotes to find out more...\n'
    exit 0
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d|--domain)
    HOST="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    echo -e "\nGenCert $VERSION\n\nOPTIONS:\n\n-d, --domain: Host Name\n-h, --help: Help\n\nEXAMPLE:\n\n./gencert.sh -h magento.3df.io\n"
    exit 0
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


openssl req -newkey rsa:2048 -nodes -keyout $HOST.key -subj "/CN=$HOST" -x509 -days 365 -out $HOST.crt
openssl x509 -text -noout -in $HOST.crt
openssl pkcs12 -inkey $HOST.key -in $HOST.crt -export -out $HOST.p12
openssl pkcs12 -in $HOST.p12 -noout -info
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -out ca.crt
openssl dhparam -out dhparams.pem 4096
