# include <stdio.h> /* entrées / sorties */
# include <unistd.h> /* primitives de base : fork , ...*/
# include <stdlib.h> /* exit */
#include <signal.h>

# define MAX_PAUSES 10 /* nombre d ’ attentes maximum */


void traitant (int sig) {
    printf("PID PERE = %d \n", getpid());
    alarm(5);
}

int main ( int argc , char * argv []) {
    struct sigaction mon_action;
    
    mon_action.sa_handler = traitant;
    sigemptyset(&mon_action.sa_mask);
    mon_action.sa_flags = 0;
    sigaction(SIGALRM, &mon_action, NULL);    
    alarm(5);
    for (int nbPauses = 0 ; nbPauses < MAX_PAUSES ; nbPauses ++) {
            pause (); // Attente d ’ un signal
    } ; 
    return EXIT_SUCCESS ;
}