#!/usr/bin/env python3
import os
import re
import requests
from bs4 import BeautifulSoup

PSF_URL = 'https://www.python.org/ftp/python/'
HEROKU_URL = 'https://devcenter.heroku.com/articles/python-support'
pattern = re.compile('(?<=python-)\d.\d.\d\d?\b*')

# DRY up a repeated action
def grabSource(url):
    response = requests.get(url)
    return BeautifulSoup(response.text, 'html.parser')

psfsoup = grabSource(PSF_URL)

# This crauls the PSF FTP home page and returns a list of valid version numbers
psf = [
    link.get('href').replace('/', '') \
    for link in psfsoup.find_all('a', href=re.compile('\d(.\d\d?){2}')) #update
    ]

herokuSoup = grabSource(HEROKU_URL)

# This is dense. Most of this is based off of the page structure, but the key is
# how we have to work with the heroku python support page's data structure
# find_all('ul') returns a soup item full of 'li's. These li's have a text
# attribute, but the way the 'supported versions table currently (July 2019)
# returns is as one long string - example of how this string shows up in the data:

"""
[ "

# python-3.7.3 on all (heroku-16, and heroku-18) runtime stacks

# python-3.6.8 on all (heroku-16, and heroku-18) runtime stacks

# python-2.7.16 on all (heroku-16, and heroku-18) runtime stacks

# "]
"""
heroku = [
    pattern.findall(item.text.strip()) \
    for item in herokuSoup.find_all('ul') \
    if pattern.findall(item.text.strip())
    ][0]

# This reads a file created during docker build by running `pyenv install --list`
pyenv = [line.rstrip('\n').strip() for line in open('available.txt')]

# Check which of the Heroku supported runtime versions are available via pyenv
herokuSupported = set(heroku).intersection(pyenv)

# Defensively check that all Heroku supported versions are available via the PSF
# Then, write all versions to the 'python-versions' file
with open('python-versions.txt', 'w') as file:
    for match in herokuSupported.intersection(psf):
        file.write(f'{match}\n')
