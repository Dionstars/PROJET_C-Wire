# PROJET_C-Wire

## Introduction
Le projet C-Wire est un programme conçu pour synthétiser les données d'un système de distribution d'électricité.
Les données à analyser sont stockées dans un fichier appelé "DATA_CWIRE.csv" et seront filtrées par un script shell nommé "c-wire.sh" puis ensuite traitées par un programme C.
Le but de ce programme est de répondre aux demandes diverses des utilisateurs afin de déterminer si les stations (centrales, stations HV-A, stations HV-B, postes LV) sont en situation de surproduction ou de sous-production d’énergie, ainsi que
d’évaluer quelle proportion de leur énergie est consommée par les entreprises et les particuliers. 

## Programme
### Configuration
1. Récupérez les dossiers et fichiers que contient ce git
2. Par la suite dans votre terminal, accordez les permissions nécessaires au script pour permettre son éxecution:  
`chmod +x c-wire.sh`
3. Puis entrez  
   `./c-wire.sh`

### Utilisation
Une fois le programme lancé, vous devriez tomber sur une page vous demandant de sélectionner vos paramètres.  
  
__Premier paramètre :__  
`type de station à traiter : hvb (high-voltage B), hva (high-voltage A), lv (low-voltage)`  
__Deuxième paramètre :__  
`type de consommateur à traiter : comp (entreprises), indiv (particuliers), all (tous)`

__ATTENTION :__ les options suivantes sont interdites car seules des entreprises sont connectées aux stations HV-B et HV-A : hvb all, hvb, indiv, hva all, hva indiv.

__Troisième paramètre (optionnel) :__  
`Identifiant de centrale`  

__Quatrième paramètre :__  
`Option d'aide -h, qui affiche un message d'aide détaillée sur l’utilisation du script (description, fonctionnalités, options possibles, ordre des paramètres, etc…)`

### Exécution du programme C

Lorsque vous avez fini de rentrer vos paramètres, ceux-ci sont envoyés vers le programme C qui les prendra en compte et traitera les données en fonction de ces paramètres.  
Le but de ce programme est de faire la somme des consommations d’un type de station. En passant par un AVL afin de limiter le temps de traitement.





