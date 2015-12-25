#!/bin/sh

# bin/create_key.sh INTERMEDATE_CA CLIENT_NAME [server_cert|usr_cert]

# Get the name of the intermediate
if [ "$#" -ne 3 ]; then
	echo "You must provide:"
	echo "Intermediate_CA"
	echo "'Common_Name'"
	echo "[server_cert|usr_cert]"

	exit
fi

INTERMEDIATE_NAME=$1
DIR=./intermediates/$INTERMEDIATE_NAME
NAME=$2
TYPE=$3

# Look to see if the CSR exists.  If not, then gen a private key and CSR
if [ ! -f $DIR/csr/$NAME.csr.pem ]; then

	# If the key exists, then this is an error
	if [ -f $DIR/private/$NAME.key.pem ]; then
		echo "Private key exists but CSR dos not.  You need to either create the CSR or delete the key."
		exit
	fi

	# Create the key
	openssl genrsa -aes256 -out $DIR/private/$NAME.key.pem 2048

	# Protect it
	chmod 400 $DIR/private/$NAME.key.pem

	# Now create a Certificate and CSR for this key
	openssl req -config $DIR/openssl.cnf \
		-key $DIR/private/$NAME.key.pem \
		-new -sha256 -out $DIR/csr/$NAME.csr.pem

	# Protect it
	chmod 400 $DIR/csr/$NAME.csr.pem

fi

# Sign the certificate
openssl ca -config $DIR/openssl.cnf \
      -extensions $TYPE -days 9995 -notext -md sha256 \
      -in $DIR/csr/$NAME.csr.pem \
      -out $DIR/certs/$NAME.cert.pem

# protect it
chmod 444 $DIR/certs/$NAME.cert.pem

# Review the certificate
openssl x509 -noout -text \
      -in $DIR/certs/$NAME.cert.pem

#Verify trust
openssl verify -CAfile $DIR/certs/ca-chain.cert.pem \
      $DIR/certs/$NAME.cert.pem


