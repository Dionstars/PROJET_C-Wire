#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct AVLNode {
    long long plant_id;
    long long station_id;
    long long consumer_id;
    long long capacity;
    long long consumption;
    struct AVLNode* left;
    struct AVLNode* right;
    int balance;
} AVLNode;

AVLNode* createNode(long long plant_id, long long station_id, long long consumer_id, long long capacity, long long consumption) {
    AVLNode* newNode = (AVLNode*)malloc(sizeof(AVLNode));
    newNode->plant_id = plant_id;
    newNode->station_id = station_id;
    newNode->consumer_id = consumer_id;
    newNode->capacity = capacity;
    newNode->consumption = consumption;
    newNode->left = NULL;
    newNode->right = NULL;
    newNode->balance = 0;
    return newNode;
}

int height(AVLNode* node) {
    if (node == NULL) return 0;
    int hleft = height(node->left);
    int hright = height(node->right);
    return 1 + (hleft > hright ? hleft : hright);
}

int balance(AVLNode* node) {
    if (node == NULL) return 0;
    node->balance = height(node->left) - height(node->right);
    return node->balance;
}

AVLNode* rotateRight(AVLNode* node) {
    AVLNode* temp1 = node->left;
    AVLNode* temp2 = temp1->right;
    temp1->right = node;
    node->left = temp2;
    balance(node);
    balance(temp1);
    return temp1;
}

AVLNode* rotateLeft(AVLNode* node) {
    AVLNode* temp1 = node->right;
    AVLNode* temp2 = temp1->left;
    temp1->left = node;
    node->right = temp2;
    balance(node);
    balance(temp1);
    return temp1;
}

AVLNode* rotateAVL(AVLNode* node) {
    node->balance = balance(node);
    if (node->balance > 1) {
        if (node->left && node->left->balance < 0) {
            node->left = rotateLeft(node->left);
        }
        return rotateRight(node);
    }
    if (node->balance < -1) {
        if (node->right && node->right->balance > 0) {
            node->right = rotateRight(node->right);
        }
        return rotateLeft(node);
    }
    return node;
}

AVLNode* insertAVL(AVLNode* node, long long plant_id, long long station_id, long long consumer_id, long long capacity, long long consumption) {
    if (node == NULL) {
        return createNode(plant_id, station_id, consumer_id, capacity, consumption);
    }
    if (capacity < node->capacity || (capacity == node->capacity && station_id < node->station_id)) {
        node->left = insertAVL(node->left, plant_id, station_id, consumer_id, capacity, consumption);
    } else if (capacity > node->capacity || (capacity == node->capacity && station_id > node->station_id)) {
        node->right = insertAVL(node->right, plant_id, station_id, consumer_id, capacity, consumption);
    } else {
        node->consumption += consumption;
        if (capacity > 0) {
            node->capacity = capacity;
        }
    }
    return rotateAVL(node);
}

void writeFile(AVLNode* node, const char* argv2, const char* argv3, const char* argv4) {
    if (node == NULL) return;
    writeFile(node->left, argv2, argv3, argv4);
    char filename[128];
    snprintf(filename, sizeof(filename), "%s_%s_%s.csv", argv2, argv3, argv4);
    FILE *file = fopen(filename, "a");
    if (file == NULL) {
        printf("Erreur : Impossible de créer le fichier %s\n", filename);
        return;
    }
    fprintf(file, "%lld:%lld:%lld:%lld:%lld\n", node->plant_id, node->station_id, node->consumer_id, node->capacity, node->consumption);
    fclose(file);
    writeFile(node->right, argv2, argv3, argv4);
}

void freeAVL(AVLNode* node) {
    if (node) {
        freeAVL(node->left);
        freeAVL(node->right);
        free(node);
    }
}

int main(int argc, char *argv[]) {
    if (argc < 5) {
        printf("Erreur : Aucun fichier spécifié.\n");
        return 1;
    }
    char *file_path = argv[1];
    FILE *file = fopen(file_path, "r");
    if (file == NULL) {
        printf("Erreur : Impossible d'ouvrir le fichier %s\n", file_path);
        return 1;
    }
    AVLNode* root = NULL;
    char line[256];
    while (fgets(line, sizeof(line), file)) {
        char *plant_id_str = strtok(line, ";");
        char *station_id_str = strtok(NULL, ";");
        char *consumer_id_str = strtok(NULL, ";");
        char *capacity_str = strtok(NULL, ";");
        char *consumption_str = strtok(NULL, ";");
        long long plant_id = (plant_id_str && plant_id_str[0] != '-') ? atoll(plant_id_str) : 0;
        long long station_id = (station_id_str && station_id_str[0] != '-') ? atoll(station_id_str) : 0;
        long long consumer_id = (consumer_id_str && consumer_id_str[0] != '-') ? atoll(consumer_id_str) : 0;
        long long capacity = (capacity_str && capacity_str[0] != '-') ? atoll(capacity_str) : 0;
        long long consumption = (consumption_str && consumption_str[0] != '-') ? atoll(consumption_str) : 0;
        root = insertAVL(root, plant_id, station_id, consumer_id, capacity, consumption);
    }
    fclose(file);
    writeFile(root, argv[2], argv[3], argv[4]);
    freeAVL(root);
    return 0;
}