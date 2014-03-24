Hubo-in-the-Browser Live server
===============================

System Prerequisites:
---------------------

The "normal" setup is to use the ach network daemon to mirror the ach channels from the hubo computer onto the server which runs the Hubo Live software, to take the burden of the server off of the hubo computer itself.
Therefore, you must have the remote computer (the actual hubo computer or the computer running OpenHubo) configured to accept ACH network daemon requests.
Details [here](http://golems.github.io/ach/manual/#AEN437).

TLDR version:

1. `sudo apt-get install openbsd-inetd` 
2. Add 
`8076  stream  tcp  nowait  nobody  /usr/local/bin/achd /usr/local/bin/achd serve`
to the end of `/etc/inetd.conf`


Running:
--------

There are two components to Hubo Live.
The first is the webpage itself.
The second is the websocket server that provides the live data.
The webpage itself is static and compiled using Docpad like the rest of Hubo-in-the-Browser.
You can see the latest "official" release live at my website, http://wmhilton.com/hubo-js/live
You can run the development version on your computer by running Docpad in the top-level hubo-js directory, e.g.

1. In the top directory, run `docpad run`
2. Navigate to [http://localhost:9778/live/](http://localhost:9778/live/)

The second component is the websocket server, which sends the state data to the webpages.
You can run this by calling `node live_display_server.js` with the necessary flags (documented by '--help') or simply using one of the provided shell scripts, like:

1. In this directory, run `./run.sh`

Start On Boot
-------------

You may want a permanent Hubo Live server.
Therefore it is desirable to start the websocket server and/or Docpad server on boot.
Assuming you are using Ubuntu 12.04, the best way to do that is with Upstart services.

Upstart service config files are provided in `./init/.`

To start the server on boot, simply place `docpad-server.conf` and `socketio-server.conf` in `/etc/init/`

