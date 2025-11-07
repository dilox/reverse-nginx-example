#!/bin/bash
set -e

# Directory to store certs
CERT_DIR="./certs"
DOMAIN="example-nginx-reverse.app"

mkdir -p "$CERT_DIR"

# Generate a self-signed certificate
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$CERT_DIR/privkey.pem" \
  -out "$CERT_DIR/cert.pem" \
  -subj "/CN=$DOMAIN"

echo "Self-signed certificate and key generated in $CERT_DIR/"
echo "Certificate: $CERT_DIR/cert.pem"
echo "Key: $CERT_DIR/privkey.pem"
