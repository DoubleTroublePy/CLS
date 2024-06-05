// Editeur de noeud
runPath("1:/lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "Ntext.ks", 4, true).
if language = "fr"{
    set TextN to Text[0].
}else if language = "en"{
    set TextN to Text[1].
}
deletePath(Ntext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", orbit.ks, 3, true).

// --- DEBUT INTERFACE GRAPHIQUE --- //
set close to false.
local HomeWindow is gui(300).
set HomeWindow:y to 75.

// Ajout des boites
local homebox is HomeWindow:addvlayout().// Boite verticale 
local innerHbox1 is homebox:addhlayout().// Boite horizontale avec nom du burn, flèche, Nouveau, supression
local innerHbox2 is homebox:addhlayout().// Boite horizontale avec vue, alarme, validation et go
local innerVbox is homebox:addvlayout().// Boite verticale avec les différents composants du burn
local innerHbox1_1 is innerVbox:addhlayout().// Boite horizontale avec prograde et retrograde
local innerHbox1_2 is innerVbox:addhlayout().// Boite horizontale avec normal et antinormal
local innerHbox1_3 is innerVbox:addhlayout().// Boite horizontale avec radial et antiradial
local innerHbox1_4 is innerVbox:addhlayout().// Boite horizontale avec Temps et remise à zero
local innerVbox2 is innerVbox:addvlayout().// Boite avec les différents moyens de gérer le temps + bouton cacher car 20 boutons
local innerHbox1_4_1 is innerVbox2:addvlayout().// Boite avec les boutons temps suivants: Seconde+-, Minute+-, heure+-, Jour+-
local innerHbox1_4_1_1 is innerHbox1_4_1:addhlayout(). // Boite avec Seconde+, Minute+, heure+, Jour+
local innerHbox1_4_1_2 is innerHbox1_4_1:addhlayout(). // Boite avec Seconde-, Minute-, heure-, Jour-
local innerHbox1_4_2 is innerVbox2:addvlayout(). // Boite avec les boutons temps Suivants : Semaine+-, Mois+-, Années+-, Orbite+-
local innerHbox1_4_2_1 is innerHbox1_4_2:addhlayout(). // Boite avec Semaine+, Mois+, Années+, Orbite+
local innerHbox1_4_2_2 is innerHbox1_4_2:addhlayout(). // Boite avec Semaine-, Mois-, Années-, Orbite-
local innerHbox1_5 is innerVbox2:addhlayout().// Boite horizontale avec bouton temps : Apoapse, Periapse, Noeud ascendant et Noeud Descendant
local innerHbox1_6 is innerVbox:addvlayout().// Boite verticale avec un slider pour réduire ou augmenter l'amplitude

// Composant de la innerHbox1
local PreviousBurn is innerHbox1:addbutton("<-").
set PreviousBurn:style:hstretch to true.
local Burn_name is innerHbox1:addlabel(TextN["no_node"]). // Ajouter numéro du burn
local NextBurn is innerHbox1:addbutton("->").
set NextBurn:style:hstretch to true.
local New is innerHbox1:addbutton(TextN["new"]).
set New:style:margin:h to -2.
set New:style:margin:right to -5.
local Del is innerHbox1:addbutton(TextN["del"]).

// Composant de la innerHbox2
local View is innerHbox2:addbutton(TextN["view"]).// Switch de la vue à vaisseau
local Validate is innerHbox2:addbutton(TextN["close"]).
local Go is innerHbox2:addbutton(TextN["go"]).

// Composant de la innerHbox1_1
local ProgradeBt is innerHbox1_1:addbutton("ProgradeBt").
local RetrogradeBt is innerHbox1_1:addbutton("RetrogradeBt").
local Data_Prograde_Retrograde is innerHbox1_1:addtextfield("0").
local Unit_1 is innerHbox1_1:addlabel("m/s").
local Kill_1 is innerHbox1_1:addbutton("X").// Supprime tout le dv du composant

// Composant de la innerHbox1_2
local NormalInBt is innerHbox1_2:addbutton("NormalInBt").
local NormalOutBt is innerHbox1_2:addbutton("NormalOutBt").
local Data_Normal_In_Out is innerHbox1_2:addtextfield("0").
local Unit_2 is innerHbox1_2:addlabel("m/s").
local Kill_2 is innerHbox1_2:addbutton("X").

// Composant de la innerHbox1_3
local RadialInBt is innerHbox1_3:addbutton("RadialInBt").
local RadialOutBt is innerHbox1_3:addbutton("RadialOutBt").
local Data_Radial_In_Out is innerHbox1_3:addtextfield("0").
local Unit_3 is innerHbox1_3:addlabel("m/s").
local Kill_3 is innerHbox1_3:addbutton("X").

local CustomBtBurnList is list(New, Del, ProgradeBt, RetrogradeBt,  // Parametre pour bonton custom
                                NormalInBt, NormalOutBt,
                                RadialInBt, RadialOutBt
                                ).

local string is "".
local string2 is "".
for button in CustomBtBurnList{
    set string to "SA/Modes/Style/" + button:text.
    set string2 to string + "2".
    set button:style:bg to string.
    set button:style:hover:bg to string2.
    set button:style:active:bg to string.
    set button:style:width to 50.
    set button:style:height to 39.
    set button:text to "".
}
// Composant de la innerHbox1_4
local Hide is innerHbox1_4:addbutton(TextN["hide"]). // Bouton pour cacher les 16 boutons 
local Data_Time is innerHbox1_4:addtextfield("0").
local Unit_4 is innerHbox1_4:addlabel("s").
local Kill_4 is innerHbox1_4:addbutton("X").// Met le temps à deux secondes avant le burn

local CustomBtKillList is list(Kill_1, Kill_2, Kill_3, Kill_4).
for button in CustomBtKillList{
    set button:style:textcolor to red.
}
// -- Début Composant de la innerVbox2 --
// Composant de la innerHbox1_4_1_1
local SecPlus is innerHbox1_4_1_1:addbutton(TextN["+sec"]).
local MinPlus is innerHbox1_4_1_1:addbutton(TextN["+min"]).
local HourPlus is innerHbox1_4_1_1:addbutton(TextN["+h"]).
local DayPlus is innerHbox1_4_1_1:addbutton(TextN["+d"]).

// Composant de la innerHbox1_4_1_2
local SecMinus is innerHbox1_4_1_2:addbutton(TextN["-sec"]).
local MinMinus is innerHbox1_4_1_2:addbutton(TextN["-min"]).
local HourMinus is innerHbox1_4_1_2:addbutton(TextN["-h"]).
local DayMinus is innerHbox1_4_1_2:addbutton(TextN["-d"]).

// Composant de la innerHbox1_4_2_1
local TenDayPlus is innerHbox1_4_2_1:addbutton(TextN["+we"]).
local HunDayPlus is innerHbox1_4_2_1:addbutton(TextN["+m"]).
local YearPlus is innerHbox1_4_2_1:addbutton(TextN["+y"]).
local ObtPlus is innerHbox1_4_2_1:addbutton(TextN["+o"]).

// Composant de la innerHbox1_4_2_2
local TenDayMinus is innerHbox1_4_2_2:addbutton(TextN["-we"]).
local HunDayMinus is innerHbox1_4_2_2:addbutton(TextN["-m"]).
local YearMinus is innerHbox1_4_2_2:addbutton(TextN["-y"]).
local ObtMinus is innerHbox1_4_2_2:addbutton(TextN["-o"]).

// Composant de la innerHbox1_5 
local Ap is innerHbox1_5:addbutton("Ap").
local Pe is innerHbox1_5:addbutton("Pe").

local TimeButtonList is list(SecPlus, MinPlus, HourPlus, DayPlus,
                             SecMinus, MinMinus, HourMinus, DayMinus,
                             TenDayPlus, HunDayPlus, YearPlus, ObtPlus,
                             TenDayMinus, HunDayMinus, YearMinus, ObtMinus,
                             Ap, Pe). // Liste 
// -- Fin Composant de la innerVbox2 --
// Composant de la innerHbox1_6
global Scale_value is 1.0.
local Scale is innerHbox1_6:addlabel(TextN["scale"]).
local Scale_Slider is innerHbox1_6:addhslider(2.0, 0.0, 5.0).


// --- FIN INTERFACE GRAPHIQUE --- //


// --- DEBUT LOGIQUE --- //

local BurnNodeNum is 0.

local function ChangeNode{ // L'utilisateur passe au burn suivant ou précédent ou crée une nouvelle node
    wait 1.
    parameter type.
    //Met aucune node
    if(type = "del"){
        set BurnNodeNum to 0.
        set Burn_name:text to TextN["no_node"].
        set Data_Prograde_Retrograde:text to "0".
        set Data_Normal_In_Out:text to "0".
        set Data_Radial_In_Out to "0".
        set Data_Time:text to "0".
    }else if(type = "new" or allNodes:length = 0){ // Met une nouvelle node
        local newNode is node(time:seconds + 6, 0, 0, 0).
        wait 1.
        add newNode.
        wait 1.
        set BurnNodeNum to 0.
        set Burn_name:text to TextN["node1"].
        set Data_Prograde_Retrograde:text to nextNode:prograde:tostring.
        set Data_Normal_In_Out:text to nextNode:normal:tostring.
        set Data_Radial_In_Out:text to nextNode:radialout:tostring.
        set Data_Time:text to nextNode:eta:tostring.
    }else{ // Met la node suivante ou précédente ou fais rien
        if(type = "prev" and BurnNodeNum >= 1 and allNodes:length > 1){
            set BurnNodeNum to BurnNodeNum - 1.
        }else if(type = "next" and BurnNodeNum < allNodes:length and allNodes:length > 1){
            set BurnNodeNum to BurnNodeNum + 1.
        }else if(type = "next" and BurnNodeNum = allNodes:length){
            set BurnNodeNum to BurnNodeNum.
        }else if(type = "prev" and BurnNodeNum = 0){
            set BurnNodeNum to 0.
        }else if(type = "next" and allNodes:length = 1){
            set BurnNodeNum to 0.
        }else{
            set BurnNodeNum to 999.
        }
        if(BurnNodeNum <> 999){
            set Burn_name:text to TextN["node_n"] + (BurnNodeNum):tostring.
            set Data_Prograde_Retrograde:text to allNodes[BurnNodeNum]:prograde:tostring.
            set Data_Normal_In_Out:text to allNodes[BurnNodeNum]:normal:tostring.
            set Data_Radial_In_Out:text to allNodes[BurnNodeNum]:radialout:tostring.
            set Data_Time:text to allNodes[BurnNodeNum]:eta:tostring.
        }else{
            LogAndPrint(TextN["node_err"]).
        }
    }
}


// Composant de la innerHbox1
set PreviousBurn:onclick to {ChangeNode("prev").}.
set NextBurn:onclick to {ChangeNode("next").}.
set New:onclick to {
    LogAndPrint(TextN["+node"]).
    ChangeNode("new").
}.
set Del:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        LogAndPrint(TextN["-node"]).
        Remove allNodes[BurnNodeNum].
        set BurnNodeNum to 0.
        ChangeNode("del").
    }
}.

