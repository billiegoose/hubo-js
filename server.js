var docpadInstanceConfiguration = {};
require('docpad').createInstance(docpadInstanceConfiguration, function(err,docpadInstance){
    if (err)  return console.log(err.stack);
    // ...
    docpadInstance.action('generate server watch', function(err,result){
        if (err)  return console.log(err.stack);
        console.log('OK');
    });
});

