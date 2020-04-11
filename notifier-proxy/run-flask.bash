#! /bin/bash
#
# flask.bash
# Copyright (C) 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

export FLASK_APP=flaskr
export FLASK_ENV=development

flask run --host=0.0.0.0 --port=6300
