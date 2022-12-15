#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>

void garnir(char zone[], int lg, char motif) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		zone[ind] = motif ;
	}
}

void lister(char zone[], int lg) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		printf("%c",zone[ind]);
	}
	printf("\n");
}

int main(int argc,char *argv[]) {
	int fichier, codeTerm;
	int taillepage = sysconf(_SC_PAGESIZE);
	int taillezone = 3*taillepage;
	char tampon[taillezone];
	char* zone;
	garnir(tampon, taillezone, 'a');
	pid_t pidFils;

	if((fichier = open("fichier.txt", O_RDWR | O_CREAT | O_TRUNC, S_IRWXU)) < 0) {
		perror("Erreur d'ouverture du fichier");
		exit(1);
	}

	if( write(fichier, tampon, taillezone*sizeof(char)) < 0) {
		perror("Erreur d'écriture du fichier");
		exit(1);
	}
	

	if((zone = mmap(NULL, taillezone, PROT_READ | PROT_WRITE, MAP_SHARED, fichier, 0)) == MAP_FAILED) {
		perror("Erreur de couplage du fichier");
		exit(1);
	}


	switch(pidFils = fork()) {	
		case  -1 : //ERREUR
			perror("Erreur fork\n");
			exit(1);
		
		case 0 : //FILS
			if((zone = mmap(NULL, taillezone, PROT_READ | PROT_WRITE, MAP_PRIVATE, fichier, 0)) == MAP_FAILED) {
				perror("Erreur de couplage du fichier");
				exit(1);
			}
			printf("Page 1 : ");
			lister(zone, 10);

			sleep(4);
			printf("Page 1 : ");
			lister(zone, 10);
			printf("Page 2 : ");
			lister(zone + taillepage, 10);
			printf("Page 3 : ");
			lister(zone + 2*taillepage, 10);

			garnir(zone + taillepage, taillepage, 'd');
			sleep(8);

			printf("Page 1 : ");
			lister(zone, 10);
			printf("Page 2 : ");
			lister(zone + taillepage, 10);
			printf("Page 3 : ");
			lister(zone + 2*taillepage, 10);

			exit(0);
		default : // PERE
			sleep(1);
			garnir(zone, 2*taillepage, 'b');
			sleep(6);
			garnir(zone + taillepage, taillepage, 'c');
			wait(&codeTerm);
	}
	return EXIT_SUCCESS;

}
