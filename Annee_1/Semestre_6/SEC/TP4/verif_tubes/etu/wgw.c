#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h> // POur les fichier
#include <sys/wait.h>

int main(int argc , char * argv []) {
    
    if(argc != 2) {
        perror("Le programme nécéssite unquement le nom de l'utilisateur en argument");
        exit(EXIT_FAILURE);
    }

    pid_t pidFils, pidPetitFils;
    int grepwc[2], whogrep[2], status;

    if(pipe(grepwc) == -1) {
        perror("Erreur déclaration du pipe grepwc");
        exit(EXIT_FAILURE);
    }

    

    switch (pidFils = fork()) 
    {
        case  -1 : //ERREUR
            perror("Erreur fork\n");
            exit(EXIT_FAILURE);
        
        case 0 : //FILS
            if(pipe(whogrep) == -1) {
                perror("Erreur déclaration du pipe whogrep");
                exit(EXIT_FAILURE);
            }

            switch (pidPetitFils = fork()) 
            {
                case  -1 : //ERREUR
                    perror("Erreur fork\n");
                    exit(EXIT_FAILURE);
                
                case 0 : //PETIT-FILS WHO
                    //grepwc inutile pour le petit-fils
                    close(grepwc[0]);
                    close(grepwc[1]);

                    close(whogrep[0]);
                    
                    dup2(whogrep[1], 1);

                    close(whogrep[1]);

                    execlp("who", "who", NULL);
                    
                    exit(EXIT_SUCCESS);

                default: //FILS GREP
                    close(whogrep[1]);
                    close(grepwc[0]);

                    dup2(whogrep[0], 0);
                    dup2(grepwc[1], 1);

                    close(whogrep[0]);
                    close(grepwc[1]);

                    waitpid(pidPetitFils, &status, 0);                    
                    execlp("grep", "grep", argv[1], NULL);

                    exit(EXIT_SUCCESS);
            }
            

        default: //PERE WC
            close(grepwc[1]);
            dup2(grepwc[0], 0);
            close(whogrep[0]);

            waitpid(pidFils, &status, 0);
            execlp("wc", "wc", "-l", NULL);
            
            break;
    }
    exit(EXIT_SUCCESS); 
}