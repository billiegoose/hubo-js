# 
# GUI 
#
watch playback, 'state', () ->
    console.log(@)
    ui = $('#toggle_play')
    if @state in ['NOT_LOADED', 'LOADING']
        ui.attr('disabled','disabled')
    else
        ui.removeAttr('disabled')
    switch @state
        when 'PLAYING'      then ui.html('Pause')
        when 'DONE_PLAYING' then ui.html('Replay')
        else ui.html('Play')

$('#traj_selection').on 'change', (event) ->
    return if $(this).val() is '' 
    playback.state = 'LOADING'  # This is important because of the asynchronicity
    playback.filename = 'trajectories/' + $(this).val()
    hubo.reset() # Fix any missing limbs... caused by setting joints to NaN. Too bad this isn't the walk-ready pose.
    c.render()
    loadTrajectory playback.filename, (headers,data) -> 
        console.log(data.length)
        playback.data = data
        playback.framerate = 200 # Hz
        # Quick hack fix for knees and elbows
        headers[headers.indexOf('LKN')] = 'LKP'
        headers[headers.indexOf('RKN')] = 'RKP'
        headers[headers.indexOf('LEB')] = 'LEP'
        headers[headers.indexOf('REB')] = 'REP'
        # Hack to add 20 degrees to shoulder roll.
        for i in [0..data.length-1]
            data[i][headers.indexOf('LSR')] += 20/180*Math.PI
            data[i][headers.indexOf('RSR')] -= 20/180*Math.PI
        # Find the joints we can actually use
        playback.working_headers = {}
        for id in headers
            playback.working_headers[id] = headers.indexOf(id) if hubo.motors[id]?
        playback.state = 'LOADED'
        playback.frame = 0
        return

$('#toggle_play').on 'click', togglePlay

$('#load').on 'click', (event)-> 
    $(this).html("Loading...").attr('disabled','disabled')
    # This code is meant to show the bare minimum needed to add a Hubo to a webpage.
    # Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
    window.c = new WebGLRobots.DefaultCanvas('#hubo_container')
    # Create a new robot instance.
    window.hubo = new Hubo 'hubo2',
        callback = ->
            # Once the URDF is completely loaded, this function is run.
            # Add your robot to the canvas.
            c.add hubo
            hubo.autorender = false
            $('#panel_load').hide();
            $('#panel_traj').show();
      , progress = (step,total,node) ->
            $('#load').html("Loading " + step + "/" + total)

#
# MAIN
#
$( document ).ready () ->
    window.stats = new Stats();
    stats.setMode(0); # 0: fps, 1: ms
    $('#hubo_container').append(stats.domElement)
    stats.domElement.style.position = 'absolute'
    stats.domElement.style.left = '400px'
    stats.domElement.style.top = '0px'