#!/bin/bash

# Get the name of the intermediate
if [ "$#" -eq 0 ]; then
	echo "You must provide the name of the Intermedaite"
	exit
fi

INTERMEDIATE_NAME=$1
DIR=./intermediates/$INTERMEDIATE_NAME

if [ -e $DIR ]; then
	echo "Directory $DIR already exists."
	exit
fi

# Create the intermedate directory and descend
mkdir -p $DIR
pushd $DIR

# Do the setup in there..
mkdir certs crl csr newcerts private bin
chmod 700 private
touch index.txt
echo 1000 > serial

# Return
popd

# Set a number for the CRL
echo 1000 > $DIR/crlnumber

# Copy the template down and set the directory
cat openssl-intermedate-template.cnf | sed s^__DIR__^${DIR}^ | sed s^__INTERMEDIATE_NAME__^$INTERMEDIATE_NAME^ > $DIR/openssl.cnf

# Create the Intermdiate key
openssl genrsa -aes256 -out $DIR/private/$INTERMEDIATE_NAME.key.pem 4096

# Protect it
chmod 400 $DIR/private/$INTERMEDIATE_NAME.key.pem

# Create the Intermediate Certificate Siging Request
openssl req -config $DIR/openssl.cnf -new -sha256 -key $DIR/private/$INTERMEDIATE_NAME.key.pem -out $DIR/csr/$INTERMEDIATE_NAME.csr.pem

# Create the Intermedate Certificate 
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
	-days 3650 -notext -md sha256 \
	-in $DIR/csr/$INTERMEDIATE_NAME.csr.pem \
	-out $DIR/certs/$INTERMEDIATE_NAME.cert.pem

# Protect it
chmod 444 $DIR/certs/$INTERMEDIATE_NAME.cert.pem

# Review it
openssl x509 -noout -text \
      -in $DIR/certs/$INTERMEDIATE_NAME.cert.pem

# Verify trust
openssl verify -CAfile certs/ca.cert.pem \
      $DIR/certs/$INTERMEDIATE_NAME.cert.pem

# Create the chain file
cat $DIR/certs/$INTERMEDIATE_NAME.cert.pem \
      certs/ca.cert.pem > $DIR/certs/ca-chain.cert.pem

# Protect it
chmod 444 $DIR/certs/ca-chain.cert.pem

# Create a blank CRL
openssl ca -config $DIR/openssl.cnf \
      -gencrl -out $DIR/crl/$INTERMEDIATE_NAME.crl.pem


