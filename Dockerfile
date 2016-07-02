FROM ubuntu:14.04
MAINTAINER Tim Jones (tdj28@github)

# docker build -t c9-only .

# interactive:
# docker run -i -t -p 9999:9999 -v $PWD/folder:/usr/local/develop --name devdock c9-only

# docker run -d -p 9999:9999 -v $PWD/folder:/usr/local/develop --name devdock c9-only

# Debian packages
ENV DEBIAN_FRONTEND noninteractive
COPY ./apt/packages.txt /usr/local/packages.txt
RUN apt-get update && cat /usr/local/packages.txt | xargs apt-get install -yq

# Pip packages
WORKDIR /usr/local/
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
COPY ./pip/requirements.txt /usr/local/requirements.txt
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
COPY ./supervisor/c9.conf /etc/supervisor/conf.d/c9.conf

RUN mkdir /usr/local/develop

WORKDIR /usr/local/develop
USER root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
