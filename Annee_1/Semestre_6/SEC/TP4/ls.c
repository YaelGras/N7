#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h> // POur les fichier

int main(int argc , char * argv []) {
    if (argc != 2) {
        perror("Erreur : besoin d'un unique argument");
        exit(EXIT_FAILURE);
    }      
    
    int fichier = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0600); 
    dup2(fichier, 1);
    close(fichier);
    execlp("ls", "ls", "-u", NULL);
    
    exit(EXIT_SUCCESS); 
}