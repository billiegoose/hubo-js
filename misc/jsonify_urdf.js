$.ajaxSetup({timeout:10000}); //10 seconds
/*
 * * * 3D MODEL OF HUBO * * *
 */
// TODO: Move canvas stuff to WebGLRobots.
var display_width=480, display_height=480, max_display_height=480;
var hubo_container;
var camera, scene, renderer;

var WST, NKY, NKP;
var LSP, LSR, LSY, LEB, LWY, LWR, LWP;
var RSP, RSR, RSY, REB, RWY, RWR, RWP;
var LHY, LHP, LHR, LKN, LAR, LAP;
var RHY, RHP, RHR, RKN, RAR, RAP;
var Lfingers, Rfingers;

//var X2JS = new X2JS();
var xml;

function Hubo() {
    // Joint abstraction
    this.joints = new Object();
    // TODO: It appears this part is broken... and unused
    this.joints.set = function() {
        // Set the angle
        thi
        return Object.keys(this).length - 1;
    };
    // Collada meshes abstraction
    this.links = new Object();
    // The number of links to load
    this.links.num = 0; 
    // A running count of the number of links loaded.
    this.links.num_loaded = 0;
}

// TODO: Is this function used?
function addJointSetter(j) {
    Object.defineProperty(j, "value", {
        get : function(){
            return myValue;
        },
        set : function(newValue){ 
            this.child.quaternion.w = newValue;
            //this.child.quaternion.setFromAxisAngle( str2vec(this.axis), newValue );
            myValue = newValue; 
        },
        enumerable : true,
        configurable : true});

}

$('#load_urdf').on('click', function(event, ui) {
    loadURDF("hubo-urdf/model.urdf");
});
$('#save_json').on('click', function(event, ui) {
    saveJSON(hubo);
});


function init() {
    // container
    hubo_container = document.getElementById('hubo_container');
    display_width = Math.min(max_display_height, window.innerHeight*.9);
    display_height = display_width;

    // renderer
    //renderer = new THREE.WebGLRenderer();
    //renderer = new THREE.CanvasRenderer();
    renderer = Detector.webgl? new THREE.WebGLRenderer(): new THREE.CanvasRenderer();

    renderer.setSize(display_width, display_height)
    hubo_container.appendChild( renderer.domElement );

    // scene
    scene = new THREE.Scene();

    // Adding trackball controls.
    camera = new THREE.PerspectiveCamera( 60, display_width / display_height, 0.1, 1000 );
    camera.up = new THREE.Vector3( 0, 0, 1 ); // the example that we load has Z as the up axis
    camera.position.x = 1.45;
    camera.position.y = 0;
    camera.position.z = 0.9;
    // This is obsoleted by the need to set controls.target below.
    // camera.lookAt(new THREE.Vector3(0,0,0.7));

    controls = new THREE.TrackballControls( camera, renderer.domElement );

    controls.rotateSpeed = 1.0;
    controls.zoomSpeed = 1.2;
    controls.panSpeed = 0.8;

    controls.noZoom = false;
    controls.noPan = false;

    controls.staticMoving = true;
    controls.dynamicDampingFactor = 0.3;

    // Tell the trackball where to look. This is sadly
    // not automatically set by the camera angle.
    controls.target=new THREE.Vector3(0,0,0.7);

    controls.addEventListener( 'change', render );

    // Add some lights so we can see Hubo 
    var ambient = new THREE.AmbientLight( 0x101030 );
    scene.add( ambient );

    var directionalLight = new THREE.DirectionalLight( 0xffeedd );
    directionalLight.position.set( 1, 0.1, 1 ).normalize();
    scene.add( directionalLight );

    var backlight = new THREE.DirectionalLight( 0xffeedd );
    backlight.position.set( -1, -0.1, -1 ).normalize();
    scene.add( backlight );

    // // Add an axis at the center. Thanks Mr. Doob!
    // var aa = new THREE.AxisHelper();
    // scene.add( aa );

    // var bb = new THREE.AxisHelper();
    // bb.position = new THREE.Vector3(0.0122581, 0.143973, 0.0486356);
    // scene.add(bb);
    // var v = str2vec("0.0122581 0.143973 0.0486356");
    // // onLoadedCreator("LSP",v,"y");
    // var v2 = str2vec("0.0269 0.072 0");
    // // v2.add(v);
    // var cc = new THREE.AxisHelper();
    // cc.position = v2;
    // scene.add(cc)


    window.addEventListener( 'resize', onWindowResize, false );
}


function loadURDF(filename) {
    // Uses jQuery
    $.get(filename, function (data) {
        // Save URDF XML DOM globally.
        xml = $.parseXML(data);
        console.log('Inside loadURDF');
        links = $(xml).find('robot link');
        // Save the number of links there are total
        hubo.links.num = $(links).length;
        // TODO: hubo.links.expectedCount = $(links).length;
        // Load each link into memory on the hubo.links object
        $(links).each( function() {
            loadLink($(this));
            // var name = $(this).attr("name");
            // console.log(name);
            // var collada = $(this).find("collision geometry mesh").attr("filename");
            // collada = collada.replace("package://hubo","./hubo-urdf");            
            // console.log(collada);
        })
    })
    .fail(function() { alert("error"); })
}


