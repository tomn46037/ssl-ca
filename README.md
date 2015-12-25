# Overview

These scripts are my attempt to not have to remember how to do this every time I try to create certs.  

The goal of this is to create the root certificate authority.  Then create multiple intermediate certificate authroities under that.  These would then be used for different purpouses.  For example, you may have an intermediate to sign web server certificates.  You may have a second intermediate CA to sign the users that log into those servers.

They support revoking certificates.  For instance, you would use this to revoke a certificate issued to a user to log into your server.

There is also support files for generating CSRs will multiple subjectAltName entries in the manual-cert-generation/readme.txt file.  You can use this to make a certificate that is valid for mutliple DNS names.

They are bascially taken directly from

https://jamielinux.com/docs/openssl-certificate-authority/index.html

That was a simple walk thorugh of how to creat your own SSL CA.  Go read 
that as you work your way thorugh these scripts.

# Installation and Use

You shoud clone this into a specific directory based on the name of your root CA.

1. Download the repo: `git clone git@github.com:tomn46037/ssl-ca.git NAME_OF_ROOT_CA`
2. Review the openssl.cnf and openssl-intermediate-template.cnf files for their default certificate values
2. Create the root ca: `bin/create_root.sh`
3. Create at least one intermedaite certificate authority: `bin/create_intermedates.sh ServerIntermediate`
4. Create your first certificate:  `bin/create_certificate.sh ServerIntermediate test usr_cert`

You can create your own key and csr then copy that into the intermedaite/NAME/csr directory then just run step 3.  If you run step four without a CSR, it will create a key for you in the intermedaite/NAME/private directoy.

You can revoke certificates with: `bin/revoke_certificate.sh ServerIntermediate test-cert`  (It's left up to you to distribute that CRL.)

