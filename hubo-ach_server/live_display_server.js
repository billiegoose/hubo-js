console.log('Started ' + __filename + '\n');

var argv = require ("argp").createParser ({ once: true })
    .description ("live_display_server")
    .email ("wmhilton@gmail.com")
    .body ()
        //The object and argument definitions and the text of the --help message
        //are configured at the same time
        .text (" Arguments:")
        .argument ("drc", { description: "Use for drc-hubo" })
        .text ("\n Options:")
        .option ({ short: "s", long: "socketio", description: "Use socket.io instead of Firebase" })
        .option ({ short: "f", long: "hz", 
        	metavar: "FREQUENCY", type: Number, default: 10,
        	description: "State publishing frequency" })
        .help ()
        .version ("0.0.2")
    .argv ();

if (argv.socketio) {
	var app = require('http').createServer()
	    , io = require('socket.io').listen(app)
} else {
	// Get Firebase URL
	var firebase_url = 'https://hubo-firebase.firebaseIO.com';
	if (argv.drc) {
		var firebase_url = 'https://drc-hubo.firebaseIO.com';
	}
	console.log('Using Firebase: ' + firebase_url);

	// NOTE: The limitations of a free developer Firebase account: 5 GB Data Transfer, 50 Max Connections, 100 MB Data Storage
	var Firebase = require('firebase');
	// Open Firebase connection
	var huboRef = new Firebase(firebase_url);
}

// Communicate with ACH
var hubo_ach = require('hubo-ach-readonly');

var state = {};
var serial_state = '';
var old_state = serial_state + 'not_equal';
var updateID = null;
var main = function() {
    var r = hubo_ach.init();
    if (!r) {
        console.log("Error initializing hubo-ach-readonly module. Likely cause: hubo-daemon is not running.")
        return
    }
    if (argv.socketio) {
		app.listen(6060);
		// Send initial position
		io.sockets.on('connection', function (socket) {
		  socket.emit('serial_state', serial_state);
		});
	}
    updateID = setInterval(update,1000/argv.hz);
}

