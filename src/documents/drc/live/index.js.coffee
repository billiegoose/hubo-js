use_socket = true;

if (use_socket)
  socket = io.connect(':6060');
else
  #
  # Init Firebase
  #
  window.serial_stateRef = new Firebase('http://drc-hubo.firebaseIO.com/serial_state')

window.ledTimeoutId = null;
flashLED = () ->
  # Cancel the previous timeout.
  window.clearTimeout(window.ledTimeoutId)
  $('#led').show()
  # If we don't get more data soon, hide the LED.
  window.ledTimeoutId = setTimeout(()->
    $('#led').hide()
  , 100)

# TODO: make this a function
# # http://threejs.org/docs/#Reference/Extras.Geometries/CylinderGeometry
# rayx = new THREE.Mesh(new THREE.CylinderGeometry(.01, .01, .1, 24, 1, false),
#  new THREE.MeshNormalMaterial())
# c.scene.add(rayx)
class FT_Sensor
  constructor: (@name) ->
    # TODO: Use cylinder to make it thicker?
    @m_x_obj = new THREE.ArrowHelper(new THREE.Vector3(1,0,0), new THREE.Vector3(0,0,0),0.15,0xFF0000)
    @m_y_obj = new THREE.ArrowHelper(new THREE.Vector3(0,1,0), new THREE.Vector3(0,0,0),0.15,0x00FF00)
    @f_z_obj = new THREE.ArrowHelper(new THREE.Vector3(0,0,-1), new THREE.Vector3(0,0,0),0.15,0x0000FF)
    @axis = new THREE.Object3D()
    @axis.add(@m_x_obj)
    @axis.add(@m_y_obj)
    @axis.add(@f_z_obj)
  updateColor: (o) ->
    # Get mx_min, mx_max, etc
    # Scale 
    mx_gradient = interpColor(o.mx_min, o.mx_max, 0, @m_x)
    # console.log("mx_gradient: #{mx_gradient}")
    my_gradient = interpColor(o.my_min, o.my_max, 0, @m_y)
    fz_gradient = interpColor(o.fz_min, o.fz_max, 0, @f_z)
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

