// Correction de l'orbite
runPath("lib.ks").
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "Cotext.ks", 4, true).
if language = "fr"{
    set TextCo to Text[0].
}else if language = "en"{
    set TextCo to Text[1].
}
deletePath(Cotext.ks).
// Fin préconfiguration de la langue
loadfile("1:/", orbit.ks, 3, true).
global function correction {
    LogAndPrint("-----------------------").
    LogAndPrint(TextCo["start"]).
    parameter apo is 0.
    parameter peri is 0.
    local correctionNum is 0.
    if apo = 0 {
        local window1 is gui(400).
        set close1 to false.
        local topbox1 is window1:addvlayout.
        local bottombox1 is window1:addvlayout.
        local hellotext1 is topbox1:addlabel(TextCo["new_obt"]).
        set hellotext1:style:align to "center".
        set hellotext1:style:hstretch to true.

        local demandeapo is bottombox1:addtextfield("").
        set demandeapo:tooltip to TextCo["ap_t"].
        bottombox1:addspacing(5).
        local demandeperi is bottombox1:addtextfield("").
        set demandeperi:tooltip to TextCo["pe_t"].
        bottombox1:addspacing(5).
        local demandeincl is bottombox1:addtextfield("").
        set demandeincl:tooltip to TextCo["incl_t"].
        bottombox1:addspacing(5).
        local valider is bottombox1:addbutton(TextCo["validate"]).
        window1:show.
        wait until valider:pressed = true.
        window1:hide.
        if demandeapo:text:tonumber(-999) <> -999{
            set correctionNum to correctionNum + 1.
        }
        if demandeperi:text:tonumber(-999) <> -999{
            set correctionNum to correctionNum + 1.
        }
        if demandeincl:text:tonumber(-999) <> -999{
            set correctionNum to correctionNum + 1.
        }
        if correctionNum = 3{
            set apoastre1 to demandeapo:text:tonumber.
            set apoastre1 to apoastre1 * 1000.
            set periastre to demandeperi:text:tonumber.
            set periastre to periastre * 1000.
            set inclinaisonN to demandeincl:text:tonumber.
            highCorrection(apoastre1, periastre, inclinaisonN).
        }
        if correctionNum = 2{
            if demandeapo:text:tonumber(-999) <> -999 and demandeperi:text:tonumber(-999) <> -999{
                set apoastre1 to demandeapo:text:tonumber.
                set apoastre1 to apoastre1 * 1000.
                set periastre to demandeperi:text:tonumber.
                set periastre to periastre * 1000.
                middleCorrection(apoastre1, periastre, "apo-peri").
            }
            if demandeapo:text:tonumber(-999) <> -999 and demandeincl:text:tonumber(-999) <> -999{
                set apoastre1 to demandeapo:text:tonumber.
                set apoastre1 to apoastre1 * 1000.
                set inclinaisonN to demandeincl:text:tonumber.
                middleCorrection(apoastre1, inclinaisonN, "apo-incl").
            }
            if demandeperi:text:tonumber(-999) <> -999 and demandeincl:text:tonumber(-999) <> -999{
                set periastre to demandeperi:text:tonumber.
                set periastre to periastre * 1000.
                set inclinaisonN to demandeincl:text:tonumber.
                middleCorrection(periastre, inclinaisonN, "peri-incl").
            }
        }
        if correctionNum = 1{
            if demandeapo:text:tonumber(-999) <> -999{
                set apoastre1 to demandeapo:text:tonumber.
                set apoastre1 to apoastre1 * 1000.
                smallCorrection(apoastre1, "apo").
            }
            if demandeperi:text:tonumber(-999) <> -999{
                set periastre to demandeperi:text:tonumber.
                set periastre to periastre * 1000.
                smallCorrection(periastre, "peri").
            }
            if demandeincl:text:tonumber(-999) <> -999{
                set inclinaisonN to demandeincl:text:tonumber.
                smallCorrection(inclinaisonN, "incl").
            }
        }
        window1:hide.
    }else{
        set apoastre1 to apo.
        set periastre to peri.
        middleCorrection(apoastre1, periastre, "apo-peri").
    }
    LogAndPrint(TextCo["end"]).
}
local function smallCorrection{
    parameter element.
    parameter type.
    if type = "apo"{
        LogAndPrint(TextCo["ap_c"]).
        circularisation("Pe", element, ship:orbit:periapsis).
        executerManoeuvre().
    }
    if type = "peri"{
        LogAndPrint(TextCo["pe_c"]).
        circularisation("Ap", ship:orbit:apoapsis, element).
        executerManoeuvre().
    }
    if type = "incl"{
        LogAndPrint(TextCo["incl_c"]).
        LogAndPrint(TextCo["incl_i"]).
        set actualLen to allNodes:length.
        wait until allNodes:length > actualLen.
        wait 0.1.
        wait until mapView = false.
        local v is 
        calculervitesse(ship:orbit:periapsis, ship:orbit:apoapsis, ship:altitude).
        local deltaV is v*sqrt(2*(1-cos(element))).
        set nextNode:normal to deltaV.
        executerManoeuvre().
    }
}
local function middleCorrection{
    parameter element1.
    parameter element2.
    parameter type.
    if type = "apo-peri"{ // Element1 = Apo, Element2 = Peri
        if eta:apoapsis < eta:periapsis {
            LogAndPrint(TextCo["pe_ap"]).
            smallCorrection(element2, "peri").
            smallCorrection(element1, "apo").
        }else{
            LogAndPrint(TextCo["ap_pe"]).
            smallCorrection(element1, "apo").
            smallCorrection(element2, "peri").
        }
    }else if type = "apo-incl"{// Element1 = Apo, Element2 = Incl
        LogAndPrint(TextCo["ap_incl"]).
        smallCorrection(element2, "incl").
        smallCorrection(element1, "apo").
    }else if type = "peri-incl"{// Element1 = Peri, Element2 = Incl
        LogAndPrint(TextCo["pe_incl"]).
        smallCorrection(element2, "incl").
        smallCorrection(element1, "peri").
    }
}
local function highCorrection{
    parameter apo.
    parameter peri.
    parameter incl.
    smallCorrection(incl, "incl").
    middleCorrection(apo, peri, "apo-peri").
}
if(defined Cov){
    if (Cov = true){
        correction().
    }
}
if(defined Co2v){
    if Co2v = true{
        correction().
    }
}


