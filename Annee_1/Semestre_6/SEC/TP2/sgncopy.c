#include <stdio.h> /* entrées / sorties */
#include <unistd.h> /* primitives de base : fork , ...*/
#include <stdlib.h> /* exit */
#include <signal.h>

# define MAX_PAUSES 10 /* nombre d ’ attentes maximum */

void traitant (int sig) {
    printf("pid recu = %d et signal recu = %d \n", getpid(), sig);
}


int main ( int argc , char * argv []) {
    int nbPauses ;
    nbPauses = 0;
    struct sigaction mon_action;
    
    mon_action.sa_handler = traitant;
    sigemptyset(&mon_action.sa_mask);
    mon_action.sa_flags = 0;
    for(int i = 1; i <= SIGRTMAX; i++) {               
        sigaction(i, &mon_action, NULL);
    }

    printf ("Processus de pid %d \n" , getpid ());
    for ( nbPauses = 0 ; nbPauses < MAX_PAUSES ; nbPauses ++) {
        pause (); // Attente d ’ un signal
        printf ("pid = %d - NbPauses = %d \n" , getpid () , nbPauses );
    } ;
    return EXIT_SUCCESS ;
}