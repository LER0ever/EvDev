## EvDev
LER0ever's Personal Dockerized Development Environment

## Awesomeness included
- Alpine Edge
- Full-Featured EverVim (with all of supported languages) running on latest Neovim
- Preconfigured Tmux and Zsh
- Toolchains for
    - C (clang, lldb, gcc, gdb)
    - Golang
    - Rust (Cargo, Rustc, Racer)
    - Nodejs (Tern, Typescript)
    - Ruby (Rails)
    - Python 2/3
    - C# Mono
    - Lua(jit)
- Full-Featured Spacemacs (on latest emacs)
- FRP

![](https://i.imgur.com/S0sclRg.png)

## Usage
#### Build
```
# docker version
docker pull ler0ever/evdev
# put evdev into /usr/local/bin
```

#### Use
```
cd your-workspace
evdev
# Enjoy
```

#### Create derivatives
Make sure you changed all the personal info before put this into production, for example:

```dockerfile
FROM ler0ever/evdev:latest
MAINTAINER Your Name <you@riseup.net>

# Rename evdev
RUN usermod -m -l your_user_name -d /home/your_user_name everette

# Add packages
RUN apk add --update-cache \
    fish

# Override dotfiles
COPY vim/EverVim.vimrc $HOME/.EverVim.vimrc

# ...
```

## [Docker Hub](https://hub.docker.com/r/ler0ever/evdev/)
The image is built daily using cronjob, and automatically pushed to DockerHub: [LER0ever/EvDev](https://hub.docker.com/r/ler0ever/evdev/), available to everyone.

![](https://i.imgur.com/V5PVnX4.png)

## License
EvDev is licensed under the term of **Apache 2.0**  
`gitconfig`, `bin`, and `xterm-256color` are from [peterdemartini/pdev](https://github.com/peterdemartini/pdev)
