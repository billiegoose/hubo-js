// Cloud9 IDE provides an environment variable called PORT
var port = process.env.PORT || 8125;
// Valid values are 'development' and 'production'
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

// Let's use Express.js, because everyone else does.
var express = require('express')
    , compiler = require('connect-compiler')
    ;

var app = express();
app.use(express.compress()); // Apply gzip compression
app.use(express.bodyParser()); // Automatically parse data in http POST etc
app.use(express.methodOverride()); // Provides faux support for http PUT and http DELETE methods
app.use(app.router); // Lets us add code for handling specific paths

// I have a simple strategy: each HTML page comes from a Jade page of the same name.
// Using this connector is much easier than writing repetitive code to render 'views'.
app.use(compiler(
    { enabled : [ 'coffee'
                , 'jade'
                , 'stylus'
                ]
    , expires : true
    , options :
        { coffee: { header: true
                  }
        , jade: {basedir: '.'}
        }
    }
));
// Render static content
app.use(express.static(__dirname));
app.use('/examples',express.directory('examples')); // Provides cool directory indexes!
app.use('/src',express.directory('src')); // Provides cool directory indexes!
app.use('/lib',express.directory('lib')); // Provides cool directory indexes!
app.use('/data',express.directory('data')); // Provides cool directory indexes!

// Start server
app.listen(port);
console.log('Server running at http://localhost:' + port + '/');