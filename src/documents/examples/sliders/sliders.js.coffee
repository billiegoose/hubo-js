footMatrix = null

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
    $('#footanchor').on 'change', (event) ->
      console.log(event)
      if this.checked
        # WARNING! Global variable.
        footMatrix = new THREE.Matrix4
        footMatrix.copy(hubo.links.Body_LAR.matrixWorld)
      else
        footMatrix = null
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
    if footMatrix?
      console.log("Fix foot")
      # Rotate the whole shebang so that the foot is the "grounded" object.
      # for prop of hubo.links
      #     if hubo.links[prop].applyMatrix?
      #         hubo.links[prop].applyMatrix(hubo.links.Body_RAR.matrixWorld)
      a = new THREE.Matrix4
      a.getInverse(hubo.links.Body_LAR.matrixWorld)
      b = new THREE.Matrix4
      b.multiplyMatrices(a,footMatrix)
      hubo.links.Body_Torso.applyMatrix(b)

sign = (x) ->
  (if x then (if x < 0 then -1 else 1) else 0)