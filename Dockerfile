FROM alpine:edge
MAINTAINER evdev Rong (https://rongyi.blog)
ENV HOSTNAME EvDev-Container

# ENV DEBIAN_FRONTEND noninteractive
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

# User with temporary password
RUN adduser -s /bin/zsh -D evdev && \
    echo "root:33554432!" | chpasswd &&\
    echo "evdev:33554432!" | chpasswd && \
    echo "evdev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# base
RUN apk add --update-cache \
    linux-headers alpine-sdk build-base cmake

# utilities
RUN apk add --update-cache \
    bash zsh less tmux ncurses \
    the_silver_searcher p7zip \
    git htop neofetch shadow

# Python
RUN apk add --update-cache \
    python-dev python3-dev python3

# thefuck
RUN pip3 install thefuck

# Go
RUN apk add --update-cache \
    go

# Nodejs
RUN apk add --update-cache \
    nodejs yarn nodejs-npm \
    && npm i -g typescript \
    && npm i -g tern

# C/C++
RUN apk add --update-cache \
    clang clang-dev ctags

# Rust
RUN apk add --update-cache \
    rust rust-src cargo

# Csharp
ENV NUGET_VERSION 4.6.0
RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache --virtual=.build-dependencies ca-certificates && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies && \
    wget -P /usr/lib/mono https://dist.nuget.org/win-x86-commandline/v${NUGET_VERSION}/nuget.exe && \
    echo -e '#!/bin/sh\nexec /usr/bin/mono $MONO_OPTIONS /usr/lib/mono/nuget.exe "$@"' > /usr/bin/nuget && \
    chmod a+x /usr/bin/nuget

# Ruby
RUN apk add --update-cache \
    ruby ruby-dev ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    && echo 'gem: --no-document' > /etc/gemrc

# Lua
RUN apk add --update-cache \
    lua5.3-dev lua-sec luajit

# Editors
RUN apk add --update-cache \
    libtermkey neovim neovim-doc emacs \
    && pip3 install neovim \
    && gem install neovim

# FRP
ENV FRP_VERSION 0.15.1
RUN set -ex \
    && apk add --update-cache \
    openssh-server \
    && cd /tmp \
    && wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && rm frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && cd frp_${FRP_VERSION}_linux_amd64 \
    && cp frps /usr/local/bin \
    && cp frpc /usr/local/bin \
    && mkdir /etc/frp \
    && cp frps.ini /etc/frp \
    && cp frpc.ini /etc/frp \
    && cd .. \
    && rm -rf frp_${FRP_VERSION}_linux_amd64
COPY frp/frpc.ini /etc/frp/

# Clean the cache
RUN rm -rf /var/cache/apk/*

ENV SHELL /bin/zsh

COPY bin /usr/local/bin

RUN chmod -R 777 /usr/local

# ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
ENV HOME /home/evdev
ENV XDG_CONFIG_HOME  $HOME/.config
RUN chown -R evdev:evdev $HOME
USER evdev

# git
COPY git/gitconfig $HOME/.gitconfig
COPY git/gitignore_global $HOME/.gitignore_global

# EverVim
COPY vim/EverVim.vimrc $HOME/.EverVim.vimrc
RUN curl -sLf https://raw.githubusercontent.com/LER0ever/EverVim/master/Boot-EverVim.sh | bash \
  && echo -e "Installing EverVim Distribution ..." \
  && sudo chown evdev:evdev $HOME/.EverVim.vimrc \
  && nvim --headless +PlugInstall +qa &> /dev/null
RUN cd $HOME/.EverVim/bundle/YouCompleteMe \
    && python3 install.py --clang-completer --system-libclang --go-completer --rust-completer --js-completer --cs-completer

# Spacemacs
COPY emacs/spacemacs $HOME/.spacemacs
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d \
  && sudo chown evdev:evdev $HOME/.spacemacs \
  && echo -e "Installing Spacemacs ..." \
  && emacs -nw -batch -u "evdev" -q -kill >/dev/null 2>&1 \
  && emacs -nw -batch -u "evdev" -q -kill >/dev/null 2>&1

# go
ENV GOPATH $HOME/Code/Go
ENV GOBIN $GOPATH/bin
ENV PATH "$PATH:$GOBIN"

# ssh
COPY ssh $HOME/.ssh
# RUN ssh-keyscan github.com > $HOME/.ssh/known_hosts

# colors
COPY xterm-256color-italic.terminfo $XDG_CONFIG_HOME/xterm-256color-italic.terminfo
ENV TERM xterm-256color-italic
RUN tic $XDG_CONFIG_HOME/xterm-256color-italic.terminfo
# RUN curl -fsSL https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash

# tmux config
COPY tmux/tmux.conf.local $HOME/.tmux.conf.local
COPY tmux/tmux.conf $HOME/.tmux.conf

# zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
COPY zsh/zshrc $HOME/.zshrc
COPY zsh/void-mod.zsh-theme $HOME/.oh-my-zsh/custom/themes/

# node
ENV NPM_CONFIG_LOGLEVEL error
RUN yarn global add eslint prettier && yarn cache clean

COPY vim/ctags $HOME/.ctags

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
 && ~/.fzf/install --bin

RUN mkdir -p $XDG_CONFIG_HOME/nvim/shada && touch $XDG_CONFIG_HOME/nvim/shada/main.shada

ENV PATH "$PATH:$HOME/.fzf/bin"

WORKDIR /workdir

CMD [ "/bin/zsh" ]
