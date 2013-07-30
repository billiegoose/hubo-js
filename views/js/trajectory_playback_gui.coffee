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
        when 'NOT_LOADED'   then ui.html('Start')
        when 'PLAYING'      then ui.html('Pause')
        when 'DONE_PLAYING' then ui.html('Replay')
        else ui.html('Play')

$('#traj_selection').on 'change', (event) ->
    return if $(this).val() is '' 
    playback.state = 'NOT_LOADED'  # This is important because of the asynchronicity
    playback.filename = 'trajectories/' + $(this).val()
    loadTrajectory playback.filename, (headers,data) -> 
        console.log(data.length)
        playback.data = data
        playback.framerate = 200 # Hz
        # Quick hack fix for knees and elbows
        headers[headers.indexOf('LKN')] = 'LKP'
        headers[headers.indexOf('RKN')] = 'RKP'
        headers[headers.indexOf('LEB')] = 'LEP'
        headers[headers.indexOf('REB')] = 'REP'
        # Find the joints we can actually use
        playback.working_headers = {}
        for id in headers
            playback.working_headers[id] = headers.indexOf(id) if hubo.motors[id]?
        playback.state = 'LOADED'
        playback.frame = 0
        return

$('#toggle_play').on 'click', togglePlay

$('#load').on 'click', (event)-> 
    $(this).html "Loading..."
    # This code is meant to show the bare minimum needed to add a Hubo to a webpage.
    # Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
    window.c = new WebGLRobots.DefaultCanvas('#hubo_container')
    # Create a new robot instance.
    window.hubo = new Hubo 'hubo2', callback = ->
      # Once the URDF is completely loaded, this function is run.
      # Add your robot to the canvas.
      c.add hubo
      hubo.autorender = false
      $('#panel_load').hide();
      $('#panel_traj').show();

#
# MAIN
#
$( document ).ready () ->
    $('#panel_traj').hide();
    $('#panel_load').show();

    window.stats = new Stats();
    stats.setMode(0); # 0: fps, 1: ms
    $('#hubo_container').append(stats.domElement)
    stats.domElement.style.position = 'absolute'
    stats.domElement.style.left = '400px'
    stats.domElement.style.top = '0px'