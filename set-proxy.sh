#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Set proxy settings
read -p "Enter proxy server address: " proxy_server
read -p "Enter proxy server port: " proxy_port

# Set environment variables
export http_proxy="http://$proxy_server:$proxy_port"
export https_proxy="http://$proxy_server:$proxy_port"

# Set proxy settings for system update manager (apt)
if command -v apt-get &> /dev/null; then
  cat > /etc/apt/apt.conf.d/95proxies <<EOL
Acquire::http::Proxy "http://$proxy_server:$proxy_port";
Acquire::https::Proxy "http://$proxy_server:$proxy_port";
EOL
fi

# Set proxy settings for npm
if command -v npm &> /dev/null; then
  npm config set proxy "http://$proxy_server:$proxy_port"
  npm config set https-proxy "http://$proxy_server:$proxy_port"
fi

# Set proxy settings for network (systemd-resolved)
if command -v systemctl &> /dev/null; then
  if [ -f /etc/systemd/resolved.conf ]; then
    sed -i "s/^#?DNS=.*/DNS=$proxy_server/" /etc/systemd/resolved.conf
    sed -i "s/^#?DNSStubListener=.*/DNSStubListener=no/" /etc/systemd/resolved.conf
    systemctl restart systemd-resolved
  fi
fi

# Set proxy settings for node
if command -v node &> /dev/null; then
  node -e "console.log(process.execPath)" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    NODE_PATH=$(node -e "console.log(require.resolve('npm'))" 2> /dev/null)
    if [ -n "$NODE_PATH" ]; then
      sed -i "s#^proxy=.*#proxy=http://$proxy_server:$proxy_port#" $NODE_PATH/npmrc
      sed -i "s#^https-proxy=.*#https-proxy=http://$proxy_server:$proxy_port#" $NODE_PATH/npmrc
    fi
  fi
fi

echo "Proxy settings set successfully"
