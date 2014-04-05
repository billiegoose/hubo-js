DefaultCanvas = function(container, display_width, display_height) {
    if (display_width == null) {display_width = $(container).width();};
    if (display_height == null) {display_height = $(container).height();};

    // renderer
    var renderer = Detector.webgl? new THREE.WebGLRenderer({antialias: true}): new THREE.CanvasRenderer();
    renderer.setSize(display_width, display_height);
    // NOTE: I use prepend instead of append
    $(renderer.domElement).css("position","absolute");
    $(container).prepend(renderer.domElement);

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
    function resize(display_width, display_height) {
        $(renderer.domElement).attr({ 
            width: display_width,
            height: display_height
        });
        renderer.setSize( display_width, display_height );
        camera.aspect = display_width / display_height;
        camera.updateProjectionMatrix();
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
    function add(obj) {
        scene.add(obj);
        obj.canvas = this;
        render();
    }

    // Export public variables.
    this.display_width = display_width;
    this.display_height = display_height;
    this.renderer = renderer;
    this.scene = scene;
    this.camera = camera;
    this.controls = controls;
    this.resize = resize;
    this.render = render;
    this.add = add;
    return this;
};