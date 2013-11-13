#!/usr/bin/env python
# /*
# Copyright (c) 2013, William Hilton
# All rights reserved.
# */

import ach
from hubo_ach import *
import sys
import time
# import math
# import re

FLAG_DRC = False

# Ach messages
ACH_ = {
    ach.ACH_OK: 'ACH_OK',
    ach.ACH_OVERFLOW: 'ACH_OVERFLOW',
    ach.ACH_INVALID_NAME: 'ACH_INVALID_NAME',
    ach.ACH_BAD_SHM_FILE: 'ACH_BAD_SHM_FILE',
    ach.ACH_FAILED_SYSCALL: 'ACH_FAILED_SYSCALL',
    ach.ACH_STALE_FRAMES: 'ACH_STALE_FRAMES',
    ach.ACH_MISSED_FRAME: 'ACH_MISSED_FRAME',
    ach.ACH_TIMEOUT: 'ACH_TIMEOUT',
    ach.ACH_EEXIST: 'ACH_EEXIST',
    ach.ACH_ENOENT: 'ACH_ENOENT',
    ach.ACH_CLOSED: 'ACH_CLOSED',
    ach.ACH_BUG: 'ACH_BUG',
    ach.ACH_EINVAL: 'ACH_EINVAL',
    ach.ACH_CORRUPT: 'ACH_CORRUPT',
    ach.ACH_BAD_HEADER: 'ACH_BAD_HEADER',
    ach.ACH_EACCES: 'ACH_EACCES',
    ach.ACH_O_WAIT: 'ACH_O_WAIT',
    ach.ACH_O_LAST: 'ACH_O_LAST',
    ach.AchException: 'AchException'
}

string_to_index = {
    "LSP":LSP,
    "LSR":LSR,
    "LSY":LSY,
    "RSP":RSP,
    "RSR":RSR,
    "RSY":RSY,
    "LEB":LEB,
    "REB":REB,
    "RWP":RWP,
    "LWP":LWP,
    "LWR":LWR,
    "LWY":LWY,
    "RWR":RWR,
    "RWY":RWY,
    "RHP":RHP,
    "RHR":RHR,
    "RHY":RHY,
    "LHP":LHP,
    "LHR":LHR,
    "LHY":LHY,
    "RKN":RKN,
    "LKN":LKN,
    "RAR":RAR,
    "LAR":LAR,
    "LAP":LAP,
    "RAP":RAP,
    "WST":WST,
    "NK1":NK1,
    "NK2":NK2,
    "NKY":NKY,
    "RF1":RF1,
    "RF2":RF2,
    "RF3":RF3,
    "RF4":RF4,
    "RF5":RF5,
    "LF1":LF1,
    "LF2":LF2,
    "LF3":LF3,
    "LF4":LF4,
    "LF5":LF5,
    "HUBO_FT_R_HAND":HUBO_FT_R_HAND,
    "HUBO_FT_L_HAND":HUBO_FT_L_HAND,
    "HUBO_FT_R_FOOT":HUBO_FT_R_FOOT,
    "HUBO_FT_L_FOOT":HUBO_FT_L_FOOT,
    "HUBO_IMU0":HUBO_IMU0,
    "HUBO_IMU1":HUBO_IMU1,
    "HUBO_IMU2":HUBO_IMU2
    }

# NOTE: the "native format" we are going to use for a pose is a
# Python list of joint values, ordered with the same indices as 
# joints are indexed in hubo-ach.

def pose_header_string(): 
    return 'RHY RHR RHP RKN RAP RAR LHY LHR LHP LKN LAP LAR RSP RSR RSY REB RWY RWR RWP LSP LSR LSY LEB LWY LWR LWP NKY NK1 NK2 WST RF1 RF2 RF3 RF4 RF5 LF1 LF2 LF3 LF4 LF5'

def pose_to_string(pose):
    global header
    output = ''
    for i in range(len(header)):
        # This is written expanded on multiple lines to assist in debugging
        name = header[i]
        index = string_to_index[name]
        value = pose[index]
        output += '{:<+12.6f}'.format(value)
    return output

