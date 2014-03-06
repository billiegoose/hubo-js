// Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
c = new WebGLRobots.DefaultCanvas('#hubo_container');
// Create a new robot instance.
window.hubo = new Hubo('hubo2',
  function callback() {
    // Once the URDF is completely loaded, this function is run.
    // Add your robot to the canvas.
    c.add(hubo);
    $('#load').hide();
  },
  function progress(step,total,node) {
    $('#load').html("Loading " + step + "/" + total);
  }
);

$('#mouse_info_dialog').dialog(
    { autoOpen: false
    , closeOnEscape: true
    , buttons: { OK: function () { $(this).dialog('close'); } }
    }
);

$('#mouse_info_button').on('click', function() { $('#mouse_info_dialog').dialog('open'); });



//http://jonathanstark.com/blog/debugging-html-5-offline-application-cache?filename=2009/09/27/debugging-html-5-offline-application-cache/
var cacheStatusValues = [];
cacheStatusValues[0] = 'uncached';
cacheStatusValues[1] = 'idle';
cacheStatusValues[2] = 'checking';
cacheStatusValues[3] = 'downloading';
cacheStatusValues[4] = 'updateready';
cacheStatusValues[5] = 'obsolete';

var cache = window.applicationCache;
cache.addEventListener('cached', logEvent, false);
cache.addEventListener('checking', logEvent, false);
cache.addEventListener('downloading', logEvent, false);
cache.addEventListener('error', logEvent, false);
cache.addEventListener('noupdate', logEvent, false);
cache.addEventListener('obsolete', logEvent, false);
cache.addEventListener('progress', logEvent, false);
cache.addEventListener('updateready', logEvent, false);

function logEvent(e) {
    var online, status, type, message;
    online = (navigator.onLine) ? 'yes' : 'no';
    status = cacheStatusValues[cache.status];
    type = e.type;
    message = 'online: ' + online;
    message+= ', event: ' + type;
    message+= ', status: ' + status;
    if (type == 'error' && navigator.onLine) {
        message+= ' (prolly a syntax error in manifest)';
    }
    console.log(message);
}

window.applicationCache.addEventListener(
    'updateready', 
    function(){
        window.applicationCache.swapCache();
        console.log('swap cache has been called');
    }, 
    false
);

setInterval(function(){cache.update()}, 10000);