#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include "readcmd.h"

/**
 * Sans wait, les deux processus pere et fils se retrouve à s'éxecuter en même temps,
 * ainsi nous avons la demande de la nouvelle commande et l'execution de la commande 
 * entrée en même temps. Nous avons donc un probleme de synchronisation
 * 
 * De plus, avec ce code, les commande lancée cause la création de processus zombies.
 */


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
        printf("exit");
    } else {
        pidFils=fork();
    } 
    

    /* bonne pratique : tester systématiquement le retour des appels système */
    if (pidFils == -1) {
      printf("Erreur fork\n");
      exit(1);
      /* par convention, renvoyer une valeur > 0 en cas d'erreur,
      * différente pour chaque cause d'erreur
      */
    }
    if (pidFils == 0) {  /* fils */ 
      execvp(commande->seq[0][0], commande->seq[0]);
      
      exit(pidFils);
    }
    else {   /* père */
        /*idFils=wait(&codeTerm);
        *if (idFils == -1) {
        *  perror("ERROR");
        *  exit(2);
        *}
        *if (codeTerm == 0) {
        *  printf("SUCCES\n");
        *} else {
        *  printf("ECHEC\n");
        *}
        */      
    }
  }

  printf("Salut \n");
  return EXIT_SUCCESS; 
}
