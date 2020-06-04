#! /bin/bash
#
# flask.bash
# Copyright (C) 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

export FLASK_APP=flaskr
export FLASK_ENV=development
if test -z "$NOTIFIER_PROXY_PORT"
then
    export NOTIFIER_PROXY_PORT='6300'
fi

if test -z "$NOTIFIER_PROXY_HOSTNAME"
then
    NOTIFIER_PROXY_HOSTNAME='0.0.0.0'
fi

backend="$1"
if test "$backend" = '--mojo'
then
    perl mojolicious.pl daemon -l "http://${NOTIFIER_PROXY_HOSTNAME}:${NOTIFIER_PROXY_PORT}"
else
    flask run --host="$NOTIFIER_PROXY_HOSTNAME" --port="${NOTIFIER_PROXY_PORT}"
fi
