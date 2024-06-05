runPath("lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "dockingtext.ks", 4, true).
if language = "fr"{
    set Textdocking to Text[0].
}else if language = "en"{
    set Textdocking to Text[1].
}
deletePath(dockingtext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", orbit.ks, 3, true).
loadfile("1:/", navball.ks, 3, true).
//Docking
local function Transfer_Burn{
    lock rayon to body:radius.
    lock RP to rayon + ship:periapsis.//Rayon de l'ap
    lock RM to rayon + ((ship:apoapsis + ship:periapsis)/2).//Rayon moyen
    lock RPt to rayon  + target:periapsis.
    lock RAt to rayon + target:apoapsis.//Rayon du Pe de la target
    lock RMt to rayon + ((target:apoapsis + target:periapsis)/2).//Rayon moyen de la target
    //Manoeuvre de transfert
    //
    //Position
    local DeltaT is 180 * sqrt((RM + RMt)^3/(8 * body:mu)).
    local atransfert is DeltaT / sqrt(RMt^3 / body:mu).//Angle parcouru par la cible
    local Btransfert is 180 - atransfert.
    lock asc to vAng(ship:prograde:vector, target:prograde:vector). 
    set a to asc.
    wait 1.
    set b to asc.
    set dAsc to b-a.
    local As is 0.//Angle que le vaisseau doit parcourir avant la manoeuvre de transfert 
    wait 1. 
    if dAsc > 0 {
        set As to (180 - asc) + (180 - Btransfert).
        log (Textdocking["case"] + "1") to log.txt.
    }else if dAsc < Btransfert{
        set As to asc + 180 + (180 - Btransfert).
        log (Textdocking["case"] + "2") to log.txt.
    }else{
        set As to asc - Btransfert.
        log (Textdocking["case"] + "3") to log.txt.
    }
    local vangms is 360/ship:orbit:period.
    local vangmt is 360/target:orbit:period.
    local vAMR is vangms - vangmt.
    local ttransfert is As/vAMR.
    //DeltaV
    local vi is 0.
    local vf is 0.
    set vi to calculervitesse(ship:orbit:periapsis, ship:orbit:apoapsis, ship:altitude).
    log "vi : " + vi to log.txt.
    set vf to sqrt((2 * body:mu * RPt)/(RP^2 + (RP * RAt))).
    log "vf : " + vf to log.txt.
    local DeltaVT is 0.
    set DeltaVT to Vf - vi.
    log "DeltaV : " + DeltaVT to log.txt.
    LogAndPrint(Textdocking["calc_done"]).
    //Noeud
    local noeud is node(ttransfert + time:seconds, 0, 0, DeltaVT).
    add noeud.
    wait 1.
    LogAndPrint(Textdocking["node_add"]).
    executerManoeuvre().
    wait 1.
}
global function Rendezvous{
    defVariable().
    if abs(target:altitude - apoapsis) > 8000{
        LogAndPrint(Textdocking["first_burn_go"]).
        Transfer_Burn().
        LogAndPrint(Textdocking["first_burn_end"]).
    }
    if target:distance > 2000{
        LogAndPrint(Textdocking["corr_rdv"]).
        correctionRDV().
        LogAndPrint(Textdocking["corr_rdv_end"]).
    }
    if target:distance < 2000 and target:distance > 50{
        LogAndPrint(Textdocking["end_rdv_start"]).
        EndRDV().
        LogAndPrint(Textdocking["end_rdv_end"]).
    }
}
local function correctionRDV{
    LogAndPrint(Textdocking["corr_traj"]).
    LogAndPrint(Textdocking["dist"] + round(target:distance) + "m").
    LogAndPrint("-----------------").
    unlock steering.
    sas off.
    rcs off.
    set turn to 4.
    set dist to 80000.
    set dv to 500.
    set warpv to 3.
    until turn <= 0{
        set dist to dist/2.
        set dv to dv/2.
        set turn to turn-1.
        set warp to warpv.
        wait until target:distance < (dist + 2000).
        set warp to 0.
        wait until kuniverse:timewarp:rate = 1.
        CorrectionHeading().
        sas on.
        unlock steering.
        wait 0.5.
        set sasMode to "ANTITARGET".
        wait until vAng(facing:vector, -target:position) < 1.
        ChangeEngine(100).
        lock throttle to 1.
        wait until vst:mag < dv.
        lock throttle to 0.
        wait 1.5.
        if not warpv = 2{
            set warpv to 2.
        }
    }
    LogAndPrint(Textdocking["wait_2km"]).
    set warp to 3.
    wait until target:distance < 2200.
    set warp to 0.
    wait until target:distance < 2000.
    sas off.
    lock steering to vst.
    wait until vAng(facing:vector, vst) < 1.
    ChangeEngine(1.5).
    lock throttle to 1.
    wait until vst:mag < 4.
    lock throttle to 0.
    LogAndPrint(Textdocking["corr_traj_end"]).
    LogAndPrint(Textdocking["dist"] + target:distance).
}
global function CorrectionHeading{
    parameter P_rcs is false.
    parameter P_pow is 1.
    parameter Align is false.
    local control is ship:control.
    sas off.
    if P_rcs = false{
        LogAndPrint(Textdocking["corr_engine"]).
        ChangeEngine(0.75).
        if round(arcp) < 0{
            LogAndPrint(Textdocking["first_corr"]).
            wait 0.2.
            set dir to heading(compas_Re, pitch_Re + 20).
            lock steering to dir.
            wait until vAng(facing:vector, dir:vector) < 2.
            LogAndPrint(Textdocking["align"]).
            lock throttle to 1.
            wait until arcp > (- 0.5).
            lock throttle to 0.
            wait 0.2.
        }else if round(arcp) > 0{
            LogAndPrint(Textdocking["first_corr"]).
            wait 0.2.
            set dir to heading(compas_Re, pitch_Re - 20).
            lock steering to dir.
            wait until vAng(facing:vector, dir:vector) < 2.
            LogAndPrint(Textdocking["align"]).
            lock throttle to 1.
            wait until arcp < 0.5.
            lock throttle to 0.
            wait 0.2.
        }
        ChangeEngine(0.25).
        if round(arcy, 2) < (-0.2){
            LogAndPrint(Textdocking["second_corr"]).
            wait 0.2.
            set dir to heading(compas_Re + 15, pitch_Re).
            lock steering to dir.
            wait until vAng(facing:vector, dir:vector) < 2.
            LogAndPrint(Textdocking["align"]).
            lock throttle to 1.
            wait until arcy > (- 0.1).
            lock throttle to 0.
            wait 0.2.
        }else if round(arcy, 2) > 0.2{
            LogAndPrint(Textdocking["second_corr"]).
            wait 0.2.
            set dir to heading(compas_Re - 15, pitch_Re).
            lock steering to dir.
            wait until vAng(facing:vector, dir:vector) < 2.
            LogAndPrint(Textdocking["align"]).
            lock throttle to 1.
            wait until arcy < 0.1.
            lock throttle to 0.
            wait 0.2.
        }
        unlock steering.
        wait 1.
        sas on.
    }else{
        LogAndPrint(Textdocking["corr_rcs"]).
        if Align = true{
            sas off.
            wait 0.2.
            rcs on.
            set dir to v(target:position:x , target:position:y, 0).
            lock steering to dir.
            wait until vAng(facing:vector, dir) < 0.1.
            unlock steering.
            wait 0.2.
        }
        sas on.
        rcs on.
        wait 0.2.
        set sasMode to "target".
        wait 0.2.
        if round(apcp, 1) < (-0.2){
            LogAndPrint(Textdocking["first_corr"]).
            set control:top to -P_pow.
            wait until apcp >= (-0.1).
            set control:top to 0.
            wait 0.2.
        }else if round(apcp, 1) > 0.2{
            LogAndPrint(Textdocking["first_corr"]).
            set control:top to P_pow.
            wait until apcp <= 0.1.
            set control:top to 0.
            wait 0.2.
        }
        if round(apcy, 1) < (-0.2){
            LogAndPrint(Textdocking["second_corr"]).
            set control:starboard to -P_pow.
            wait until apcy >= (-0.1).
            set control:starboard to 0.
            wait 0.2.
        }else if round(apcy, 1) > 0.2{
            LogAndPrint(Textdocking["second_corr"]).
            set control:starboard to P_pow.
            wait until apcy <= 0.1.
            set control:starboard to 0.
            wait 0.2.
        }
    }
}
local function Docking_Check{ 
    if target:distance > 100{
        LogAndPrint(Textdocking["rdv_late"]).
        Rendezvous().
    }
    clearScreen.
    if defined Dp{
        Dp:controlfrom().
    }else{
        LogAndPrint(Textdocking["need_dpa"], true).
    }
    LogAndPrint(Textdocking["target_dp"]).
    wait until (hastarget and target:typename = "DockingPort").
    clearScreen.
    LogAndPrint(Textdocking["dp_select"]).
    LogAndPrint(Textdocking["enjoy_dock"]).
    wait 2.
}
global function Docking{
    // Fonction basé sur le script de aidygus : gist.github.com/aidygus
    Docking_Check().
    clearScreen.
    sas off.
    rcs off.
    set p to 7.
    set i to p / 3.
    set st to prograde.
    lock steering to st.
    lock st to target:portfacing:vector:normalized * -1.
    wait 4.
    rcs on.
    lock cls to (target:ship:velocity:orbit - ship:velocity:orbit).
    lock u to (facing * R (-90, 0, 0)):vector:normalized.
    lock fwd to facing:vector:normalized.
    lock stb to (facing * R (0, 90, 0)):vector:normalized.
    lock uerr to target:ship:position * u.
    lock ferr to target:ship:position * fwd.
    lock stberr to target:ship:position * stb.
    lock dup to cls * u.
    lock dstb to cls * stb.
    lock dfwd to cls * fwd.
    set f to 1.
    set uint to 0.
    set stbint to 0.
    set fint to 0.
    set standoff to target:ship:position:mag.
    if standoff < 15 {set standoff to 15.}.
    lock distance_port to abs((dp:nodeposition - target:nodeposition):mag).
    until f = 0{
        if distance_port <= 4{break.}
        set fwddes to (standoff - ferr) / 10.
        if (abs(uerr) < .5) and (abs(stberr) < .5) { set fwddes to (ferr/ 20) * -1. set standoff to ferr. }.
        if fwddes > 1.5 {set fwddes to 1.5.}.
        if fwddes < -1.5 {set fwddes to -1.5.}.
        set updes to (uerr / 12) * -1.
        set stbdes to (stberr / 12) * -1.
        if updes > 1.5 {set updes to 1.5.}.
        if updes < -1.5 {set updes to -1.5.}.
        if stbdes > 1.5 {set stbdes to 1.5.}.
        if stbdes < -1.5 {set stbdes to -1.5.}.
        set fpot to dfwd - fwddes.
        set upot to dup - updes.
        set stbpot to dstb - stbdes.
        set fint to fint + fpot * .1.
        set stbint to stbint + stbpot * .1.
        set uint to uint + upot * .1.
        if fint > 5 { set fint to 5.}.
        if fint < -5 { set fint to -5. }.
        if stbint > 5 { set stbint to 5.}.
        if uint > 5 { set uint to 5. }.
        if stbint < -5 { set stbint to -5.}.
        if uint < -5 { set uint to -5. }.
        set fwdctr to fpot * p + fint * i.
        set ship:control:fore to (fwdctr).
        set upctr to upot * p + uint * i.
        set ship:control:top to (upctr).
        set stbctr to stbpot * p + stbint * i.
        set ship:control:starboard to (stbctr).
        clearscreen.
        print Textdocking["top_bottom"] + round(uerr, 2) + "m, " + round(dup, 2)+"m/s".
        print Textdocking["forward_back"] + round(distance_port, 2) + "m, " + round(dfwd, 2)+"m/s".
        print Textdocking["left_right"] + round(stberr, 2) + "m, " + round(dstb, 2)+"m/s".
        if (abs(uerr) < .5) and (abs(stberr) < .5) { print Textdocking["in_approach"]. }.
        if (abs(uerr) > .5) or (abs(stberr) > .5) { print Textdocking["stop"] + round(standoff). }.
        wait .1.
    }
    clearScreen.
    LogAndPrint(Textdocking["almost"]).
    set ship:control:fore to 0.
    set ship:control:starboard to 0.
    set ship:control:top to 0.
    unlock steering.
    wait 0.3.
    sas on.
    wait 0.3.
    set sasMode to "target".
    wait until Dp:state:contains("Docked").
    LogAndPrint(Textdocking["finish"]).
    set Dov to false.
    reboot.
}
local function EndRDV{
    lock vst to target:velocity:obt - ship:velocity:obt.
    clearScreen.
    local control is ship:control.
    sas on.
    LogAndPrint(Textdocking["first_align"]).
    CorrectionHeading(true, 1, true).
    sas on.
    wait 1.
    set sasMode to "TARGET".
    rcs on.
    //2, 1, 500, 250, 125 
    LogAndPrint(Textdocking["50m"]).
    set control:fore to 1.
    wait until vst:mag >= 4.
    set control:fore to 0.
    LogAndPrint(Textdocking["2km"]).
    set warp to 3.
    wait until target:distance <= 2500.
    set warp to 2.
    wait until target:distance <= 2100.
    set warp to 0.
    wait until target:distance <= 2000.
    set distance_t to 2000.
    until distance_t <= 62.5{
        CorrectionHeading(true, 1).
        sas on.
        wait 1.
        set sasMode to "TARGET".
        set distance_t to distance_t/2.
        set control:fore to 1.
        wait until vst:mag >= 4.
        set control:fore to 0.
        LogAndPrint(Textdocking["wait_dist"] + round(distance_t) + "m").
        set warp to 2.
        wait until target:distance <= distance_t + 100.
        set warp to 1.
        wait until target:distance <= distance_t + 20.
        set warp to 0.
        wait until target:distance <= distance_t.
    }
    LogAndPrint(Textdocking["big_deceleration"]).
    set sasMode to "TARGET".
    set control:fore to -1.
    wait until vst:mag <= 0.5.
    set control:fore to -0.5.
    wait until vst:mag <= 0.15.
    set control:fore to 0.
}
global function defVariable{
    //lock vst to target:ship:velocity:obt - ship:velocity:obt.//Retrograde:target de la navball//Vitesse entre vaisseau et cible
    lock vst to target:velocity:obt - ship:velocity:obt.
    // Pitch et yall pour retrograde(mode target)
    lock compas_and_pitch_Re to compass_and_pitch_for(ship, vst).
    lock compas_Re to compas_and_pitch_Re[0].
    lock pitch_Re to compas_and_pitch_Re[1].

    // Pitch et yall pour antitarget
    //lock compas_and_pitch_AT to compass_and_pitch_for(ship, -target:ship:position).
    lock compas_and_pitch_AT to compass_and_pitch_for(ship, -target:position).
    lock compas_AT to compas_and_pitch_AT[0].
    lock pitch_AT to compas_and_pitch_AT[1].
    lock arcp to pitch_AT - pitch_Re .//Angle retrograde Anti target pitch
    lock arcy to compas_AT - compas_Re.//Angle retrograde Anti target yaw(compas)
    lock pst to ship:velocity:obt - target:velocity:obt.
    // Pitch et yall pour target
    lock compas_and_pitch_T to compass_and_pitch_for(ship, target:position).
    lock compas_T to compas_and_pitch_T[0].
    lock pitch_T to compas_and_pitch_T[1].

    // Pitch et yall pour prograde(mode target)
    lock compas_and_pitch_Pr to compass_and_pitch_for(ship, pst).
    lock compas_Pr to compas_and_pitch_Pr[0].
    lock pitch_Pr to compas_and_pitch_Pr[1].

    lock apcp to pitch_T - pitch_Pr.//Angle prograde target pitch
    lock apcy to compas_T - compas_Pr.//Angle prograde target yaw(compas)
}
