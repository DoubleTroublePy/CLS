//Orbite simple
runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "CCtext.ks", 4, true).
if language = "fr"{
    set TextCC to Text[0].
}else if language = "en"{
    set TextCC to Text[1].
}
deletePath(CCtext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", orbit.ks, 3, true).
LogAndPrint("-----------------------").
LogAndPrint(TextCC["start"]).
set apoastre to 100000.
set periastre to 100000.
if Mov = true and (status = "PRELAUNCH" or status = "LANDED"){
    orbital(apoastre, periastre).
}else{
    LogAndPrint(TextCC["issue"]).
}
if status = "ORBITING" and (Cov = true or Co2v = true){
    loadfile("1:/", Cofile.ks, 2, true).
}
LogAndPrint(TextCC["end"]).