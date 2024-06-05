local fr is lexicon(
    "start", "Début de la séquence de correction",
    "end","Correction terminée !",
    "new_obt","Nouvelle orbite",
    "ap_t","Apoapsis souhaité (km), laisser vide si pas de changement",
    "pe_t","Périapsis souhaité (km), laisser vide si pas de changement",
    "incl_t","Inclinaison souhaité, laisser vide si pas de changement",
    "validate","Valider",
    "ap_c","Correction de l'apoapsis",
    "pe_c","Correction du periapsis",
    "incl_c","Correction de l'inclinaison",
    "incl_i",
"Merci de placer le noeud au noeud ascendant ou descendant,
puis passer sur vue vaisseau quand terminé, 
Aucun deltaV à mettre",
    "pe_ap","Correction periapsis-apoapsis",
    "ap_pe","Correction apoapsis-periapsis",
    "ap_incl","Correction apoapsis-inclinaison",
    "pe_incl","Correction periapsis-inclinaison"
).

local en is lexicon(
    "start", "Start of the correction sequence",
    "end", "Correction completed!",
    "new_obt", "New orbit",
    "ap_t", "Desired Apoapsis (km), leave empty if no change",
    "pe_t", "Periapsis desired (km), leave empty if no change",
    "incl_t", "Desired inclination, leave empty if no change",
    "validate", "Validate",
    "ap_c", "Correction of apoapsis",
    "pe_c", "Periapsis correction",
    "incl_c", "Inclination correction",
    "incl_i",
"Please place the node at the ascending or descending node,
then switch to ship view when done, 
No deltaV to put",
    "pe_ap", "Correction periapsis-apoapsis",
    "ap_pe", "Correction apoapsis-periapsis",
    "ap_incl", "Correction apoapsis-inclination",
    "pe_incl","Correction periapsis-inclination"
).

global Text is list(fr, en).