from flask import Flask, request

import requests

app = Flask(__name__)


@app.route('/notify')
def notify():
    requests.get(
        "http://192.168.1.192:6300/notify", params=request.args)
    return "OK"
