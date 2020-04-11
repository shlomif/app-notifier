import os

from flask import Flask, request

import requests

app = Flask(__name__)

REMOTE_HOST = os.getenv("NOTIFIER_PROXY_HOST", "192.168.1.192")
REMOTE_PORT = os.getenv("NOTIFIER_PROXY_PORT", "6300")


@app.route('/notify')
def notify():
    requests.get(
        "http://{}:{}/notify".format(
            REMOTE_HOST, REMOTE_PORT), params=request.args)
    return "OK"
