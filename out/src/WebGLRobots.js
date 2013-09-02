 /*
 * WebGLRobots.js
 * Author: William Hilton (wmhilton@gmail.com)
 * License: http://opensource.org/licenses/MIT
 */
var WebGLRobots = {version: 0.0};

WebGLRobots.str2vec = function(coords) {
    coords = coords.split(' ');
    var v = new THREE.Vector3();
    v.x = parseFloat(coords[0]);
    v.y = parseFloat(coords[1]);
    v.z = parseFloat(coords[2]);
    return v;
}

WebGLRobots.getDirName = function(filename) {
    return filename.replace(/[^\/\\]*$/,"");
}

WebGLRobots.DefaultCanvas = function(container, display_width, display_height) {
    if (display_width == null) {display_width = 480;};
    if (display_height == null) {display_height = display_width;};

    // renderer
    var renderer = Detector.webgl? new THREE.WebGLRenderer({antialias: true}): new THREE.CanvasRenderer();
    renderer.setSize(display_width, display_height);
    $(container).append(renderer.domElement);

    // scene
    var scene = new THREE.Scene();

    // camera
    var camera = new THREE.PerspectiveCamera( 60, display_width / display_height, 0.1, 1000 );
    camera.up = new THREE.Vector3( 0, 0, 1 ); // the example that we load has Z as the up axis
    camera.position.x = 1.45;
    camera.position.y = 0;
    camera.position.z = -0.1;
    // Note: The camera.lookAt(THREE.Vector3) function is rendered useless and overridden by controls.target

    // trackball controls
    var controls = new THREE.TrackballControls( camera, renderer.domElement );
    controls.rotateSpeed = 1.0;
    controls.zoomSpeed = 1.2;
    controls.panSpeed = 0.8;
    controls.staticMoving = true;
    controls.dynamicDampingFactor = 0.3;
    // Tell the trackball where to look. 
    // TODO: File bug with TrackballControls.js to have this set automatically set by the camera angle.
    controls.target=new THREE.Vector3(0,0,-0.3);
    controls.addEventListener( 'change', render );

    // Add some lights so we can see the robot 
    var ambient = new THREE.AmbientLight( 0x101030 );
    scene.add( ambient );

    var directionalLight = new THREE.DirectionalLight( 0xffeedd );
    directionalLight.position.set( 1, 0.1, 1 ).normalize();
    scene.add( directionalLight );

    var backlight = new THREE.DirectionalLight( 0xffeedd );
    backlight.position.set( -1, -0.1, -1 ).normalize();
    scene.add( backlight );

    // If the rendering canvas is desired at a size other than the default,
    // this function will resize the canvas and update the trackball control.
    function defaultResize(display_height, display_width) {
        renderer.setSize( display_width, display_height );
        controls.handleResize();
        render();
    }
    // Call controls.update() frequently
    function animate(timestamp) {
        requestAnimationFrame( animate );
        controls.update();
        // We do not call render() here. That would create a constant CPU load 
        // even when there is nothing moving in the scene. Instead, we will
        // only call render() when needed, for example after a joint value is
        // changed or when the trackball controls have updated the camera.
    }
    // controls.update() will call render() as it sees needed.
    function render(timestamp) {
        renderer.render( scene, camera );
    }

    // Begin the animation loop.
    requestAnimationFrame(animate);

    // Add a robot to the scene and set it's .canvas property.
    function add(robot) {
        // It might be possible for a robot to not have a single root object... I'm not sure.
        // Anyway, this should cover that possibility.
        robot.roots.forEach( function(obj) {
            scene.add(obj);
        });
        robot.canvas = this;
        robot.autorender = true;
        render();
    }

    // Export public variables.
    this.display_width = display_width;
    this.display_height = display_height;
    this.renderer = renderer;
    this.scene = scene;
    this.camera = camera;
    this.controls = controls;
    this.render = render;
    this.add = add;
    return this;
};

