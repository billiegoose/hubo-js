# Using namespace LIVE
LIVE = {}
LIVE.use_socket = true;
LIVE.connectionEstablished = $.Deferred()

LIVE.connectToServer = () ->
  if (LIVE.use_socket)
    console.log('Trying to connect to server...')
    if (window.document.domain == "wmhilton.com") 
      # wmhilton.com behavior. The socketio server is running on Serenity at Drexel.
      server_address = 'hubovision.us:6060'
    else 
      # Default behavior. The socketio server is running on same computer as HTML server.
      server_address = ':6060' 
    LIVE.socket = io.connect(server_address, {'force new connection':true, timeout: 3000})
    socket = LIVE.socket
    # Due to a design flaw in socket.io? the events won't work if the initial
    # connection fails due to the server not running.
    # Therefore we manually will keep trying to reconnect until we establish an
    # initial connection.
    connectTimeoutId = setTimeout( LIVE.connectToServer, 5000 )

    socket.on 'connect', () -> 
      console.log('connect')
      window.clearTimeout(connectTimeoutId)
      LIVE.connectionEstablished.resolve()
    # Debugging
    socket.on 'connecting', () -> console.log('connecting')
    socket.on 'disconnect', () -> console.log('disconnect')
    socket.on 'connect_failed', () -> console.log('connect_failed')
    socket.on 'reconnect', () -> console.log('reconnect')
    socket.on 'reconnecting', () -> console.log('reconnecting')
    socket.on 'reconnect_failed', () -> console.log('reconnect_failed')
  else
    #
    # Init Firebase
    #
    serial_stateRef = new Firebase('http://hubo-firebase.firebaseIO.com/serial_state')
    # Create the Firebase update
    serial_stateRef.on 'value', (snapshot) ->
      # NOTE: With the stats library, we are timing the interval
      # between runs of this function, not the time needed to render
      # it. Therefore, we end recording at the beginning and begin recording
      # right away.
      serial_state = snapshot.val()
      # console.log(serial_state)
      # LED status indicator
      flashLED()
      updateModel(serial_state)

# Closure for LED Timeout
do ->
  ledTimeoutId = null;
  LIVE.flashLED = () ->
    # Cancel the previous timeout.
    window.clearTimeout(ledTimeoutId)
    $('#led').show()
    # If we don't get more data soon, hide the LED.
    ledTimeoutId = setTimeout( ()->
      $('#led').hide()
    , 200) # TODO: Make this a function of the update frequency. TODO: Have the server tell the client the update frequency.

# Everybody needs a lerp (Linear intERPolation) every now and then.
# Mine is special, because it considers relative distance from 'zero' to be 
# the thing being measured. (E.g. 0 is green, -5 or +10 are red type of scenarios.)
lerp = (min,max,zero,t) ->
  if t > max
    t = max
  if t < min
    t = min
  if t < zero
    return Math.min((zero-t)/(zero-min),1)
  else
    return Math.min((t-zero)/(max-zero),1)

# A class to display FT sensors in the GUI
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
    mx_gradient = lerp(o.mx_min, o.mx_max, 0, @m_x)
    # console.log("mx_gradient: #{mx_gradient}")
    my_gradient = lerp(o.my_min, o.my_max, 0, @m_y)
    fz_gradient = lerp(o.fz_min, o.fz_max, 0, @f_z)
    # Set colors
    @axis.children[0].setColor(computeColor(mx_gradient).getHex())
    @axis.children[1].setColor(computeColor(my_gradient).getHex())
    @axis.children[2].setColor(computeColor(fz_gradient).getHex())
    # temp = new THREE.Color()

    # temp.setRGB(mx_gradient,(1-mx_gradient),0)
    # @axis.children[0].setColor(temp.getHex())

    # temp.setRGB(my_gradient,(1-my_gradient),0)
    # @axis.children[1].setColor(temp.getHex())

    # temp.setRGB(fz_gradient,(1-fz_gradient),0)
    # @axis.children[2].setColor(temp.getHex())
  computeColor = (t) ->
    temp = new THREE.Color()
    y = $('#color_limits .y_threshold').val()
    if t > y
      temp.setRGB(
        1,
        1-lerp(y,1,0,t),
        0)
    else
      temp.setRGB(
        lerp(0,y,0,t),
        1,
        0)
    return temp

