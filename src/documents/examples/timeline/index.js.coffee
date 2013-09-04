# Create cute little convenience objects for animating
wrapProp = (src,prop,dest,name) ->
  Object.defineProperty dest, name,
    get: () -> 
      return src[prop]
    set: (val) ->
      src[prop] = val
    enumerable: true
  return

populateTracks = () ->
  t = Timeline.getGlobalInstance()
  console.log('t.tracks[0].propertyTracks.length = ' + t.tracks[0].propertyTracks.length)
  for d in t.tracks    
    for p in d.propertyTracks
      newKey = 
        time: 0
        value: hubo.motors[p.propertyName].default_value
        easing: Timeline.Easing.Linear.EaseNone
        track: p
      p.keys.push(newKey)
  #t.rebuildSelectedTracks()
  return

# Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
c = new WebGLRobots.DefaultCanvas('#hubo_container', 480, 300)
# Create a new robot instance.
window.hubo = new Hubo 'hubo2',
  callback = () ->
    # Once the URDF is completely loaded, this function is run.
    # Add your robot to the canvas.
    c.add(hubo)
    $('#load').hide()

    head = {}
    wrapProp(hubo.motors.NKY,'value',head,'NKY')
    wrapProp(hubo.motors.NK1,'value',head,'NK1')
    wrapProp(hubo.motors.NK2,'value',head,'NK2')

    larm = {}    
    wrapProp(hubo.motors.LSP,'value',larm,'LSP')
    wrapProp(hubo.motors.LSR,'value',larm,'LSR')
    wrapProp(hubo.motors.LSY,'value',larm,'LSY')
    wrapProp(hubo.motors.LEP,'value',larm,'LEP')
    wrapProp(hubo.motors.LWP,'value',larm,'LWP')
    wrapProp(hubo.motors.LWY,'value',larm,'LWY')

    rarm = {}
    wrapProp(hubo.motors.RSP,'value',rarm,'RSP')
    wrapProp(hubo.motors.RSR,'value',rarm,'RSR')
    wrapProp(hubo.motors.RSY,'value',rarm,'RSY')
    wrapProp(hubo.motors.REP,'value',rarm,'REP')
    wrapProp(hubo.motors.RWP,'value',rarm,'RWP')
    wrapProp(hubo.motors.RWY,'value',rarm,'RWY')

    lleg = {}
    wrapProp(hubo.motors.LHY,'value',lleg,'LHY')
    wrapProp(hubo.motors.LHR,'value',lleg,'LHR')
    wrapProp(hubo.motors.LHP,'value',lleg,'LHP')
    wrapProp(hubo.motors.LKP,'value',lleg,'LKP')
    wrapProp(hubo.motors.LAR,'value',lleg,'LAR')
    wrapProp(hubo.motors.LAP,'value',lleg,'LAP')

    rleg = {}
    wrapProp(hubo.motors.RHY,'value',rleg,'RHY')
    wrapProp(hubo.motors.RHR,'value',rleg,'RHR')
    wrapProp(hubo.motors.RHP,'value',rleg,'RHP')
    wrapProp(hubo.motors.RKP,'value',rleg,'RKP')
    wrapProp(hubo.motors.RAR,'value',rleg,'RAR')
    wrapProp(hubo.motors.RAP,'value',rleg,'RAP')
    # There's a fencepost bug in the GUI such that it won't scroll to the last value
    # This is the poor man's careless fix.
    window.dummy = {}

    # Animate
    #anim("LSP",hubo.motors['LSP']).to({"value":0},0).to({"value":-1},0.5).to({"value":0},1);
    #anim("Head")
    anim("Head",head)
    anim("Left Arm",larm) #.to({"LEP":0},0).to({"LEP":-2},2);
    anim("Right Arm",rarm)
    anim("Left Leg",lleg)
    anim("Right Leg",rleg)
    anim("Dummy", dummy)
    Timeline.getGlobalInstance().loop(-1)
    Timeline.getGlobalInstance().start()
    populateTracks()
    Timeline.getGlobalInstance().stop()
  progress = (step,total,node) ->
    $('#load').html("Loading " + step + "/" + total)
    