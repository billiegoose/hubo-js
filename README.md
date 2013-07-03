hubo-js
=======

This repository will contain a collection of web-based tools for Hubo, the humanoid robot.
The first is WebGLRobots.js, a JavaScript library that will let you embed a Hubo on your 
own webpage! Just look at 'public/minimal.html' to see how.

Building
========

If you are already have a webserver, you can use that instead. If not, you can use the
NodeJS server that I use to develop.

* Clone this repository
* Install [node](http://nodejs.org/)
* Open the command line, go to the repository directory and type `npm update`

Running
=======

To start the server, run 'node server.js' or 'npm start'.

Troubleshooting
===============

#### Using the web pages locally

* Won't work. You have to use a NodeJS server.

#### Using the web pages though a web server

* Run 'node server.js' to start the HTTP server on your local computer.
* Open http://localhost:8125/ in your browser.