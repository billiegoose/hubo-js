# Using namespace LIVE
LIVE = {}
LIVE.use_socket = true;
LIVE.connectionEstablished = $.Deferred()

LIVE.connectToServer = () ->
  if (LIVE.use_socket)
    console.log('Trying to connect to server...')
    LIVE.socket = io.connect(':6060', {'force new connection':true, timeout: 3000})
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
  lerp = (min,max,zero,t) ->
    if t > max
      t = max
    if t < min
      t = min
    if t < zero
      return Math.min((zero-t)/(zero-min),1)
    else
      return Math.min((t-zero)/(max-zero),1)

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

    updateModel = (serial_state) ->
      if (not serial_state? or serial_state == "")
        return

      state = JSON.parse(serial_state);
      # console.log(state);

      jointType = $('input[name="angle-source"]:checked').val() #'ref' # or 'pos' 

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
