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
cmdline *commande;

typedef struct proc {
    int pid; // indique si le descripteur correspond à un client effectivement connecté 
    int status; // 0 = FINI, 1 = ACTIF, 2 = SUSPENDU, 3 = Actif en avant plan
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

int add_proc(int pid, cmdline *commande, int backgrounded) {
    int i;
    for (i = 0; i < MAX_PROC; i++) {
        if (list_proc[i].status == 0) {

            list_proc[i].pid = pid;
            list_proc[i].status = 1;

            list_proc[i].command = calloc(strlen(commande->seq[0][0]), sizeof(char));

            if(list_proc[i].command == NULL) {
                perror("Erreur de calloc lors de l'ajout de la commande en arrière plan");
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
                    perror("Erreur de realloc lors de l'ajout de la commande en arrière plan");
                    break;
                }                
            }
            if (backgrounded == 1) {
                printf("[%d] : %d \n", i+1, pid);
            } else {
                list_proc[i].status = 3; 
            }
            return i + 1; //Identifiant dans l'enregistrement des processus en cours
        }
    }
    return 0; // Erreur lors de l'enregistrement (Pas de place)

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
                perror("Erreur de la commande kill dans la fonction sj \n");
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
            if(list_proc[i].status == 1 || list_proc[i].status == 2) {
                printf("\n[%d] Fini : %s\n", i+1, list_proc[i].command);
            }
            list_proc[i].status = 0;
            break;
        }
    }
}

void bg(int id) {
    int ret_kill;
    if (list_proc[id].status == 2) {

        ret_kill = kill(list_proc[id].pid, SIGCONT);

        if (ret_kill < 0) {
            perror("ERREUR de la commande kill dans la fonction bg \n");
        } else {
            list_proc[id].status = 1;
            printf("[%d] Reprise en background : %s\n", id+1, list_proc[id].command);
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
            perror("ERREUR de la commande kill dans la fonction fg \n");
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
        } else if ((pid_fils_termine != 0) & (WIFSTOPPED(wstatus))) { // Le processus a été suspendu dans un autre terminal
            for (int i = 0; i < MAX_PROC; i++) {
                if (list_proc[i].pid == pid_fils_termine) {
                    list_proc[i].status = 2;
                    break;
                }
            }
        }
        
    } while (pid_fils_termine != 0);   
    printf("\n");
}

void handler_SIGTSTP (int signal) {
    int ret_kill;
    for(int i = 0; i < MAX_PROC; i++) {
        if(list_proc[i].status == 3) {
            ret_kill = kill(list_proc[i].pid, SIGSTOP);
            if (ret_kill < 0) {
                perror("Erreur lors du kill du Ctrl-Z");
            } else {
                list_proc[i].status = 2;
                printf("Processus %d d'identification %d, suspendu par Ctrl-Z\n", list_proc[i].pid, i+1);
            }
            return;
        }
    }
    printf("\n");
}

void handler_SIGINT (int signal) {
    int ret_kill;
    for(int i = 0; i < MAX_PROC; i++) {
        if(list_proc[i].status == 3) {
            ret_kill = kill(list_proc[i].pid, SIGKILL);
            if (ret_kill < 0) {
                perror("Erreur lors du kill du Ctrl-C");
            } else {
                list_proc[i].status = 0;
                printf("Processus %d fini par Ctrl-C\n", list_proc[i].pid);
            }
            return;
        }
    }
    printf("\n");
}

void kill_all() {
    for(int i = 0; i < MAX_PROC; i++) {
        if(list_proc[i].status != 0) {
            int ret_kill = kill(list_proc[i].pid, SIGKILL);
            if (ret_kill < 0) {
                perror("Erreur lors du kill du exit");
            } else {
                list_proc[i].status = 0;
                printf("Processus %d fini par exit\n", list_proc[i].pid);
            }
        }
    }
}

int main(int argc, char *argv[]) {
    int ret_add;
    pid_t pidFils;
    struct sigaction action_SIGCHLD, action_SIGTSTP, action_SIGINT;
    sigset_t signaux_masque;
    
    sigemptyset(&signaux_masque);
    sigaddset(&signaux_masque, SIGTSTP);
    sigaddset(&signaux_masque, SIGINT);

    
    action_SIGCHLD.sa_handler = handler_SIGCHLD;
    sigemptyset(&action_SIGCHLD.sa_mask);
    action_SIGCHLD.sa_flags = 0;

    action_SIGTSTP.sa_handler = handler_SIGTSTP;
    sigemptyset(&action_SIGTSTP.sa_mask);
    action_SIGTSTP.sa_flags = 0;

    action_SIGINT.sa_handler = handler_SIGINT;
    sigemptyset(&action_SIGINT.sa_mask);
    action_SIGINT.sa_flags = 0;

    sigaction(SIGCHLD, &action_SIGCHLD, NULL); 
    sigaction(SIGTSTP, &action_SIGTSTP, NULL); 
    sigaction(SIGINT, &action_SIGINT, NULL); 
    

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
            kill_all();
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

        // Suspension du shell
        } else if (strcmp(commande->seq[0][0],"susp") == 0) {
            int ret_susp = kill(getpid(), SIGSTOP);
            if (ret_susp < 0) {
                perror("Erreur lors de la suspension du shell");
                exit(EXIT_FAILURE);
            } else {
                // On n'arrive ici que si on relance le minishell avec la commante kill -CONT pid_du_minishell
                printf("Minishell repris \n");
            }
        // others commands
        } else {
            switch(pidFils=fork()) 
            {
                case  -1 : //ERREUR
                    printf("Erreur fork\n");
                    exit(1);
                
                case 0 : //FILS
                    sigprocmask(SIG_BLOCK, &signaux_masque, NULL);

                    execvp(commande->seq[0][0], commande->seq[0]);   

                    sigprocmask(SIG_UNBLOCK, &signaux_masque, NULL);   
                    exit(0);
                    
                default: //PERE
                    //printf("%d\n", getpid());
                    
                    if(commande->backgrounded == NULL) {
                        // Cela permets d'avoir le pid du processus en cours en avant plan si il y a un SIGSTOP ou un SIGINT
                        ret_add = add_proc(pidFils, commande, 0);
                        if (ret_add == 0) {
                            perror("Manque de place dans la liste d'enregistrement des processus");
                        } else {
                            while(list_proc[ret_add - 1].status == 3){
                                //le fils est en cours d'execution, on attend que sont statut change
                            } 
                        }
                        
                    } else {
                        ret_add = add_proc(pidFils, commande, 1);

                        if (ret_add == 0) {
                            perror("Manque de place dans la liste d'enregistrement des processus");
                        }
                    }
                    break;
            }
        }                 
    } while (true);
    

    
    return EXIT_SUCCESS; 
}
