runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "ATtext.ks", 4, true).
if language = "fr"{
    set TextAT to Text[0].
}else if language = "en"{
    set TextAT to Text[1].
}
deletePath(ATtext.ks).
// Fin préconfiguration de la langue
LogAndPrint("------------------------------").
LogAndPrint(TextAT["start"]).
landingburn().
LogAndPrint(TextAT["end"]).