
To generate a CSR with mutliple subjectAltName DNS entries.  This will make this certificate valid for multiple domains.

openssl genrsa -aes256 -out private/mqtt.sneaky.net.key.pem
openssl req -config mqtt.sneaky.net.cnf -new -key mqtt.sneaky.net.key.pem -sha256 -nodes -out mqtt.sneaky.net.csr.pem
