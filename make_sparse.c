/*
 * PROJ1-1: YOUR TASK B CODE HERE
 *
 * Feel free to define additional helper functions.
 */

#include <stdlib.h>
#include <stdio.h>
#include "sparsify.h"
#include "utils.h"

/* Returns a NULL-terminated list of Row structs, each containing a NULL-terminated list of Elem structs.
 * See sparsify.h for descriptions of the Row/Elem structs.
 * Each Elem corresponds to an entry in dense_matrix whose value is not 255 (white).
 * This function can return NULL if the dense_matrix is entirely white.
 */
Row *dense_to_sparse(unsigned char *dense_matrix, int width, int height) {
   
    Row *head = NULL;
    Row *prev_row = NULL;
   
   
    for (int i = 0; i < height; i++) {
        Elem *first_elem = NULL;
        Elem *prev_elem = NULL;
        for (int j = 0; j < width; j++) {
            if (0 <= dense_matrix[i*width + j] && dense_matrix[i*width + j] < 255) {
                Elem *temp_elem = malloc(1 * sizeof(Elem));
                if (temp_elem == NULL) {
                    allocation_failed();
                }
                temp_elem->x = j;
                temp_elem->value = dense_matrix[i*width + j];
                temp_elem->next = NULL;
                if (first_elem == NULL) {
                    first_elem = temp_elem;
                }
                if (prev_elem == NULL) {
                    prev_elem = temp_elem;
                } else {
                    prev_elem->next = temp_elem;
                    prev_elem = prev_elem->next;
                }
            }
        }
        if (first_elem != NULL) {
            Row *temp_row = malloc(1 * sizeof(Row));
            if (temp_row == NULL) {
                allocation_failed();
            }
            temp_row->y = i;
            temp_row->next = NULL;
            temp_row->elems = first_elem;
            if (head == NULL) {
                head = temp_row;
            }
            if (prev_row == NULL) {
                prev_row = temp_row;
            } else {
                prev_row->next = temp_row;
                prev_row = prev_row->next;
            }
        }
    }
    //print_sparse(head);
    return head;
}
  
        
        
        
        
        
        
        
void free_sparse_rowelements(Elem *elem){
    if (elem != NULL) {
        free_sparse_rowelements(elem->next);
        free(elem);
    }
}
        


/* Frees all memory associated with SPARSE. SPARSE may be NULL. */
void free_sparse(Row *sparse) {
    if (sparse != NULL) {
        free_sparse_rowelements(sparse->elems);
        free_sparse(sparse->next);
        free(sparse);
    }
}

