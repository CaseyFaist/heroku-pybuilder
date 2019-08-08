# Heroku PyBuilder

This tool uses Pyenv and Docker to provide an environment that can build Python runtime binaries against the Heroku stack image locally and deployed to the platform.

When deployed, the command `bash runjob.sh` can be run on a periodic schedule to automatically build and archive python binaries.
