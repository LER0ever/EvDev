FROM ler0ever/evdev.config:latest
MAINTAINER Everette Rong (https://rongyi.blog)

# Record the current image's build time
RUN echo -e "EvDev Build: $(date)" | sudo tee -a /etc/EvDev.prop

WORKDIR /workdir

CMD [ "/bin/zsh" ]
