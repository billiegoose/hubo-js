# Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
c = new WebGLRobots.DefaultCanvas('#hubo_container')
# Create a new robot instance.
window.hubo = new Hubo 'hubo2'
  , callback = () ->
    # Once the URDF is completely loaded, this function is run.
    # Add your robot to the canvas.
    c.add(hubo)
    $('#load').hide()
    # Add clicking support
    c.projector = new THREE.Projector()
    $(c.renderer.domElement).on "mousedown", (event) ->
      # Compute the actual click coordinates. (Sheesh)
      click = {}
      click.x = event.clientX - $(this).offset().left
      click.y = event.clientY - $(this).offset().top
      # Magic code from the canvas_interactive_cubes.html example
      vector = new THREE.Vector3( ( click.x / c.display_width ) * 2 - 1, - ( click.y / c.display_height ) * 2 + 1, 0.5 )
      c.projector.unprojectVector( vector, c.camera )
      raycaster = new THREE.Raycaster( c.camera.position, vector.sub( c.camera.position ).normalize() )
      # Check the ray to see if it intersects objects. The second parameter sets recursive search to true.
      intersects = raycaster.intersectObjects( Array(hubo.links.Body_Torso), true)
      if ( intersects.length > 0 )
        hubo.unhighlightAll()
        $('#part').html(intersects[0].object.parent.name)
        intersects[0].object.parent.highlight()

  , progress = (step,total,node) ->
    $('#load').html("Loading " + step + "/" + total)

$('#mouse_info_dialog').dialog
  autoOpen: false
  closeOnEscape: true
  buttons: 
    OK: () -> 
      $(this).dialog('close')

$('#mouse_info_button').on 'click', () ->
    $('#mouse_info_dialog').dialog('open')