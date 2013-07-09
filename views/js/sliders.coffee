c = new WebGLRobots.DefaultCanvas("#hubo_container")
hubo = new WebGLRobots.Robot()
hubo.loadURDF "hubo-urdf/model.urdf", callback = ->
  c.add hubo  
  # Make joint sliders
  $(".joint").each ->
    id = $(this).attr("data-name")    
    # Set with initial text
    $("[data-name=" + id + "] .joint_txt").html "0.00"
    console.log "makeSlider " + id
    console.log "id: " + id + " lower: " + hubo.joints[id].lower_limit + " upper:" + hubo.joints[id].upper_limit
    console.log typeof hubo.joints[id].lower_limit
    lower = parseFloat(hubo.joints[id].lower_limit)
    upper = parseFloat(hubo.joints[id].upper_limit)
    makeSlider $("[data-name=" + id + "] .joint_slider"), id, lower, upper

#
# * * * JQUERY SLIDERS * * *
# 
makeSlider = (el, id, minval, maxval) ->
  s = el
  s.slider
    min: minval
    max: maxval
    step: 0.01
    value: 0
  
  # Update text display
  s.on "slide", (event, ui) ->
    $("[data-name=" + id + "] .joint_txt").html ui.value.toFixed(2)
  
  # Update Hubo model
  s.on "slide", (event, ui) ->
    hubo.joints[id].value = ui.value

sign = (x) ->
  (if x then (if x < 0 then -1 else 1) else 0)