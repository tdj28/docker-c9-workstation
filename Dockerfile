FROM ubuntu:14.04
MAINTAINER Tim Jones (doctimjones@github)

# docker build -t doctimjones/c9-linux-workstation .

# interactive:
# docker run -i -t -p 9999:9999 -v $PWD/folder:/usr/local/develop --name devdock doctimjones/c9-linux-workstation

# docker run -d -p 9999:9999 -v $PWD/folder:/usr/local/develop --name devdock doctimjones/c9-linux-workstation

ENV DEBIAN_FRONTEND noninteractive

# R 
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -

# Apt packages
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
