$('#controls').tabs()

c = new WebGLRobots.DefaultCanvas("#hubo_container")
hubo = new Hubo 'hubo2',
  callback = ->
    # Once the URDF is completely loaded, this function is run.
    # Add your robot to the canvas.
    c.add hubo
    $('#load').hide()
    # Make joint sliders
    $(".joint").each ->
      id = $(this).attr("data-name")
      makeSlider(id)
      # Set with initial text
      $("[data-name=" + id + "] .joint_txt").html hubo.motors[id].value.toFixed(2)
      
  progress = (step,total,node) ->
    $('#load').html("Loading " + step + "/" + total)

#
# * * * JQUERY SLIDERS * * *
# 
makeSlider = (id) ->
  s = $("[data-name=" + id + "] .joint_slider")
  s.slider
    min: parseFloat(hubo.motors[id].lower_limit)
    max: parseFloat(hubo.motors[id].upper_limit)
    step: 0.01
    value: hubo.motors[id].value

  # Update text display
  s.on "slide", (event, ui) ->
    $("[data-name=" + id + "] .joint_txt").html ui.value.toFixed(2)
  
  # Update Hubo model
  s.on "slide", (event, ui) ->
    hubo.motors[id].value = ui.value

sign = (x) ->
  (if x then (if x < 0 then -1 else 1) else 0)