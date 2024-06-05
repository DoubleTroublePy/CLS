local fr is lexicon( // Aide en français 
    "name", "Aide",
    "home", "Accueil",
    "FC", "S.A controle",
    "CC", "Orbite simple",
    "AO", "Autre orbite",
    "D", "Docking",
    "C", "Correction",
    "A", "Atterissage",
    "EM", "Executer manoeuvre",
    "N", "Editeur de manoeuvre",
    "P","Plus...",
    "homeT", 
"En difficulté ?
Selectionne le point où ça bloque à l'aide du menu déroulant",
    "FCT", 
"Sur l'interface S.A contrôle, tu disposes de plusieurs boutons,
Commençons en haut : 

tu as le bouton 'logs', qui te permet de voir toutes les actions et messages du script, utile pour savoir pourquoi le script crash sans raison,
tu as le bouton '-', qui te permet de réduire la fenêtre,
tu as le bouton '+' qui te permet d'accéder aux paramètres,
tu as le bouton 'X', qui te permet de fermer la fenêtre,
pas de panique, tu peux restaurer la fenêtre en appuyant 2 fois sur le module Toggle power de ton ordinateur Kos OU avec la commande 'reboot.' dans le terminal OU avec la commande 'run restart.'. 

Ensuite, nous allons voir comment sélectionner un mode : 

1. Il faut que tu appuies sur le mode de ton choix par exemple Orbite simple
2. Il faut que tu sélectionnes les options liés à ce mode si le mode en a comme Mise en orbite dans le mode orbite simple
3. Appuie sur valider
Voilà, si tu ne vois pas de message d'erreur, tu ne t'es pas trompé

Enfin tu disposes du bouton réinitialiser qui te permet d'effacer tous les choix que tu as fait sur l'interface
",
    "CCT", 
"Dans ce mode, tu disposes de 3 options : 
'Mise en orbite' qui te permet d'aller sur orbite une orbite de rayon 100km et équatorial (0° d'inclinaison), tu dois le cocher si tu ne veux pas d'erreur, ATTENTION : Tu dois mettre des Rampes de lancements au lanceur puis les déplacer un étage après l'allumage des moteurs du première étage, dans le staging ET ton lanceur doit avoir un TWR inférieur ou égal à 1.9
De plus, le script a du mal à gérer le vol des lanceurs avec boosters latéraux !!
'Correction de trajectoire' qui te permet d'effectuer une correction de ton orbite après mise en orbite,
'Staging auto' qui te permet de laisser le script séparer automatiquement tes étages et même ta coiffe ! Si tu ne veux pas qu'elle soit séparée automatiquement, met lui un tag Kos quelconque.
",
    "AOT", 
"Dans ce mode, tu disposes de toutes les options du mode Orbite simple avec 3 différences : 
'Mise Orbite' n'est plus obligatoire si tu sélectionnes l'option Constellation ATTENTION si sélection de Mise en orbite: Tu dois mettre des Rampes de lancements au lanceur puis les déplacer un étage après l'allumage des moteurs du première étage, dans le staging.
'Mise en Orbite' te permet de te placer sur une orbite personnalisée.
'Constellation' te permet de placer en orbite une constellation de satellite.
Tu dois mettre le tag 'S' sur chacun des ordinateurs kos de tes satellites + mettre leur bootfile sur SA.ks
",
    "DT", "ATTENTION, DANS CE MODE TU DOIS NOMMER TON PORT D'AMMARAGE 'dpa' ET CIBLER LE VAISSEAU CIBLE
Dans ce mode, tu disposes de 4 options :  
'Mise Orbite' te place sur une orbite 10km au-dessus de l'atmosphère ou à 20km d'altitude si le corps n'a pas d'atmosphère ATTENTION : Tu dois mettre des Rampes de lancements au lanceur puis les déplacer un étage après l'allumage des moteurs du première étage, dans le staging.
'Rendez-vous' te permet de te placer à 50m de ta cible, il te faudra des propulseurs et des RCS.
'Docking' te permet de laisser le script amarrer ton vaisseau.
'Staging auto' qui te permet de laisser le script séparer automatiquement tes étages et même ta coiffe ! Si tu ne veux pas qu'elle soit séparée automatiquement, met lui un tag Kos quelconque.
",
    "CT", 
"Dans ce mode, tu pourras effectuer en cochant : 
une fois l'option 'Correction de trajectoire', une seule correction.
deux fois l'option 'Correction de trajectoire', deux corrections. 
",
    "AT", 
