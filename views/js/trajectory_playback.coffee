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

window.param = 30
window.param2 = 30

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
            # Split by delimiter
            delimiter = /[ \t]+/;
            # Grab header (first line)
            headers = allTextLines.shift().split(delimiter) # Remove first line, split by spaces and tabs
            # Grab remaining lines and convert to numbers
            data = []
            for line in allTextLines
                line = line.trim()
                if line != "" # skip empty lines
                    data.push (parseFloat(n) for n in line.split(delimiter))
            # Return the headers and the data
            callback headers,data

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
        # Fingers and neck are... strange. Velocity control or current control or something.
        if prop[0..1] == "LF" or prop[0..1] == "RF"
            hubo.motors[prop].value -= playback.data[playback.frame][i] / window.param
        else if (prop[0..1] == "NK1") or (prop[0..1] == "NK2")
            # hubo.motors[prop].value += playback.data[playback.frame][i] / window.param2
            hubo.motors[prop].value = 95 # not working yet.
            console.log 'WTF'
        else
            hubo.motors[prop].value = playback.data[playback.frame][i]
    # I'm curious how long that process takes actually.
    delta_post = window.performance.now() - playback.startedTime
    process_time = delta_post - delta
    window.numframes++
    # console.log "Frame: " + playback.frame + ' i: ' + numframes
    c.render()
    requestAnimationFrame( animate )
    return
