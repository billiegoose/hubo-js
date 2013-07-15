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
            playback.working_headers[id] = headers.indexOf(id) if hubo.joints[id]?
        playback.state = 'LOADED'
        playback.frame = 0
        return

$('#toggle_play').on 'click', togglePlay