#!/usr/bin/env python

from flask import Flask
from flask import request
import sys
import socket

app = Flask(__name__)
version = '1.0'

@app.route('/welcome')
@app.route('/')
def hello_world():
    hn = socket.gethostname()
    return 'HOSTNAME: {0}<br>VERSION: {1}'.format(hn, version)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
