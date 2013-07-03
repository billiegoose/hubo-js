var http = require('http');
var express = require('express');
var path = require('path');
var util = require('util');
// Used by utils
var fs = require('fs');

var port = process.env.PORT || 8125;

var app = express();
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

var server = http.createServer(app);
server.listen(port);
console.log('Server running at http://localhost:' + port + '/');
