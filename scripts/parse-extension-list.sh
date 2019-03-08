#!/bin/bash

jq -r ".[].metadata.publisherId" ../extensions.json > ../extensions.list