var serialize = function() {
	var datastring = '{';
	datastring += '"ft":[';
	datastring += state.ft[0].m_x.toFixed(3) + ',';
	datastring += state.ft[0].m_y.toFixed(3) + ',';
	datastring += state.ft[0].f_z.toFixed(3) + ',';
	datastring += state.ft[1].m_x.toFixed(3) + ',';
	datastring += state.ft[1].m_y.toFixed(3) + ',';
	datastring += state.ft[1].f_z.toFixed(3) + ',';
	datastring += state.ft[2].m_x.toFixed(3) + ',';
	datastring += state.ft[2].m_y.toFixed(3) + ',';
	datastring += state.ft[2].f_z.toFixed(3) + ',';
	datastring += state.ft[3].m_x.toFixed(3) + ',';
	datastring += state.ft[3].m_y.toFixed(3) + ',';
	datastring += state.ft[3].f_z.toFixed(3) + ']';

	datastring += ',';
	datastring += '"imu":[';
	datastring += '{ "a_x":' + state.imu[0].a_x.toFixed(3);
	datastring += ', "a_y":' + state.imu[0].a_y.toFixed(3);
	datastring += ', "a_z":' + state.imu[0].a_z.toFixed(3);
	datastring += ', "w_x":' + state.imu[0].w_x.toFixed(3);
	datastring += ', "w_y":' + state.imu[0].w_y.toFixed(3);
	datastring += ', "w_z":' + state.imu[0].w_z.toFixed(3);
	datastring += '},';
	datastring += '{ "a_x":' + state.imu[1].a_x.toFixed(3);
	datastring += ', "a_y":' + state.imu[1].a_y.toFixed(3);
	datastring += ', "a_z":' + state.imu[1].a_z.toFixed(3);
	datastring += ', "w_x":' + state.imu[1].w_x.toFixed(3);
	datastring += ', "w_y":' + state.imu[1].w_y.toFixed(3);
	datastring += ', "w_z":' + state.imu[1].w_z.toFixed(3);
	datastring += '},';
	datastring += '{ "a_x":' + state.imu[2].a_x.toFixed(3);
	datastring += ', "a_y":' + state.imu[2].a_y.toFixed(3);
	datastring += ', "a_z":' + state.imu[2].a_z.toFixed(3);
	datastring += ', "w_x":' + state.imu[2].w_x.toFixed(3);
	datastring += ', "w_y":' + state.imu[2].w_y.toFixed(3);
	datastring += ', "w_z":' + state.imu[2].w_z.toFixed(3);
	datastring += '}]';

	datastring += ',';
	datastring += '"ref":[';
	datastring += state.joint[0].ref.toFixed(3) + ',';
	datastring += state.joint[1].ref.toFixed(3) + ',';
	datastring += state.joint[2].ref.toFixed(3) + ',';
	datastring += state.joint[3].ref.toFixed(3) + ',';
	datastring += state.joint[4].ref.toFixed(3) + ',';
	datastring += state.joint[5].ref.toFixed(3) + ',';
	datastring += state.joint[6].ref.toFixed(3) + ',';
	datastring += state.joint[7].ref.toFixed(3) + ',';
	datastring += state.joint[8].ref.toFixed(3) + ',';
	datastring += state.joint[9].ref.toFixed(3) + ',';
	datastring += state.joint[10].ref.toFixed(3) + ',';
	datastring += state.joint[11].ref.toFixed(3) + ',';
	datastring += state.joint[12].ref.toFixed(3) + ',';
	datastring += state.joint[13].ref.toFixed(3) + ',';
	datastring += state.joint[14].ref.toFixed(3) + ',';
	datastring += state.joint[15].ref.toFixed(3) + ',';
	datastring += state.joint[16].ref.toFixed(3) + ',';
	datastring += state.joint[17].ref.toFixed(3) + ',';
	datastring += state.joint[18].ref.toFixed(3) + ',';
	datastring += state.joint[19].ref.toFixed(3) + ',';
	datastring += state.joint[20].ref.toFixed(3) + ',';
	datastring += state.joint[21].ref.toFixed(3) + ',';
	datastring += state.joint[22].ref.toFixed(3) + ',';
	datastring += state.joint[23].ref.toFixed(3) + ',';
	datastring += state.joint[24].ref.toFixed(3) + ',';
	datastring += state.joint[25].ref.toFixed(3) + ',';
	datastring += state.joint[26].ref.toFixed(3) + ',';
	datastring += state.joint[27].ref.toFixed(3) + ',';
	datastring += state.joint[28].ref.toFixed(3) + ',';
	datastring += state.joint[29].ref.toFixed(3) + ',';
	datastring += state.joint[30].ref.toFixed(3) + ',';
	datastring += state.joint[31].ref.toFixed(3) + ',';
	datastring += state.joint[32].ref.toFixed(3) + ',';
	datastring += state.joint[33].ref.toFixed(3) + ',';
	datastring += state.joint[34].ref.toFixed(3) + ',';
	datastring += state.joint[35].ref.toFixed(3) + ',';
	datastring += state.joint[36].ref.toFixed(3) + ',';
	datastring += state.joint[37].ref.toFixed(3) + ',';
	datastring += state.joint[38].ref.toFixed(3) + ',';
	datastring += state.joint[39].ref.toFixed(3) + ',';
	datastring += state.joint[40].ref.toFixed(3) + ',';
	datastring += state.joint[41].ref.toFixed(3) + ']';

	datastring += ',';
	datastring += '"pos":[';
	datastring += state.joint[0].pos.toFixed(3) + ',';
	datastring += state.joint[1].pos.toFixed(3) + ',';
	datastring += state.joint[2].pos.toFixed(3) + ',';
	datastring += state.joint[3].pos.toFixed(3) + ',';
	datastring += state.joint[4].pos.toFixed(3) + ',';
	datastring += state.joint[5].pos.toFixed(3) + ',';
	datastring += state.joint[6].pos.toFixed(3) + ',';
	datastring += state.joint[7].pos.toFixed(3) + ',';
	datastring += state.joint[8].pos.toFixed(3) + ',';
	datastring += state.joint[9].pos.toFixed(3) + ',';
	datastring += state.joint[10].pos.toFixed(3) + ',';
	datastring += state.joint[11].pos.toFixed(3) + ',';
	datastring += state.joint[12].pos.toFixed(3) + ',';
	datastring += state.joint[13].pos.toFixed(3) + ',';
	datastring += state.joint[14].pos.toFixed(3) + ',';
	datastring += state.joint[15].pos.toFixed(3) + ',';
	datastring += state.joint[16].pos.toFixed(3) + ',';
	datastring += state.joint[17].pos.toFixed(3) + ',';
	datastring += state.joint[18].pos.toFixed(3) + ',';
	datastring += state.joint[19].pos.toFixed(3) + ',';
	datastring += state.joint[20].pos.toFixed(3) + ',';
	datastring += state.joint[21].pos.toFixed(3) + ',';
	datastring += state.joint[22].pos.toFixed(3) + ',';
	datastring += state.joint[23].pos.toFixed(3) + ',';
	datastring += state.joint[24].pos.toFixed(3) + ',';
	datastring += state.joint[25].pos.toFixed(3) + ',';
	datastring += state.joint[26].pos.toFixed(3) + ',';
	datastring += state.joint[27].pos.toFixed(3) + ',';
	datastring += state.joint[28].pos.toFixed(3) + ',';
	datastring += state.joint[29].pos.toFixed(3) + ',';
	datastring += state.joint[30].pos.toFixed(3) + ',';
	datastring += state.joint[31].pos.toFixed(3) + ',';
	datastring += state.joint[32].pos.toFixed(3) + ',';
	datastring += state.joint[33].pos.toFixed(3) + ',';
	datastring += state.joint[34].pos.toFixed(3) + ',';
	datastring += state.joint[35].pos.toFixed(3) + ',';
	datastring += state.joint[36].pos.toFixed(3) + ',';
	datastring += state.joint[37].pos.toFixed(3) + ',';
	datastring += state.joint[38].pos.toFixed(3) + ',';
	datastring += state.joint[39].pos.toFixed(3) + ',';
	datastring += state.joint[40].pos.toFixed(3) + ',';
	datastring += state.joint[41].pos.toFixed(3) + ']';

	datastring += '}';
	return datastring;
}

