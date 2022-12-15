#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h> 
#include <fcntl.h> // POur les fichier

#define BUFSIZE 20

void afficher_usage(void) {
    perror("Usage de ./copier : \n ./copier fichier_source fichier_destination");
}

int main(int argc, char *argv[]) {
    
    if(argc != 3) {
        afficher_usage();
        return EXIT_FAILURE;
    } 

    char tampon[BUFSIZE];
    int fd, fs, nblus, nbecrit;
    bool fin = false;

    memset(tampon, BUFSIZE, sizeof(char));

    fs = open(argv[1], O_RDONLY);
    fd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0600);   

    if(fs < 0) {
        perror("Erreur d'ouverture du fichier source. \n");
        return EXIT_FAILURE;
    } else if (fd < 0) {
        perror("Erreur d'ouverture du fichier destination. \n");
        return EXIT_FAILURE;
    }

    while(!fin) {
        nblus = read(fs, tampon, sizeof(tampon));
        if(nblus < 0) {
            perror("Erreur de lecture du fichier source. \n");
        } else if (nblus > 0) {
            nbecrit = write(fd, tampon, nblus);
            if((nbecrit < 0) | (nbecrit != nblus)) {
                perror("Erreur d'ecriture dans le fichier destination. \n");
            }
        } else {
            fin = true;
        }
    }

    close(fs);
    close(fd);

    return EXIT_SUCCESS; 
}