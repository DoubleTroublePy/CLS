//------FC : S.A Contrôle (principal)-------
//Fenêtre principal
runPath(lib).
if exists("restart.ks") = false{
    copyPath("0:/SA/restart.ks", "1:/restart.ks").
}
// Préconfiguration langue
set language to FindLanguage().
if language = false{
    LogAndPrint("Language problem, please check info.ks in data folder").
    wait 15.
    shutdown.
}
loadfile("1:/", "FCtext.ks", 4, true).
if language = "fr"{
    set TextFC to Text[0].
}else if language = "en"{
    set TextFC to Text[1].
}
deletePath(FCtext.ks).
// Fin préconfiguration de la langue
if(exists("0:/SA/Data/Msg_const.txt")){
    LogAndPrint("-----------------------").
    LogAndPrint(TextFC["Preparation_deploy"]).
    global Ctv is true.
    loadfile("1:/", AOfile.ks, 2, true).
}
set close to false.
local HomeWindow is gui(300).
set HomeWindow:y to 75.
local homebox is HomeWindow:addhlayout().
local home_text is homebox:addlabel("home_text").
set home_text:style:fontsize to 18.
set home_text:style:textcolor to blue.
set home_text:style:hstretch to true.
set home_text:style:align to "CENTER".
local Log_bt is homebox:addbutton("Logs").
local open_log is false.
local Reduction is homebox:addbutton("-").
local Closebutton is homebox:addbutton("X").
local parameterbt is homebox:addbutton("+").
set visibleBox to true.
local vbox1 is HomeWindow:addvlayout().
local Mode_text is vbox1:addlabel("Modes :").
//Boites avec les modes :
vbox1:addspacing(10).
global CC is vbox1:addradiobutton("CC", false).
vbox1:addspacing(10).
global AO is vbox1:addradiobutton("AO", false).
vbox1:addspacing(10).
global D is vbox1:addradiobutton("D", false).
vbox1:addspacing(10).
global C is vbox1:addradiobutton("C", false).
vbox1:addspacing(10).
global A is vbox1:addradiobutton("A", false).
vbox1:addspacing(10).
global EM is vbox1:addradiobutton("EM", false).
vbox1:addspacing(10).
global N is vbox1:addradiobutton("N", false).
vbox1:addspacing(10). 
global V is vbox1:addbutton("V").
vbox1:addspacing(20).
global R is vbox1:addbutton("R").
vbox1:addspacing(10).
global AI is vbox1:addbutton("AI").
vbox1:addspacing(10).

//Boites qui contiendra les options qui feront le plan de vol
local vbox2 is HomeWindow:addvlayout().
local etape_text is vbox2:addlabel("etape_text").
global Mo is vbox2:addcheckbox("Mo", false).
global RDV is vbox2:addcheckbox("RDV", false).
global Do is vbox2:addcheckbox("Do", false).
global Co is vbox2:addcheckbox("Co", false).
global Co2 is vbox2:addcheckbox("Co2", false).
global At is vbox2:addcheckbox("At", false).
global S is vbox2:addcheckbox("S", false).
global CT is vbox2:addcheckbox("CT", false).
local FlightOptionList is list(Mo, RDV, Do, Co, Co2, At, S, CT).
for button in FlightOptionList{
    set button:visible to false.
}

//Definition du texte pour plusieurs boutons : 
local NeedEditElement is list(home_text, CC, AO, D, C, A, EM, N, V, R, AI, 
                                etape_text, Mo, RDV, Do, Co, Co2, At, S, CT).