var update = function() {
    state = hubo_ach.getState()
    // TODO: Serialize compare with previous state before sending.
    serial_state = serialize();
    if (serial_state !== old_state) {
    	console.log(serial_state);
    	if (argv.socketio) {
			io.sockets.emit('serial_state', serial_state);
    	} else {
    		huboRef.child('serial_state').set(serial_state);
    	}
    }
    old_state = serial_state;
}

main();

// // This event is run when the Python bridge writes to its standard out, which 
// // we read in an interpret.
// jointControl.stdout.on('data', function(data) {
//     var lines = data.toString().split('\n');
//     for (i=0; i<lines.length; i++) {
//         var line = lines[i].trim();
//         // Skip empty lines.
//         if (line == "") {
//             continue;
//         }
//         // Parse line
//         line = line.split(':');
//         // console.log('Joint Control: ' + line);
//         var key = line[0].trim();
//         var value = line[1].trim();
//         // Update model
//         switch(key) {
//             case "status":
//                 console.log("status = " + value);
//                 ach_status = value;
//                 break;
//             case "pos":
//                 // if (ach_status == "ACH_OK") {
//                     console.log("\nPOSE = " + value);
//                     setPos(string_to_pose(value));
//                 // }
//                 break;
//             case "ref":
//                 // if (ach_status == "ACH_OK") {
//                     console.log("\nREF = " + value);
//                     setRef(string_to_pose(value));
//                 // }
//                 break;
//             case "HUBO_FT_R_HAND":
//                 setFT("HUBO_FT_R_HAND", value);
//                 break;
//             case "HUBO_FT_L_HAND":
//                 setFT("HUBO_FT_L_HAND", value);
//                 break;
//             case "HUBO_FT_R_FOOT":
//                 setFT("HUBO_FT_R_FOOT", value);
//                 break;
//             case "HUBO_FT_L_FOOT":
//                 setFT("HUBO_FT_L_FOOT", value);
//                 break;
//         }
//     }
//     jointControl.stdin.write('ok\n');
// });

