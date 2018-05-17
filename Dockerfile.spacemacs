FROM ler0ever/evdev.evervim:latest
MAINTAINER Everette Rong (https://rongyi.blog)

# Spacemacs
COPY emacs/spacemacs $HOME/.spacemacs
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d \
  && sudo chown everette:everette $HOME/.spacemacs \
  && echo -e "Installing Spacemacs ..." \
  && emacs -nw -batch -u "everette" -q -kill >/dev/null 2>&1 \
  && emacs -nw -batch -u "everette" -q -kill >/dev/null 2>&1
