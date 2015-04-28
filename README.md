Hubo-in-the-Browser
===================

This repository will contain a collection of web-based tools for Hubo, the humanoid robot. The full name of the project is Hubo-in-the-Browser, but for brevity it is also called hubo-js.

Examples
======== 

You can check out live examples hosted on <http://wmhilton.github.io/hubo-js> You can use the View Source option in your browser to look at the code, or you'll find the raw HTML/CSS/Javascript code for all the samples is in the `/out` directory.

How to develop/contribute
=========================

I'm using a tool called [docpad][] to make my web-developing more efficient. It is build on top of  another tool called [node][]. The source code that I actually edit is in `/src`. The core of Hubo-js is in `/src/src` and contains `WebGLRobots.js` and `hubo.coffee`. The source for the examples is in `/src/examples` obviously. If you want to develop/contribute, the easiest thing to do would be:

1. Install [node][]. **(Note: There have been reports that hubo-js doesn't work properly in Node version 0.12.x. Install the 0.10.x series. Hubo-in-the-Browser was last tested with node version 0.10.38)**
2. [Fork][] this repository.
3. `git clone https://github.com/[your-usename]/hubo-js`
4. `cd hubo-js`
5. `git submodule init`
6. `git submodule update`
7. `npm install`

To run:

1. `npm start`
2. Navigate to <http://localhost:9778>

And now you've got a live webserver that will transform the templates and stuff in `/src` into real web pages that you can see.

[docpad]: http://docpad.org/
[node]: http://nodejs.org/
[Fork]: https://github.com/wmhilton/hubo-js#fork-destination-box

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
