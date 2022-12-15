#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h> // POur les fichier
#include <sys/wait.h>

int main(void) {
    
    int p[2], val_read, val_sent, status;

    if(pipe(p) == -1) {
        perror("Erreur déclaration du pipe");
        exit(EXIT_FAILURE);
    }
    val_sent = 10;
    write(p[1], &val_sent, sizeof(val_sent));

    switch (fork()) 
    {
        case  -1 : //ERREUR
            printf("Erreur fork\n");
            exit(1);
            break;
        
        case 0 : //FILS
            close(p[1]);
            while(read(p[0], &val_read, sizeof(val_read)) == 0);
            printf("%d\n", val_read);
            close(p[0]);
            exit(0);

        default: //PERE
            close(p[0]);
            close(p[1]);
            wait(&status);
            break;
    }
    exit(EXIT_SUCCESS); 
}