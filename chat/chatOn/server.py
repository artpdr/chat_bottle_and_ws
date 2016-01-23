#This module is responsible for web routing
__author__ = 'Artur Pedroso'

from bottle import request, Bottle, abort, template
from gevent.pywsgi import WSGIServer
from geventwebsocket import WebSocketError
from geventwebsocket.handler import WebSocketHandler

app = Bottle()

@app.route('/websocket')
def handle_websocket():
    wsock = request.environ.get('wsgi.websocket')
    if not wsock:
        abort(400, 'Expected WebSocket request.')

    while True:
        try:
            message = wsock.receive()
            wsock.send("Your message was: %r" % message)
        except WebSocketError:
            break

@app.route('/')
def main_page():
    return template('index')

def start_server():
    server_addr = "127.0.0.1"
    app_port = 8080
    print 'Server started and is waiting connections at ' + server_addr + ':' + str(app_port)
    server = WSGIServer((server_addr, app_port), app,
                        handler_class = WebSocketHandler)
    server.serve_forever()