// // This let's us know if the Python bridge crashes. :-(
// jointControl.on('exit', function(code) {
//     console.log('Joint Control exited with code ' + code);
// });

// function string_to_pose(pose_string) {
//     return pose_string.trim().split(/\s+/);
// }

// function setPos(pose) {
//     if (notZeros(pose)) {
//         for (var i = 0; i < joint_names.length; i++) {
//             jointRef.child(joint_names[i]).child("pos").set(parseFloat(pose[i]));
//         }
//     }
// }

// function setRef(pose) {
//     for (var i = 0; i < joint_names.length; i++) {
//         jointRef.child(joint_names[i]).child("ref").set(parseFloat(pose[i]));
//     }
// }

// function setFT(ft_name, ft_string) {
//     // TODO: Re-write this so if the string to parse is not valid, it will not crash whole server.
//     var tokens = ft_string.split(',');
//     ftRef.child(ft_name).child('m_x').set(parseFloat(tokens[0]));
//     ftRef.child(ft_name).child('m_y').set(parseFloat(tokens[1]));
//     ftRef.child(ft_name).child('f_z').set(parseFloat(tokens[2]));
// }

// // For some reason, ACH likes to return frames with ALL ZEROS, even when the status is ACH_OK sometimes.
// // Since this is highly undesireable behavior, I'm checking and discarding such frames.
// function notZeros(pose) {
//     for (var i = 0; i < pose.length; i++) {
//         if (pose[i] != 0) {
//             return true;
//         }
//     }
//     return false;
// }



// // Setup server
// var express = require('express'); // this is the webserver
// var app = express();
// app.use(express.bodyParser());
// app.use(express.methodOverride());
// app.use(app.router);
// // Serve static files out of the /out directory generated by Docpad. (Clever!)
// app.use(express.static(path.join(__dirname, '../out')));


// app.set('views', __dirname + '/views');
// app.set('view engine', 'jade');

// app.use(coffeescript({
//   src: "public",
//   bare: true
// }));



// app.get('/', function (req, res) {
//     res.render('index');
// });

// app.put('/joints/:id', function (req, res) {
//     var jointId = req.params.id.toUpperCase();
//     var jointValue = parseFloat(req.body['newValue']);
//     console.log('jointId: ' + jointId + ', jointValue: ' + jointValue);
//     jointControl.stdin.write(jointId + ' ' + jointValue + '\n'); 
//     res.send(200);
// });

// app.put('/pose', function (req, res) {
//     var pose = req.body['pose'];
//     console.log(pose);
//     var header = req.body['header'];
//     console.log(header);

//     var names = header.trim().split(/\s+/);
//     var values = pose.trim().split(/\s+/);
//     //console.log(values);
//     for (_i = 0, _len = names.length; _i < _len; _i++) {
//         name = names[_i];
//         console.log(name + ': ' + values[_i]);
//         jointControl.stdin.write(name + ' ' + values[_i] + '\n'); 
//     }
//     jointControl.stdin.write('updateRef' + '\n');
//     res.send(200);
// });

// app.put('/playTrajectory', function (req, res) {
//     var freq = req.body['frequency'];
//     var data = req.body['trajectory'];
//     var header = req.body['header']; // TODO: Include in traj file.
//     fs.writeFile("public/data/temp.traj", data, function(err) {
//         if(err) {
//             console.log(err);
//         } else {
//             console.log("The trajectory file was saved.");
//         }
//     }); 

