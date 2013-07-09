// Cloud9 IDE provides an environment variable called PORT
var port = process.env.PORT || 8125;
// Valid values are 'development' and 'production'
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

// Let's use Express.js, because everyone else does.
var express = require('express')
	, connectJadeHtml = require('connect-jade-html')
	, stylus = require('stylus')
	;

var app = express();
app.use(express.compress()); // Apply gzip compression
app.use(express.bodyParser()); // Automatically parse data in http POST etc
app.use(express.methodOverride()); // Provides faux support for http PUT and http DELETE methods
app.use(app.router); // Lets us add code for handling specific paths
app.use(express.directory('public')); // Provides cool directory indexes!

app.use(stylus.middleware(
	{ src     : __dirname + '/views'
	, dest    : __dirname + '/public'
	, force: (process.env.NODE_ENV === 'development' ? true : false)
	, compile : function(str, path) {
	      return stylus(str)
		        .set('filename', path)
		        .set('warn', true)
		        .set('compress', false);
    }
}));

// I have a simple strategy: each HTML page comes from a Jade page of the same name.
// Using this connector is much easier than writing repetitive code to render 'views'.
app.use(connectJadeHtml(
	{ src: __dirname + '/views'
	, dest: __dirname + '/public'
	, pretty: true
	, force: (process.env.NODE_ENV === 'development' ? true : false)
	}
));

// Render static content
app.use(express.static(__dirname + '/public'));

// Start server
app.listen(port);
console.log('Server running at http://localhost:' + port + '/');