# Just use the code-server docker binary
FROM codercom/code-server as coder-binary

FROM ubuntu:18.10 as vscode-env
ARG DEBIAN_FRONTEND=noninteractive

# Install the actual VSCode to download configs and extensions
RUN apt-get update && \
	apt-get install -y curl && \
	curl -o vscode-amd64.deb -L https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable && \
	dpkg -i vscode-amd64.deb || true && \
	apt-get install -y -f && \
	# VSCode missing deps
	apt-get install -y libx11-xcb1 libasound2 && \
	rm -f vscode-amd64.deb && \
	# CLI json parser
	apt-get install -y jq

COPY scripts /root/scripts
COPY sync.gist /root/sync.gist

# This gets user config from gist, parse it and install exts with VSCode
RUN code -v --user-data-dir /root/.config/Code && \
	cd /root/scripts && \
	sh get-config-from-gist.sh && \
	sh parse-extension-list.sh && \
	sh install-vscode-extensions.sh ../extensions.list

# The production image for code-server
FROM ubuntu:18.10
MAINTAINER Everette Rong (https://rongyi.blog)
WORKDIR /project
COPY --from=coder-binary /usr/local/bin/code-server /usr/local/bin/code-server
RUN mkdir -p /root/.code-server/User
COPY --from=vscode-env /root/settings.json /root/.code-server/User/settings.json
COPY --from=vscode-env /root/.vscode/extensions /root/.code-server/extensions
COPY scripts /root/scripts

RUN apt-get update && \
	apt-get install -y curl gnupg2 ca-certificates && \
	apt-get install -y locales && \
	locale-gen en_US.UTF-8
# Locale Generation
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LANG=en_US.UTF-8

# Install langauge toolchains
RUN sh /root/scripts/install-tools-nodejs.sh
RUN sh /root/scripts/install-tools-dev.sh
RUN sh /root/scripts/install-tools-golang.sh
RUN sh /root/scripts/install-tools-cpp.sh
RUN sh /root/scripts/install-tools-python.sh

EXPOSE 8443
CMD code-server $PWD
