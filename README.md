# Overview

These scripts are my attempt to not have to remember how to do this every time I try to create certs.  

They are bascially taken directly from

https://jamielinux.com/docs/openssl-certificate-authority/introduction.html

That was a simple walk thorugh of how to creat your own SSL CA.  Go read 
that as you work your way thorugh these scripts.

# Installation

1. Download the repo: `git clone git@github.com:tomn46037/ssl-ca.git`
2. Create the root ca: `bin/create_root.sh`
3. Create at least one intermedaite: `bin/create_intermedates.sh one`
4. Create your first certificate:  `bin/create_certificate.sh one test usr_cert`

You can create your own key and csr then copy that into the intermedaite/NAME/csrs directory then just run step 3.  If you run step three without a CSR, it will create a key for you.

