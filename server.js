var http = require('http');
var express = require('express');
var path = require('path');
var util = require('util');
// Used by utils
var fs = require('fs');

var app = express();

app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

var server = http.createServer(app);
server.listen(8125);
console.log('Server running at http://localhost:8125/');
