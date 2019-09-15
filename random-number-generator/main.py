import secrets
import os

from flask import Flask
from gevent import pywsgi

flask = Flask(__name__)


@flask.route("/")
def get_random():
    return "%s" % secrets.randbelow(1_000_001)


if __name__ == "__main__":
    app = pywsgi.WSGIServer(('127.0.0.1', int(os.getenv("PORT"))), flask)
    app.serve_forever()
