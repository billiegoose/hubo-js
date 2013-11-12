#
# Init Firebase
#
window.huboRef = new Firebase('https://hubo-firebase.firebaseIO.com')
window.jointRef = huboRef.child('joints')

#
# Setup Hubo-in-the-Browser
#
c = new WebGLRobots.DefaultCanvas("#hubo_container")

# TODO: make this a function
# # http://threejs.org/docs/#Reference/Extras.Geometries/CylinderGeometry
# rayx = new THREE.Mesh(new THREE.CylinderGeometry(.01, .01, .1, 24, 1, false),
#  new THREE.MeshNormalMaterial())
# c.scene.add(rayx)
# TODO: Make this a class
class FT_Axis
  constructor: (@name) ->
    # TODO: Use cylinder to make it thicker?
    @m_x = new THREE.ArrowHelper(new THREE.Vector3(1,0,0), new THREE.Vector3(0,0,0),0.1,0xFF0000)
    @m_y = new THREE.ArrowHelper(new THREE.Vector3(0,1,0), new THREE.Vector3(0,0,0),0.1,0x00FF00)
    @f_z = new THREE.ArrowHelper(new THREE.Vector3(0,0,-1), new THREE.Vector3(0,0,0),0.1,0x00FF00)
    @axis = new THREE.Object3D()
    @axis.add(@m_x)
    @axis.add(@m_y)
    @axis.add(@f_z)
    return @axis
  updateColor: () ->
    # Get mx_min, mx_max
    # Get value
    # Scale to get color
    # Set color
    # Repeat for m_y, f_z

window.hubo = new Hubo("hubo2", callback = ->
  
  # Once the URDF is completely loaded, this function is run.
  # Add your robot to the canvas.
  c.add hubo
  $("#load").hide()

  # Create FT display axes
  if not hubo.displays?
    hubo.displays = {}
  hubo.displays.FT_R_HAND = new FT_Axis("FT_R_HAND")
  hubo.displays.FT_L_HAND = new FT_Axis("FT_L_HAND")
  hubo.displays.FT_R_FOOT = new FT_Axis("FT_R_FOOT")
  hubo.displays.FT_L_FOOT = new FT_Axis("FT_L_FOOT")

  # Add the hand FT sensors to the wrist pitch links
  hubo.links.Body_RWP.add(hubo.displays.FT_R_HAND)
  hubo.links.Body_LWP.add(hubo.displays.FT_L_HAND)
  hubo.links.Body_RAR.add(hubo.displays.FT_R_FOOT)
  hubo.links.Body_LAR.add(hubo.displays.FT_L_FOOT)
  # The origin of wrist pitch link is in the middle of the wrist, so we will
  # offset the axis a bit so it is in the middle of the hand.
  hubo.displays.FT_R_HAND.position = new THREE.Vector3(0,0,-0.1)
  hubo.displays.FT_L_HAND.position = new THREE.Vector3(0,0,-0.1)
  hubo.displays.FT_R_FOOT.position = new THREE.Vector3(-0.05,0,-0.11)
  hubo.displays.FT_L_FOOT.position = new THREE.Vector3(-0.05,0,-0.11)


  # jointRef.once('value', (data) ->
  #     data.forEach((joint) ->
  #       hubo.motors[joint.name()].value = joint.pos());
  #     });
  # });

  # Create the Firebase update
  jointRef.on('child_changed', (snapshot) ->
    name = snapshot.name()
    joint = snapshot.val()
    hubo.motors[name].value = joint.pos
  )
  # Update the rendering to reflect any changes to Hubo.
  c.render()
, progress = (step, total, node) ->
  $("#load").html "Loading " + step + "/" + total
)

#
# Setup GUI
#
$("#mouse_info_dialog").dialog
  autoOpen: false
  closeOnEscape: true
  buttons:
    OK: ->
      $(this).dialog "close"

$("#mouse_info_button").on "click", ->
  $("#mouse_info_dialog").dialog "open"

