## EvDev

My own configuration to run VSCode on the cloud for browser-based coding.

For the original EvDev which features EverVim and SpaceMacs, please see the [terminal](https://github.com/LER0ever/EvDev/tree/terminal) branch


## Usage
```bash
docker run -p 127.0.0.1:8443:8443 -v "${PWD}:/project" ler0ever/evdev code-server --allow-http --no-auth
```

## Features
#### Sync with VSCode Settings Sync
Directly download VSCode configurations and extension lists from SettingsSync gist.

#### Official VSCode Extension Market
Microsoft VSCode binary is used to install all the extensions before copying to code-server for final use, so they are up-to-date and official. 

#### Dev Tools Included out of the box
Comes with Golang, C++, Nodejs, Python and Rust toolings pre-installed and ready to use.


## License
Credits goes to [code-server](https://github.com/codercom/code-server) project.  
Code for this configuration is licensed under Apache 2.0, detailed in [LICENSE.md](LICENSE.md)

