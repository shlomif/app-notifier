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

flask run --host=0.0.0.0 --port="${NOTIFIER_PROXY_PORT}"
