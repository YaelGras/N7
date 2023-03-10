with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package arbre_de_huffman is

    type T_Octet is mod 256;

    Exception_Donnee_Absente : exception;

    type T_Frequences is limited private;

    type Arbre is limited private;

    type T_Dictionnaire is limited private;


    --nom : Calcul_Freq
    --sémantique : calculer la fréquence des caractères dans le Texte et le retranscrire dans la Table.
    -- paramètres : Table : out T_Frequences
    --              Texte : in Unbounded_String
    procedure Calculer_Freq(Table : out T_Frequences; Texte : in Unbounded_String);


    --nom : Construire_Arbre
    --sémantique : construire l'arbre de Huffman à partir du Tableau des fréquences des caractères
    -- paramètres : Arbre_Huff : out Arbre
    --              Table : in T_Frequences
    procedure Construire_Arbre(Arbre_Huff : out Arbre; Table : in T_Frequences);


    --nom : Vider_Arbre
    --sémantique : Vide l'espace mémoire occupé par l'arbre de Huffman
    -- paramètres : Arbre_Huff : in out Arbre
    -- post-condition : Arbre_Huff=null
    procedure Vider_Arbre(Arbre_Huff : in out Arbre);

    -- nom : Fabriquer_Dict
    -- sémantique : forme la table de Huffman Dict grâce à son arbre correspondant Arbre_Huff
    -- paramètres : Arbre_Huff : in Arbre
    --              Dict : in out T_Dictionnaire
    procedure Fabriquer_Dict(Dict : in out T_Dictionnaire; Arbre_Huff : in Arbre);

    -- nom : La_Donnee_Dict
    -- sémantique : Retourne le codage de Huffman d'un caractère
    -- paramètres : Dict : in T_Dictionnaire
    --              Caractere : in Character
    --              Fin : in Boolean
    -- Type de retour : Unbounded_String
    -- pré-condition : Fin=True or then Caractere est dans le Dictionnaire entre 2 et 27
    function La_Donnee_Dict(Dict : in T_Dictionnaire; Caractere : in Character; Fin : in Boolean) return Unbounded_String;

    -- nom : Le_Caractere_Dict
    -- sémantique : Retourne le caractère d'un codage de Huffman
    -- paramètres : Dict : in T_Dictionnaire
    --              Code : in Unbounded_String
    -- Type de retour : Character
    -- pré-condition : Code_Est_Present_Dict(Code,Dict)
    function Le_Caractere_Dict(Dict : in T_Dictionnaire; Code : in Unbounded_String) return Character with
            Pre => Code_Est_Present_Dict(Code,Dict);

    -- nom : Vider_Dict
    -- sémantique : Vide l'espace mémoire occupé par le Dictionnaire Dict
    -- paramètres : Dict : in out T_Dictionnaire
    -- post-condition : pour tout i dans 1..27 Dict(i)=null
    procedure Vider_Dict(Dict : in out T_Dictionnaire);

    -- nom : Recuperer_Arbre
    -- sémantique : Extraire l'arbre de Huffman d'un texte préalablement compressé
    -- paramètres : Arbre_Huff : out Arbre
    --              Texte : in out Unbounded_String
    procedure Recuperer_Arbre(Arbre_Huff : out Arbre; Texte : in out Unbounded_String);

    -- nom : Code_Est_Present_Dict
    -- sémantique : Détermine si le Code est bien un code de Huffman du dictionnaire
    -- paramètres : Code : in Unbounded_String
    --              Dict : in T_Dictionnaire
    -- Type de retour : Boolean
    function Code_Est_Present_Dict(Code : in Unbounded_String; Dict : in T_Dictionnaire) return Boolean;

    -- nom : Arbre_En_Binaire
    -- sémantique : Renvoie le codage binaire de la forme de l'arbre de Huffman
    -- paramètres : Arbre_Huff : in Arbre
    -- Type de retour : Unbounded_String
    function Arbre_En_Binaire(Arbre_Huff : in Arbre) return Unbounded_String;

    -- nom : Table_En_Binaire
    -- sémantique : Renvoie le codage binaire de la forme de la table de Huffman
    -- paramètres : Dict : in T_Dictionnaire
    -- Type de retour : Unbounded_String
    function Table_En_Binaire(Dict : in T_Dictionnaire) return Unbounded_String;

    -- nom : Afficher_Arbre
    -- sémantique : Afficher l'arbre de Huffman comme la figure 20 du polycopié de projet
    -- paramètres : Arbre_Huff : in Arbre
    procedure Afficher_Arbre(Arbre_Huff : in Arbre);

    -- nom : Afficher_Dict
    -- sémantique : Afficher la table de Huffman comme la figure 21 du polycopié de projet
    -- paramètres : Dictionnaire : in T_Dictionnaire
    procedure Afficher_Dict(Dict: in T_Dictionnaire);

    ---- nom : Convertir_Binaire
    ---- sémantique : Convertir un texte de caractères en binaire avec leur code ASCII
    ----              binaire correspondant.
    ---- paramètres : Texte : in out Unbounded_String
    procedure Convertir_Binaire(Texte : in out Unbounded_String);

    ---- nom : Convertir_Caracteres
    ---- sémantique : Convertir un texte en binaire en caractères avec leur code ASCII
    ----              binaire correspondant.
    ---- paramètres : Texte : in out Unbounded_String
    procedure Convertir_Caracteres(Texte : in out Unbounded_String);


private

    type C_Frequences is record
        Caractere : Character;
        Frequence : Integer; -- {Frequence >=0}
    end record;

    type A_Frequences is array(1..256) of C_Frequences;

    type T_Frequences is record
        Taille : Integer; -- {0<=Taille<=256}
        Tableau : A_Frequences;
    end record;

    type T_Feuille;

    type Arbre is access T_Feuille;

    type T_Feuille is record
        Frequence : Integer; -- {Frequence>=0}
        Caractere : Character;
        Fils_G : Arbre;
        Fils_D : Arbre;
    end record;

    type T_Cellule;

    type LCA is access T_Cellule;

    type T_Cellule is record
        Caractere : Character;
        Code_Huff : Unbounded_String;
        Suivant : LCA;
    end record;

    type T_Dictionnaire is array(1..27) of LCA;
end arbre_de_huffman;
