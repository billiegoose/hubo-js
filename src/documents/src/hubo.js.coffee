# A custom extension of WebGLRobots.Robot just for Hubo.
class Hubo extends WebGLRobots.Robot
  _robot = this
  constructor: (@name, ready_callback, progress_callback) ->
    # Set this = new WebGLRobots.Robot()
    super()
    _robot = this
    # Motors
    @motors = new Dict()
    # Load the robot using the URDF importer.
    @loadURDF(
      "#{local_root}data/hubo-urdf/model.urdf",
      load_callback = () =>
        # Once the URDF is completely loaded, this function is run.
        for own key, value of @joints
          if key.length == 3
            @addRegularMotor(key);
        # Offsets for shoulder roll and elbow pitch (values taken from huboplus.kinbody.xml "<initial>" fields)
        _robot.motors.LSR.offset = +15/180*Math.PI
        _robot.motors.RSR.offset = -15/180*Math.PI
        _robot.motors.LEP.offset = -10/180*Math.PI
        _robot.motors.REP.offset = -10/180*Math.PI
        @addFinger('LF1')
        @addFinger('LF2')
        @addFinger('LF3')
        @addFinger('LF4')
        @addFinger('LF5')
        @addFinger('RF1')
        @addFinger('RF2')
        @addFinger('RF3')
        @addFinger('RF4')
        @addFinger('RF5')      
        @addNeckMotor('NK1')
        @addNeckMotor('NK2')
        @reset()
        # Add your robot to the canvas.
        ready_callback()
      progress_callback
    )
  addRegularMotor: (name) ->
    _robot = this
    motor = {}
    motor.name = name
    motor.lower_limit = @joints[name].lower_limit
    motor.upper_limit = @joints[name].upper_limit
    motor.default_value = 0
    motor.offset = 0
    motor.value = motor.default_value
    Object.defineProperties motor,
    value:
      get: -> return _robot.joints[@name].value - _robot.motors[@name].offset
      set: (val) -> 
        val = clamp(val,this)
        val = val + _robot.motors[@name].offset
        _robot.joints[@name].value = val
        return val
      enumerable: true
    @motors[name] = motor
  addNeckMotor: (name) ->
    _robot = this
    # Create the neck motors.
    motor = {}
    motor.name = name # Either NK1 or NK2
    motor.lower_limit = 0 # mm, Note: linear actuator pitch is 1mm/rev, 128 encoder counts per rev.
    motor.upper_limit = 20 # mm
    Object.defineProperties motor,
      value:
        get: -> return @_value
        set: (val) ->
          val = clamp(val,this)
          @_value = val
          # We need both neck motors to calculate the head pose
          if _robot.motors.NK1? and _robot.motors.NK2?
            # We add 85mm to the extension of the linear actuator to get the total link length
            [pitch, roll] = _robot.neckKin(_robot.motors.NK1.value+85, _robot.motors.NK2.value+85)
            _robot.joints.HNP.value = pitch*Math.PI/180
            _robot.joints.HNR.value = roll*Math.PI/180
    motor.default_value = 10 #mm
    motor.value = motor.default_value
    @motors[name] = motor
  addFinger: (name) ->
    _robot = this
    # Add finger motor
    motor = {}
    motor.name = name
    motor.lower_limit = 0
    motor.upper_limit = 1.4
    # Note: we are VERY MUCH expecting a TLA for 'name'
    hand = if (name[0]=='L') then 'left' else 'right'
    fingers = ['Thumb', 'Index', 'Middle', 'Ring', 'Pinky']
    finger = fingers[name[2]-1]
    motor.full_name = hand + finger
    Object.defineProperties motor,
      value:
        get: -> return @_value
        set: (val) -> 
          val = clamp(val,this)
          @_value = val              
          _robot.joints[@full_name + 'Knuckle1'].value = val
          _robot.joints[@full_name + 'Knuckle2'].value = val
          _robot.joints[@full_name + 'Knuckle3'].value = val
          return
    motor.default_value = 0.9 # start with fingers half curled
    motor.value = motor.default_value
    # Add to motor collection
    @motors[name] = motor
  # ATTENTION: This returns values in degrees.
  neckKin: (val1, val2) ->
    # The code used to derive these equations can be found in the 'neck_kin' branch. 
    # Short Explanation: The neck forward kinematics has no straightforward analytical solution. Instead, it was solved numerically by
    # fixing the head pitch and roll, and then finding the lengths of the linear actuators. (Essentially, the inverse kinematics are 
    # easier to solve.) Using this, a big lookup table was calculated. When plotted, the pitch and roll functions can be seen to be 
    # non-linear but they are nearly planar 2D functions. The equations used below are the linear best fit of the numerical lookup tables.
    # It shouldn't be off by more than a couple degrees at worst.    
    HNP = -294.4 + 1.55*val1 + 1.55*val2
    HNR =    0.0 - 1.3197*val1 + 1.3197*val2
    return [HNP, HNR]
  reset: () ->
    @motors.asArray().forEach (e) ->
      e.value = e.default_value
  outputPoseHeader: () ->
    return 'RHY         RHR         RHP         RKP         RAP         RAR         LHY         LHR         LHP         LKP         LAP         LAR         RSP         RSR         RSY         REP         RWY         RWR         RWP         LSP         LSR         LSY         LEP         LWY         LWR         LWP         NKY         NK1         NK2         WST         RF1         RF2         RF3         RF4         RF5         LF1         LF2         LF3         LF4         LF5         '
  outputPose: () ->
    str = ''
    names = @outputPoseHeader().trim().split( /\W+/ )
    for name in names
      if hubo.motors[name]?        
        v = hubo.motors[name].value
      else
        # We need to support ignoring columns (wrist roll, specifically) in order to be compatible 
        # with hubo-read-trajectory
        v = 0       
      vstr = v.toFixed(6)
      vstr = (if v>=0 then "+" else "") + vstr
      # if v >= 0 
      #   vstr = "+" + vstr
      # else
      #   vstr = "-" + vstr
      vstr = rpad(vstr,11,' ') + ' '
      str += vstr
    return str

clamp = (val,joint) ->
  warn = off
  if val < joint.lower_limit
    if warn then console.warn joint.name + ' tried to violate lower limit: ' + joint.lower_limit
    return joint.lower_limit
  else if val > joint.upper_limit
    if warn then console.warn joint.name + ' tried to violate upper limit: ' + joint.upper_limit
    return joint.upper_limit
  return val


lpad = (originalstr, length, strToPad) ->
    while (originalstr.length < length)
        originalstr = strToPad + originalstr
    return originalstr

 
rpad = (originalstr, length, strToPad) ->
    while (originalstr.length < length)
        originalstr = originalstr + strToPad
    return originalstr