function loadLink(link) {
    // We are being passed in a URDF <link> element.
    var name = $(link).attr("name");
    console.log(name);
    var filename = $(link).find("collision geometry mesh").attr("filename");
    filename = filename.replace("package://hubo","./hubo-urdf");            
    console.log(filename);
    // Load mesh
    var loader = new ColladaLoader2();
    loader.setLog(onLoaderLogMessage);
    loader.load(filename, 
        function(collada) {
            var node = collada.scene;
            //node.eulerOrder = "ZYX"; // Roll, Pitch, Yaw
            node.name = name;
            hubo.links[name] = node;  
            hubo.links.num_loaded++; //TODO: Remove line.
            console.log("ADD: %s %i", name, hubo.links.num_loaded)             
            // console.log(node);
            // TODO: if (hubo.links.count === hubo.links.expectedCount) {
            if (hubo.links.num_loaded == hubo.links.num) {
                connectLinks();
            }
        }, 
        onProgress);
}

function connectLinks() {
    $(xml).find("robot > joint").each( function() {
        // TODO: Clean this shit up. It's verbose.
        console.log("--");
        var name = $(this).attr("name");
        console.log("joint: " + name);
        hubo.joints[name] = new Object();
        // TODO: var joint = new WebGLRobots.Joint();
        hubo.joints[name].name = name;
        // TODO: joint.name = $(this).attr("name");
        var child = $(this).find("child").attr("link");
        child = hubo.links[child];
        hubo.joints[name].child = child;
        // TODO: joint.child = $(this).find("child").attr("link");
        console.log("child: " + child.name);
        var parent = $(this).find("parent").attr("link");
        parent = hubo.links[parent];
        hubo.joints[name].parent = parent;
        // TODO: joint.parent = $(this).find("parent").attr("link");
        console.log("parent: " + parent.name);
        var coords = $(this).find("origin").attr("xyz");
        hubo.joints[name].coords = coords;
        console.log("coords: " + coords);
        // TODO: joint.coords = $(this).find("origin").attr("xyz");
        var rpy = $(this).find("origin").attr("rpy"); // roll, pitch, yaw
        hubo.joints[name].rpy = rpy;
        console.log("rpy: " + rpy); 
        // TODO: joint.rpy = $(this).find("origin").attr("rpy"); 
        var axis = $(this).find("axis").attr("xyz");
        hubo.joints[name].axis = axis;
        //hubo.joints[name].axis = str2vec(axis);
        // TODO: joint.axis = $(this).find("axis").attr("xyz");
        console.log("axis: " + axis);
        var limits = $(this).find("limit");
        var lower = $(limits).attr("lower");
        var upper = $(limits).attr("upper");
        // TODO: joint.lower_limit = $(limits).attr("lower");
        // TODO: joint.upper_limit = $(limits).attr("upper");
        hubo.joints[name].lower_limit = lower;
        hubo.joints[name].upper_limit = upper;
        console.log("limits: " + lower + " to " + upper);
        // TODO: hubo.joints[name] = joint;
        // Do stuff
        // Because the child link is offset and rotated from the parent link, but the axis of rotation
        // for the child link is specified in the child CS, we need to apply a coordinate system transform between
        // the child and the parent without disturbing the values of the child's rotation.
        // The only way I can think of to do this at the moment of writing is to insert another Object3D in between
        // the parent and child and apply the offset to the Object3D
        var obj = new THREE.Object3D();
        obj.position = str2vec(coords); //TODO: joint.coords
        // This nonsensical conversion is because ObjectExporter.js only saves the .position, .rotation., and .scale
        // properties of an object. .eulerOrder, .quaternion, etc are all not preserved. Thus we must convert from
        // roll, pitch, yaw 'ZYX' Euler angles to quaternion and then convert from quaternion to 'XYZ' Euler angles
        var q = new THREE.Quaternion().setFromEuler(str2vec(rpy),"ZYX"); //TODO: joint.rpy
        obj.rotation.setEulerFromQuaternion(q);
        parent.add(obj); // TODO: joint.parent
        obj.add(child); // TODo: joint.child
    });
    // TODO: Do a .traverse() to find all objects with no parent and add them.
    scene.add(hubo.links.Body_Torso);
    hubo.links.Body_Torso.position.z += 1;
}

function saveJSON() {
    // Save objects
    console.log('Converting to JSON...')
    var exporter = new THREE.ObjectExporter();
    // TODO: Make this more generic
    var torso = exporter.parse(hubo.links["Body_Torso"]);

    //TODO: Change this to Hubo.serialize()
    var safe_hubo = makeSafeReferences(hubo);

    var output = {};
    output.hubo = safe_hubo;
    output.Object3D = torso;

    var output = JSON.stringify(output);
    console.log('Sending JSON to server...')
    $.ajax({
        type: 'POST',
        url: 'utils/write_json',
        data: {"text": output},
    }).success( function() {
        console.log('JSON received by server.');
    }).error( function() {
        console.log('Error sending JSON.');
    });

    // Strip hubo of THREE.Object3D references
    console.log(makeSafeReferences(hubo))
}