// Composant de la innerHbox2
set View:onclick to {
    if mapView{
        set mapView to false.
    }else{
        set mapView to true.
    }
}.

when Validate:pressed then {
    ChangeNode("del").
    wait 1.
    HomeWindow:hide.
}
set Go:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        executerManoeuvre().
        ChangeNode("del").
    }
}.

// Composant de la innerHbox1_1
set Data_Prograde_Retrograde:onconfirm to {
    parameter nothing.
    if(Burn_name:text <> TextN["no_node"]){
        set allNodes[BurnNodeNum]:prograde to Data_Prograde_Retrograde:text:toscalar.
    }
}.

set ProgradeBt:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Prograde_Retrograde:text to 
            (Data_Prograde_Retrograde:text:toscalar + Scale_value):tostring. // Nouvelle valeur de la prograde
        set allNodes[BurnNodeNum]:prograde to Data_Prograde_Retrograde:text:toscalar.
    }
}.

set RetrogradeBt:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Prograde_Retrograde:text to 
            (Data_Prograde_Retrograde:text:toscalar - Scale_value):tostring. // Nouvelle valeur de la prograde
        set allNodes[BurnNodeNum]:prograde to Data_Prograde_Retrograde:text:toscalar.
    }
}.

set Kill_1:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Prograde_Retrograde:text to "0". // Mets à 0 la prograde
        set allNodes[BurnNodeNum]:prograde to 0.
    }
}.

