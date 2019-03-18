#!/bin/bash

# Install Node.js
curl -sL https://deb.nodesource.com/setup_11.x | bash -

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt-get update && apt-get install -y yarn nodejs