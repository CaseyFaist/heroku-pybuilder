python crawl.py

xargs -P 1 -n 1 pyenv install < python-versions.txt

bash archive.sh

cp python-versions.txt heroku-18

aws s3 sync heroku-18 s3://lang-python-staging/heroku-18 --delete
