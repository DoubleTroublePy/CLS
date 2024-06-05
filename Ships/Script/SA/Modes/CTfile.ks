// Constellation file
// Configuration
runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "CTtext.ks", 4, true).
if language = "fr"{
    set TextCT to Text[0].
}else if language = "en"{
    set TextCT to Text[1].
}
deletePath(CTtext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", Cofile.ks, 2, true).
//Fenetre de configuration
global nb_satt is -1.
global rayon is -1.
global apoastre2 is -1.
if(ship:status = "PRELAUNCH"){
    local window1 is gui(200).
    set close1 to false.
    local topbox1 is window1:addvlayout.
    local bottombox1 is window1:addvlayout.

    local hellotext1 is topbox1:addlabel(TextCT["conf_name"]).
    set hellotext1:style:align to "center".
    set hellotext1:style:hstretch to true.

    local demandeNbSat is bottombox1:addtextfield("").
    set demandeNbSat:tooltip to TextCT["nb_sat"].
    local demandeAlt is bottombox1:addtextfield("").
    set demandeAlt:tooltip to TextCT["alt"].
    local valider is bottombox1:addbutton(TextCT["validate"]).
    local liftoff is bottombox1:addbutton(TextCT["liftoff"]).
    window1:show.
    wait until valider:pressed = true.
    local rayon is 0.
    set rayon to demandeAlt:text:tonumber.
    set rayon to rayon*1000.
    global nb_satt is 0.
    set nb_satt to demandeNbSat:text:tonumber.
    global apoastre1 is rayon.
    local inclinaison is 0.
    local period is CalcPeriodTransfer(nb_satt, rayon).
    local periodFinal is CalcPeriodeVisee(apoastre1).
    local periastre is CalcPeriapsis(rayon, period).
    wait until liftoff:pressed = true.
    set close1 to true.
    until close1.
    window1:hide.
    //Vol
    orbital(apoastre1, periastre, inclinaison).
    LogAndPrint("-----------------------").
    LogAndPrint(TextCT["reduce_diff"] + "(" + abs(period - ship:obt:period) + ")").
    if periodFinal < (ship:orbit:period - 10) or periodFinal > (ship:orbit:period + 10){
        local gravitecorps is kerbin:mu /((kerbin:radius)^2).
        local TWR is ship:availablethrust / (ship:mass * gravitecorps).
        if TWR > 1.25{
            ChangeEngine(1.25).
        }
        correction(apoastre1, periastre).
    }
    LogAndPrint(TextCT["diff_final"] + abs(period - ship:obt:period)).
    LogAndPrint(TextCT["start_deploy"]).
}
if(exists("0:/SA/Data/Msg_const.txt")){
    LogAndPrint("-----------------------").
    LogAndPrint(TextCT["switch"]).
    local messsage is open("0:/SA/Data/Msg_const.txt"):READALL:string.
    LogAndPrint(TextCT["received"]).
    set nb_satt to messsage:substring((messsage:find(",") + 1), 
                                        ((messsage:findlast(",") - messsage:find(",")) - 1)
                                    ):tonumber.
    set rayon to messsage:substring((messsage:findlast(",") + 1), 
                                        ((messsage:length - messsage:findlast(",")) - 1)
                                    ):tonumber.
    set apoastre2 to rayon.
    LogAndPrint(nb_satt).
    LogAndPrint(rayon).
    deletePath("0:/SA/Data/Msg_const.txt").
    wait until kuniverse:timewarp:rate = 1.
    wait 1.
}
LogAndPrint("-----------------------").
wait 1.
local name0 is 0.
set name0 to ship:name.
local name is name0 + " Sonde".
if (nb_satt = -1){
    LogAndPrint(TextCT["undefined"]).
    set nb_satt to 3.
    set rayon to ship:orbit:apoapsis.
    set apoastre2 to rayon.
}
if nb_satt > 0 {
    set traget_time to time:seconds + (eta:apoapsis - 127).
    warpTo(traget_time).
    wait until time:seconds >= traget_time.
    wait until kuniverse:timewarp:rate = 1.
    wait 3.
    sas off.
    lock steering to prograde.
    wait 3.
    unlock steering.
    sas on.
    wait 1.
    stage.
    LogAndPrint(TextCT["sat_deploy"]).
    wait 2.
    LogAndPrint(name).
    local stringMsg is apoastre2:tostring + "," + (nb_satt - 1):tostring.// Message à envoyer
    set vesselConnection to vessel(name).
    set my_connection to vesselConnection:connection.
    if my_connection:isconnected{
        LogAndPrint(TextCT["connexion"]).
    }else{
        LogAndPrint(TextCT["err_connexion"]).
    }
    if my_connection:sendmessage(stringMsg){
        LogAndPrint(TextCT["send_data_ok"]).
    }
    else{
        LogAndPrint(TextCT["send_date_fail"]).
    }
    set nb_satt to (nb_satt - 1).
    set kuniverse:activevessel to vessel(name).
    wait until kuniverse:activevessel = ship.
    wait 1.
    LogAndPrint(TextCT["prep"]).
    clearScreen.
}
