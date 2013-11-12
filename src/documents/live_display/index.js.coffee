#
# Init Firebase
#
window.huboRef = new Firebase('https://hubo-firebase.firebaseIO.com')
window.jointRef = huboRef.child('joints')

#
# Setup Hubo-in-the-Browser
#
c = new WebGLRobots.DefaultCanvas("#hubo_container")
window.hubo = new Hubo("hubo2", callback = ->
  
  # Once the URDF is completely loaded, this function is run.
  # Add your robot to the canvas.
  c.add hubo
  $("#load").hide()

  # jointRef.once('value', (data) ->
  #     data.forEach((joint) ->
  #       hubo.motors[joint.name()].value = joint.pos());
  #     });
  # });

  # Create the Firebase update
  jointRef.on('child_changed', (snapshot) ->
    name = snapshot.name()
    joint = snapshot.val()
    hubo.motors[name].value = joint.pos
  )
, progress = (step, total, node) ->
  $("#load").html "Loading " + step + "/" + total
)

#
# Setup GUI
#
$("#mouse_info_dialog").dialog
  autoOpen: false
  closeOnEscape: true
  buttons:
    OK: ->
      $(this).dialog "close"

$("#mouse_info_button").on "click", ->
  $("#mouse_info_dialog").dialog "open"
