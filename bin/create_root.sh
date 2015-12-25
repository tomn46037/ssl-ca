#!/bin/sh

# Prepare the directory structure
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

# Create the root key
openssl genrsa -aes256 -out private/ca.key.pem 4096

# Protect the root key
chmod 400 private/ca.key.pem

# Create the root certificate
openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem

# Protect it
chmod 444 certs/ca.cert.pem

# Review the root certificate
openssl x509 -noout -text -in certs/ca.cert.pem

