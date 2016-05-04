#!/bin/bash
set -e

if ! [ -e index.php -a -e update.php ]; then
    echo >&2 "Drupal not found in $(pwd) - copying now..."
    if [ "$(ls -A)" ]; then
        echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
        ( set -x; ls -A; sleep 10 )
    fi
    tar cf - --one-file-system -C /usr/src/drupal-${DRUPAL_VERSION} . | tar xf -
    echo >&2 "Complete! Drupal has been successfully copied to $(pwd)"
fi

exec "$@"