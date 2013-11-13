#
# Init Firebase
#
window.huboRef = new Firebase('https://hubo-firebase.firebaseIO.com')
window.jointRef = huboRef.child('joints')
window.ftRef = huboRef.child('ft')

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
class FT_Sensor
  constructor: (@name) ->
    # TODO: Use cylinder to make it thicker?
    @m_x_obj = new THREE.ArrowHelper(new THREE.Vector3(1,0,0), new THREE.Vector3(0,0,0),0.1,0xFF0000)
    @m_y_obj = new THREE.ArrowHelper(new THREE.Vector3(0,1,0), new THREE.Vector3(0,0,0),0.1,0x00FF00)
    @f_z_obj = new THREE.ArrowHelper(new THREE.Vector3(0,0,-1), new THREE.Vector3(0,0,0),0.1,0x00FF00)
    @axis = new THREE.Object3D()
    @axis.add(@m_x_obj)
    @axis.add(@m_y_obj)
    @axis.add(@f_z_obj)
  updateColor: () ->
    # Get mx_min, mx_max, etc
    mx_min = $("##{ @name } .m_x_min").val()
    mx_max = $("##{ @name } .m_x_max").val()
    # console.log("mx_min: #{mx_min}")
    # console.log("mx_max: #{mx_max}")
    my_min = $("##{ @name } .m_y_min").val()
    my_max = $("##{ @name } .m_y_max").val()
    fz_min = $("##{ @name } .f_z_min").val()
    fz_max = $("##{ @name } .f_z_max").val()
    # Scale 
    mx_gradient = interpColor(mx_min, mx_max, 0, @m_x)
    # console.log("mx_gradient: #{mx_gradient}")
    my_gradient = interpColor(my_min, my_max, 0, @m_y)
    fz_gradient = interpColor(fz_min, fz_max, 0, @f_z)
    # Set colors
    temp = new THREE.Color()
    temp.setRGB(mx_gradient,(1-mx_gradient),0)
    @axis.children[0].setColor(temp.getHex())

    temp.setRGB(my_gradient,(1-my_gradient),0)
    @axis.children[1].setColor(temp.getHex())

    temp.setRGB(fz_gradient,(1-fz_gradient),0)
    @axis.children[2].setColor(temp.getHex())

interpColor = (min,max,zero,t) ->
  if t > max
    t = max
  if t < min
    t = min
  if t < zero
    return Math.min((zero-t)/(zero-min),1)
  else
    return Math.min((t-zero)/(max-zero),1)

window.hubo = new Hubo("hubo2", callback = ->
  
  # Once the URDF is completely loaded, this function is run.
  # Add your robot to the canvas.
  c.add hubo
  $("#load").hide()

  # Create FT display axes
  if not hubo.ft?
    hubo.ft = {}
  hubo.ft.HUBO_FT_R_HAND = new FT_Sensor("HUBO_FT_R_HAND")
  hubo.ft.HUBO_FT_L_HAND = new FT_Sensor("HUBO_FT_L_HAND")
  hubo.ft.HUBO_FT_R_FOOT = new FT_Sensor("HUBO_FT_R_FOOT")
  hubo.ft.HUBO_FT_L_FOOT = new FT_Sensor("HUBO_FT_L_FOOT")

  # Add the hand FT sensors to the wrist pitch links
  hubo.links.Body_RWP.add(hubo.ft.HUBO_FT_R_HAND.axis)
  hubo.links.Body_LWP.add(hubo.ft.HUBO_FT_L_HAND.axis)
  hubo.links.Body_RAR.add(hubo.ft.HUBO_FT_R_FOOT.axis)
  hubo.links.Body_LAR.add(hubo.ft.HUBO_FT_L_FOOT.axis)
  # The origin of wrist pitch link is in the middle of the wrist, so we will
  # offset the axis a bit so it is in the middle of the hand.
  hubo.ft.HUBO_FT_R_HAND.axis.position = new THREE.Vector3(0,0,-0.1)
  hubo.ft.HUBO_FT_L_HAND.axis.position = new THREE.Vector3(0,0,-0.1)
  hubo.ft.HUBO_FT_R_FOOT.axis.position = new THREE.Vector3(-0.05,0,-0.11)
  hubo.ft.HUBO_FT_L_FOOT.axis.position = new THREE.Vector3(-0.05,0,-0.11)


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

  # Create the Firebase update
  ftRef.on('child_changed', (snapshot) ->
    name = snapshot.name()
    ft = snapshot.val()
    console.log('name: '+ name)
    console.log(ft)
    # TODO: Make part of class. Add setters/getters
    hubo.ft[name].m_x = ft.m_x
    hubo.ft[name].m_y = ft.m_y
    hubo.ft[name].f_z = ft.f_z
    hubo.ft[name].updateColor()
    hubo.canvas.render()
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