def state_pos_to_pose(state):
    global FLAG_DRC
    pose = [0 for x in range(HUBO_JOINT_COUNT)]
    if FLAG_DRC:
        pose[RWR] = state.joint[RWR].pos
        pose[LWR] = state.joint[LWR].pos
        pose[RF1] = state.joint[RF1].pos
        pose[RF2] = state.joint[RF2].pos
        pose[LF1] = state.joint[LF1].pos

    pose[RSP] = state.joint[RSP].pos
    pose[RSR] = state.joint[RSR].pos
    pose[RSY] = state.joint[RSY].pos
    pose[REB] = state.joint[REB].pos
    pose[RWY] = state.joint[RWY].pos
    pose[RWP] = state.joint[RWP].pos

    pose[LSP] = state.joint[LSP].pos
    pose[LSR] = state.joint[LSR].pos
    pose[LSY] = state.joint[LSY].pos
    pose[LEB] = state.joint[LEB].pos
    pose[LWY] = state.joint[LWY].pos
    pose[LWP] = state.joint[LWP].pos

    pose[WST] = state.joint[WST].pos

    pose[RHY] = state.joint[RHY].pos
    pose[RHR] = state.joint[RHR].pos
    pose[RHP] = state.joint[RHP].pos
    pose[RKN] = state.joint[RKN].pos
    pose[RAP] = state.joint[RAP].pos
    pose[RAR] = state.joint[RAR].pos

    pose[LHY] = state.joint[LHY].pos
    pose[LHR] = state.joint[LHR].pos
    pose[LHP] = state.joint[LHP].pos
    pose[LKN] = state.joint[LKN].pos
    pose[LAP] = state.joint[LAP].pos
    pose[LAR] = state.joint[LAR].pos
    return pose

def state_ref_to_pose(state):
    global FLAG_DRC
    pose = [0 for x in range(HUBO_JOINT_COUNT)]
    if FLAG_DRC:
        pose[RWR] = state.joint[RWR].ref
        pose[LWR] = state.joint[LWR].ref
        pose[RF1] = state.joint[RF1].ref
        pose[RF2] = state.joint[RF2].ref
        pose[LF1] = state.joint[LF1].ref

    pose[RSP] = state.joint[RSP].ref
    pose[RSR] = state.joint[RSR].ref
    pose[RSY] = state.joint[RSY].ref
    pose[REB] = state.joint[REB].ref
    pose[RWY] = state.joint[RWY].ref
    pose[RWP] = state.joint[RWP].ref

    pose[LSP] = state.joint[LSP].ref
    pose[LSR] = state.joint[LSR].ref
    pose[LSY] = state.joint[LSY].ref
    pose[LEB] = state.joint[LEB].ref
    pose[LWY] = state.joint[LWY].ref
    pose[LWP] = state.joint[LWP].ref

    pose[WST] = state.joint[WST].ref

    pose[RHY] = state.joint[RHY].ref
    pose[RHR] = state.joint[RHR].ref
    pose[RHP] = state.joint[RHP].ref
    pose[RKN] = state.joint[RKN].ref
    pose[RAP] = state.joint[RAP].ref
    pose[RAR] = state.joint[RAR].ref

    pose[LHY] = state.joint[LHY].ref
    pose[LHR] = state.joint[LHR].ref
    pose[LHP] = state.joint[LHP].ref
    pose[LKN] = state.joint[LKN].ref
    pose[LAP] = state.joint[LAP].ref
    pose[LAR] = state.joint[LAR].ref
    return pose

def state_to_ft_string(state):
    string = ''
    for name in ['HUBO_FT_R_HAND', 'HUBO_FT_L_HAND', 'HUBO_FT_R_FOOT', 'HUBO_FT_L_FOOT']:
        ind = string_to_index[name]
        string += "%s:%f,%f,%f\n" % (name, state.ft[ind].m_x, state.ft[ind].m_y, state.ft[ind].f_z)
    return string

def main():
    global header
    # Open the Hubo-Ach state channel, so we can read information
    s = ach.Channel(HUBO_CHAN_STATE_NAME)
    s.flush()
    state = HUBO_STATE()


    # Send header to Node to verify / establish joint names
    print "header:", pose_header_string()
    header = pose_header_string().split()
    # print "how big is this? ", len(header)

    while True:
        # Wait briefly
        time.sleep(0.2)
        
        # Get the current robot state
        [status, framesizes] = s.get(state, wait=False, last=True)
        print "status:", ACH_[status]
        pos_pose = state_pos_to_pose(state)
        ref_pose = state_ref_to_pose(state)
        # TODO: FT sensors

        # Output that information 
        print "pos:", pose_to_string(pos_pose)
        print "ref:", pose_to_string(ref_pose)
        print state_to_ft_string(state)
        # TODO: print FT sensors
        sys.stdout.flush()

        # Wait for feedback from Node
        line = sys.stdin.readline()
        if line == 'exit\n' or line == 'quit\n':
            break
        elif line == 'ok\n':
            # time.sleep(0.1)
            continue
        elif line == 'bad\n':
            # TODO: Implement more commands as needed.
            pass

    # Close the connection to the channels
    s.close()

main()
