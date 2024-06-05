//Circularisation pour les satellites
copyPath("0:/SA/Lib/lib.ks", "S:/lib.ks").
runPath("S:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("S:/", "CTstext.ks", 4, true).
if language = "fr"{
    set TextCTs to Text[0].
}else if language = "en"{
    set TextCTs to Text[1].
}
deletePath(CTstext.ks).
// Fin préconfiguration de la langue
LogAndPrint(TextCTs["wait_circ"]).
local done is false.
until done{
    when ship:messages:empty = false then{
        if (ship:messages:peek:content:tostring:contains(",") and not 
            ship:messages:peek:content:tostring:contains("Finish")){
            set done to true.
        }
        else{
            ship:messages:clear().
        }
    }.
}
LogAndPrint(TextCTs["switch"]).
local thrust is ship:availableThrust.
local gravitecorps is body:mu /((body:radius)^2).
local weight is ship:mass * gravitecorps.
local TWR is thrust/weight.
if TWR > 1.5{
    ChangeEngine(1.5).
}
sas on.
rcs on.
wait 1.
LogAndPrint(TextCTs["prep_cir"]).
set queueT to ship:messages.
local message is queueT:peek().
local messageStr is message:content:tostring.
local apoastre is messageStr:substring(0, messageStr:find(",")):tonumber().
local nb_sat is messageStr:substring((messageStr:find(",") + 1), 
                                        ((messageStr:length - messageStr:find(",")) - 1)
                                        ):tonumber().

local name is message:sender.
local periastre is apoastre.
LogAndPrint(periastre).
LogAndPrint(apoastre).
LogAndPrint(name).
LogAndPrint(nb_sat).
local periodVisee is CalcPeriodeVisee(apoastre).
LogAndPrint(periodVisee).
circularisation("Ap", ship:orbit:apoapsis, periastre).
executerManoeuvre(false, 80).
ChangeEngine(0.6).
lock throttle to 0.5.
lock steering to prograde.
local Burn_finish is false.
if(ship:obt:period - periodVisee) < 0{// Attente que la periode actuelle soit proche de la période finale
    until Burn_finish = true{
        if((ship:obt:period - periodVisee) >= -2){// Potentiel bug sur cette partie
            LogAndPrint(TextCTs["burn_end"]).
            set Burn_finish to true.
        }
        wait 0.2.
    }
}else{
    until Burn_finish = true{
        if((ship:obt:period - periodVisee) <= 2){// Potentiel bug sur cette partie
            LogAndPrint(TextCTs["burn_end"]).
            set Burn_finish to true.
        }
        wait 0.2.
    }
}
lock throttle to 0.
unlock throttle.
wait 1.
LogAndPrint(TextCTs["next_corr"]).
local finishMsg is "Finish" + "," + nb_sat:tostring + "," + apoastre.
log finishMsg to "0:/SA/Data/Msg_const.txt".
set myvessel to ship.
set myvessel:shipname to "Orbiting sat".
set core:tag to "1".
wait 5.
set kuniverse:activevessel to name.