"Dans ce mode, tu n'as pas d'options MAIS tu dois mettre à un de tes pieds d'atterissage le nametag 'pied'
Tu peux donc directement appuyer sur valider après sélection
Il te fera atterrir dès que possible.
ATTENTION PAS D'ATTERRISSAGE PRECIS.
",
    "EMT", 
"Dans ce mode, tu n'as pas d'options
Tu peux donc directement appuyer sur valider après sélection
Il exécutera la manoeuvre la plus proche 
",
    "NT", "Un éditeur de manoeuvre, what else ? ",
    "PT", 
"Cette interface n'a pas répondu à tes questions ?
Tu souhaiterais en savoir plus sur le fonctionnement de l'autopilote ?
Ou alors tu voudrais me suggérer des modifications/améliorations ? 
Bref, tu souhaites entrer en contact avec moi ou des personnes capables de te répondre.
Pas de soucis, rejoint ce serveur discord : https://discord.gg/9xnGmGJtZC
"
).

local en is lexicon( // Help in english
    "name", "Help",
    "home", "Accueil",
    "FC", "S.A. control",
    "CC", "Simple orbit",
    "AO", "Other orbit",
    "D", "Docking",
    "C", "Correction",
    "A", "Landing",
    "EM", "Execute maneuver",
    "N", "Maneuver Editor",
    "P", "More...",
    "homeT", 
"In trouble?
Select the point where it blocks using the drop-down menu",
    "FCT", 
"On the S.A. control interface, you have several buttons,
Let's start at the top: 

you have the 'logs' button, which allows you to see all the actions and messages of the script,
you have the button '-', which allows you to reduce the window,
you have the 'X' button, which allows you to close the window,
don't panic, you can restore the window by pressing twice on the Toggle power module of your Kos computer or with the command 'reboot.' in the terminal. 

Next, we will see how to select a mode: 

1. You have to press the mode of your choice, for example Simple Orbit
2. You have to select the options related to this mode if the mode has some like Put in orbit in the simple orbit mode
3. Press validate
If you don't see an error message, you are not mistaken

Finally you have the reset button which allows you to erase all the choices you have made on the interface
",
    "CCT", 
"In this mode, you have 3 options: 
'Put into orbit' which allows you to go into orbit an orbit of radius 100km and equatorial (0° of inclination), you have to check it if you don't want any error, WARNING : You have to put launch ramps to the launcher and then move them one stage after the ignition of the engines of the first stage, in the staging AND your launcher must have a TWR lower or equal to 1.9
Moreover, the script has difficulties to manage the flight of launchers with side boosters !
'Course correction' which allows you to make a correction of your orbit after putting into orbit,
'Auto staging' which allows you to let the script automatically separate your stages and even your fairing! If you don't want it to be separated automatically, put a random Kos tag on it.
",
    "AOT", 
"In this mode, you have all the options of the simple orbit mode with 3 differences: 
'Put into orbit' is no longer required if you select the Constellation option WARNING if you select 'Put into orbit': You must put launch ramps on the launcher and then move them one stage after the ignition of the first stage engines, in the staging.
'Put into orbit' allows you to place yourself in a custom orbit.
'Constellation' allows you to place in orbit a constellation of satellites.
You have to put the tag 'S' on each of the kos computers of your satellites + put their bootfile on SA.ks
",
    "DT", "ATTENTION, IN THIS MODE YOU MUST NAME YOUR Docking Port 'dpa' AND TARGET VESSEL
In this mode, you have 4 options:  
Orbiting' places you in an orbit 10km above the atmosphere or 20km above if the body has no atmosphere.
Rendezvous' allows you to place yourself 50m from your target, you will need thrusters and RCS.
Docking' allows you to let the script dock your ship.
Staging auto' allows you to let the script automatically separate your floors and even your cap! If you don't want it to be separated automatically, put a Kos tag on it.
",
    "CT", 
"In this mode, you can do by checking : 
once the option 'Course correction', only one correction.
twice the option 'Course correction', two corrections. 
",
    "AT", 
"In this mode, you have no options BUT you must put the nametag 'leg' on one of your landing legs
So you can directly press validate after selection
It will land you as soon as possible.
ATTENTION NO PRECISE LANDING.
",
    "EMT", 
"In this mode, you have no options
So you can directly press validate after selection
It will execute the nearest maneuver 
",
    "NT", "A maneuver editor, what else? ",
    "PT", 
"Didn't this interface answer your questions?
Would you like to know more about how the autopilot works?
Or would you like to suggest modifications/improvements? 
In short, you want to get in touch with me or with people who can answer you.
No worries, join this discord server: https://discord.gg/9xnGmGJtZC
"
).

global Text is list(fr, en).
