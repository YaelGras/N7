#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

void viderBuffer()
{
    int c = 0;
    while (c != '\n' && c != EOF)
    {
        c = getchar();
    }
}


int main(int argc, char *argv[]) {
  int codeTerm;
  pid_t pidFils, idFils;

  pidFils = 1;
  bool sortie;
  sortie = 0;

  while(!sortie) {
    char buf [30] ; /* contient la commande saisie au clavier */
    int ret ; /* valeur de retour de scanf */
    printf(">>> ");
    ret = scanf("%s", buf) ; /* lit et range dans buf la chaine entrée e au clavier */
    //char commande [30] = strsplit(buf, " ")[0];
    //printf("%s", buf);
    //printf("%d", ret);
    if (ret == -1 || strcmp(buf,"exit") == 0) {
      sortie = 1;
      
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
      ret = execlp(buf, buf, NULL);
      
      exit(ret);
    }
    else {   /* père */
      if(sortie != 1) {
        idFils=wait(&codeTerm);
        if (idFils == -1) {
          perror("ERROR");
          exit(2);
        }
        if (codeTerm == 0) {
          printf("SUCCES\n");
        } else {
          printf("ECHEC\n");
        }
      }
      
    }
    viderBuffer();
  }

  printf("Salut \n");
  return EXIT_SUCCESS; 
}
