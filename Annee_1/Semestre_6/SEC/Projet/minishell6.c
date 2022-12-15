#include <unistd.h>

#include <stdlib.h>
#include <sys/wait.h> /* wait */
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <errno.h>
#include "readcmd.h"

#define MAX_PROC 20

typedef struct cmdline cmdline;

typedef struct ptp {
    int pid; /* indique si le descripteur correspond à un client effectivement connecté */
    int status; /*0=dead, 1=actif, 2=suspendu */
    char* command;
} processus;


processus list_proc [MAX_PROC];


void show_proc(int id) {
    processus proc = list_proc[id];
    if (proc.status != 0) {
        printf(" [%d] %d ",id + 1 , proc.pid);

        if (proc.status == 1) {
            printf("  ACTIF   ");
        } else if(proc.status == 2) {
            printf(" SUSPENDU ");
        }

        printf(" ./%s \n", proc.command);     
    }
}

void add_proc(int pid, cmdline *commande) {
    int i;
    for (i = 0; i < MAX_PROC; i++) {
        if (list_proc[i].status == 0) {

            list_proc[i].pid = pid;
            list_proc[i].status = 1;

            list_proc[i].command = calloc(strlen(commande->seq[0][0]), sizeof(char));

            if(list_proc[i].command == NULL) {
                printf("Erreur de calloc");
                break;
            }

            strcpy(list_proc[i].command, commande->seq[0][0]);
            int j = 1;

            while(commande->seq[0][j] != NULL) {
                char* temp = realloc(list_proc[i].command, (1 + strlen(commande->seq[0][j]) + strlen(list_proc[i].command)) * sizeof(char));
                if(temp) {
                    list_proc[i].command = temp;
                    strcat(list_proc[i].command, " ");
                    strcat(list_proc[i].command, commande->seq[0][j]);                    
                    j = j + 1;
                } else {
                    printf("Erreur de realloc");
                    break;
                }                
            }
            printf("[%d] : %d \n", i+1, pid);
            break;
        }
    }

}

void stop_proc(int id) {
    int ret_kill;
    switch(list_proc[id].status) 
    {
        case  0 : 
            printf("ERROR : Le processus d'identifiant : %d n'est pas en arrière-plan \n", id+1);
            break;
        
        case 1 : 
            ret_kill = kill(list_proc[id].pid, SIGSTOP);

            if (ret_kill < 0) {
                printf("ERREUR de la commande kill dans la fonction sj \n");
            } else {
                list_proc[id].status = 2;
                printf("[%d] : %d Suspendu \n", id+1, list_proc[id].pid);
            }     
            break;
            
        case 2 : 
            //printf("ERROR : Le processus d'identifiant : %d est déjà suspendu arrière-plan \n", id+1);
            break;
    }    
}

void del_proc(int pid) {
    for (int i = 0; i < MAX_PROC; i++) {
        if (list_proc[i].pid == pid) {
            list_proc[i].status = 0;
            printf("\n[%d] Fini : %s\n", i+1, list_proc[i].command);
            break;
        }
    }
}

void bg(int id) {
    int ret_kill;
    if (list_proc[id].status == 2) {

        ret_kill = kill(list_proc[id].pid, SIGCONT);

        if (ret_kill < 0) {
            printf("ERREUR de la commande kill dans la fonction bg \n");
        } else {
            list_proc[id].status = 1;
            printf("\n[%d] Reprise en background : %s\n", id+1, list_proc[id].command);
        }

    } else if (list_proc[id].status == 1) {
        printf("Le processus %d est déjà actif \n", list_proc[id].pid);
    } else {
        printf("ERREUR d'identifiant\n");
    }
}

void fg(int id) {
    int ret_kill;
    int status;
    if (list_proc[id].status == 2) {

        ret_kill = kill(list_proc[id].pid, SIGCONT);

        if (ret_kill < 0) {
            printf("ERREUR de la commande kill dans la fonction fg \n");
        } else {
            list_proc[id].status = 0;
            printf("\n[%d] Reprise en foreground : %s\n", id+1, list_proc[id].command);
        }

        waitpid(list_proc[id].pid, &status, 0);

    } else if (list_proc[id].status == 1) {
        waitpid(list_proc[id].pid, &status, 0);
    } else {
        printf("ERREUR identifiant \n");
    }
}

