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