// Librairie avec fonctions orbitales, Utilisation partielle d'OptiGT
runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "orbittext.ks", 4, true).
if language = "fr"{
    set Textorbit to Text[0].
}else if language = "en"{
    set Textorbit to Text[1].
}
deletePath(orbittext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", navball.ks, 3, true).
set Inlaunch to false.
//Recherche vitesse
local function recherchevitesse {
    set totalMass to ship:mass.
    set stageClamp to 1.
    //--- on retire la masse des rampes de lancement :
    for prt in ship:partsDubbed("launchClamp1") {
        set totalMass to totalMass - prt:mass.
    }

    if ship:partsDubbed("launchClamp1"):length > 0 {
        set stageClamp to ship:stagenum - ship:partsDubbed("launchClamp1")[0]:stage.
    }

    //--- on récupère de tous les moteurs déclenchés avant les rampes de lancement
    list ENGINES in engineList.
    local firstStageEngine is list().
    for en in engineList {
        if en:stage >= ship:stagenum - stageClamp {firstStageEngine:add(en).}
    }

    set wantedThrust to 0.
    for en in firstStageEngine {
        set wantedThrust to wantedThrust + en:possibleThrust.
    }

    //--- on calcule la gravité
    set g_here to body:mu / ((body:radius + ship:altitude)^2).
    //--- on renvoit le TWR
    set TWR to wantedThrust / (totalMass*g_here).
    if TWR > 1.9{
        lock throttle to 0.
        unlock throttle.
        unlock steering.
        LogAndPrint(Textorbit["twr_problem"], true).
    }else if TWR > 1.6 and TWR <= 1.9 and stage:solidfuel = 0{
        set Vamp to 65.
        set Vpitch to 32.143 * TWR^2 - 249.4 * TWR + 364.42 + 30.
    }else if TWR > 1.6 and TWR <= 1.9 and stage:solidfuel > 0.1{
        set Vamp to 65.
        set Vpitch to 32.143 * TWR^2 - 249.4 * TWR + 364.42 + 50.
    }else if TWR <= 1.6 and stage:solidfuel = 0{
        set Vamp to 75.
        set vpitch to 35.714 * TWR^2 - 223.57 * TWR + 292.71 + 30.
    }else if TWR <= 1.6 and stage:solidfuel > 0.1{
        set Vamp to 80.
        set vpitch to 50 * TWR^2 - 249.57 * TWR + 287.63 + 50.
    }
}
// Verification si aucun problème
local function fail{
    // Inclinaison verticale du lanceur passant sous l'horizon
    if vANg(up:vector, prograde:vector) > 90.5{
        if ship:altitude > 500 and ship:status <> "preLaunch" and Inlaunch{
            return true.
        }
    }else{
        return false.
    }
}
//Gravity Turn
global function gravityTurn {
    parameter apoastre, periastre, headLift, head.
    when fail() then{
        local explosion_name is "TacSelfDestruct".
        LogAndPrint(Textorbit["failure"]).
        lock throttle to 0.
        unlock steering.
        set abort to true.
        // Possiblement appeller une fonction
        wait 1.
        for part in ship:parts{
            if (part:hasmodule(explosion_name)){
                if(part:getmodule(explosion_name):hasevent("self destruct!")){
                    LogAndPrint(Textorbit["self_destruct"]).
                    part:getmodule(explosion_name):doevent("self destruct!").
                }
            }
        }
    }
    if head > headLift{
        set inclinaison to 90 - head.
        set sign to true. // Signe +(inclinaison de l'orbite)
    }else{
        set inclinaison to (-90) + head.
        set sign to false. // Signe -(inclinaison de l'orbite)
    }
    LogAndPrint("-----------------------").
    LogAndPrint(Textorbit["head_lift"] + headLift + "°").
    LogAndPrint(Textorbit["head_end"] + head + "°").
    set size to ship:bounds:size:mag.
    lock throttle to 1.
    sas off.
    rcs off.
    set steelift to facing.
    lock steering to steelift.
    LogAndPrint(Textorbit["liftoff"]).
    LogAndPrint(Textorbit["ap_target"] + (apoastre/1000):tostring + " km").
    LogAndPrint(Textorbit["pe_target"] + (periastre/1000):tostring + " km").
    LogAndPrint(Textorbit["incl"] + inclinaison + "°").
    LogAndPrint("----------------------").
    wait 1.
    until stageClamp = 0{
        set stageClamp to stageClamp - 1.
        stage.
        wait 0.3.
        wait until stage:ready.
    }
    wait until ship:bounds:bottomalt > size + 1.
    LogAndPrint(Textorbit["lp_left"]).
    set Inlaunch to true.
    lock steering to heading(headLift,90).
    wait until ship:verticalspeed > vpitch.
    LogAndPrint(Textorbit["gt_start"]).
    local directionDepart is heading(headLift, Vamp).
    //inclinaison = inclinaison de l'orbite
    //angle = inclinaison du vaisseau pour gravity turn
    lock steering to directionDepart.
    wait until vAng(facing:vector, directionDepart:vector) < 1.
    wait until vAng(srfPrograde:vector, facing:vector) < 1.
    lock steering to heading(headLift, 90 - vAng(up:vector, srfPrograde:vector)).
    wait until abs(ship:orbit:inclination - inclinaison) < 1.25.// Le vaisseau a atteint l'angle voulu
    if inclinaison <> 0{
        local headprime is headLift.
        if(sign = true){
            set headprime to headprime + 1.5.
            LogAndPrint(Textorbit["add_head"]).
            lock steering to heading(headprime, 90 - vAng(up:vector, srfPrograde:vector)).
            wait until abs(ship:orbit:inclination - inclinaison) < 0.1.
        }else{
            set headprime to headprime - 1.5.
            LogAndPrint(Textorbit["sub_head"]).
            lock steering to heading(headprime, 90 - vAng(up:vector, srfPrograde:vector)).
            wait until abs(ship:orbit:inclination - inclinaison) < 0.1.
        }
    }
    LogAndPrint("---------------").
    lock steering to heading(head, 90 - vAng(up:vector, srfPrograde:vector)). // Se bloque dans la direction
    wait until apoapsis >= 0.95 * periastre.
    lock throttle to 0.25.
    wait until apoapsis >= periastre.
    lock throttle to 0.
    LogAndPrint("----------------------").
    LogAndPrint(Textorbit["gt_end"]).
    set Inlaunch to false.
}
//Calculer vitesse
global function calculervitesse{
    parameter peri, apo, shipaltitude.
    local a is (peri + apo + 2*body:radius)/2.
    local alti is shipaltitude + body:radius.
    return sqrt(body:mu*(2/alti - 1/a)).
}
//Transfert Hohman
global function transfert {
    parameter shipaltitude, altitudecible.

    local Vi is 0.//vitesse initiale
    local Vf is 0.//vitesse finale
    local DeltaV is 0.

    set Vi to calculervitesse(ship:orbit:periapsis, ship:orbit:apoapsis, shipaltitude).
    
    if shipaltitude < altitudecible {
        set Vf to calculervitesse(shipaltitude, altitudecible, shipaltitude).
    }
    else{
         set Vf to calculervitesse(altitudecible, shipaltitude, shipaltitude).
    }
    set DeltaV to Vf - vi.
    LogAndPrint("-----------------------").
    LogAndPrint(Textorbit["Vm"]).
    LogAndPrint(Textorbit["Vi"] + round(Vi, 2) + "m/s").
    LogAndPrint(Textorbit["Vf"] + round(Vf, 2) + "m/s").
    LogAndPrint("DeltaV = " + round(DeltaV, 2) + "m/s").
    LogAndPrint("-----------------------").
    return DeltaV.

}
//Circularisation
global function circularisation {
    parameter ApPe, apoastre, periastre.
    local DeltaV is 0.
    local noeudcirc is node(0, 0, 0, 0).
    if ApPe = "Ap" {
        set DeltaV to transfert(periastre, apoastre).
        set noeudcirc to node(time:seconds + eta:apoapsis, 0, 0, DeltaV).
    }
    else {
        set DeltaV to transfert(periastre, apoastre).
        set noeudcirc to node(time:seconds + eta:periapsis, 0, 0, DeltaV).
    }
    add noeudcirc.
}
//Executer manoeuvre
global function executerManoeuvre {
    parameter complete is true.
    parameter percetage is 100.
    local pourcentage is percetage/100.
    when ship:maxthrust = 0 then{
        stage.
        preserve.
    }
    sas off.
    local noeud is nextNode.
    local noeud_rest is noeud:deltav:mag * (1-pourcentage).
    rcs on.
    
    local max_acc is ship:availablethrust/ship:mass.
    local burn_duration is noeud:deltav:mag/max_acc.
    local half_burn is burn_duration/2.
    local done is false.
    until done{
        if body:atm:exists{
            until altitude > body:atm:height{
                if time:seconds = (time:seconds + noeud:eta - half_burn + 10){
                    break.
                }
                wait 0.1.
            }
        }
        set done to true.
    }
    lock steering to noeud:burnVector.
    wait until vAng(noeud:deltav, ship:facing:vector) < 0.25.
    
    warpTo(time:seconds + noeud:eta - (burn_duration/2 + 20)).
    
    wait until noeud:eta <= (burn_duration/2).

    local tset is 0.
    lock throttle to tset.

    set done to False.
    local dv0 is noeud:deltav.
    if complete{
        until done
        {
            set max_acc to ship:availablethrust/ship:mass.
            set tset to min(noeud:deltav:mag/max_acc, 1).

            if noeud:deltav:mag < 1 {
                wait until vdot(dv0, noeud:deltav) < 0.05.
                lock throttle to 0.
                set done to True.
            }
            
        }
        unlock steering.
        unlock throttle.
        wait 1.
        remove noeud.

        wait 1.
        sas on.
        wait 2.
    }else{
        LogAndPrint(Textorbit["burn_not_full"]).
        LogAndPrint(Textorbit["resting_dv"] + noeud_rest).
        until done
        {
            set max_acc to ship:availablethrust/ship:mass.
            set tset to min(noeud:deltav:mag/max_acc, 1).

            if vDot(dv0, noeud:deltav) < noeud_rest{
                lock throttle to 0.
                break.
            }

            when noeud:deltav:mag < noeud_rest then{
                lock throttle to 0.
                set done to True.
            }
            
        }
        unlock steering.
        unlock throttle.
        wait 0.5.
        remove noeud.
    }
    
}
// Lancement orbital
global function orbital {
    parameter apoastre , periastre, headlift is 90, head is 90.
    local apoastre2 is apoastre.
    local periastre2 is periastre.
    recherchevitesse().
    if Sv = true{
        when Inlaunch then {
            when (stage:liquidfuel < 0.1 and stage:solidfuel < 0.1) then{
                wait until stage:ready.
                stage.
                LogAndPrint(Textorbit["stage_sep"]).
                preserve.
            }
            when ship:altitude > 70000 then{
                for part in ship:parts{
                    if part:hasmodule("ModuleProceduralFairing") and part:tag = ""{ 
                        part:getmodule("ModuleProceduralFairing"):doaction("déployer", true).
                        LogAndPrint(Textorbit["fairing_sep"]).
                    }
                }
            }
        }
    }
    
    gravityTurn(apoastre2, periastre2, headlift, head).
    LogAndPrint(Textorbit["circ_start"]).
    circularisation("Ap", apoastre2, periastre2).
    executermanoeuvre().
    LogAndPrint(Textorbit["circ_end"]).
}
