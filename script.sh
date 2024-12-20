#!/bin/bash



                         # FONCTIONS DE PROGRAMME SCRIPT SHELL


# Fonction d'affichage de l'aide -h avec instructions
function Help() {
    echo "Use: $0 <chemin_fichier_csv> <type_station> <type_conso> [identifiant_centrale] [-h]"
    echo
    echo "Required Parameters :"
    echo "  - csv_file_path    : Path to the csv file which has the data."
    echo "  - type_station     : Type of station to be processed (hvb, hva, lv)."
    echo "  - type_consumer    : Type of consumer to be processed (comp, indiv, all)."
    echo
    echo "Optional Parameters :"
    echo "  - id_centrale      : Power plant's ID to filter results."
    echo
    echo "Options :"
    echo "  -h                    : Display this help and stop execution."
    echo
    echo "Common errors :"
    echo "  - The 'hvb all', 'hvb indiv', 'hva all' and 'hva indiv' options are prohibited."
    echo "  - Check that parameter values are consistent with requirements."
    exit 1
}

# Fonction vérifiant la présence de l'exécutable C
function Executable_C() {
    echo "Vérification de l'exécutable 'cwire'..."
    
    # Supprime l'exécutable s'il existe pour forcer la recompilation
    rm -f cwire  
    
    gcc main.c -o cwire
    if [ $? -ne 0 ]; then
        echo "Erreur de compilation de tester.c"
        exit 1
    fi

    echo "Compilation réussie."
}


# Fonction vérifiant si gnuplot est installé, sinon l'installe
function CheckAndInstallGnuplot() {
    if ! command -v gnuplot &> /dev/null; then
        echo "'gnuplot' isn't installed. Downloading in progress..."

        # Vérifier le système d'exploitation et installer gnuplot en conséquence
        if [ -x "$(command -v apt-get)" ]; then
            # Pour les distributions basées sur Debian (Ubuntu, Mint, etc.)
            sudo apt-get update
            sudo apt-get install -y gnuplot

        else
            echo "The package manager is not recognized. Manual installation required."
        fi
    else
        echo "gnuplot is already installed."
    fi
}

