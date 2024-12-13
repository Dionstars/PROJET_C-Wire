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
    if ! command -v ./programme_c &> /dev/null; then
        echo "'programme_c' wasn't found. Compilation in progress..."
        gcc programme_c.c -o programme_c

        if [ $? -ne 0 ]; then
            echo "Failed compilation."
            exit 1
        fi
        echo "Successful compilation."
    fi

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







                      # PARAMETRE DU SCRIPT SHELL



chemin_fichier_csv=$1
type_station=$2
type_conso=$3
identifiant_centrale=$4
option_help=$5


# Faire les vérifications des options + création du répertoire + exécution C + Gnuplot
