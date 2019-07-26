FROM heroku/heroku:18-build

# inspiration for running pyenv in docker taken from:
# https://github.com/themattrix/docker-pyenv/blob/master/Dockerfile
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

ENV PYENV_ROOT="/.pyenv" \
    PATH="/.pyenv/bin:/.pyenv/shims:$PATH" \
    PYTHON_CONFIGURE_OPTS="--enable-shared"

# Heroku provides sqlite, but has removed the headers. For build, add them back.
RUN apt-get update && apt-get install -y libsqlite3-dev

# Get the pyenv installer
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

RUN pyenv update
RUN pyenv install 3.7.4
RUN pyenv global 3.7.4

# Should pip installs be in a requirements.txt? That is future Queen Snake's problem
RUN pip install --upgrade pip

# Used to put things in AWS
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html#install-bundle-other-os
RUN pip install awscli --upgrade

# Required for crawl.py
RUN pip install beautifulsoup4 requests

# Make the directories we need for the python build process and prep for run
RUN mkdir -p /.heroku/python \
    mkdir -p heroku-18/runtimes
COPY crawl.py /app/crawl.py
COPY archive.sh /app/archive.sh
COPY runjob.sh /app/runjob.sh
RUN pyenv install --list > available.txt
RUN chmod +x /app/archive.sh
RUN chmod +x /app/runjob.sh