class LIVE.PowerCircle
  constructor: (opts) ->
    if opts?
      {name, radius, segments, color} = opts
    name ?= 'circle'
    radius ?= 5
    segments ?= 32
    color ?= 0xff8800

    material = new THREE.MeshBasicMaterial({color: color, side: THREE.DoubleSide, opacity: 0.5, transparent: true});
    # geo = new THREE.CircleGeometry( radius, segments ); 
    geo = new THREE.CylinderGeometry( radius, radius, 0.01, segments ); 
    # geo = new THREE.TorusGeometry( radius, 0.005, 8, segments );
    @object = new THREE.Mesh( geo, material);
    @object.name = name

# Get the range of safe FT values from the GUI textboxes (currently hidden because they're ugly, 
# so you are stuck with the default values).
extractLimits = (el) ->
  o = {}
  o.mx_min = $(el).find(".m_x_min").val()
  o.mx_max = $(el).find(".m_x_max").val()
  o.my_min = $(el).find(".m_y_min").val()
  o.my_max = $(el).find(".m_y_max").val()
  o.fz_min = $(el).find(".f_z_min").val()
  o.fz_max = $(el).find(".f_z_max").val()
  return o

# Resize the canvas (to deal with tablet orientation, desktop window resizing, etc)
adaptCanvasSize = (c) ->
  if (document.webkitIsFullScreen)
    width = $(window).width()
    height = $(window).height()
  else
    width = Math.min($(window).width(), $(window).height())
    height = width
  $('#hubo_container').width(width)
  $('#hubo_container').height(height)
  c.resize(width, height)

# Add the FPS counter
addStats = () ->  
  stats = new Stats()
  stats.setMode(0); # 0: fps, 1: ms
  $('#hubo_container').append(stats.domElement)
  stats.domElement.style.position = 'relative'
  stats.domElement.style.cssFloat = 'right'
  LIVE.stats = stats

LIVE.setCircleVisibility = (val) ->
  for joint in LIVE.hubo.joints.asArray()
    if joint.circle?
      joint.circle.object.visible = val

