#!/bin/bash

# Prompt the user to enter the Common Name
read -p "Enter the Common Name: " CommonName

# Get the current date and time
current_date_time=$(date +%Y-%m-%d_$CommonName)

# Create a folder with the current date and time
folder_name="$current_date_time"
mkdir "$folder_name"

# Generate CA key and certificate
openssl genrsa 2048 > "$folder_name/ca-key.pem"
openssl req -new -x509 -nodes -days 3650 -key "$folder_name/ca-key.pem" > "$folder_name/ca-cert.pem" -subj "/C=XX/ST=StateName/L=CityName/O=Omro/OU=OmroCompany/CN=$CommonName"

# Generate server key and certificate signing request
openssl req -newkey rsa:2048 -days 3650 -nodes -keyout "$folder_name/server-key.pem" > "$folder_name/server-req.pem" -subj "/C=XX/ST=StateName/L=CityName/O=Omro/OU=OmroCompany/CN=$CommonName"

# Generate server certificate signed by CA
openssl x509 -req -in "$folder_name/server-req.pem" -days 3650 -CA "$folder_name/ca-cert.pem" -CAkey "$folder_name/ca-key.pem" -set_serial 01 > "$folder_name/server-cert.pem"

# Generate client key and certificate signing request
openssl req -newkey rsa:2048 -days 3650 -nodes -keyout "$folder_name/client-key.pem" > "$folder_name/client-req.pem" -subj "/C=XX/ST=StateName/L=CityName/O=Omro/OU=OmroCompany/CN=$CommonName"

# Generate client certificate signed by CA
openssl x509 -req -in "$folder_name/client-req.pem" -days 3650 -CA "$folder_name/ca-cert.pem" -CAkey "$folder_name/ca-key.pem" -set_serial 01 > "$folder_name/client-cert.pem"

# Verify the certificates using the CA
openssl verify -CAfile "$folder_name/ca-cert.pem" "$folder_name/server-cert.pem" "$folder_name/client-cert.pem"
