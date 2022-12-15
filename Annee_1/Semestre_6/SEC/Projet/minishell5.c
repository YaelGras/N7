#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include "readcmd.h"




int main(int argc, char *argv[]) {
  int codeTerm;
  pid_t pidFils, idFils;
  struct cmdline *commande;

  pidFils = 1;
  bool sortie;
  sortie = 0;

  while(!sortie) {
    int ret;
    printf(">>> ");

    commande = readcmd(); 
    
    if(strcmp(commande->seq[0][0], "exit") == 0) {
        sortie = 1;
    } else if (strcmp(commande->seq[0][0], "cd") != 0){
      pidFils=fork();
    } 

    if (pidFils == -1) {
      printf("Erreur fork\n");
      exit(1);
    }
    if (pidFils == 0) {  /* fils */ 
      execvp(commande->seq[0][0], commande->seq[0]);      
      exit(0);
    }
    else {   /* père */
      if(sortie != 1) {
        if (strcmp(commande->seq[0][0], "cd") == 0){ 
          if (commande->seq[0][1] == NULL) {
              chdir(getenv("HOME"));
          } else {
              int ret = chdir(commande->seq[0][1]);
            if(strcmp(commande->seq[0][1], "$HOME") == 0) {
              ret = chdir(getenv("HOME"));
            }
            if(ret == -1) {
              printf("Le répertoire %s n'existe pas depuis le dossier courant. \n", commande->seq[0][1]);
            }
          }
          
        } else {
          printf(commande->backgrounded);
          if(commande->backgrounded == NULL) {
            idFils=wait(&codeTerm);
            if (idFils == -1) {
              perror("ERROR");
              exit(2);
            }
          }
          
        }
        
      }      
    }
  }

  printf("Salut \n");
  return EXIT_SUCCESS; 
}
