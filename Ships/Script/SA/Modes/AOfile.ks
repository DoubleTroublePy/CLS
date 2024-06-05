//Autre orbite file
//Configuration
runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "AOtext.ks", 4, true).
if language = "fr"{
    set TextAO to Text[0].
}else if language = "en"{
    set TextAO to Text[1].
}
deletePath(AOtext.ks).
// Fin préconfiguration de la langue
LogAndPrint("------------------------------").
LogAndPrint(TextAO["start"]).
loadfile("1:/", orbit.ks, 3, true).
if Ctv{
    loadfile("1:/", CTfile.ks, 2, true).
}else{
    local window1 is gui(400).
    set close1 to false.
    local topbox1 is window1:addvlayout.
    local bottombox1 is window1:addvlayout.

    local hellotext1 is topbox1:addlabel(TextAO["config"]).
    set hellotext1:style:align to "center".
    set hellotext1:style:hstretch to true.

    local demandeapo is bottombox1:addtextfield("").
    set demandeapo:tooltip to TextAO["ap"].
    local demandeperi is bottombox1:addtextfield("").
    set demandeperi:tooltip to TextAO["pe"].
    local demandeincl is bottombox1:addtextfield("").
    set demandeincl:tooltip to TextAO["incl"].
    local valider is bottombox1:addbutton(TextAO["validate"]).
    local liftoff is bottombox1:addbutton(TextAO["liftoff"]).
    window1:show.
    wait until valider:pressed.
    set apoastre to demandeapo:text:tonumber.
    set apoastre to apoastre * 1000.
    set periastre to demandeperi:text:tonumber.
    set periastre to periastre * 1000.
    set inclinaison to demandeincl:text.
    local head is 90.
    local headlift is 90.
    local inclinaisonStr is "".
    local inclinaisonInt is 0.

    if inclinaison:contains("n"){
        set inclinaisonStr to inclinaison:substring(0, inclinaison:find("n")).
        set inclinaisonInt to inclinaisonStr:toscalar().
        set headlift to 90 - inclinaisonInt - 5.
        set head to 90 - inclinaisonInt.
    }else if inclinaison:contains("s"){
        set inclinaisonStr to inclinaison:substring(0, inclinaison:find("s")).
        set inclinaisonInt to inclinaisonStr:toscalar().
        set headlift to 90 + inclinaisonInt + 5.
        set head to 90 + inclinaisonInt.
    }else{
        LogAndPrint(TextAO["incli_def"]).
    }
    if inclinaisonInt = 0{
        set head to 90.
        set headlift to 90.
    }
    wait until liftoff:pressed.
    set close1 to true.
    until close1.
    window1:hide.
    //Vol
    set inclinaison to 0.
    if Mov{
        orbital(apoastre, periastre, headlift, head).
    }
    if status = "ORBITING" and Cov{
        correction().
    }
}
LogAndPrint(TextAO["end"]).