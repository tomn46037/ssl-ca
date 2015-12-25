#!/bin/sh

# bin/create_key.sh INTERMEDATE_CA CLIENT_NAME

# Get the name of the intermediate
if [ "$#" -eq 0 ]; then
	echo "You must provide the 'Common Name'"

	exit
fi

INTERMEDIATE_NAME=$1
DIR=./intermediates/$INTERMEDIATE_NAME
NAME=$2

# Look to see if the CSR exists.  If not, then gen a private key and CSR
if [ ! -f $DIR/certs/$NAME.cert.pem ]; then

	echo "Certificate does not exist."
	exit

fi

# Revoke the certificate
openssl ca -config $DIR/openssl.cnf \
      -revoke $DIR/certs/$NAME.cert.pem

# Recrate the CRL
openssl ca -config $DIR/openssl.cnf \
      -gencrl -out $DIR/crl/$INTERMEDIATE_NAME.crl.pem


