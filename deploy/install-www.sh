#!/usr/bin/env bash
set -eu

REMOTE_ROOT="/var/www/pinfold-www"
TAR="/tmp/pinfold-www.tar.gz"
NGINX_SRC="/tmp/pinfold-www.conf"
INSTALL_NGINX="${1:-0}"

mkdir -p "$REMOTE_ROOT"
find "$REMOTE_ROOT" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
tar -xzf "$TAR" -C "$REMOTE_ROOT"
chmod -R a+rX "$REMOTE_ROOT"
rm -f "$TAR"
echo "Site files deployed to $REMOTE_ROOT"

if [ "$INSTALL_NGINX" = "1" ]; then
  SSL_DIR="/etc/nginx/ssl"
  if [ -f "$SSL_DIR/pinfoldai-origin.crt" ]; then
    if ! openssl x509 -in "$SSL_DIR/pinfoldai-origin.crt" -noout -text 2>/dev/null | grep -q 'DNS:pinfoldai.com'; then
      echo "Regenerating origin cert with pinfoldai.com SAN..."
      mkdir -p "$SSL_DIR"
      openssl req -x509 -nodes -days 825 -newkey rsa:2048 \
        -keyout "$SSL_DIR/pinfoldai-origin.key" \
        -out "$SSL_DIR/pinfoldai-origin.crt" \
        -subj "/CN=pinfoldai.com" \
        -addext "subjectAltName=DNS:pinfoldai.com,DNS:www.pinfoldai.com,DNS:api.pinfoldai.com,DNS:admin.pinfoldai.com"
    fi
  fi

  cp "$NGINX_SRC" /etc/nginx/sites-available/pinfold-www.conf
  ln -sf /etc/nginx/sites-available/pinfold-www.conf /etc/nginx/sites-enabled/pinfold-www.conf
  nginx -t
  systemctl reload nginx
  echo "nginx reloaded with pinfold-www.conf"
fi
