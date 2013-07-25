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
            get: -> return @_value
            set: (val) -> 
              @_value = val
              _robot.joints[@name].value = val
              return
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
      # Add your robot to the canvas.
      ready_callback()
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
          if val < @lower_limit
              #console.warn 'Motor ' + @name + ' tried to violate lower limit: ' + @lower_limit
              val = @lower_limit
          else if val > @upper_limit
              #console.warn 'Joint ' + @name + ' tried to violate upper limit: ' + @upper_limit
              val = @upper_limit
          @_value = val              
          _robot.joints[@full_name + 'Knuckle1'].value = val
          _robot.joints[@full_name + 'Knuckle2'].value = val
          _robot.joints[@full_name + 'Knuckle3'].value = val
          return
    motor.value = 0.9 # start with fingers half curled
    # Add to motor collection
    @motors[name] = motor