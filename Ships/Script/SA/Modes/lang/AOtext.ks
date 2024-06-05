local fr is lexicon( // Autre orbite en français
    "start", "Début de la séquence : autres orbites", 
    "ap","Apoapsis souhaité (km)",
    "pe","Périapsis souhaité (km)",
    "incl",
"Inclinaison souhaité avec 'n' si nord 
ou 's' si sud, par ex: 90n",
    "validate","Valider",
    "liftoff","Décollage !",
    "incli_def","Mise à défaut de l'inclinaison : 0°",
    "end","Fin de la séquence : autres orbites",
    "config","Configuration"
).

local en is lexicon( // Other orbit in english
    "start", "Start of the sequence: other orbits", 
    "Ap", "Desired Apoapsis (km)",
    "Pe", "Desired periapsis (km)",
    "incl",
"Desired inclination with 'n' if north 
or 's' if south, e.g. 90n",
    "validate", "Validate",
    "liftoff", "Liftoff!",
    "incli_def", "Set default inclination: 0°",
    "end", "End of sequence: other orbits",
    "config","Setup"
).

global Text is list(fr, en).