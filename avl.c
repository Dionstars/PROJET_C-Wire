#include "avl.h"

AVLNode* createNode(int station_id, int capacity){
    AVLNode* newNode = (AVLNode*)malloc(sizeof(AVLNode));
    if (newNode==NULL){
        printf("Allocation failed!");
        exit(EXIT_FAILURE);
    }
    newNode->station_id = station_id;
    newNode->capacity = capacity;
    newNode->consumption = 0;
    newNode->left = NULL;
    newNode->right = NULL;
    newNode->balance = 0;
    return newNode;
}

int height(AVLNode* node){
    if (node==NULL){
        return 0;
    }
    int hleft = height(node->left);
    int hright = height(node->right);
    return 1 + (hleft>hright ? hleft : hright);
}

int balance(AVLNode* node){
    if (node==NULL){
        return 0;
    }
    node->balance = height(node->left) - height(node->right);
    return node->balance;
}

AVLNode* rotateRight(AVLNode* node){
    AVLNode* temp1 = node->left;
    AVLNode* temp2 = temp1->right;
    temp1->right = node;
    node->left = temp2;
    balance(node);
    balance(temp1);
    return temp1;
}

AVLNode* rotateLeft(AVLNode* node){
    AVLNode* temp1 = node->right;
    AVLNode* temp2 = temp1->left;
    temp1->left = node;
    node->right = temp2;
    balance(node);
    balance(temp1);
    return temp1;
}

AVLNode* rotateAVL(AVLNode* node){
    balance(node);
    if (node->balance > 1){
        if (node->left && node->left->balance < 0){
            node->left = rotateLeft(node->left);
        }
        return rotateRight(node);
    }
    if (node->balance < 1){
        if (node->right && node->right->balance > 0){
            node->right = rotateRight(node->right);
        }
        return rotateLeft(node);
    }
    return node;
}

AVLNode* insertAVL(AVLNode* node, int station_id, int capacity){
    if(node==NULL){ 
        return createNode(station_id, capacity);
    }
    if (station_id < node->station_id){
        node->left = insertAVL(node->left, station_id, capacity);
    }
    else if (station_id > node->station_id){
        node->right = insertAVL(node->right, station_id, capacity);
    }
    else return node;
    return balance(node);
}

AVLNode* searchNode(AVLNode* node, int station_id){
    if (node==NULL || node->station_id == station_id) return node;
    if (station_id < node->station_id) return searchNode(node->left, station_id);
    else return searchNode(node->right, station_id);
}

void display(AVLNode* node){
    if (node){
        display(node->left);
        printf("Station ID: %d, Capacity: %d, Consumption: %d\n", node->station_id, node->capacity, node->consumption);
        display(node->right);
    }
}

void prefix(AVLNode* node){
    if (node){
        printf("Station ID: %d, Capacity: %d, Consumption: %d\n", node->station_id, node->capacity, node->consumption);
        prefix(node->left);
        prefix(node->right);
    }
}

void freeAVL(AVLNode* node){
    if(node){
        freeAVL(node->left);
        freeAVL(node->right);
        free(node);
    }
}
