#This module is responsible for web routing
__author__ = 'Artur Pedroso'

from bottle import request, Bottle, abort, template, static_file
from gevent.pywsgi import WSGIServer
from geventwebsocket import WebSocketError
from geventwebsocket.handler import WebSocketHandler
import os

app = Bottle()
STATIC_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "../static"))
open_websockets = {}
usernames_taken = []


@app.route('/websocket')
def handle_websocket():
    prefix_message = 'msg:'
    prefix_user_in = 'usr_in:'
    prefix_user_out = 'usr_out'
    wsock = request.environ.get('wsgi.websocket')
    if not wsock:
        abort(400, 'Expected WebSocket request.')

    try:
        username = wsock.receive()
    except WebSocketError:
        return

    if ' ' in username:
        return

    open_websockets.update({username: wsock})
    for key in open_websockets.keys():
        try:
            usernames_to_send = ' '.join(usernames_taken)
            open_websockets[key].send(prefix_user_in + usernames_to_send)
            open_websockets[key].send(prefix_message + username + ' logged in...')
        except WebSocketError:
            del open_websockets[key]

    while True:
        try:
            message = wsock.receive()
            for key in open_websockets.keys():
                try:
                    open_websockets[key].send(prefix_message + username + ': ' + message)
                except WebSocketError:
                    del open_websockets[key]
        except WebSocketError:
            del open_websockets[username]
            usernames_taken.remove(username)
            for key in open_websockets.keys():
                try:
                    open_websockets[key].send(prefix_user_out + username)
                    open_websockets[key].send(prefix_message + username + ' logged out...')
                except WebSocketError:
                    del open_websockets[key]
            break
        except:
            del open_websockets[username]
            usernames_taken.remove(username)
            for key in open_websockets.keys():
                try:
                    open_websockets[key].send(prefix_user_out + username)
                    open_websockets[key].send(prefix_message + username + ' logged out...')
                except WebSocketError:
                    del open_websockets[key]
            break


@app.route('/')
def main_page():
    return template('index')


@app.route('/chat', method='POST')
def chat_page():
    username = request.POST.get('username', '')
    if username:
        if username in usernames_taken:
            return template('index', error = 'This username is currently in use... choose another!')
        elif ' ' in username:
            return template('index', error = 'The username can\'t contain spaces!')
        else:
            usernames_taken.append(username)
            usernames_taken.sort()
            return template('chat', username = username)
    else:
        return template('index')


@app.route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root = STATIC_PATH)


def start_server():
    server_addr = "127.0.0.1"
    app_port = 8080
    print 'Server started and is waiting connections at ' + server_addr + ':' + str(app_port)
    server = WSGIServer((server_addr, app_port), app,
                        handler_class = WebSocketHandler)
    server.serve_forever()


