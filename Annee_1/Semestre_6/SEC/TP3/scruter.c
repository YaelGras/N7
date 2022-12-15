#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h> 
#include <fcntl.h> // POur les fichier


int main(void) {
    
    int fd, ecrit;
    
    fd = open("temp.txt", O_WRONLY | O_CREAT | O_TRUNC, 0600);   

    if (fd < 0) {
        perror("Erreur d'ouverture du fichier pour ecriture. \n");
        return EXIT_FAILURE;
    }

    for(int i = 0; i < 30; i++) {
        if (i%10 == 0) {
            switch (fork()) 
            {
                case  -1 : //ERREUR
                    printf("Erreur fork\n");
                    exit(1);
                    break;
                
                case 0 : //FILS
                    int fl = open("temp.txt", O_RDONLY); 
                    if (fl < 0) {
                        perror("Erreur d'ouverture du fichier pour lecture. \n");
                        return EXIT_FAILURE;
                    }
                    exit(0);
                    break;
                default: //PERE
                    
                    break;
            }
        }

        char* ecriture = itoa(i) + "\n";
        ecrit = write(fd, ecriture, strlen(ecriture) * sizeof(char));
        if(ecrit < 0) {
            return EXIT_FAILURE;
        }
        sleep(1);
    }
    
      
    close(fd);

    return EXIT_SUCCESS; 
}