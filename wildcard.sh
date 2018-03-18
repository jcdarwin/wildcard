#!/usr/bin/env bash

# As per https://gist.github.com/mfdj/8277918
if [ -z "$1" ]; then
  echo -n 'Enter root domain (no www): '
  read input_d
  DOMAIN=$input_d
else
  DOMAIN=$1
fi

[ -d certs ] || mkdir certs

# Easiest to generate conf file for each
# certificate creation process
OpenSSLConf="$DOMAIN"-openssl.cnf

cat >"$OpenSSLConf" <<EOL
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = *.$DOMAIN

[v3_req]
keyUsage = keyEncipherment, dataEncipherment, nonRepudiation, digitalSignature
basicConstraints = CA:FALSE
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOL

# Create Private RSA Key
openssl genrsa -out "certs/$DOMAIN".key 1024

# Create Certifcate Signing Request
openssl req -new -key "certs/$DOMAIN".key -out "certs/$DOMAIN".csr -config "$OpenSSLConf"

# Create Certifcate
openssl x509 -req -days 3650 -in "certs/$DOMAIN".csr \
-signkey "certs/$DOMAIN".key -out "certs/$DOMAIN".crt \
-extensions v3_req \
-extfile "$OpenSSLConf"

# Nix the configfile
rm -- "$OpenSSLConf"

echo "Private key, CSR, and Cert created for ${DOMAIN} in ./certs"