// TODO: Just for gods sake export the parts of the robot that you need to export
// TODO: and make it a method of WebGLRobots.Robot.
function makeSafeReferences(obj) {
    for (var key in obj) {
        if (obj.hasOwnProperty(key)) {
            if (obj[key] instanceof THREE.Object3D) {
                // Replace Object3D reference with the object's name
                //console.log('key is Object3D');
                obj[key] = obj[key].name;
            } else if (obj[key] instanceof Array) {
                //console.log('key is Array');
                for (var i = 0; i < obj[key].length; i++) {
                    obj[key] = makeSafeReferences(obj[key]);
                }
            } else if (typeof obj[key] === "object") {
                //console.log('key is Object');
                obj[key] = makeSafeReferences(obj[key]);
            }
        }
    }
    return obj;
}

// TODO: Delete this. Not used
function selectRevoluteAxis(axis) {
    if (axis.x == 1) {
        return 'x';
    } else if (axis.y == 1) {
        return 'y';
    } else if (axis.z == 1) {
        return 'z';
    }
}

function onLoaderLogMessage(msg, type) {
    // Overloading the default (which is to console.log messages) to make it shut up.
    // var typeStr = ColladaLoader2.messageTypes[type];
    // console.log(typeStr + ": " + msg);
}

// TODO: Figure out how to show progress more effectively.
function onProgress(data) {
    // data.total might be null if the server does not set the Content-Length header
    if (data.total) {
        var percentLoaded = 100 * data.loaded / data.total;
        // console.log("Load progress: " + percentLoaded.toFixed(2) + "%");
        document.getElementById('percentloaded').innerHTML = percentLoaded.toFixed(0) + '%';
    } else {
        console.log("Load progress: " + data.loaded + " bytes");
        document.getElementById('percentloaded').innerHTML = data.loaded;
    }	
}

// TODO: Bring the good stuff from index.js over, like uncommenting controls.handleResize();
function onWindowResize() {
    display_height = Math.min(max_display_height, window.innerHeight * .9);
    display_width = display_height;
    //camera.aspect = display_width / display_height;
    //camera.updateProjectionMatrix();
    renderer.setSize( display_width, display_height );
    // controls.handleResize();
    render();
}

function animate(timestamp) {
    requestAnimationFrame( animate );
    controls.update();
    render(timestamp);
}

function render(timestamp) {
    renderer.render( scene, camera );
}

// TODO: Put this stuff somewhere else.
function repeat(pattern, count) {
    if (count < 1) return '';
    var result = '';
    while (count > 0) {
        if (count & 1) result += pattern;
        count >>= 1, pattern += pattern;
    }
    return result;
}
function printStructure(obj, indent) {
    indent = optArg(indent, 0);
    console.log(indent);
    console.log(repeat('  ',indent) + '%O %s', obj, obj.name);
    //console.log(obj)
    //console.log(repeat('  ',indent) + obj.name);
    for (var i in obj.children) {
        printStructure(obj.children[i],indent+1);
    }
}

function optArg(arg,val) {
    return typeof arg !== 'undefined' ? arg : val;
}

// TODO: Make part of WebGLRobots
function str2vec(coords) {
    coords = coords.split(' ');
    var v = new THREE.Vector3();
    v.x = parseFloat(coords[0]);
    v.y = parseFloat(coords[1]);
    v.z = parseFloat(coords[2]);
    return v;
}

// Convert roll, pitch, yaw (ZYX) angles (string) to XYZ euler angles (vector)
function rpy2xyz(rpy) {
    rpy = rpy.split(' ');
    var v = new THREE.Vector3();
    v.x = parseFloat(rpy[2]);
    v.y = parseFloat(rpy[1]);
    v.z = parseFloat(rpy[0]);
    return v;
}

// TODO: Switch to WebGLRobots
var hubo = new Hubo();
init();
requestAnimationFrame(animate);


// TODO: Delete this when everything else works hunky dory.
// function fixOrigin(obj,coords) {

//     coords = coords.split(' ');
//     x = parseFloat(coords[0]);
//     y = parseFloat(coords[1]);
//     z = parseFloat(coords[2]);

//     x0 = obj.position.x;
//     y0 = obj.position.y;
//     z0 = obj.position.z;

//     dx = x-x0;
//     dy = y-y0;
//     dz = z-z0;

//     obj.position.x += dx;
//     obj.position.y += dy;
//     obj.position.z += dz;

//     if (obj instanceof THREE.Mesh) {
//         obj.geometry.vertices.forEach( function(el,i,ar) {
//             el.x -= dx;
//             el.y -= dy;
//             el.z -= dz;
//         });
//         obj.geometry.verticesNeedUpdate = true;
//     }

//     for(var i in obj.children) {
//         node = obj.children[i];
//         if (node.hasOwnProperty('position')) {
//             node.position.x -= dx;
//             node.position.y -= dy;
//             node.position.z -= dz;
//         }
//     };

// }
