#
# GLOBALS
#
window.playback = {}
playback.possible_states = 
    [ 'NOT_LOADED'
    , 'LOADING'
    , 'LOADED'
    , 'PLAYING'
    , 'STOPPED'
    , 'DONE_PLAYING'
    ]
playback.state = 'NOT_LOADED'
playback.filename = null

window.param = 150/200
window.param2 = 30

#
# FUNCTIONS
#
loadTrajectoryString = (allText, callback) ->  
    if (not callback? and parent_callback?) 
        callback = parent_callback
    # Split by line
    allText = allText.replace('\r\n','\n') # Fix DOS
    allText = allText.replace('\n\r','\n') # Fix Mac
    allTextLines = allText.split('\n')
    # Split by delimiter
    delimiter = /[ \t,]+/;
    # Grab header (first line)
    headers = allTextLines.shift().split(delimiter) # Remove first line, split by spaces and tabs
    # TODO: Remove this "convenience" hack for trajectories with unlabeled headers
    if isNumber(headers[0])
        this_many = headers.length - 1
        # Whooops, it ain't no header. Put it back. 
        allTextLines.unshift(headers.join(' '))
        # Let's use these values instead.
        headers = "RHY RHR RHP RKN RAP RAR LHY LHR LHP LKN LAP LAR RSP RSR RSY REB RWY RWR RWP LSP LSR LSY LEB LWY LWR LWP NKY NK1 NK2 WST RF1 RF2 RF3 RF4 RF5 LF1 LF2 LF3 LF4 LF5"
        headers = headers.split(delimiter)
        headers = headers[0..this_many] # Trim off unused headers, often the fingers.
    # Grab remaining lines and convert to numbers
    data = []
    for line in allTextLines
        line = line.trim()
        if line != "" # skip empty lines
            data.push (parseFloat(n) for n in line.split(delimiter))
    # Return the headers and the data
    callback headers,data

loadTrajectoryFile = (filename, callback) ->
    # Now load the trajectory file
    console.log 'loadTrajectory'
    $.ajax
        type: "GET"
        url: filename
        dataType: "text"
        success: (data) -> 
            loadTrajectoryString(data, callback)

togglePlay = () ->
    if not playback.footMatrix?
        playback.footMatrix = new THREE.Matrix4
        playback.footMatrix.copy(hubo.links.Body_RAR.matrixWorld)

    if playback.state == 'DONE_PLAYING' then playback.frame = 0
    switch playback.state    
        when 'LOADED', 'STOPPED', 'DONE_PLAYING'
            playback.state = 'PLAYING'
            playback.startedTime = window.performance.now() - playback.frame/playback.framerate*1000 # ms
            #requestAnimationFrame( animate )
            window.setTimeout(animate, 1)
            window.numframes = 0
        when 'PLAYING'
            playback.state = 'STOPPED'
    return

animate = (timestamp) ->
    if not timestamp?
        timestamp = window.performance.now()
    # Update FPS - TODO: Figure out how to make this agnostic. What if users don't want FPS monitor?
    stats.begin()
    if (playback.state != 'PLAYING')
        return
    # timestamp is a floating point milleseconds in recent Chrome / Firefox
    # Calculate time delta and animation frame to use
    playback.lastframe = playback.frame
    delta = timestamp - playback.startedTime
    playback.frame = Math.round(delta*playback.framerate/1000)
    if playback.frame >= playback.data.length
        playback.state = 'DONE_PLAYING'
        return
    # Update all joints
    for prop of playback.working_headers
        i = playback.working_headers[prop]
        # Fingers and neck are... strange. Velocity control or current control or something.
        if prop[0..1] == "LF" or prop[0..1] == "RF"
            # Integrate the data in between the last frame and now
            tmp = 0
            for j in [playback.lastframe+1 .. playback.frame]
                tmp += playback.data[j][i]
            tmp /= playback.framerate
            # Apply to finger value
            hubo.motors[prop].value -= tmp / window.param
        else if (prop[0..2] == "NK1") or (prop[0..2] == "NK2")
            # Integrate the data in between the last frame and now
            tmp = 0
            for j in [playback.lastframe+1 .. playback.frame]
                tmp += playback.data[j][i]
            # tmp /= 128 # 128 encoder ticks per rev
            # tmp /= Math.PI # 1mm pitch per rev
            tmp *= window.param2
            #hubo.motors[prop].value += tmp
            hubo.motors[prop].value = 0 # Disable because the trajectory files are missing NK2. Oops!
        else
            hubo.motors[prop].value = playback.data[playback.frame][i]
    # Rotate the whole shebang so that the foot is the "grounded" object.
    # for prop of hubo.links
    #     if hubo.links[prop].applyMatrix?
    #         hubo.links[prop].applyMatrix(hubo.links.Body_RAR.matrixWorld)
    a = new THREE.Matrix4
    a.getInverse(hubo.links.Body_RAR.matrixWorld)
    b = new THREE.Matrix4
    b.multiplyMatrices(a,playback.footMatrix)
    hubo.links.Body_Torso.applyMatrix(b)
    # hubo.links.Body_Torso.matrix.getInverse(hubo.links.Body_RAR.matrixWorld)
    # I'm curious how long that process takes actually.
    delta_post = window.performance.now() - playback.startedTime
    process_time = delta_post - delta
    window.numframes++
    # console.log "Frame: " + playback.frame + ' i: ' + numframes
    c.render()
    # Update FPS
    stats.end()
    #requestAnimationFrame( animate )
    window.setTimeout(animate, 1)
    return

#
# HELPERS
#
isNumber = (n) ->
  return !isNaN(parseFloat(n)) && isFinite(n)
