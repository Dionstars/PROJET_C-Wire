#ifndef AVL_H
#define AVL_H

#include <stdio.h>
#include <stdlib.h>

typedef struct AVLNode {
    int station_id;
    int capacity;
    int consumption;
    struct AVLNode* left;
    struct AVLNode* right;
    int balance;
} AVLNode;

AVLNode* createNode(int station_id, int capacity);
int height(AVLNode* node);
int balance(AVLNode* node);
AVLNode* rotateRight(AVLNode* node);
AVLNode* rotateLeft(AVLNode* node);
AVLNode* rotateAVL(AVLNode* node);
AVLNode* insertAVL(AVLNode* node, int station_id, int capacity);
AVLNode* searchNode(AVLNode* node, int station_id);
void display(AVLNode* node);
void prefix(AVLNode* node);
void freeAVL(AVLNode* node);

#endif