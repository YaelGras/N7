#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h> // POur les fichier


int main(int argc , char * argv []) {
    if(argc != 3) {
        exit(EXIT_FAILURE);
    } 

    int fd;

    fd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0600);
    
    if (fd < 0) {
        perror("Erreur d'ouverture du fichier destination. \n");
        exit(EXIT_FAILURE);
    }

    dup2(fd, 1);
    close(fd);
    execlp("cat", "cat", argv[1], NULL);
    
    exit(EXIT_SUCCESS); 
}