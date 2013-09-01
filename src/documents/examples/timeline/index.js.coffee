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
  for d in t.displayedTracks
    for p in d.propertyTracks
      newKey = 
        time: 0
        value: hubo.motors[p.propertyName].default_value
        easing: Timeline.Easing.Linear.EaseNone
        track: p
      p.keys.push(newKey)
  t.rebuildSelectedTracks()
  return

# Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
c = new WebGLRobots.DefaultCanvas('#hubo_container')
# Create a new robot instance.
window.hubo = new Hubo 'hubo2',
  callback = () ->
    # Once the URDF is completely loaded, this function is run.
    # Add your robot to the canvas.
    c.add(hubo)
    $('#load').hide()

    larm = {}
    wrapProp(hubo.motors.LSP,'value',larm,'LSP')
    wrapProp(hubo.motors.LSR,'value',larm,'LSR')
    wrapProp(hubo.motors.LSY,'value',larm,'LSY')
    wrapProp(hubo.motors.LEP,'value',larm,'LEP')
    wrapProp(hubo.motors.LWP,'value',larm,'LWP')
    wrapProp(hubo.motors.LWY,'value',larm,'LWY')

    # Animate
    #anim("LSP",hubo.motors['LSP']).to({"value":0},0).to({"value":-1},0.5).to({"value":0},1);
    anim("Left Arm",larm); #.to({"LEP":0},0).to({"LEP":-2},2);
    Timeline.getGlobalInstance().loop(-1);
    Timeline.getGlobalInstance().start();
  progress = (step,total,node) ->
    $('#load').html("Loading " + step + "/" + total)
    