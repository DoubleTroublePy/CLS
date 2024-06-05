runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "EMtext.ks", 4, true).
if language = "fr"{
    set TextEM to Text[0].
}else if language = "en"{
    set TextEM to Text[1].
}
deletePath(EMtext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", orbit.ks, 3, true).
LogAndPrint("-----------------------").
LogAndPrint(TextEM["ready"]).
executermanoeuvre().
LogAndPrint(TextEM["end"]).