#
# Init Firebase
#
window.stateRef = new Firebase('https://hubo-firebase.firebaseIO.com/state')

# TODO: make this a function
# # http://threejs.org/docs/#Reference/Extras.Geometries/CylinderGeometry
# rayx = new THREE.Mesh(new THREE.CylinderGeometry(.01, .01, .1, 24, 1, false),
#  new THREE.MeshNormalMaterial())
# c.scene.add(rayx)
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

#
# MAIN
#
$( document ).ready () ->
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

  window.stats = new Stats();
  stats.setMode(0); # 0: fps, 1: ms
  $('#hubo_container').append(stats.domElement)
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.left = '400px'
  stats.domElement.style.top = '0px'

  #
  # Setup Hubo-in-the-Browser
  #
  c = new WebGLRobots.DefaultCanvas("#hubo_container")
  window.hubo = new Hubo("hubo2", callback = ->    
    # Once the URDF is completely loaded, this function is run.
    # Add your robot to the canvas.
    c.add hubo
    hubo.autorender = false
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
    stateRef.on('value', (snapshot) ->
      # NOTE: With the stats library, we are timing the interval
      # between runs of this function, not the time needed to render
      # it. Therefore, we end recording at the beginning and begin recording
      # right away.
      stats.end();
      stats.begin();
      state = snapshot.val()

      # TODO: In the future, make this a loop rather than hard-coded.
      hubo.ft["HUBO_FT_R_HAND"].m_x = state.ft[0].m_x
      hubo.ft["HUBO_FT_R_HAND"].m_y = state.ft[0].m_y
      hubo.ft["HUBO_FT_R_HAND"].f_z = state.ft[0].f_z
      console.log(state.ft[0].m_y.toFixed(2)) #state.ft[0].m_x.toFixed(2) + ', ' + state.ft[0].m_y.toFixed(2) + ', ' + )
      hubo.ft["HUBO_FT_R_HAND"].updateColor()
      hubo.ft["HUBO_FT_L_HAND"].m_x = state.ft[1].m_x
      hubo.ft["HUBO_FT_L_HAND"].m_y = state.ft[1].m_y
      hubo.ft["HUBO_FT_L_HAND"].f_z = state.ft[1].f_z
      hubo.ft["HUBO_FT_L_HAND"].updateColor()
      hubo.ft["HUBO_FT_R_FOOT"].m_x = state.ft[2].m_x
      hubo.ft["HUBO_FT_R_FOOT"].m_y = state.ft[2].m_y
      hubo.ft["HUBO_FT_R_FOOT"].f_z = state.ft[2].f_z
      hubo.ft["HUBO_FT_R_FOOT"].updateColor()
      hubo.ft["HUBO_FT_L_FOOT"].m_x = state.ft[3].m_x
      hubo.ft["HUBO_FT_L_FOOT"].m_y = state.ft[3].m_y
      hubo.ft["HUBO_FT_L_FOOT"].f_z = state.ft[3].f_z
      hubo.ft["HUBO_FT_L_FOOT"].updateColor()

      # j2i = { "WST": 0
      #       , "NKY": 1
      #       , "NK1": 2
      #       , "NK2": 3
      #       , "LSP": 4
      #       , "LSR": 5
      #       , "LSY": 6
      #       , "LEB": 7
      #       , "LWY": 8
      #       , "LWR": 9
      #       , "LWP": 10
      #       , "RSP": 11
      #       , "RSR": 12
      #       , "RSY": 13
      #       , "REB": 14
      #       , "RWY": 15
      #       , "RWR": 16
      #       , "RWP": 17 #mind the gap
      #       , "LHY": 19
      #       , "LHR": 20
      #       , "LHP": 21
      #       , "LKN": 22
      #       , "LAP": 23
      #       , "LAR": 24 #mind the gap
      #       , "RHY": 26
      #       , "RHR": 27
      #       , "RHP": 28
      #       , "RKN": 29
      #       , "RAP": 30
      #       , "RAR": 31
      #       , "RF1": 32
      #       , "RF2": 33
      #       , "RF3": 34
      #       , "RF4": 35
      #       , "RF5": 36
      #       , "LF1": 37
      #       , "LF2": 38
      #       , "LF3": 39
      #       , "LF4": 40
      #       , "LF5": 41
      #       }
      hubo.motors["WST"].value = state.joint[0].ref
      hubo.motors["NKY"].value = state.joint[1].ref
      hubo.motors["NK1"].value = state.joint[2].ref
      hubo.motors["NK2"].value = state.joint[3].ref
      hubo.motors["LSP"].value = state.joint[4].ref
      hubo.motors["LSR"].value = state.joint[5].ref
      hubo.motors["LSY"].value = state.joint[6].ref
      hubo.motors["LEP"].value = state.joint[7].ref
      hubo.motors["LWY"].value = state.joint[8].ref
      # hubo.motors["LWR"].value = state.joint[9].ref
      hubo.motors["LWP"].value = state.joint[10].ref
      hubo.motors["RSP"].value = state.joint[11].ref
      hubo.motors["RSR"].value = state.joint[12].ref
      hubo.motors["RSY"].value = state.joint[13].ref
      hubo.motors["REP"].value = state.joint[14].ref
      hubo.motors["RWY"].value = state.joint[15].ref
      # hubo.motors["RWR"].value = state.joint[16].ref
      hubo.motors["RWP"].value = state.joint[17].ref
      # mind the gap
      hubo.motors["LHY"].value = state.joint[19].ref
      hubo.motors["LHR"].value = state.joint[20].ref
      hubo.motors["LHP"].value = state.joint[21].ref
      hubo.motors["LKP"].value = state.joint[22].ref
      hubo.motors["LAP"].value = state.joint[23].ref
      hubo.motors["LAR"].value = state.joint[24].ref
      # # mind the gap
      hubo.motors["RHY"].value = state.joint[26].ref
      hubo.motors["RHR"].value = state.joint[27].ref
      hubo.motors["RHP"].value = state.joint[28].ref
      hubo.motors["RKP"].value = state.joint[29].ref
      hubo.motors["RAP"].value = state.joint[30].ref
      hubo.motors["RAR"].value = state.joint[31].ref
      hubo.motors["RF1"].value = state.joint[32].ref
      hubo.motors["RF2"].value = state.joint[33].ref
      hubo.motors["RF3"].value = state.joint[34].ref    
      hubo.motors["RF4"].value = state.joint[35].ref
      hubo.motors["RF5"].value = state.joint[36].ref
      hubo.motors["LF1"].value = state.joint[37].ref
      hubo.motors["LF2"].value = state.joint[38].ref
      hubo.motors["LF3"].value = state.joint[39].ref
      hubo.motors["LF4"].value = state.joint[40].ref
      hubo.motors["LF5"].value = state.joint[41].ref
      # Needed for FT sensor updates. TODO: Make FT sensor updates run render themselves.
      hubo.canvas.render();
    )

    # # Create the Firebase update
    # jointRef.on('child_changed', (snapshot) ->
    #   name = snapshot.name()
    #   joint = snapshot.val()
    #   hubo.motors[name].value = joint.pos
    # )

    # # Create the Firebase update
    # ftRef.on('child_changed', (snapshot) ->
    #   name = snapshot.name()
    #   ft = snapshot.val()
    #   console.log('name: '+ name)
    #   console.log(ft)
    #   # TODO: Make part of class. Add setters/getters
    #   hubo.ft[name].m_x = ft.m_x
    #   hubo.ft[name].m_y = ft.m_y
    #   hubo.ft[name].f_z = ft.f_z
    #   hubo.ft[name].updateColor()
    #   hubo.canvas.render()
    # )

    # Update the rendering to reflect any changes to Hubo.
    c.render()
  , progress = (step, total, node) ->
    $("#load").html "Loading " + step + "/" + total
  )
