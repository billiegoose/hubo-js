*TO INSTALL*

You will need an Internet connection to complete the install process.

Prerequisites: an installation of hubo-ach and [node][].

* `git clone --recursive https://bitbucket.org/wmhilton/drchubo.js.git`
  * You may be prompted to enter your credentials twice, because of the private drchubo-urdf submodule.
* `cd drchubo.js`
* `./install_all.sh`

More instructions to follow

Hubo-in-the-Browser
===================

This repository will contain a collection of web-based tools for Hubo, the humanoid robot. The full name of the project is Hubo-in-the-Browser, but for brevity it is also called hubo-js.

Examples
======== 

You can check out live examples hosted on <http://wmhilton.github.io/hubo-js> You can use the View Source option in your browser to look at the code, or you'll find the raw HTML/CSS/Javascript code for all the samples is in the `/out` directory.

I want to embed Hubo in my webpage!
===================================

Great! Either do a git clone, or download a zip file of this repository. You'll need to copy these directories to your webserver: 

* `out/data/hubo-urdf` directory  
* `out/lib` directory  
* `out/src` directory

Then, in the webpage in which you want to insert Hubo, you'll need to add the following HTML:

```html
<div id="hubo_container">
  <button id="load">Load Hubo</button>
</div>
```

This creates the canvas for Hubo. To load Hubo onto that canvas, you append the following scripts to the bottom of the page, before the closing `</body>` tag.

```html
<!-- Used for rendering 3D Hubo -->
<script src="/lib/three/three.min.js"></script>
<script src="/lib/three/Detector.js"></script>
<script src="/lib/three/ColladaLoader2.js"></script>
<script src="/lib/three/TrackballControls.js"></script>
<!-- Our code -->
<script src="/lib/dict/dict.js"></script>
<script src="/src/WebGLRobots.js"></script>
<script src="/src/hubo.js"></script>
<script>
  $('#load').click(function() {
    $(this).html("Loading...");        
    // Create a THREE.WebGLRenderer() to host the robot.
    c = new WebGLRobots.DefaultCanvas('#hubo_container');
    // Create a new robot instance.
    window.hubo = new Hubo('hubo2',
      function callback() {
        // Add the robot to the canvas.
        c.add(hubo);
        $('#load').hide();
      },
      function progress(step,total,node) {
        $('#load').html("Loading " + step + "/" + total);
      });
  });
</script>
```

I probably need to make it even simpler. That's a lot of code to paste.

How to develop/contribute
=========================

I'm using a tool called [docpad][] to make my web-developing more efficient. It is build on top of  another tool called [node][]. The source code that I actually edit is in `/src`. The core of Hubo-js is in `/src/src` and contains `WebGLRobots.js` and `hubo.coffee`. The source for the examples is in `/src/examples` obviously. If you want to develop/contribute, the easiest thing to do would be:

1. Clone this repository
2. Install [node][]
3. Open the command line, go to the repository directory and run `npm install`
4. Then run `npm start`
5. Navigate to <http://localhost:9778>

And now you've got a live webserver that will transform the templates and stuff in `/src` into real web pages that you can see.

[docpad]: http://docpad.org/
[node]: http://nodejs.org/


Hubo-in-the-Browser API
=======================

`var hubo = new Hubo(name, ready_callback, progress_callback)`
  * `name` is a string to identify the Hubo, in case you have multiple Hubos.
  * `ready_callback()` is a function handle that is called once the Hubo is finished loading.
  * `progress_callback(num_links_loaded, total_links, link)` is a function handle that is called as each link of Hubo's body loads, so you can display loading progress.

`hubo.reset()`
  * Sets Hubo back to his default joint values.

`hubo.motors[]`
  * A collection of objects that correspond to the joints in hubo-ach. Each motor has the following properties:
    * `name` an identifier, like 'RSP' for right shoulder pitch
    * `value` sets and gets the value of the joint
      * The unit is in radians for revolute joints and mm for linear actuators.
      * Trying to set value beyond the `lower_limit` or `upper_limit` will result in the motor stopping at that limit.
    * `lower_limit` the lower bound allowed for `value`
    * `upper_limit` the upper bound allowed for `value`
    * `default_value` the value of the joint in the 'home' position

`hubo.links[]`
  * A collection of the THREE.Object3D's that make up the links of Hubo's body.

`hubo.joints[]`    
  * Hint: You should use `hubo.motors` instead, because it provides an accurate abstraction for moving the fingers and head.
  * A collection of raw joint objects corresponding to the joints in the URDF file for Hubo. Joint objects have properties similar to those in `hubo.motors`.


Troubleshooting
===============

#### I downloaded the webpages and opened them locally, but it doesn't work.

* AJAX commands won't work locally. You have to have a local HTTP server like [node][].
