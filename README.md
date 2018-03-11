## EvDev
LER0ever's Personal Dockerized Development Environment

## Awesomeness included
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
- Spacemacs (on latest emacs)
- FRP

## Usage
#### Build
```
# docker version
./build-evdev
cp evdev /usr/local/bin
```

#### Use
```
cd your-workspace
evdev
# Enjoy
```

## License
EvDev is licensed under the term of **Apache 2.0**  
`gitconfig`, `bin`, and `xterm-256color` are from [peterdemartini/pdev](https://github.com/peterdemartini/pdev)