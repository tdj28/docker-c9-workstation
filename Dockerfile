FROM ubuntu:14.04
MAINTAINER Tim Jones (tdj28@github)

# docker build -t c9-only --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa)" .

# interactive:
# docker run -i -t -p 9999:9999 -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v $PWD/folder:/usr/local/develop --name devdock c9-only

# docker run -d -p 9999:9999 -v $PWD/folder:/usr/local/develop --name devdock c9-only

# Debian packages
ENV DEBIAN_FRONTEND noninteractive
COPY packages.txt /usr/local/packages.txt
RUN apt-get update && cat /usr/local/packages.txt | xargs apt-get install -yq

# Pip packages
WORKDIR /usr/local/
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
COPY ./requirements.txt /usr/local/requirements.txt
RUN pip3 --no-cache-dir install -r /usr/local/requirements.txt

# Install Cloud9 IDE
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN mkdir /usr/local/c9
WORKDIR /usr/local/c9
RUN git clone https://github.com/c9/core.git
WORKDIR /usr/local/c9/core
RUN scripts/install-sdk.sh

# Set up supervisor
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/log/supervisor/conf.d
COPY ./c9.conf /etc/supervisor/conf.d/c9.conf

RUN mkdir /usr/local/develop

EXPOSE 9999
WORKDIR /usr/local/develop
USER root

ARG SSH_KEY
RUN mkdir -p /root/.ssh && \
  echo "$SSH_KEY" >/root/.ssh/id_rsa && \
  chmod 0600 /root/.ssh/id_rsa

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