//     // TODO: I'm getting a lot of "Set tty unbuffered error" when using the newer version
//     // of hubo-read-trajectory. I don't get this when using the Python subprocess module.
//     // So maybe it makes more sense to spawn it from python?

//     // var hubo_read_trajectory = spawn('/usr/bin/hubo-read-trajectory', 
//     //     ['-n', 'public/data/temp.traj', '-f', freq],
//     //     { stdio: 'pipe' } );

//     var hubo_read_trajectory = exec('/usr/bin/hubo-read-trajectory -n public/data/temp.traj -f ' + freq,
//         function (error, stdout, stderr) {
//             console.log('stdout: ' + stdout);
//             console.log('stderr: ' + stderr);
//             if (error !== null) {
//               console.log('exec error: ' + error);
//             }
//         });

//     // hubo_read_trajectory.on('close', function (code) {
//     //   if (code !== 0) {
//     //     console.log('hubo-read-trajectory exited with code ' + code);
//     //   }
//     // });
//     // hubo_read_trajectory.stderr.on('data', function (data) {
//     //   console.log('stderr: ' + data);
//     // });
//     // hubo_read_trajectory.stdout.on('data', function (data) {
//     //   console.log('stdout: ' + data);
//     // });
//     res.send(200);
// });

// app.get('/restartSim', function (req, res) {
//     var p1 = exec('sudo /usr/bin/hubo-ach killall > /dev/null 2>&1',
//         function (error, stdout, stderr) {
//             console.log('ran killall');
//             // console.log('stdout: ' + stdout);
//             // if (stderr !== null) {
//             //     console.log('stderr: ' + stderr);
//             // }
//             // if (error !== null) {
//             //   console.log('exec error: ' + error);
//             // }
//             // python /etc/hubo-ach/virtualHubo.py physics drc
//             var p2 = exec('sudo /usr/bin/hubo-ach sim && python /etc/hubo-ach/virtualHubo.py physics drc > /dev/null 2>&1 &', ///usr/bin/hubo-ach sim openhubo physics drc',
//                 function (error, stdout, stderr) {
//                     console.log('restarted openHubo');
//                     // console.log('stdout: ' + stdout);
//                     // if (stderr !== null) {
//                     //     console.log('stderr: ' + stderr);
//                     // }
//                     // if (error !== null) {
//                     //   console.log('exec error: ' + error);
//                     // }
//                     setTimeout(function () {
//                         // restart python script
//                         jointControl.stdin.write('\n');
//                         jointControl = spawn('python', ['joint_control.py']);
//                         console.log('Restarted joint_control.py');
//                     },7000);
//                 });
//         });

//     // hubo_read_trajectory.on('close', function (code) {
//     //   if (code !== 0) {
//     //     console.log('hubo-read-trajectory exited with code ' + code);
//     //   }
//     // });
//     // hubo_read_trajectory.stderr.on('data', function (data) {
//     //   console.log('stderr: ' + data);
//     // });
//     // hubo_read_trajectory.stdout.on('data', function (data) {
//     //   console.log('stdout: ' + data);
//     // });
//     res.send(200);
// });

// app.put('/updateRef', function (req, res) {
//     jointControl.stdin.write('updateRef' + '\n');
//     res.send(200);
// });

// app.put('/save', function (req, res) {
//     var data = req.body['data'];
//     fs.writeFile("public/data/test.traj", data, function(err) {
//         if(err) {
//             console.log(err);
//         } else {
//             console.log("The file was saved!");
//         }
//     }); 
//     res.send(200);
// });

// //jointRef.on('child_changed', function(snapshot) {
// //  var jointId = snapshot.name(),
// //      jointValue = snapshot.val();
// //  console.log('jointId: ' + jointId + ', jointValue: ' + jointValue);
// //  jointControl.stdin.write(jointId + ' ' + jointValue/100 + '\n'); 
// //});

// app.get('/exit', function(req, res) {
//     jointControl.stdin.write('\n');
// });





// app.listen(3000);