// Composant de la innerHbox1_2
set Data_Normal_In_Out:onconfirm to {
    parameter nothing.
    if(Burn_name:text <> TextN["no_node"]){
        set allNodes[BurnNodeNum]:normal to Data_Normal_In_Out:text:toscalar.
    }
}.

set NormalInBt:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Normal_In_Out:text to 
            (Data_Normal_In_Out:text:toscalar + Scale_value):tostring. // Nouvelle valeur de la normal
        set allNodes[BurnNodeNum]:normal to Data_Normal_In_Out:text:toscalar.
    }
}.

set NormalOutBt:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Normal_In_Out:text to 
            (Data_Normal_In_Out:text:toscalar - Scale_value):tostring. // Nouvelle valeur de l'normal
        set allNodes[BurnNodeNum]:normal to Data_Normal_In_Out:text:toscalar.
    }
}.

set Kill_2:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Normal_In_Out:text to "0". // Mets à 0 la normal
        set allNodes[BurnNodeNum]:normal to 0.
    }
}.

// Composant de la innerHbox1_3
set Data_Radial_In_Out:onconfirm to {
    parameter nothing.
    if(Burn_name:text <> TextN["no_node"]){
        set allNodes[BurnNodeNum]:radialout to Data_Radial_In_Out:text:toscalar.
    }
}.

