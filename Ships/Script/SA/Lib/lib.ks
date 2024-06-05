// Lib.ks
copyPath("0:/SA/Lib/navball.ks", "1:/navball.ks").
runPath("1:/navball.ks").

global function loadfile{
    set directory to list("0:/SA/", "0:/SA/Modes/", "0:/SA/Lib/", "0:/SA/Modes/lang/").
    parameter destination, filename, type, start.
    if not exists(destination + filename){
        copypath(directory[type-1] + filename, destination + filename). 
    }
    if start = true{
        runPath(destination + filename).
    }
}
global function LogAndPrint{
    parameter String, Error is false, LogPath is "0:/SA/Data/log.txt".
    print(String:tostring).
    local logstring is ship:name + " : " + "'" + String +  "'" + " à " + time:full.
    log logstring to LogPath:tostring.
    if Error{
        wait 6.
        reboot.
    }
}
global function FindLanguage{
    local AllInfos is open("0:/SA/Data/info.txt"):READALL.
    for line in AllInfos{
        if line:tostring:tolower = "fr"{
            return "fr".
        }else if line:tostring:tolower = "en"{
            return "en".
        }
    }
    return false.
}
// Préconfiguration langue
set language to FindLanguage().
if language = false{
    LogAndPrint("Language problem, please check please check info.ks in data folder").
    wait 15.
    shutdown.
}
loadfile("1:/", "libtext.ks", 4, true).
if language = "fr"{
    set Textlib to Text[0].
}else if language = "en"{
    set Textlib to Text[1].
}
deletePath(libtext.ks).
// Fin préconfiguration de la langue
//Landing burn
global function landingburn {
    rcs on.
    sas off.
    for part in ship:parts{
        if (part:tag = "pied" or part:tag = "leg"){
            global pied is part.
            if pied:name = "miniLandingLeg"{
                set offset to 0.5.
            }else if pied:name = "landingLeg1"{
                set offset to 1.
            }else if pied:name = "landingLeg1-2"{
                set offset to 1.5.
            }
        }
    }
    if defined pied{
        LogAndPrint(Textlib["lb_leg_ok"]).
    }else{
        LogAndPrint(Textlib["lb_leg_fail"], true).
    }
    if defined offset{
        LogAndPrint(Textlib["st_leg_ok"]).
    }else{
        LogAndPrint(Textlib["st_leg_fail"]).
        set offset to 0.5.
    }
    lock lt to stoppingdistance() / distancetoground(1).
    ChangeEngine(100).
    wait until ship:altitude < body:atm:height.
    set brakes to true.
    wait until ship:altitude < 15000.
    when ship:altitude < 1500 then{
        set gear to true.
        lock lt to stoppingdistance() / distancetoground(2).
    }
    lock steering to srfRetrograde.
    wait until lt > 1.
    lock throttle to lt.
    wait until ship:status = "landed".
    unlock steering.
    lock throttle to 0.
    LogAndPrint(Textlib["land_success"]).
    unlock throttle.
    sas on.
    function distancetoground{
        parameter mode.
        if mode = 1{
            return (alt:radar).
        }if mode = 2{
            return (alt:radar - (pied:position - ship:rootpart:position):mag - offset).
        }
    }

    function stoppingdistance{
        local grav is constant:g * (body:mass / body:radius^2).
        lock maxdeceleration to (ship:availablethrust / ship:mass) - grav.
        return ship:verticalSpeed^2 / (2 * maxdeceleration).
    }
    
}
//Constellation
global function CalcPeriodeVisee{
    parameter rayon1.
    //local rayonObt is ().
    local Distance is 2*constant:pi*(rayon1 + body:radius).
    local Speed is sqrt(body:mu/(rayon1 + body:radius)).
    local period is Distance/Speed.
    return period.
}
global function CalcPeriodTransfer{
    parameter nb_sat, rayon.
    local period is CalcPeriodeVisee(rayon)*(1-1/nb_sat).
    return period.
}
global function CalcPeriapsis{
    parameter apo, period.
    local peri is 2*(body:mu * (period/ (2*constant:pi))^2)^(1/3) - (apo+body:radius).
    return peri - body:radius.
}
global function ChangeEngine{
    parameter TWR.
    if (TWR = 100){
        for part in ship:parts{
            if part:hasmodule("ModuleEnginesFX") and part:getmodule("ModuleEnginesFX"):hasevent("arrêter propulseur"){
                part:getmodule("ModuleEnginesFX"):setfield("limiteur de poussée", 100).
            }
        }
    }else{
        local gravitecorps is body:mu /((body:radius)^2).
        local weight is ship:mass * gravitecorps.
        local throttle1 is TWR * weight.
        LogAndPrint(Textlib["target_power"] + throttle1).
        local x is 100.
        if throttle1 < ship:maxthrust{
            for part in ship:parts{
                if part:hasmodule("ModuleEnginesFX") and part:getmodule("ModuleEnginesFX"):hasevent("arrêter propulseur"){
                    if ship:availablethrust > throttle1{
                        until throttle1 >= ship:availablethrust{
                            set x to x-0.5.
                            part:getmodule("ModuleEnginesFX"):setfield("limiteur de poussée", x).
                        }
                    }
                    if ship:availablethrust < throttle1{
                        until throttle1 <= ship:availablethrust{
                            set x to x+0.5.
                            part:getmodule("ModuleEnginesFX"):setfield("limiteur de poussée", x).
                        }
                    }
                    LogAndPrint(Textlib["power_change"]).
                }
            }
        }else{
            LogAndPrint(Textlib["change_not_need"]).
        }
    }
}