WebGLRobots.Robot = function() {
    var _robot = this;

    // Note that the Joint class references _robot, and therefore is unique to each instance of WebGLRobots.Robot
    // Specifically, joint = new WebGLRobots.Robot.Joint() // ERROR
    // robot = new WebGLRobots.Robot(); joint = new robot.Joint() // GOOD
    this.Joint = function Joint() {this._value = 0;};
    this.Joint.prototype = {
            get value() {
                return this._value; 
            },
            set value(val) {
                if (val < this.lower_limit) {
                    console.warn('Joint ' + this.name + ' tried to violate lower limit: ' + this.lower_limit);
                    val = this.lower_limit;
                } else if (val > this.upper_limit) {
                    console.warn('Joint ' + this.name + ' tried to violate upper limit: ' + this.upper_limit);
                    val = this.upper_limit;
                }
                this._value = val;
                //console.log('Set value to ' + val);
                if (!(typeof _robot === 'undefined')) {
                    var q = new THREE.Quaternion().setFromAxisAngle(this.axis, this._value);
                    this.child.rotation.setEulerFromQuaternion(q);
                    if (!(typeof _robot.canvas === 'undefined')) {                        
                        if (_robot.autorender) {
                            _robot.canvas.render();
                        }
                    }
                }
            }
        }

    this.links = new Dict();
    this.joints = new Dict();
    this.loadURDF = function(filename, callback, progress) {
        // A default progress callback - consider it an example.
        if (typeof progress === "undefined") {
            progress = function(step,total,node) {
                console.log("Link %i of %i: %s, %s", step, total, node.name, node.userData.filename);
            };
        }
        // Uses jQuery
        $.get(filename, function (data) {
            var path = WebGLRobots.getDirName(filename);
            var xml = $.parseXML(data);
            console.log('Inside loadURDF');
            links = $(xml).find('robot link');
            // Save the number of links there are total
            _robot.links.expectedCount = $(links).length;
            // Due to the asynchronous nature of AJAX file requests, we have to break up 
            // our code into a bunch of callbacks.
            var createLink = function(name, node, filename) {                
                // Improve appearance for canvas rendering.
                if (!Detector.webgl) {
                    if (node.children[0]) {
                        node.children[0].material.overdraw = true;
                    }
                }
                node.name = name;
                node.userData.filename = filename;
                _robot.links[name] = node;
                // Report progress
                progress(_robot.links.count, _robot.links.expectedCount+1, node);
                // When we have loaded all the links...
                if (_robot.links.count === _robot.links.expectedCount) { 
                    createJoints();
                }
            }
            // Once ALL the links are loaded, load joints.
            var createJoints = function() {
                $(xml).find("robot > joint").each( function() {
                    // Extract joint information from XML.
                    console.log("--");
                    var name = $(this).attr("name");
                    console.log("joint: " + name);
                    var child = $(this).find("child").attr("link");
                    console.log("child: " + child);
                    var parent = $(this).find("parent").attr("link");
                    console.log("parent: " + parent);
                    var coords = $(this).find("origin").attr("xyz");
                    console.log("coords: " + coords);
                    var rpy = $(this).find("origin").attr("rpy"); // roll, pitch, yaw
                    console.log("rpy: " + rpy); 
                    var axis = $(this).find("axis").attr("xyz");
                    console.log("axis: " + axis);
                    var limits = $(this).find("limit");
                    var lower = $(limits).attr("lower");
                    var upper = $(limits).attr("upper");
                    console.log("limits: " + lower + " to " + upper);

                    // Save values to Joint object.
                    var joint = new _robot.Joint();
                    joint.name = name;
                    joint.child = _robot.links[child];
                    joint.parent = _robot.links[parent];
                    // TODO: Figure out how to export these Vector3Ds in JSON, hmm.
                    joint.coords = WebGLRobots.str2vec(coords);
                    joint.rpy = WebGLRobots.str2vec(rpy);
                    joint.axis =  WebGLRobots.str2vec(axis);
                    joint.lower_limit = parseFloat(lower);
                    joint.upper_limit = parseFloat(upper);
                    _robot.joints[name] = joint;
                    // Do stuff
                    // Because the child link is offset and rotated from the parent link, but the axis of rotation
                    // for the child link is specified in the child CS, we need to apply a coordinate system transform between
                    // the child and the parent without disturbing the values of the child's rotation.
                    // The only way I can think of to do this at the moment of writing is to insert another Object3D in between
                    // the parent and child and apply the offset to the Object3D.
                    var obj = new THREE.Object3D();
                    obj.position = joint.coords;
                    // This nonsensical conversion is because ObjectExporter.js only saves the .position, .rotation., and .scale
                    // properties of an object. .eulerOrder, .quaternion, etc are all not preserved. Thus we must convert from
                    // roll, pitch, yaw 'ZYX' Euler angles to quaternion and then convert from quaternion to 'XYZ' Euler angles
                    var q = new THREE.Quaternion().setFromEuler(joint.rpy,"ZYX");
                    obj.rotation.setEulerFromQuaternion(q);
                    joint.parent.add(obj);
                    obj.add(joint.child);
                });
                // Determine which links have no parent, and thus are the root nodes to add to the scene.
                _robot.roots = [];
                _robot.links.asArray().forEach(function(link) {
                    if (typeof link.parent === 'undefined') {
                        _robot.roots.push(link);
                    }
                });
                callback();
            }
            // Load each link's mesh file
            $(links).each( function() {
                // We are being passed in a URDF <link> element.
                var name = $(this).attr("name");
                // TODO: Resolve whether to use the collision or visual geometry by default.
                // Right now I'm using the collision because it is smaller and looks nicer than the visual geometry for Hubo.
                var filename = $(this).find("collision geometry mesh").attr("filename");
                if (typeof filename === 'undefined') {
                    createLink(name, new THREE.Object3D());
                } else {
                    filename = path + filename;
                    // Load mesh
                    var loader = new ColladaLoader2();
                    loader.setLog(onLoaderLogMessage);
                    loader.load(filename, 
                        function(collada) {
                            var node = collada.scene;
                            createLink(name, node, filename);
                        }, 
                        onProgress);
                }
            });
        })
        .fail(function() { alert("error"); })
    };
        
    function onLoaderLogMessage(msg, type) {
        // Overloading the default (which is to console.log messages) to make it shut up.
        // var typeStr = ColladaLoader2.messageTypes[type];
        // console.log(typeStr + ": " + msg);
    }
    // TODO: Figure out how to show progress more effectively.
    function onProgress(data) {
        // data.total might be null if the server does not set the Content-Length header
        // if (data.total) {
        //     var percentLoaded = 100 * data.loaded / data.total;
        //     console.log("Load progress: " + percentLoaded.toFixed(0) + "%");
        // } else {
        //     console.log("Load progress: " + data.loaded + " bytes");
        //     document.getElementById('percentloaded').innerHTML = data.loaded;
        // }   
    }
};

// /* * * * * * * * *
//  * Example usage *
//  * * * * * * * * */
// c = new WebGLRobots.DefaultCanvas('#robot_container');
// r = new WebGLRobots.Robot();
// r.loadURDF("hubo-urdf/model.urdf", function() {
//     c.add(r);
// });