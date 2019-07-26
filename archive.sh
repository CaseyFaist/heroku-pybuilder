for i in /.pyenv/versions/*; do
    cp -r $i /.heroku/python
done

for i in /.heroku/python/*; do
    # Before archiving, simlink sqlite headers in for each directory
    pathname=$i
    versionnum=$(basename $pathname)

    # Adapted from current heroku python binstubs
    # Remove unneeded test directories, similar to the official Docker Python images:
    # https://github.com/docker-library/python
    find "${pathname}" \( -type d -a \( -name test -o -name tests \) \) -exec rm -rf '{}' +

    # copy over sqlite3 headers
    cp "/usr/include/sqlite3"* "$pathname/include/"

    # create generic .so symlink against stack image
    ln -s "/usr/lib/x86_64-linux-gnu/libsqlite3.so.0" "$pathname/lib/libsqlite3.so"
    tar -zcvf /app/heroku-18/runtimes/python-$versionnum.tar.gz $pathname
done
