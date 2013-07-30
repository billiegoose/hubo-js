# A custom extension of WebGLRobots.Robot just for Hubo.
class Hubo extends WebGLRobots.Robot
  _robot = this
  constructor: (@name, ready_callback) ->
    # Set this = new WebGLRobots.Robot()
    super()
    _robot = this
    # Motors
    @motors = new Dict()
    # Load the robot using the URDF importer.
    @loadURDF "hubo-urdf/model.urdf", load_callback = () =>
      # Once the URDF is completely loaded, this function is run.
      for own key, value of @joints
        if key.length == 3
          @motors[key] = {}
          @motors[key].name = key
          @motors[key].lower_limit = @joints[key].lower_limit
          @motors[key].upper_limit = @joints[key].upper_limit
          Object.defineProperties @motors[key],
          value:
            get: -> return _robot.joints[@name].value
            set: (val) -> 
              val = clamp(val,this)
              _robot.joints[@name].value = val
              return val
          @motors[key].value = 0
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
      # @addNeckMotor('NK1')
      # @addNeckMotor('NK2')
      # Add your robot to the canvas.
      ready_callback()
  addNeckMotor: (name) ->
    _robot = this
    # Create the neck motors.
    NK = {}
    NK.name = name # Either NK1 or NK2
    NK.lower_limit = 85
    NK.upper_limit = 105
    Object.defineProperties NK,
      value:
        get: -> return @_value
        set: (val) ->
          val = clamp(val,this)
          @_value = val
          # We need both neck motors to calculate the head pose
          if _robot.motors.NK1? and _robot.motors.NK2?
            [pitch, roll] = _robot.neckKin(_robot.motors.NK1.value, _robot.motors.NK2.value)
            _robot.joints.HNP.value = pitch*Math.PI/180
            _robot.joints.HNR.value = roll*Math.PI/180
    NK.value = 95 #mm
    @motors[name] = NK
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
    motor.value = 0.9 # start with fingers half curled
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

clamp = (val,joint) ->
  warn = off
  if val < joint.lower_limit
    if warn then console.warn joint.name + ' tried to violate lower limit: ' + joint.lower_limit
    return joint.lower_limit
  else if val > joint.upper_limit
    if warn then console.warn joint.name + ' tried to violate upper limit: ' + joint.upper_limit
    return joint.upper_limit
  return val