#
# MAIN
#
$( document ).ready () ->
  #
  # Setup live data feed
  #
  LIVE.connectToServer()

  #
  # Setup GUI
  #
  addStats()

  #
  # Setup Hubo-in-the-Browser
  #
  c = new Hubo.DefaultCanvas("#hubo_container")
  adaptCanvasSize(c);

  # Deal with tablet screen orientation and window resizes
  $(window).on('orientationchange resize', () ->
    # I added a delay to this effect because I found that the size recalculation
    # is more reliable if we wait a moment after the orientation change.
    setTimeout(adaptCanvasSize(c), 500)
  );

  # Create a floor
  texture = THREE.ImageUtils.loadTexture('checkerboard.png', THREE.Linear)
  texture.wrapS = THREE.RepeatWrapping;
  texture.wrapT = THREE.RepeatWrapping;
  texture.repeat.x = 20;
  texture.repeat.y = 20;
  floorG = new THREE.PlaneGeometry(20, 20)
  floorM = new THREE.MeshBasicMaterial({map: texture})
  LIVE.floor = new THREE.Mesh(floorG, floorM)
  LIVE.floor.overdraw = true;
  c.scene.add(LIVE.floor);

  hubo = new Hubo("hubo2", callback = ->
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
    # Place floor slightly below foot axis.
    c.render() # Needed to force foot axis matrix to update.
    LIVE.floor.position.z = hubo.ft.HUBO_FT_L_FOOT.axis.localToWorld(new THREE.Vector3(0,0,-0.01)).z
    # # Looks like the wrists need some rotation too.
    # hubo.ft.HUBO_FT_R_HAND.axis.rotation.y = -Math.PI/2
    # hubo.ft.HUBO_FT_L_HAND.axis.rotation.y = -Math.PI/2

    # # Test of new power consumption circles.
    # power_circle_data = 
    #   REB:
    #     py: -0.08
    #     rx: 90*Math.PI/180
    #   RSP:
    #     py: -0.15
    #     rx: 90*Math.PI/180
    #   RSR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   RSY:
    #     pz: -0.05  
    #     r: 0.07
    #   RWY:
    #     pz: 0.05
    #     r: 0.07
    #   RWP:
    #     py: -0.07
    #     rx: 90*Math.PI/180
    #   RHP:
    #     py: -0.03
    #     rx: 90*Math.PI/180
    #   RHR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   RHY:
    #     pz: -0.015
    #     r: 0.08 
    #   RKN:
    #     py: -0.07
    #     rx: 90*Math.PI/180
    #   RAR:
    #     px: 0.04
    #     ry: 90*Math.PI/180
    #   RAP:
    #     py: -0.04
    #     rx: 90*Math.PI/180
    #   LEB:
    #     py: 0.08
    #     rx: 90*Math.PI/180
    #   LSP:
    #     py: 0.15
    #     rx: 90*Math.PI/180
    #   LSR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   LSY:
    #     pz: -0.05  
    #     r: 0.07
    #   LWY:
    #     pz: 0.05
    #     r: 0.07
    #   LWP:
    #     py: 0.07
    #     rx: 90*Math.PI/180
    #   LHP:
    #     py: 0.03
    #     rx: 90*Math.PI/180
    #   LHR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   LHY:
    #     pz: -0.015
    #     r: 0.08 
    #   LKN:
    #     py: 0.07
    #     rx: 90*Math.PI/180
    #   LAR:
    #     px: 0.04
    #     ry: 90*Math.PI/180
    #   LAP:
    #     py: 0.04
    #     rx: 90*Math.PI/180
    #   WST:
    #     r: 0.20
    #     pz: 0.01

    # Test of new power consumption cylinders.
    power_circle_data = 
      REB:
        py: -0.08
        # rx: 90*Math.PI/180
      RSP:
        py: -0.15
        # rx: 90*Math.PI/180
      RSR:
        px: 0.05
        rz: 90*Math.PI/180
      RSY:
        pz: -0.05  
        r: 0.07
        rx: 90*Math.PI/180
      RWY:
        pz: 0.05
        r: 0.07
        rx: 90*Math.PI/180
      RWP:
        py: -0.07
        # rx: 90*Math.PI/180
      RHP:
        py: -0.03
        # rx: 90*Math.PI/180
      RHR:
        px: 0.05
        rz: 90*Math.PI/180
      RHY:
        pz: -0.015
        r: 0.08 
        rx: 90*Math.PI/180
      RKN:
        py: -0.07
        # rx: 90*Math.PI/180
      RAR:
        px: 0.04
        rz: 90*Math.PI/180
      RAP:
        py: -0.04
        # rx: 90*Math.PI/180
      LEB:
        py: 0.08
        # rx: 90*Math.PI/180
      LSP:
        py: 0.15
        # rx: 90*Math.PI/180
      LSR:
        px: 0.05
        rz: 90*Math.PI/180
      LSY:
        pz: -0.05  
        rx: 90*Math.PI/180
        r: 0.07
      LWY:
        pz: 0.05
        rx: 90*Math.PI/180
        r: 0.07
      LWP:
        py: 0.07
        # rx: 90*Math.PI/180
      LHP:
        py: 0.03
        # rx: 90*Math.PI/180
      LHR:
        px: 0.05
        rz: 90*Math.PI/180
      LHY:
        pz: -0.015
        rx: 90*Math.PI/180
        r: 0.08 
      LKN:
        py: 0.07
        # rx: 90*Math.PI/180
      LAR:
        px: 0.04
        rz: 90*Math.PI/180
      LAP:
        py: 0.04
        # rx: 90*Math.PI/180
      WST:
        r: 0.20
        pz: 0.01
        rx: 90*Math.PI/180

    # # Test of new power consumption torus. 
    # # TODO: USE AS JOINT SELECTION GUI
    # power_circle_data = 
    #   REB:
    #     py: -0.015
    #     rx: 90*Math.PI/180
    #   RSP:
    #     py: -0.075
    #     rx: 90*Math.PI/180
    #     r: 0.07
    #   RSR:
    #     px: -0.02
    #     ry: 90*Math.PI/180
    #     r: 0.06
    #   RSY:
    #     pz: -0.05  
    #     # r: 0.07
    #   RWY:
    #     pz: 0.06
    #   RWP:
    #     py: -0.01
    #     rx: 90*Math.PI/180
    #   RHP:
    #     py: -0.03
    #     rx: 90*Math.PI/180
    #   RHR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   RHY:
    #     pz: -0.015
    #     r: 0.08 
    #   RKN:
    #     py: -0.07
    #     rx: 90*Math.PI/180
    #   RAR:
    #     px: 0.04
    #     ry: 90*Math.PI/180
    #   RAP:
    #     py: -0.04
    #     rx: 90*Math.PI/180
    #   LEB:
    #     py: 0.08
    #     rx: 90*Math.PI/180
    #   LSP:
    #     py: 0.15
    #     rx: 90*Math.PI/180
    #   LSR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   LSY:
    #     pz: -0.05  
    #     r: 0.07
    #   LWY:
    #     pz: 0.05
    #     r: 0.07
    #   LWP:
    #     py: 0.01
    #     rx: 90*Math.PI/180
    #   LHP:
    #     py: 0.03
    #     rx: 90*Math.PI/180
    #   LHR:
    #     px: 0.05
    #     ry: 90*Math.PI/180
    #   LHY:
    #     pz: -0.015
    #     r: 0.08 
    #   LKN:
    #     py: 0.07
    #     rx: 90*Math.PI/180
    #   LAR:
    #     px: 0.04
    #     ry: 90*Math.PI/180
    #   LAP:
    #     py: 0.04
    #     rx: 90*Math.PI/180
    #   WST:
    #     r: 0.20
    #     pz: 0.01

    for k, v of power_circle_data
      r = v.r ? 0.05
      circle = new LIVE.PowerCircle(name: 'circle', radius: r)
      o = circle.object
      if (v.px?)
        o.position.x = v.px
      if (v.py?)
        o.position.y = v.py
      if (v.pz?)
        o.position.z = v.pz
      if (v.rx?)
        o.rotation.x = v.rx
      if (v.ry?)
        o.rotation.y = v.ry
      if (v.rz?)
        o.rotation.z = v.rz
      if (hubo.joints[k]?)        
        hubo.joints[k].circle = circle
        hubo.joints[k].child.add(o)
    LIVE.setCircleVisibility(false)

    updateModel = (serial_state) ->
      if (not serial_state? or serial_state == "")
        return

      state = JSON.parse(serial_state);
      # console.log(state);

      jointType = $('input[name="angle-source"]:checked').val() #'ref' # or 'pos' 
      showCurrent = $('input[name="current-source"]:checked').val() #'off' # or 'glow' or 'circles'

      # FT
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

      # IMU
      hubo.links.Body_Torso.rotation.x = state.imu[2].a_x;
      hubo.links.Body_Torso.rotation.y = state.imu[2].a_y;
      hubo.links.Body_Torso.rotation.z = state.imu[2].a_z;

      # Joints
      hubo.motors["WST"].value = state[jointType][0]
      hubo.motors["NKY"].value = state[jointType][1]
      # hubo.motors["NK1"].value = state[jointType][2]
      # hubo.motors["NK2"].value = state[jointType][3]
      hubo.motors["LSP"].value = state[jointType][4]
      hubo.motors["LSR"].value = state[jointType][5]
      hubo.motors["LSY"].value = state[jointType][6]
      hubo.motors["LEB"].value = state[jointType][7]
      hubo.motors["LWY"].value = state[jointType][8]
      # hubo.motors["LWR"].value = state[jointType][9]
      hubo.motors["LWP"].value = state[jointType][10]
      hubo.motors["RSP"].value = state[jointType][11]
      hubo.motors["RSR"].value = state[jointType][12]
      hubo.motors["RSY"].value = state[jointType][13]
      hubo.motors["REB"].value = state[jointType][14]
      hubo.motors["RWY"].value = state[jointType][15]
      # hubo.motors["RWR"].value = state[jointType][16]
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
      hubo.motors["RF2"].value = state[jointType][33]
      hubo.motors["RF3"].value = state[jointType][34]    
      hubo.motors["RF4"].value = state[jointType][35]
      hubo.motors["RF5"].value = state[jointType][36]
      hubo.motors["LF1"].value = state[jointType][37]
      hubo.motors["LF2"].value = state[jointType][38]
      hubo.motors["LF3"].value = state[jointType][39]
      hubo.motors["LF4"].value = state[jointType][40]
      hubo.motors["LF5"].value = state[jointType][41]

      # Current
      if (showCurrent == 'glow')
        hubo.joints["WST"].child.color.setRGB(0.866667+100*state.cur[ 0]*state.cur[ 0],0.866667+50*state.cur[ 0]*state.cur[ 0],0.866667)
        hubo.joints["NKY"].child.color.setRGB(0.866667+100*state.cur[ 1]*state.cur[ 1],0.866667+50*state.cur[ 1]*state.cur[ 1],0.866667)
      # hubo.joints["NK1"].child.color.setRGB(0.866667+100*state.cur[ 2]*state.cur[ 2],0.866667+50*state.cur[ 2]*state.cur[ 2],0.866667)
      # hubo.joints["NK2"].child.color.setRGB(0.866667+100*state.cur[ 3]*state.cur[ 3],0.866667+50*state.cur[ 3]*state.cur[ 3],0.866667)
        hubo.joints["LSP"].child.color.setRGB(0.866667+100*state.cur[ 4]*state.cur[ 4],0.866667+50*state.cur[ 4]*state.cur[ 4],0.866667)
        hubo.joints["LSR"].child.color.setRGB(0.866667+100*state.cur[ 5]*state.cur[ 5],0.866667+50*state.cur[ 5]*state.cur[ 5],0.866667)
        hubo.joints["LSY"].child.color.setRGB(0.866667+100*state.cur[ 6]*state.cur[ 6],0.866667+50*state.cur[ 6]*state.cur[ 6],0.866667)
        hubo.joints["LEB"].child.color.setRGB(0.866667+100*state.cur[ 7]*state.cur[ 7],0.866667+50*state.cur[ 7]*state.cur[ 7],0.866667)
        hubo.joints["LWY"].child.color.setRGB(0.866667+100*state.cur[ 8]*state.cur[ 8],0.866667+50*state.cur[ 8]*state.cur[ 8],0.866667)
      # hubo.joints["LWR"].child.color.setRGB(0.866667+100*state.cur[ 9]*state.cur[ 9],0.866667+50*state.cur[ 9]*state.cur[ 9],0.866667)
        hubo.joints["LWP"].child.color.setRGB(0.866667+100*state.cur[10]*state.cur[10],0.866667+50*state.cur[10]*state.cur[10],0.866667)
        hubo.joints["RSP"].child.color.setRGB(0.866667+100*state.cur[11]*state.cur[11],0.866667+50*state.cur[11]*state.cur[11],0.866667)
        hubo.joints["RSR"].child.color.setRGB(0.866667+100*state.cur[12]*state.cur[12],0.866667+50*state.cur[12]*state.cur[12],0.866667)
        hubo.joints["RSY"].child.color.setRGB(0.866667+100*state.cur[13]*state.cur[13],0.866667+50*state.cur[13]*state.cur[13],0.866667)
        hubo.joints["REB"].child.color.setRGB(0.866667+100*state.cur[14]*state.cur[14],0.866667+50*state.cur[14]*state.cur[14],0.866667)
        hubo.joints["RWY"].child.color.setRGB(0.866667+100*state.cur[15]*state.cur[15],0.866667+50*state.cur[15]*state.cur[15],0.866667)
      # hubo.joints["RWR"].child.color.setRGB(0.866667+100*state.cur[16]*state.cur[16],0.866667+50*state.cur[16]*state.cur[16],0.866667)
        hubo.joints["RWP"].child.color.setRGB(0.866667+100*state.cur[17]*state.cur[17],0.866667+50*state.cur[17]*state.cur[17],0.866667)
        # mind the gap
        hubo.joints["LHY"].child.color.setRGB(0.866667+100*state.cur[19]*state.cur[19],0.866667+50*state.cur[19]*state.cur[19],0.866667)
        hubo.joints["LHR"].child.color.setRGB(0.866667+100*state.cur[20]*state.cur[20],0.866667+50*state.cur[20]*state.cur[20],0.866667)
        hubo.joints["LHP"].child.color.setRGB(0.866667+100*state.cur[21]*state.cur[21],0.866667+50*state.cur[21]*state.cur[21],0.866667)
        hubo.joints["LKN"].child.color.setRGB(0.866667+100*state.cur[22]*state.cur[22],0.866667+50*state.cur[22]*state.cur[22],0.866667)
        hubo.joints["LAP"].child.color.setRGB(0.866667+100*state.cur[23]*state.cur[23],0.866667+50*state.cur[23]*state.cur[23],0.866667)
        hubo.joints["LAR"].child.color.setRGB(0.866667+100*state.cur[24]*state.cur[24],0.866667+50*state.cur[24]*state.cur[24],0.866667)
        # mind the gap
        hubo.joints["RHY"].child.color.setRGB(0.866667+100*state.cur[26]*state.cur[26],0.866667+50*state.cur[26]*state.cur[26],0.866667)
        hubo.joints["RHR"].child.color.setRGB(0.866667+100*state.cur[27]*state.cur[27],0.866667+50*state.cur[27]*state.cur[27],0.866667)
        hubo.joints["RHP"].child.color.setRGB(0.866667+100*state.cur[28]*state.cur[28],0.866667+50*state.cur[28]*state.cur[28],0.866667)
        hubo.joints["RKN"].child.color.setRGB(0.866667+100*state.cur[29]*state.cur[29],0.866667+50*state.cur[29]*state.cur[29],0.866667)
        hubo.joints["RAP"].child.color.setRGB(0.866667+100*state.cur[30]*state.cur[30],0.866667+50*state.cur[30]*state.cur[30],0.866667)
        hubo.joints["RAR"].child.color.setRGB(0.866667+100*state.cur[31]*state.cur[31],0.866667+50*state.cur[31]*state.cur[31],0.866667)
      else if (showCurrent == 'circles')
        # New power visualization
        hubo.joints["WST"].circle.object.material.color.setRGB(100*state.cur[ 0]*state.cur[ 0],50*state.cur[ 0]*state.cur[ 0],0)
        # hubo.joints["NKY"].circle.object.material.color.setRGB(0.866667+100*state.cur[ 1]*state.cur[ 1],0.866667+50*state.cur[ 1]*state.cur[ 1],0.866667)
      # hubo.joints["NK1"].circle.object.material.color.setRGB(0.866667+100*state.cur[ 2]*state.cur[ 2],0.866667+50*state.cur[ 2]*state.cur[ 2],0.866667)
      # hubo.joints["NK2"].circle.object.material.color.setRGB(0.866667+100*state.cur[ 3]*state.cur[ 3],0.866667+50*state.cur[ 3]*state.cur[ 3],0.866667)
        hubo.joints["LSP"].circle.object.material.color.setRGB(100*state.cur[ 4]*state.cur[ 4],50*state.cur[ 4]*state.cur[ 4],0)
        hubo.joints["LSR"].circle.object.material.color.setRGB(100*state.cur[ 5]*state.cur[ 5],50*state.cur[ 5]*state.cur[ 5],0)
        hubo.joints["LSY"].circle.object.material.color.setRGB(100*state.cur[ 6]*state.cur[ 6],50*state.cur[ 6]*state.cur[ 6],0)
        hubo.joints["LEB"].circle.object.material.color.setRGB(100*state.cur[ 7]*state.cur[ 7],50*state.cur[ 7]*state.cur[ 7],0)
        hubo.joints["LWY"].circle.object.material.color.setRGB(100*state.cur[ 8]*state.cur[ 8],50*state.cur[ 8]*state.cur[ 8],0)
      # hubo.joints["LWR"].circle.object.material.color.setRGB(100*state.cur[ 9]*state.cur[ 9],50*state.cur[ 9]*state.cur[ 9],0)
        hubo.joints["LWP"].circle.object.material.color.setRGB(100*state.cur[10]*state.cur[10],50*state.cur[10]*state.cur[10],0)
        hubo.joints["RSP"].circle.object.material.color.setRGB(100*state.cur[11]*state.cur[11],50*state.cur[11]*state.cur[11],0)
        hubo.joints["RSR"].circle.object.material.color.setRGB(100*state.cur[12]*state.cur[12],50*state.cur[12]*state.cur[12],0)
        hubo.joints["RSY"].circle.object.material.color.setRGB(100*state.cur[13]*state.cur[13],50*state.cur[13]*state.cur[13],0)
        hubo.joints["REB"].circle.object.material.color.setRGB(100*state.cur[14]*state.cur[14],50*state.cur[14]*state.cur[14],0)
        hubo.joints["RWY"].circle.object.material.color.setRGB(100*state.cur[15]*state.cur[15],50*state.cur[15]*state.cur[15],0)
      # hubo.joints["RWR"].circle.object.material.color.setRGB(100*state.cur[16]*state.cur[16],50*state.cur[16]*state.cur[16],0)
        hubo.joints["RWP"].circle.object.material.color.setRGB(100*state.cur[17]*state.cur[17],50*state.cur[17]*state.cur[17],0)
        # mind the gap
        hubo.joints["LHY"].circle.object.material.color.setRGB(100*state.cur[19]*state.cur[19],50*state.cur[19]*state.cur[19],0)
        hubo.joints["LHR"].circle.object.material.color.setRGB(100*state.cur[20]*state.cur[20],50*state.cur[20]*state.cur[20],0)
        hubo.joints["LHP"].circle.object.material.color.setRGB(100*state.cur[21]*state.cur[21],50*state.cur[21]*state.cur[21],0)
        hubo.joints["LKN"].circle.object.material.color.setRGB(100*state.cur[22]*state.cur[22],50*state.cur[22]*state.cur[22],0)
        hubo.joints["LAP"].circle.object.material.color.setRGB(100*state.cur[23]*state.cur[23],50*state.cur[23]*state.cur[23],0)
        hubo.joints["LAR"].circle.object.material.color.setRGB(100*state.cur[24]*state.cur[24],50*state.cur[24]*state.cur[24],0)
        # mind the gap
        hubo.joints["RHY"].circle.object.material.color.setRGB(100*state.cur[26]*state.cur[26],50*state.cur[26]*state.cur[26],0)
        hubo.joints["RHR"].circle.object.material.color.setRGB(100*state.cur[27]*state.cur[27],50*state.cur[27]*state.cur[27],0)
        hubo.joints["RHP"].circle.object.material.color.setRGB(100*state.cur[28]*state.cur[28],50*state.cur[28]*state.cur[28],0)
        hubo.joints["RKN"].circle.object.material.color.setRGB(100*state.cur[29]*state.cur[29],50*state.cur[29]*state.cur[29],0)
        hubo.joints["RAP"].circle.object.material.color.setRGB(100*state.cur[30]*state.cur[30],50*state.cur[30]*state.cur[30],0)
        hubo.joints["RAR"].circle.object.material.color.setRGB(100*state.cur[31]*state.cur[31],50*state.cur[31]*state.cur[31],0)
        # hubo.joints["RF1"].circle.object.material.color.setRGB(0.866667+100*state.cur[32]*state.cur[32],0.866667+state.cur[32]*5,0.866667)
        # hubo.joints["RF2"].circle.object.material.color.setRGB(0.866667+100*state.cur[33]*state.cur[33],0.866667+state.cur[33]*5,0.866667)
        # hubo.joints["RF3"].circle.object.material.color.setRGB(0.866667+100*state.cur[34]*state.cur[34],0.866667+state.cur[34]*5,0.866667)
        # hubo.joints["RF4"].circle.object.material.color.setRGB(0.866667+100*state.cur[35]*state.cur[35],0.866667+state.cur[35]*5,0.866667)
        # hubo.joints["RF5"].circle.object.material.color.setRGB(0.866667+100*state.cur[36]*state.cur[36],0.866667+state.cur[36]*5,0.866667)
        # hubo.joints["LF1"].circle.object.material.color.setRGB(0.866667+100*state.cur[37]*state.cur[37],0.866667+state.cur[37]*5,0.866667)
        # hubo.joints["LF2"].circle.object.material.color.setRGB(0.866667+100*state.cur[38]*state.cur[38],0.866667+state.cur[38]*5,0.866667)
        # hubo.joints["LF3"].circle.object.material.color.setRGB(0.866667+100*state.cur[39]*state.cur[39],0.866667+state.cur[39]*5,0.866667)
        # hubo.joints["LF4"].circle.object.material.color.setRGB(0.866667+100*state.cur[40]*state.cur[40],0.866667+state.cur[40]*5,0.866667)
        # hubo.joints["LF5"].circle.object.material.color.setRGB(0.866667+100*state.cur[41]*state.cur[41],0.866667+state.cur[41]*5,0.866667)
      
      hubo.canvas.render()

      # Update FPS counter
      LIVE.stats.end();
      LIVE.stats.begin();

    # Deferred connection established callback
    LIVE.connectionEstablished.done () ->
      if (LIVE.use_socket)
        LIVE.socket.on 'serial_state', (serial_state) ->
          LIVE.serial_state = serial_state
          # LED status indicator
          LIVE.flashLED()
          updateModel(serial_state)

    $('input[name="angle-source"]:radio').on 'change', () ->
      console.log('Radio Changed')
      updateModel(LIVE.serial_state)

    $('input[name="current-source"]:radio').on 'change', () ->
      # Reset Hubo's color to gray. Technically only needed when turning 
      # current visualization off, but doesn't hurt.      
      if @value == 'off'
        for link in hubo.links.asArray()
          link.unhighlight()
        LIVE.setCircleVisibility(false)
        hubo.canvas.render()
      else if @value == 'glow'
        LIVE.setCircleVisibility(false)
        hubo.canvas.render()
      else if @value == 'circles'        
        for link in hubo.links.asArray()
          link.unhighlight()
        LIVE.setCircleVisibility(true)

    $('#fullscreen-button').on 'click', () ->
      if (document.webkitFullscreenEnabled)
        document.getElementById('hubo_container').webkitRequestFullscreen()

    # Deprecated for now by server-side timeouts watching state.time.
    # Might still be needed to reestablish client connections at some point?
    # $('#fix-button').on 'click', () ->
    #   LIVE.connectToServer()
    #   console.log('Resetting hubo-ach...')
    #   socket.emit('reset-ach',{jawn: true})

    $(document).on 'webkitfullscreenchange', () ->
      setTimeout(adaptCanvasSize(c), 500)

    # Update the rendering to reflect any changes to Hubo.
    c.render()
  , progress = (step, total, node) ->
    $("#load").html "Loading " + step + "/" + total
  )
  # export to namespace
  LIVE.hubo = hubo
