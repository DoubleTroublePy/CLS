runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "Dtext.ks", 4, true).
if language = "fr"{
    set TextD to Text[0].
}else if language = "en"{
    set TextD to Text[1].
}
deletePath(Dtext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", docking.ks, 3, true).
loadfile("1:/", Cofile.ks, 2, true).
LogAndPrint("-----------------------").
LogAndPrint(TextD["start"]).
if body:atm:exists{
    set apoastre to body:atm:height + 10000.
}else{
    set apoastre to 20000.
}
local periastre is apoastre.

if Mov{
    orbital(apoastre, periastre).
    LogAndPrint(TextD["orbit"]).
    set Mov to false.
}
if RDVv{
    LogAndPrint(TextD["rdv_go"]).
    if (target:orbit:inclination - ship:orbit:inclination) > 0.2 or (target:orbit:inclination - ship:orbit:inclination) < -0.2{
        LogAndPrint(TextD["corr"]).
        smallCorrection(ship:obt:inclination - body:obt:inclination, "incl").
    }
    Rendezvous().
    set RDVv to false.
}
if Dov{Docking().}
LogAndPrint(TextD["end"]).