extractLimits = (el) ->
  o = {}
  o.mx_min = $(el).find(".m_x_min").val()
  o.mx_max = $(el).find(".m_x_max").val()
  # console.log("mx_min: #{mx_min}")
  # console.log("mx_max: #{mx_max}")
  o.my_min = $(el).find(".m_y_min").val()
  o.my_max = $(el).find(".m_y_max").val()
  o.fz_min = $(el).find(".f_z_min").val()
  o.fz_max = $(el).find(".f_z_max").val()
  return o

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
  stats.domElement.style.position = 'relative'
  stats.domElement.style.float = 'right'

  $(window).on('orientationchange', () ->
    size = Math.min($(window).width(), $(window).height())
    $('#hubo_container').width(size)
    $('#hubo_container').height(size)
    # $(hubo.canvas.renderer.domElement).attr({ width: size, height: size})
    hubo.canvas.resize(size, size)
  );

  #
  # Setup Hubo-in-the-Browser
  #
  # I appologize that this cannot be done with CSS.
  size = Math.min($(window).width(), $(window).height())
  $('#hubo_container').width(size)
  $('#hubo_container').height(size)
  c = new Hubo.DefaultCanvas("#hubo_container")
  window.hubo = new Hubo("hubo2", callback = ->    
    # Once the URDF is completely loaded, this function is run.
    # Add your robot to the canvas.
    c.add hubo
    # TODO: Override WebGLR
    # hubo.canvas.controls.target=new THREE.Vector3(0,0,-0.4);
    hubo.autorender = false
    $("#load").hide()

    # Create FT display axes
    if not hubo.ft?
      hubo.ft = {}
    hubo.ft.HUBO_FT_R_HAND = new FT_Sensor()
    hubo.ft.HUBO_FT_L_HAND = new FT_Sensor()
    hubo.ft.HUBO_FT_R_FOOT = new FT_Sensor()
    hubo.ft.HUBO_FT_L_FOOT = new FT_Sensor()

    # Add the hand FT sensors to the wrist pitch links
    hubo.links.Body_RWR.add(hubo.ft.HUBO_FT_R_HAND.axis)
    hubo.links.Body_LWR.add(hubo.ft.HUBO_FT_L_HAND.axis)
    hubo.links.Body_RAR.add(hubo.ft.HUBO_FT_R_FOOT.axis)
    hubo.links.Body_LAR.add(hubo.ft.HUBO_FT_L_FOOT.axis)
    # The origin of wrist pitch link is in the middle of the wrist, so we will
    # offset the axis a bit so it is in the middle of the hand.
    hubo.ft.HUBO_FT_R_HAND.axis.position = new THREE.Vector3(0.1,0,0)
    hubo.ft.HUBO_FT_L_HAND.axis.position = new THREE.Vector3(0.1,0,0)
    hubo.ft.HUBO_FT_R_FOOT.axis.position = new THREE.Vector3(-0.05,0,-0.15)
    hubo.ft.HUBO_FT_L_FOOT.axis.position = new THREE.Vector3(-0.05,0,-0.15)
    # Looks like the wrists need some rotation too.
    hubo.ft.HUBO_FT_R_HAND.axis.rotation.y = -Math.PI/2
    hubo.ft.HUBO_FT_L_HAND.axis.rotation.y = -Math.PI/2

    updateModel = (serial_state) ->
      state = JSON.parse(serial_state);
      # console.log(state);

      jointType = $('#joint-toggle').val() #'ref' # or 'pos'

      hand_limits = extractLimits($('#ft_hand_limits'))
      foot_limits = extractLimits($('#ft_foot_limits'))
      hubo.ft["HUBO_FT_R_HAND"].m_x = state.ft[0]
      # $('#huge_display').html(state.ft[0]);
      hubo.ft["HUBO_FT_R_HAND"].m_y = state.ft[1]
      hubo.ft["HUBO_FT_R_HAND"].f_z = state.ft[2]
      hubo.ft["HUBO_FT_R_HAND"].updateColor(hand_limits)
      hubo.ft["HUBO_FT_L_HAND"].m_x = state.ft[3]
      hubo.ft["HUBO_FT_L_HAND"].m_y = state.ft[4]
      hubo.ft["HUBO_FT_L_HAND"].f_z = state.ft[5]
      hubo.ft["HUBO_FT_L_HAND"].updateColor(hand_limits)
      hubo.ft["HUBO_FT_R_FOOT"].m_x = state.ft[6]
      hubo.ft["HUBO_FT_R_FOOT"].m_y = state.ft[7]
      hubo.ft["HUBO_FT_R_FOOT"].f_z = state.ft[8]
      hubo.ft["HUBO_FT_R_FOOT"].updateColor(foot_limits)
      hubo.ft["HUBO_FT_L_FOOT"].m_x = state.ft[9]
      hubo.ft["HUBO_FT_L_FOOT"].m_y = state.ft[10]
      hubo.ft["HUBO_FT_L_FOOT"].f_z = state.ft[11]
      hubo.ft["HUBO_FT_L_FOOT"].updateColor(foot_limits)

      hubo.motors["WST"].value = state[jointType][0]
      hubo.motors["NKY"].value = state[jointType][1]
      hubo.motors["NK1"].value = state[jointType][2]
      hubo.motors["NK2"].value = state[jointType][3]
      hubo.motors["LSP"].value = state[jointType][4]
      hubo.motors["LSR"].value = state[jointType][5]
      hubo.motors["LSY"].value = state[jointType][6]
      hubo.motors["LEB"].value = state[jointType][7]
      hubo.motors["LWY"].value = state[jointType][8]
      hubo.motors["LWR"].value = state[jointType][9]
      hubo.motors["LWP"].value = state[jointType][10]
      hubo.motors["RSP"].value = state[jointType][11]
      hubo.motors["RSR"].value = state[jointType][12]
      hubo.motors["RSY"].value = state[jointType][13]
      hubo.motors["REB"].value = state[jointType][14]
      hubo.motors["RWY"].value = state[jointType][15]
      hubo.motors["RWR"].value = state[jointType][16]
      hubo.motors["RWP"].value = state[jointType][17]
      # mind the gap
      hubo.motors["LHY"].value = state[jointType][19]
      hubo.motors["LHR"].value = state[jointType][20]
      hubo.motors["LHP"].value = state[jointType][21]
      hubo.motors["LKN"].value = state[jointType][22]
      hubo.motors["LAP"].value = state[jointType][23]
      hubo.motors["LAR"].value = state[jointType][24]
      # mind the gap
      hubo.motors["RHY"].value = state[jointType][26]
      hubo.motors["RHR"].value = state[jointType][27]
      hubo.motors["RHP"].value = state[jointType][28]
      hubo.motors["RKN"].value = state[jointType][29]
      hubo.motors["RAP"].value = state[jointType][30]
      hubo.motors["RAR"].value = state[jointType][31]
      hubo.motors["RF1"].value = state[jointType][32]
      # hubo.motors["RF2"].value = state[jointType][33]
      # hubo.motors["RF3"].value = state[jointType][34]    
      # hubo.motors["RF4"].value = state[jointType][35]
      # hubo.motors["RF5"].value = state[jointType][36]
      hubo.motors["LF1"].value = state[jointType][37]
      # hubo.motors["LF2"].value = state[jointType][38]
      # hubo.motors["LF3"].value = state[jointType][39]
      # hubo.motors["LF4"].value = state[jointType][40]
      # hubo.motors["LF5"].value = state[jointType][41]
      hubo.canvas.render()

    if (use_socket)
      socket.on('serial_state', (serial_state) ->
        # console.log(serial_state)
        window.serial_state = serial_state
        # LED status indicator
        flashLED()
        updateModel(serial_state)
      )
    else
      # Create the Firebase update
      serial_stateRef.on('value', (snapshot) ->
        # NOTE: With the stats library, we are timing the interval
        # between runs of this function, not the time needed to render
        # it. Therefore, we end recording at the beginning and begin recording
        # right away.
        stats.end();
        stats.begin();
        serial_state = snapshot.val()
        window.serial_state = serial_state
        # console.log(serial_state)
        # LED status indicator
        flashLED()
        updateModel(serial_state)
      )

    $('#joint-toggle').on 'slidestop', () ->
      updateModel(window.serial_state)

    # Update the rendering to reflect any changes to Hubo.
    c.render()
  , progress = (step, total, node) ->
    $("#load").html "Loading " + step + "/" + total
  )
