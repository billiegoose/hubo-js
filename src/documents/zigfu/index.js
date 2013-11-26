$('document').ready( function() {
  // Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
  c = new WebGLRobots.DefaultCanvas('#hubo_container');
  // Create a new robot instance.
  window.hubo = new Hubo('hubo2',
    function callback() {
      // Once the URDF is completely loaded, this function is run.
      // Add your robot to the canvas.
      c.add(hubo);
      $('#load').hide();

      var radardiv = document.getElementById('radar');
      var radar = {
        onuserfound: function (user) {
          console.log('running onnewuser in radar');
          bob = user;
        },
        onuserlost: function (user) {
          console.log('running onlostuser in radar');
        },
        ondataupdate: function (zigObject) {
          for (var userid in zigObject.users) if (zigObject.users.hasOwnProperty(userid)) {
            var user = zigObject.users[userid];
            if (user.skeletonTracked) {
              // 1: Head
              // 2: Neck
              // 3: Torso
              // 6: Left Shoulder
              // 7: LeftElbow
              // 9: LeftHand
              // 12: RightShoulder
              // 13: RightElbow
              // 15: RightHand
              // 17: LeftHip
              // 18: LeftKnee
              // 20: LeftFoot
              // 21: RightHip
              // 22: RightKnee
              // 24: RightFoot
              // if (bobi == 100) {
              //     console.log(user.skeleton);
              //     bobi = 101;
              // } else {
              //   bobi += 1;
              // }
              var s = user.skeleton;
              var L_shoulder = new THREE.Vector3().fromArray(s[zig.Joint.RightShoulder].position);
              var L_elbow = new THREE.Vector3().fromArray(s[zig.Joint.RightElbow].position);
              var L_hand = new THREE.Vector3().fromArray(s[zig.Joint.RightHand].position);
              var L_upper_arm = new THREE.Vector3().copy(L_shoulder).sub(L_elbow);
              var L_lower_arm = new THREE.Vector3().copy(L_hand).sub(L_elbow);
              var L_shoulder = new THREE.Vector3().copy(L_elbow).sub(L_shoulder);
              var LSR_angle = Math.asin(L_shoulder.y/L_shoulder.length());
              var LEP_angle = L_upper_arm.angleTo(L_lower_arm);

              var R_shoulder = new THREE.Vector3().fromArray(s[zig.Joint.LeftShoulder].position);
              var R_elbow = new THREE.Vector3().fromArray(s[zig.Joint.LeftElbow].position);
              var R_hand = new THREE.Vector3().fromArray(s[zig.Joint.LeftHand].position);
              var R_upper_arm = new THREE.Vector3().copy(R_shoulder).sub(R_elbow);
              var R_lower_arm = new THREE.Vector3().copy(R_hand).sub(R_elbow);
              var R_shoulder = new THREE.Vector3().copy(R_elbow).sub(R_shoulder);
              var RSR_angle = Math.asin(R_shoulder.y/R_shoulder.length());
              var REP_angle = R_upper_arm.angleTo(R_lower_arm);
              // console.log(upper_arm);
              // console.log(lower_arm);
              // console.log(LEP_angle + ', ' + REP_angle);
              hubo.motors.LEP.value = -(Math.PI + hubo.motors.LEP.offset - LEP_angle);
              hubo.motors.REP.value = -(Math.PI + hubo.motors.REP.offset - REP_angle);
              hubo.motors.LSR.value = +(Math.PI/2 - hubo.motors.LSR.offset + LSR_angle);
              hubo.motors.RSR.value = -(Math.PI/2 + hubo.motors.RSR.offset + RSR_angle);
            }
          }
        }
      };
      // Add the radar object as a listener to the zig object, so that 
      // the zig object will call the radar object's callback functions.
      zig.addListener(radar);
    },
    function progress(step,total,node) {
      $('#load').html("Loading " + step + "/" + total);
    }
  );

  $('#mouse_info_dialog').dialog(
      { autoOpen: false
      , closeOnEscape: true
      , buttons: { OK: function () { $(this).dialog('close'); } }
      }
  );

  $('#mouse_info_button').on('click', function() { $('#mouse_info_dialog').dialog('open'); });

  bob = {};
  bobi = 0;


  // setInterval(trackingp,1000);
});