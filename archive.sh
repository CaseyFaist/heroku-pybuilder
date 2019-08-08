for i in /.pyenv/versions/*; do
    cp -r $i pythonStaging
done

cd /app/pythonStaging
for i in *; do
    # Before archiving, simlink sqlite headers in for each directory
    versionnum=$(basename $i)
    echo $versionnum

    mv $versionnum python-$versionnum
    # Adapted from current heroku python binstubs
    # Remove unneeded test directories, similar to the official Docker Python images:
    # https://github.com/docker-library/python
    # find "${i}" \( -type d -a \( -name test -o -name tests \) \) -exec rm -rf '{}' +

    # # # copy over sqlite3 headers
    # cp "/usr/include/sqlite3"* "$i/include/"

    # # create generic .so symlink against stack image
    # ln -s "/usr/lib/x86_64-linux-gnu/libsqlite3.so.0" "$i/lib/libsqlite3.so"

    # tar -czf /app/heroku-18/runtimes/python-$versionnum.tar.gz $i -C /app/heroku-18/runtimes/
    # echo "/app/heroku-18/runtimes/python-$versionnum.tar.gz Created!"
done
