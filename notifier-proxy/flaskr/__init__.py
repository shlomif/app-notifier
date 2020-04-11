import requests

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return requests.get("http://192.168.1.192:6300/", params=app.params())