for element in NeedEditElement{
    set element:text to TextFC[element:text].
}
//Création des variables de validation
set Mov to false.
set RDVv to false.
set Dov to false.
set Cov to false.
set Co2v to false.
set Atv to false.
set Sv to false.
set CTv to false.
set Asv to false. 
//Paramétrage des modes
set CC:onclick to {//Orbite simple
    set Mo:visible to true.
    set RDV:visible to false.
    set Do:visible to false.
    set Co:visible to true.
    set Co2:visible to false.
    set At:visible to false.
    set S:visible to true.
    set CT:visible to false.
}.
set D:onclick to {//Docking
    set Mo:visible to true.
    set Co2:visible to false.
    set RDV:visible to true.
    set Do:visible to true.
    set Co:visible to false.
    set At:visible to false.
    set S:visible to true.
    set CT:visible to false.
}.
set AO:onclick to {//Autre Orbite
    set Mo:visible to true.
    set RDV:visible to false.
    set Do:visible to false.
    set Co:visible to true.
    set Co2:visible to false.
    set At:visible to false.
    set S:visible to true.
    set CT:visible to true.
}.
set C:onclick to {//Correction
    set Mo:visible to false.
    set RDV:visible to false.
    set Do:visible to false.
    set Co:visible to true.
    set Co2:visible to true.
    set At:visible to false.
    set S:visible to false.
    set CT:visible to false.
}.
set A:onclick to {//Atterrissage
    set Mo:visible to false.
    set RDV:visible to false.
    set Do:visible to false.
    set Co:visible to false.
    set Co2:visible to false.
    set At:visible to false.
    set S:visible to false.
    set CT:visible to false.
}.
set EM:onclick to A:onclick. //Executer manoeuvre
set N:onclick to EM:onclick.// Editeur de manoeuvre
set V:onclick to {//Valider
    //Validation du plan
    if Mo:pressed{
        set Mov to true.
    }if RDV:pressed{
        set RDVv to true.
    }if Do:pressed{
        set Dov to true.
    }if Co:pressed{
        set Cov to true.
    }if Co2:pressed{
        set Co2v to true.
    }if At:pressed{
        set Atv to true.
    }if S:pressed{
        set Sv to true.
    }if CT:pressed{
        set CTv to true.
    }
    set Mo:visible to false.
    set RDV:visible to false.
    set Do:visible to false.
    set Co:visible to false.
    set Co2:visible to false.
    set At:visible to false.
    set S:visible to false.
    set CT:visible to false.
    vbox1:hide().
    vbox2:hide().
    HomeWindow:hide().
    set visibleBox to false.
    //Validation du mode
    if CC:pressed{
        loadfile("1:/", CCfile.ks, 2, true).
    }else if D:pressed{
        for part in ship:parts{
            if part:tag = "dpa"{
                global Dp is part.
                break.
            }
        }
        if defined Dp = false{
            LogAndPrint(TextFC["dpa_tag"]).
            set R:pressed to true.
        }else if hasTarget = false{
            LogAndPrint(TextFC["target_selection"]).
            set R:pressed to true.
        }else{loadfile("1:/", Dfile.ks, 2, true).}
    }else if AO:pressed{
        loadfile("1:/", AOfile.ks, 2, true).
    }else if C:pressed{
        loadfile("1:/", Cofile.ks, 2, true).
    }else if A:pressed {
        loadfile("1:/", ATfile.ks, 2, true).
    }else if EM:pressed{
        loadfile("1:/", EMfile.ks, 2, true).
    }else if N:pressed{
        loadfile("1:/", Nfile.ks, 2, true).
    }else{
        LogAndPrint(TextFC["not_select"]).
    }
    reset().
    reset().
    HomeWindow:show().
}.
local function reset {//Réinitialiser
    //Plan invisible
    set Mo:visible to false.
    set RDV:visible to false.
    set Do:visible to false.
    set Co:visible to false.
    set Co2:visible to false.
    set At:visible to false.
    set S:visible to false.
    set CT:visible to false.
    //Boutons réinitialisés
    //Plan
    set Mo:pressed to false.
    set RDV:pressed to false.
    set Do:pressed to false.
    set Co:pressed to false.
    set Co2:pressed to false.
    set At:pressed to false.
    set S:pressed to false.
    set CT:pressed to false.
    //Mode
    set CC:pressed to false.
    set D:pressed to false.
    set AO:pressed to false.
    set C:pressed to false.
    set A:pressed to false.
    set EM:pressed to false.
    set V:pressed to false.
    set R:pressed to false.
    set AI:pressed to false.
}
set R:onclick to reset@.
//Bouton de réduction
set Reduction:onclick to {
    if visibleBox = true{
        vbox1:hide().
        vbox2:hide().
        set visibleBox to false.
    }else{
        vbox1:show().
        vbox2:show().
        set visibleBox to true.
    }
}.
when Closebutton:pressed then {
    vbox1:hide().
    vbox2:hide().
    HomeWindow:hide.
}
// Logs
set Log_bt:onclick to {
    LogAndPrint(TextFC["Open_log"]).
    local window2 is gui(600, 300).
    local homebox2 is window2:addvbox().
    local home_text2 is homebox2:addlabel(TextFC["Show_log"]).
    local scroll_box is homebox2:addscrollbox().
    set scroll_box:valways to true.
    set scroll_box:style:margin:left to 5.
    local long_log is 0.
    local text_log is open("0:/SA/Data/log.txt"):readall.
    for line in text_log{
        set long_log to long_log +1.
    }
    local text_log_box is scroll_box:addlabel(text_log:string).
    set text_log_box:style:padding:v to -long_log*2.5.
    local close_bt is homebox2:addbutton(TextFC["close"]).
    window2:show.
    until close_bt:pressed.
    window2:hide.
}.
set AI:onclick to {loadfile("1:/", Aifile.ks, 2, true).}.// Aide
// Parametres
set parameterbt:onclick to {
    LogAndPrint(TextFC["open_P"]).
    local info_path is "0:/SA/Data/info.txt".
    local window3 is gui(600, 300).
    local homebox3 is window3:addvbox().
    local h_box is homebox3:addhbox().
    local home_text3 is h_box:addlabel(TextFC["P"]).
    local close_bt is h_box:addbutton(TextFC["close"]).
    local languages_label is homebox3:addlabel("Language/Langue :").
    local languages is homebox3:addpopupmenu().
    languages:addoption("Français").
    languages:addoption("English").
    window3:show.
    until close_bt:pressed.
    local AllInfos is open(info_path):READALL.
    for line in AllInfos{set ver to line. break.}
    if languages:value = "Français"{
        set lang to "fr".
    }else if languages:value = "English"{
        set lang to "en".
    }
    deletePath(info_path).
    log ver to info_path.
    log lang to info_path.
    window3:hide().
    HomeWindow:hide().
    reboot.
}.
HomeWindow:show().
until Closebutton:pressed.