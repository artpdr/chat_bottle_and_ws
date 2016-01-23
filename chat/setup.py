# -*- coding: utf-8 -*-
from setuptools import setup

setup(
    name='chatOn',
    version='1.0',
    description='Simple chat',
    url='https://github.com/artpdr/chat_bottle_and_ws',
    author='Artur Pedroso',
    license='MIT',
    packages=['chatOn'],
    install_requires=['bottle', 'pytest', 'paste', 'gevent-websocket'],
    entry_points={
        'console_scripts': [
            'chatOn_server = chatOn.server:start_server'
        ]
    }
)