set RadialInBt:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Radial_In_Out:text to 
            (Data_Radial_In_Out:text:toscalar + Scale_value):tostring. // Nouvelle valeur de la radial
        set allNodes[BurnNodeNum]:radialout to Data_Radial_In_Out:text:toscalar.
    }
}.

set RadialOutBt:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Radial_In_Out:text to 
            (Data_Radial_In_Out:text:toscalar - Scale_value):tostring. // Nouvelle valeur de la radial
        set allNodes[BurnNodeNum]:radialout to Data_Radial_In_Out:text:toscalar.
    }
}.

set Kill_3:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Radial_In_Out:text to "0". // Mets à 0 la radial
        set allNodes[BurnNodeNum]:radialout to 0.
    }
}.


local function TimeUpdate{// Ajoute un certain temps mis en parametre au burn actuel
    parameter AddTime.
    if(Burn_name:text <> TextN["no_node"]){
        set Scalar_previous_time to Data_Time:text:toscalar.
        set Data_Time:text to (Scalar_previous_time + AddTime):tostring.
        set allNodes[BurnNodeNum]:eta to Data_Time:text:toscalar.
    }
}
// Composant de la innerHbox1_4
set Data_Time:onconfirm to {
    parameter nothing.
    if(Burn_name:text <> TextN["no_node"]) and hide:text = "Visible"{
        set allNodes[BurnNodeNum]:eta to Data_Time:text:toscalar.
    }
}.

set Hide:onclick to {
    if SecPlus:visible {
        set Hide:text to TextN["hide"].
        for button in TimeButtonList{
            set button:visible to false.
        }
    }else{
        set Hide:text to TextN["visible"].
        for button in TimeButtonList{
            set button:visible to true.
        }
    }
}.

set Kill_4:onclick to {
    if(Burn_name:text <> TextN["no_node"]){
        set Data_Time:text to "2". // Mets à 2 secondes le temps
        set allNodes[BurnNodeNum]:eta to 2.
    }
}.

// -- Début Composant de la innerVbox2 --
// Composant de la innerHbox1_4_1_1
set SecPlus:onclick to {TimeUpdate(1).}.

set MinPlus:onclick to {TimeUpdate(60).}.

set HourPlus:onclick to {TimeUpdate(3600).}.

set DayPlus:onclick to {TimeUpdate(21600).}.

// Composant de la innerHbox1_4_1_2
set SecMinus:onclick to {TimeUpdate(-1).}.

set MinMinus:onclick to {TimeUpdate(-60).}.

set HourMinus:onclick to {TimeUpdate(-3600).}.

set DayMinus:onclick to {TimeUpdate(-21600).}.

// Composant de la innerHbox1_4_2_1
set TenDayPlus:onclick to {TimeUpdate(216000).}.

set HunDayPlus:onclick to {TimeUpdate(2160000).}.

set YearPlus:onclick to {TimeUpdate(9201600).}.

set ObtPlus:onclick to {TimeUpdate(obt:period).}.

// Composant de la innerHbox1_4_2_2
set TenDayMinus:onclick to {TimeUpdate(-216000).}.

set HunDayMinus:onclick to {TimeUpdate(-2160000).}.

set YearMinus:onclick to {TimeUpdate(-9201600).}.

set ObtMinus:onclick to {TimeUpdate(-obt:period).}.

// Composant de la innerHbox1_5 
set Ap:onclick to {TimeUpdate(eta:apoapsis).}.
set Pe:onclick to {TimeUpdate(eta:periapsis).}.

// Composant de la innerHbox1_6

set Scale_Slider:onchange to {
    parameter nothing.
    if(round(Scale_Slider:value) = 0){
        set Scale:text to TextN["scale"] + "0.01".
        set Scale_value to 0.01.
    }else if (round(Scale_Slider:value) = 1){
        set Scale:text to TextN["scale"] + "0.1".
        set Scale_value to 0.1.
    }else if (round(Scale_Slider:value) = 2){
        set Scale:text to TextN["scale"] + "1".
        set Scale_value to 1.
    }else if (round(Scale_Slider:value) = 3){
        set Scale:text to TextN["scale"] + "10".
        set Scale_value to 10.
    }else if (round(Scale_Slider:value) = 4){
        set Scale:text to TextN["scale"] + "100".
        set Scale_value to 100.
    }else if (round(Scale_Slider:value) = 5){
        set Scale:text to TextN["scale"] + "1000".
        set Scale_value to 1000.
    }else{
        LogAndPrint(TextN["scale_err"]).
    }
}.
// --- FIN LOGIQUE --- //

HomeWindow:show.
