#include <stdlib.h>
#include <stdio.h>
#include "avl.h"

int main(){
//ouvre ou créer le fichier texte de sortie
    FILE* file = fopen("sortie.txt", "w");
    if (file == NULL) {
        printf("Erreur lors de l'ouverture du fichier.\n");
        return 1;
    }

//écrire dans le fichier
    fprintf(file, "(intitulé à modifier)\n");

//ferme le fichier
    fclose(file);

    return 0;
}
