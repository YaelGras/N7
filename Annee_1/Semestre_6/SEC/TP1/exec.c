#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */

int main(int argc, char *argv[]) {
  int codeTerm;
  pid_t pidFils, idFils;

  pidFils=fork();
  /* bonne pratique : tester systématiquement le retour des appels système */
  if (pidFils == -1) {
    printf("Erreur fork\n");
    exit(1);
    /* par convention, renvoyer une valeur > 0 en cas d'erreur,
     * différente pour chaque cause d'erreur
     */
  }
  if (pidFils == 0) {  /* fils */  
    if (argc > 1) {
        execlp("ls", "ls", "-l", argv[1], NULL);
    } else {
        execlp("ls", "ls", "-l", NULL);
    }
    exit(EXIT_SUCCESS);
  }
  else {   /* père */
    idFils=wait(&codeTerm);
    if (idFils == -1) {
      perror("ERROR");
      exit(2);
    }
    if (WIFEXITED(codeTerm)) {
      printf("SUCCES \n");
    } else {
      printf("ECHEC \n");
    }
  }
  return EXIT_SUCCESS; 
}

