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

This creates the canvas for Hubo. To load Hubo onto that canvas, you append the following scripts to the bottom of the page, before the closing `<body>` tag.

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


Hubo-in-the-Browser API
=======================

I should document this. Suffice it for now to say, there are two collections: `hubo.joints` and `hubo.motors`. Joints provides direct control. Motors provides direct control for most joints, and also abstractions for moving the fingers and neck.

Code Structure
==============

I'm using a tool called [docpad][] to make my web-developing more efficient. It is build on top of  another tool called [node][]. The source code that I actually edit is in `/src`. The core of Hubo-js is in `/src/src` and contains `WebGLRobots.js` and `hubo.coffee`. The source for the examples is in `/src/examples` obviously. If you want to develop/contribute, the easiest thing to do would be:

1. Clone this repository
2. Install [node][]
3. Open the command line, go to the repository directory and run `npm install`
4. Then run `npm start`
5. Navigate to `http://localhost:9778`

And now you've got a live webserver that will transform the templates and stuff in `/src` into real web pages that you can see.

[docpad]: http://docpad.org/
[node]: http://nodejs.org/


Troubleshooting
===============

#### I downloaded the webpages and opened them locally, but it doesn't work.

* AJAX commands won't work locally. You have to have a local HTTP server like
 `node`.
