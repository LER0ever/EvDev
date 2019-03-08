#!/bin/bash

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get update && apt-get -y install openjdk-8-jdk