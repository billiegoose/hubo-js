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
      hubo.autorender = false;

loadTrajectory "trajectories/Taichi.traj", (headers,data) -> 
    console.log(data.length)
    window.data = data
    window.headers = headers
    return

loadRobot()
