// Aide
runPath(lib).
// Préconfiguration langue
set language to FindLanguage().
loadfile("1:/", "AItext.ks", 4, true).
if language = "fr"{
    set TextAI to Text[0].
}else if language = "en"{
    set TextAI to Text[1].
}
deletePath(AItext.ks).
// Fin préconfiguration de la langue
local HomeWindow is gui(300).
local homebox is HomeWindow:addvlayout().
local hbox is homebox:addhlayout().
local name is hbox:addlabel(TextAI["name"]).
local closebt is hbox:addbutton("X").
local option is homebox:addpopupmenu().
local text is homebox:addlabel("").
option:addoption("1."  + TextAI["home"]).
option:addoption("2."  + TextAI["FC"]).
option:addoption("3."  + TextAI["CC"]).
option:addoption("4."  + TextAI["AO"]).
option:addoption("5."  + TextAI["D"]).
option:addoption("6."  + TextAI["C"]).
option:addoption("7."  + TextAI["A"]).
option:addoption("8."  + TextAI["EM"]).
option:addoption("9."  + TextAI["N"]).
option:addoption("10."  + TextAI["P"]).
local isDone is false.
HomeWindow:show.
until isDone{
    if option:changed{
        local value is option:value.
        if value:tostring:contains("1."){
            set text:text to TextAI["homeT"].
        }else if value:tostring:contains("2"){
            set text:text to TextAI["FCT"].
        }else if value:tostring:contains("3"){
            set text:text to TextAI["CCT"].
        }else if value:tostring:contains("4"){
            set text:text to TextAI["AOT"].
        }else if value:tostring:contains("5"){
            set text:text to TextAI["DT"].
        }else if value:tostring:contains("6"){
            set text:text to TextAI["CT"].
        }else if value:tostring:contains("7"){
            set text:text to TextAI["AT"].
        }else if value:tostring:contains("8"){
            set text:text to TextAI["EMT"].
        }else if value:tostring:contains("9"){
            set text:text to TextAI["NT"].
        }else if value:tostring:contains("10."){
            set text:text to TextAI["PT"].
        }
    }
    if closebt:takepress{set isDone to true.}
    wait 0.1.
}
HomeWindow:hide.