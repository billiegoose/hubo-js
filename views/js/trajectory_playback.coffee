#
# GLOBALS
#
window.playback = {}
playback.possible_states = 
    [ 'NOT_LOADED'
    , 'LOADING'
    , 'LOADED'
    , 'PLAYING'
    , 'REQUEST_STOP'
    , 'STOPPED'
    , 'DONE_PLAYING'
    ]
playback.state = 'NOT_LOADED'
playback.filename = null

#
# FUNCTIONS
#
loadTrajectory = (filename, callback) ->
    # Now load the trajectory file
    console.log 'loadTrajectory'
    $.ajax
        type: "GET"
        url: filename
        dataType: "text"
        success: (allText) ->  
            # Split by line
            allText = allText.replace('\r\n','\n') # Fix DOS
            allText = allText.replace('\n\r','\n') # Fix Mac
            allTextLines = allText.split('\n')
            # Grab header (first line)
            headers = allTextLines.shift().split('\t') # Remove first line, split by tabs
            # Grab remaining lines and convert to numbers
            data = []
            for line in allTextLines
                data.push (parseFloat(n) for n in line.split('\t'))
            # Return the headers and the data
            callback headers,data

loadRobot = () ->
    # This code is meant to show the bare minimum needed to add a Hubo to a webpage.
    # Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
    window.c = new WebGLRobots.DefaultCanvas('#hubo_container')
    # Create a new robot instance.
    window.hubo = new WebGLRobots.Robot()
    # Load the robot using the URDF importer.
    hubo.loadURDF "hubo-urdf/model.urdf", callback = ->
      # Once the URDF is completely loaded, this function is run.
      # Add your robot to the canvas.
      c.add hubo
      hubo.autorender = false

togglePlay = () ->
    if playback.state == 'DONE_PLAYING' then playback.frame = 0
    switch playback.state    
        when 'LOADED', 'STOPPED', 'DONE_PLAYING'
            playback.state = 'PLAYING'
            playback.startedTime = window.performance.now() - playback.frame/playback.framerate*1000 # ms
            requestAnimationFrame( animate )
            window.numframes = 0
        when 'PLAYING'
            playback.state = 'REQUEST_STOP'
    return

animate = (timestamp) ->
    if playback.state == 'REQUEST_STOP'
        playback.state = 'STOPPED'
        return
    # timestamp is a floating point milleseconds in recent Chrome / Firefox
    # Calculate time delta and animation frame to use
    delta = timestamp - playback.startedTime
    playback.frame = Math.round(delta*playback.framerate/1000)
    if playback.frame > playback.data.length
        playback.state = 'DONE_PLAYING'
        return
    # Update all joints
    for prop of playback.working_headers
        i = playback.working_headers[prop]
        hubo.joints[prop].value = playback.data[playback.frame][i]
    # I'm curious how long that process takes actually.
    delta_post = window.performance.now() - playback.startedTime
    process_time = delta_post - delta
    window.numframes++
    # console.log "Frame: " + playback.frame + ' i: ' + numframes
    c.render()
    requestAnimationFrame( animate )
    return

#
# MAIN
#

loadRobot()
