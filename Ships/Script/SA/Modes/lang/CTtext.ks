local fr is lexicon(
    "conf_name","Configuration",
    "nb_sat","Nombre de satellites",
    "alt","Altitude visée (km)",
    "validate","Valider",
    "liftoff","Décollage !",
    "reduce_diff","Correction pour réduire l'écart entre la période final et actuelle",
    "diff_final","Ecart finale entre les deux périodes : ",
    "start_deploy","Début de la séquence de déploiement",
    "switch","Switch au vaisseau principal",
    "received","Reçu par message",
    "undefined","Non défini",
    "sat_deploy","sattelite déployé",
    "connexion","Connexion établie",
    "err_connexion","Impossible de se connecter",
    "send_data_ok","Donnée envoyée !",
    "send_date_fail","Donnée non envoyé",
    "prep","Préparation pour le déploiement du prochain satellite"
).

local en is lexicon(
    "conf_name", "Configuration",
    "nb_sat", "Number of satellites",
    "alt", "Target altitude (km)",
    "validate", "Validate",
    "liftoff", "Liftoff!",
    "reduce_diff", "Correction to reduce the difference between the final and current period",
    "diff_final", "Final difference between the two periods: ",
    "start_deploy", "Start of deployment sequence",
    "switch", "Switch to main ship",
    "received", "Received by message",
    "undefined", "Not defined",
    "sat_deploy", "sattelite deployed",
    "connexion", "Connection established",
    "err_connexion", "Unable to connect",
    "send_data_ok", "Data sent!",
    "send_date_fail", "Data not sent",
    "prep", "Preparing for the deployment of the next satellite"
).

global Text is list(fr, en).