void cd (cmdline *commande) {
    if ((commande->seq[0][1] == NULL) | (strcmp(commande->seq[0][1], "$HOME") == 0)) {
        chdir(getenv("HOME"));
    } else {
        int ret = chdir(commande->seq[0][1]);
        
        if(ret == -1) {
            printf("Le répertoire %s n'existe pas depuis le dossier courant. \n", commande->seq[0][1]);
        }
    }
}

void handler_SIGCHLD(int sig) {
    int wstatus, pid_fils_termine ;
    do {
        pid_fils_termine = waitpid(-1, &wstatus, WUNTRACED|WCONTINUED|WNOHANG);
           
        if(pid_fils_termine == -1) {
            if(errno == ECHILD) {
                pid_fils_termine = 0;
            } else {
                exit(EXIT_FAILURE);
            }
        } else if ((pid_fils_termine != 0) & (WIFEXITED(wstatus) | WIFSIGNALED(wstatus))) {
            del_proc(pid_fils_termine); 
        }
    } while (pid_fils_termine != 0);   
    //printf("\n");
}

int main(int argc, char *argv[]) {
    int codeTerm;
    pid_t pidFils, idFils;
    cmdline *commande;
    struct sigaction action_SIGCHLD;
    
    action_SIGCHLD.sa_handler = handler_SIGCHLD;
    sigemptyset(&action_SIGCHLD.sa_mask);
    action_SIGCHLD.sa_flags = 0;

    sigaction(SIGCHLD, &action_SIGCHLD, NULL); 

    pidFils = 1;

    do {       
        commande = NULL;  

        printf("minishell >>> ");       

        commande = readcmd(); 
                
        //printf("exec > \n");
        if(commande == NULL) {
        } else if (commande->err != NULL){
        } else if (commande->seq == NULL){
        } else if (commande->seq[0] == NULL){
        } else if(strcmp(commande->seq[0][0], "exit") == 0) {
            printf("Salut \n");
            exit(EXIT_SUCCESS);
        } else if (strcmp(commande->seq[0][0], "cd") == 0) {             
            //printf("cd");
            cd(commande);

        // list jobs
        } else if (strcmp(commande->seq[0][0], "lj") == 0) {
            //printf("lj");
            printf("-ID- --PID-- -STATUS-   COMMANDE\n");
            for (int i = 0; i < MAX_PROC; i++) {
                show_proc(i);
            }

        // stop jobs
        } else if (strcmp(commande->seq[0][0], "sj") == 0) {
            //printf("sj");
            if(commande->seq[0][1] == NULL) {
                printf("Il manque l'identifiant du processus\n");
            } else {
                int id = atoi(commande->seq[0][1]);
                if(id == 0) {
                    printf("L'identifiant doit être un nombre \n");
                } else {
                    stop_proc(id - 1);
                }
            }

            // Après l'utilisation du sj, il y a une boucle infini sur la lecture
            // de la ligne de commande, comme si il n'arrivait pas à enregistrer 
            // correctement la ligne puis à sortir du while != null qui protege du
            // SIGCHLD.
                   
        
        // backgrounded job
        } else if (strcmp(commande->seq[0][0],"bg") == 0) {
            //printf("bg");
            if(commande->seq[0][1] == NULL) {
                printf("Il manque l'identifiant du processus\n");
            } else {
                int id = atoi(commande->seq[0][1]);
                if(id == 0) {
                    printf("L'identifiant doit être un nombre \n");
                } else {
                    bg(id - 1);
                }
            }
            
        
        // foregrounded job
        } else if (strcmp(commande->seq[0][0],"fg") == 0) {
            //printf("fg");
            if(commande->seq[0][1] == NULL) {
                printf("Il manque l'identifiant du processus\n");
            } else {
                int id = atoi(commande->seq[0][1]);
                if(id == 0) {
                    printf("L'identifiant doit être un nombre \n");
                } else {
                    fg(id - 1);
                }
            }

        // others commands
        } else {
            switch(pidFils=fork()) 
            {
                case  -1 : //ERREUR
                    printf("Erreur fork\n");
                    exit(1);
                
                case 0 : //FILS
                    execvp(commande->seq[0][0], commande->seq[0]);      
                    exit(0);
                    
                default: //PERE
                    if(commande->backgrounded == NULL) {
                        idFils=waitpid(pidFils, &codeTerm, WUNTRACED);
                        if (idFils == -1) {
                            perror("ERROR");
                            exit(2);
                        }
                    } else {
                        add_proc(pidFils, commande);
                    }
                    break;
            }
        }                 
    } while (true);
    

    
    return EXIT_SUCCESS; 
}
