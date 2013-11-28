---
title: 'Hubo-in-the-Browser'
layout: "regular-layout"
isPage: true
---

Hubo-in-the-Browser
===================

This is the project page for Hubo-in-the-Browser, aka hubo-js. The goal of the project is to bring the humanoid robot Hubo, developed at KAIST and worked on at many US institutions as well, to the largest audience possible: the entire Internet.

Here is a short presentation about the project:

<iframe width="560" height="315" src="//www.youtube.com/embed/vUAm5sd3lIY" frameborder="0" allowfullscreen></iframe>

Examples
--------

If you are at this page, I assume you are looking for the demos. All the demos are simple static HTML/JavaScript pages, so you can see all the source code by using the "View Source" option in your web browser. All the source code is also found in the Github repository.

> [color-picker.html]({local_root}examples/color-picker/color-picker.html): Demo of the highlighting and color changing API.
>
> [trajectory_playback.html]({local_root}examples/trajectory_playback/trajectory_playback.html): Play the Rainbox, Inc mocap demos.
>
> [sliders.html]({local_root}examples/sliders/sliders.html): Position upper body joints with slider controls.
>
> [minimal.html]({local_root}examples/minimal/minimal.html): Minimalistic demo with single joint movement.
>
> [really_minimal.html]({local_root}examples/minimal/really_minimal.html): Embed hubo in an `<iframe>`.

Features
--------

Hubo-js is a fledgling robot simulator, and features are being added as the need arises.

* 3D display using WebGL that supports rotate, pan, and zoom.
* 58 joints that can be directly controlled using JavaScript.
* 40 degrees of freedom (matching the 40 motors on Hubo) that can be controlled using JavaScript.
  * The abstraction reduces the working DOF in the fingers.
* That's all for now.

Planned future features:

* Self-collision detection using THREE.js Rays
* Various inverse kinematic frameworks
* A mouse API to simplify writing code where users click or drag links and joints.

Using
-----

Checkout the Github repository (<http://github.com/wmhilton/hubo-js>) and look for instructions there.

Help Out
--------

Want to help with the project? Email <wmhilton@gmail.com>

<a href="https://github.com/wmhilton/hubo-js"><img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_red_aa0000.png" alt="Fork me on GitHub"></a>