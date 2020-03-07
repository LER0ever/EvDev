## EvDev

My own configuration to run VSCode on the cloud for browser-based coding.

For the original EvDev which features EverVim and SpaceMacs, please see the [terminal](https://github.com/LER0ever/EvDev/tree/terminal) branch


## Usage
#### If you want to use my configuration:
```bash
docker run -p 127.0.0.1:8443:8443 -v "${PWD}:/project" ler0ever/evdev code-server --allow-http --no-auth
```

#### If you have your own VSCode Settings Sync setup
- Fork this project
- Change `sync.gist` into your gist id "USERNAME/GISTID"
- `docker build . -tag WHATEVER`
- `docker run -p 127.0.0.1:8443:8443 -v "${PWD}:/project" WHATEVER code-server --allow-http --no-auth`

## Features
#### Sync with VSCode Settings Sync
- Directly download VSCode configurations and extension lists from SettingsSync gist.
- VSCode settings is directly used for code-server
- VSCode extensions are parsed and installed automatically from `extensions.json`

#### Official VSCode Extension Market
- Code-server uses their own extensions registry and it is pretty limited and outdated, at least for now.  
- Here, Microsoft VSCode binary is used to install all the extensions before copying to code-server for final use, so they are up-to-date and official. 

#### Dev Tools Included out of the box
- Comes with 
	- Golang
	- C++
	- Nodejs
	- Python
	- Rust

toolings pre-installed and ready to use.

## CI and Docker Hub
This docker image is built and pushed to Docker Hub [EvDev](https://cloud.docker.com/repository/docker/ler0ever/evdev/tags) everyday with [Travis](https://travis-ci.org/LER0ever/EvDev) Cron.

## License
Credit goes to the [code-server](https://github.com/codercom/code-server) project.  
Code for this configuration is licensed under Apache 2.0, detailed in [LICENSE.md](LICENSE.md)

