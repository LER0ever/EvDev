FROM alpine:edge
MAINTAINER Everette Rong (https://rongyi.blog)
ENV HOSTNAME EvDev-Container

# Record the current image's build time
RUN echo -e "EvDev Build Start: $(date)" >> /etc/EvDev.prop

# ENV DEBIAN_FRONTEND noninteractive
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

# User with temporary password
RUN adduser -s /bin/zsh -D everette && \
    echo "root:33554432!" | chpasswd &&\
    echo "everette:33554432!" | chpasswd && \
    echo "everette ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# base
RUN apk add --update-cache \
    linux-headers alpine-sdk build-base cmake

# utilities
RUN apk add --update-cache \
    bash zsh less tmux ncurses \
    p7zip htop neofetch shadow

# dev utils
RUN apk add --update-cache \
    git the_silver_searcher \
    man man-pages ctags gdb \
    perl qemu-img qemu-system-i386 \
    openssh mosh
RUN ssh-keygen -A && echo "Welcome to EvDev Container!" > /etc/motd
EXPOSE 22
RUN wget --no-check-certificate -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh && bash gitflow-installer.sh install stable; rm -rf gitflow*
RUN cd /tmp && \
    git clone https://github.com/tj/git-extras.git && \
    cd git-extras && \
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    make install && \
    cd .. && rm -rf git-extras


# Python
RUN apk add --update-cache \
    python-dev python3-dev python3

# Python modules
RUN pip3 install thefuck \
    yapf virtualenv pipenv

# Go
RUN apk add --update-cache \
    go go-tools glide

# Nodejs
RUN apk add --update-cache \
    nodejs yarn nodejs-npm \
    && npm i -g typescript \
    && npm i -g tern

# C/C++
RUN apk add --update-cache \
    clang clang-dev

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

# LaTeX
RUN apk add --update-cache \
    texlive-full >/dev/null 2>&1

# Lua
RUN apk add --update-cache \
    lua5.3-dev lua-sec luajit

# Erlang/Elixir
RUN apk add --update-cache \
    erlang erlang-crypto erlang-syntax-tools \
    erlang-parsetools erlang-inets erlang-ssl \
    erlang-public-key erlang-eunit erlang-asn1 \
    erlang-sasl erlang-erl-interface erlang-dev \
    elixir

# Editors
RUN apk add --update-cache \
    libtermkey neovim neovim-doc \
    vim emacs \
    && apk add --no-cache kakoune --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && pip3 install neovim \
    && gem install neovim
RUN cd /tmp \
    && wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && mv nvim.appimage /usr/local/bin/nvim-git \
    && chmod +x /usr/local/bin/nvim-git
ENV MICRO_VERSION 1.4.0
RUN cd /tmp \
    && wget https://github.com/zyedidia/micro/releases/download/v${MICRO_VERSION}/micro-${MICRO_VERSION}-linux32.tar.gz \
    && tar zxvf micro-${MICRO_VERSION}-linux32.tar.gz \
    && cd micro-${MICRO_VERSION} \
    && mkdir -p /usr/local/lib/micro \
    && cp micro /usr/local/lib/micro/ \
    && echo -e '#!/bin/bash\nenv TERM=xterm-256color /usr/lib/micro/micro "$@"' > /usr/local/bin/micro \
    && cd .. \
    && rm -rf micro-*

# FRP
ENV FRP_VERSION 0.15.1
RUN set -ex \
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
ENV HOME /home/everette
ENV XDG_CONFIG_HOME  $HOME/.config
RUN chown -R everette:everette $HOME
USER everette

# git
COPY git/gitconfig $HOME/.gitconfig
COPY git/gitignore_global $HOME/.gitignore_global

# EverVim
COPY vim/EverVim.vimrc $HOME/.EverVim.vimrc
RUN curl -sLf https://raw.githubusercontent.com/LER0ever/EverVim/master/Boot-EverVim.sh | bash \
  && echo -e "Installing EverVim Distribution ..." \
  && sudo chown everette:everette $HOME/.EverVim.vimrc \
  && nvim --headless +PlugInstall +qa &> /dev/null
RUN cd $HOME/.EverVim/bundle/YouCompleteMe \
    && python3 install.py --clang-completer --system-libclang --go-completer --rust-completer --js-completer --cs-completer \
    && cd $HOME/.EverVim/bundle/vimproc.vim \
    && make

# Spacemacs
COPY emacs/spacemacs $HOME/.spacemacs
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d \
  && sudo chown everette:everette $HOME/.spacemacs \
  && echo -e "Installing Spacemacs ..." \
  && emacs -nw -batch -u "everette" -q -kill >/dev/null 2>&1 \
  && emacs -nw -batch -u "everette" -q -kill >/dev/null 2>&1

# go
ENV GOPATH $HOME/Code/Go
ENV GOBIN $GOPATH/bin
ENV PATH "$PATH:$GOBIN"

# ssh
COPY ssh $HOME/.ssh
RUN sudo chown -R everette:everette $HOME/.ssh && sudo chmod 600 $HOME/.ssh/config
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

ENV PATH "$PATH:$HOME/.fzf/bin"

# Record the current image's build time
RUN echo -e "EvDev Build Finish: $(date)" | sudo tee -a /etc/EvDev.prop

WORKDIR /workdir

CMD [ "/bin/zsh" ]
