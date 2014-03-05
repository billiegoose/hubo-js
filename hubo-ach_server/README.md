Hubo-in-the-Browser Live server
===============================

One Time Run
------------

1. In the top directory, run `docpad run`
2. In this directory, run `./run.sh`

Start On Boot
-------------

Upstart service config files are provided in ./init/. To start the server on boot, simply place ```docpad-server.conf``` and ```socketio-server.conf``` in /etc/init/

