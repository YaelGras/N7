#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h> 
#include <fcntl.h> // POur les fichier




int main(void) {
    
    int fd, ecritFils, ecritPere;
    char* ecritureFils = "FILS\n";
    char* ecriturePere = "PERE\n";

    

    switch (fork()) 
    {
        case  -1 : //ERREUR
            printf("Erreur fork\n");
            exit(1);
            break;
        
        case 0 : //FILS
            fd = open("dupli.txt", O_WRONLY | O_CREAT | O_TRUNC, 0600);   

            if (fd < 0) {
                perror("Erreur d'ouverture du fichier destination. \n");
                return EXIT_FAILURE;
            }
            for(int i = 0; i < 10; i++) {
                ecritFils = write(fd, ecritureFils, strlen(ecritureFils) *sizeof(char));
                if(ecritFils < 0) {
                    exit(1);
                }
                sleep(1);
            }
            exit(0);
            break;
        default: //PERE
            fd = open("dupli.txt", O_WRONLY | O_CREAT | O_TRUNC, 0600);   

            if (fd < 0) {
                perror("Erreur d'ouverture du fichier destination. \n");
                return EXIT_FAILURE;
            }
            for(int i = 0; i < 10; i++) {
                ecritPere = write(fd, ecriturePere, strlen(ecriturePere) * sizeof(char));
                if(ecritPere < 0) {
                    return EXIT_FAILURE;
                }
                sleep(1);
            }
            break;
    }
      
    close(fd);

    return EXIT_SUCCESS; 
}