# Création des répertoires tmp et graphs si nécessaire
function CreateRepertory() {
    if [ ! -d "tmp" ]; then
        mkdir tmp
    else
        rm -rf tmp/*
    fi

    if [ ! -d "graphs" ]; then
        mkdir graphs
    fi
}

# Vérification de la validité des paramètres
function Options() {
    if [[ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]]; then
        echo "Error : The type of station has to be 'hvb', 'hva' or 'lv'."
        Help
    fi

    if [[ "$type_conso" != "comp" && "$type_conso" != "indiv" && "$type_conso" != "all" ]]; then
        echo "Error : The type of consumer has to be 'comp', 'indiv' or 'all'."
        Help
    fi

    if [[ ("$type_station" == "hvb" || "$type_station" == "hva") && "$type_conso" == "all" ]]; then
        echo "Error : The stations HV-B and HV-A can't have consumer 'all'."
        Help
    fi
}


function AskParameters(){
 # if[-z "$chemin_fichier_csv"];then
  #  read -p "Enter the path to the CSV file :" chemin_fichier_csv
  #fi

  if [ -z "$type_station" ]; then
    echo "Select the type of station :"
    echo "  1) hvb"
    echo "  2) hva"
    echo "  3) lv"
    read -p "Choice (1/2/3): " station_choice
    case $station_choice in
      1) type_station="hvb";;
      2) type_station="hva";;
      3) type_station="lv";;
      *) echo "Invalid choice."; exit 1;;
    esac
  fi
  if [ -z "$type_conso" ]; then
    echo "Select the type of station :"
    echo "  1) comp"
    echo "  2) indiv"
    echo "  3) all"
    read -p "Choice (1/2/3): " consu_choice
    case $consu_choice in
      1) type_conso="comp";;
      2) type_conso="indiv";;
      3) type_conso="all";;
      *) echo "Invalid choice."; exit 1;;
    esac
  fi
  if [ -z "$identifiant_centrale" ]; then
    read -p "Enter the power plant's ID :" identifiant_centrale
  fi
}
      





                      # PARAMETRE DU SCRIPT SHELL



chemin_fichier_csv=$1
type_station=$2
type_conso=$3
identifiant_centrale=$4
option_help=$5


                     # VERIFICATIONS DES OPTIONS SELECTIONNEES PAR L'UTILISATEUR

# Si l'option d'aide est présente, afficher l'aide et quitter
if [[ "$option_help" == "-h" ]]; then
    Help
fi




echo "////Welcome to C-Wire ////"

#Demande les paramètres
AskParameters

#Affiche les paramètres de l'utilisateur
echo "Parameters selected :"
echo " -CSV file path     : $chemin_fichier_csv"
echo " -Station type      : $type_station"
echo " -Consumer type     : $type_conso"
echo " -Power plants's Id : ${identifiant_centrale:-None}"

# Vérification de la validité des paramètres
Options

# Vérification de l'existence de l'exécutable C
Executable_C



                    # CREATION DU REPERTOIRE ET DEBUT DU CALCUL DU TEMPS DE TRAITEMENTS DES DONNEES



# Création des répertoires tmp et graphs
CreateRepertory

# Calcul du temps de traitement
start_time=$(date +%s)


                    # DATA FILTERING AND C PROGRAM EXECUTION
echo "Identifiant centrale utilisé : $identifiant_centrale"

if [ "$type_station" == "hvb" ] && [ "$type_conso" == "comp" ]; then
    awk -F';' '$1 == "'"$identifiant_centrale"'" && $2 != "-" {print $1";"$2";"$5";"$7";"$8}' $chemin_fichier_csv > tmp/"${type_station}_${type_conso}.csv"
elif [ "$type_station" == "hva" ] && [ "$type_conso" == "comp" ]; then
    awk -F';' '$1 == "'"$identifiant_centrale"'" && $3 != "-" {print $1";"$3";"$5";"$7";"$8}' $chemin_fichier_csv > tmp/"${type_station}_${type_conso}.csv"
elif [ "$type_station" == "lv" ] && [ "$type_conso" == "comp" ]; then
    awk -F';' '$1 == "'"$identifiant_centrale"'" && $4 != "-" {print $1";"$4";"$5";"$7";"$8}' $chemin_fichier_csv > tmp/"${type_station}_${type_conso}.csv"
elif [ "$type_station" == "lv" ] && [ "$type_conso" == "indiv" ]; then
    awk -F';' '$1 == "'"$identifiant_centrale"'" && $4 != "-" {print $1";"$4";"$6";"$7";"$8}' $chemin_fichier_csv > tmp/"${type_station}_${type_conso}.csv"
elif [ "$type_station" == "lv" ] && [ "$type_conso" == "all" ]; then
    awk -F';' '$1 == "'"$identifiant_centrale"'" && $4 != "-" {print $4";"$5";"$6";"$7";"$8}' $chemin_fichier_csv > tmp/"${type_station}_${type_conso}_tmp.csv"
    sort -t';' -k5,5n tmp/"${type_station}_${type_conso}_tmp.csv" > tmp/"${type_station}_${type_conso}_sorted.csv"
    head -n 10 tmp/"${type_station}_${type_conso}_sorted.csv" > tmp/"${type_station}_${type_conso}_top10.csv"
    tail -n 10 tmp/"${type_station}_${type_conso}_sorted.csv" > tmp/"${type_station}_${type_conso}_bottom10.csv"
    cat tmp/"${type_station}_${type_conso}_top10.csv" tmp/"${type_station}_${type_conso}_bottom10.csv" > tmp/"${type_station}_${type_conso}.csv"
fi

# Check if the temporary CSV file exists
if [ ! -s "tmp/${type_station}_${type_conso}.csv" ]; then
    echo "Error: Le fichier 'tmp/${type_station}_${type_conso}.csv' est vide ou n'a pas été généré."
    exit 1
fi

echo "Lancement du programme C"
./cwire tmp/"${type_station}_${type_conso}.csv" ${type_station} ${type_conso} ${identifiant_centrale}

# Check if the C program has run effectively
if [ $? -ne 0 ]; then
    echo "Error : C program failed."
    exit 1
fi

end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "Processing time  : $execution_time secondes."