with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body arbre_de_huffman is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Feuille, Name => Arbre);
    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => LCA);

    type A_Arbres is array (1..256) of Arbre;

    type L_Arbres is record
        Taille : Integer;
        Foret : A_Arbres;
    end record ;

    type A_Caracteres is array (1..257) of Character;

    type L_Caractere is record
        Taille : Integer;
        Caracteres : A_Caracteres;
    end record;

    type A_Complets is array (1..256) of Boolean;

    type L_Complets is record
        Taille : Integer;
        Complets : A_Complets;
    end record;


    function Hachage(Caractere : in Character; Fin : in Boolean) return Integer is
    begin
        if Fin then
            return 1;
        end if;
        return (Character'pos(Caractere) mod 26 + 2);
    end Hachage;


    procedure Calculer_Freq(Table : out T_Frequences; Texte : in Unbounded_String) is
        Copie_Texte : Unbounded_String := Texte;
        Longueur, Nb_Supprimer : Integer;
        Caractere : Character;
    begin
        -- Parcours de tout le texte
        Table.Taille := 0;
        while Length(Copie_Texte) > 0 loop

            -- Initialisation des variables
            Longueur := Length(Copie_Texte);
            Nb_Supprimer := 0;
            Caractere := To_String(Copie_Texte)(1);

            -- Compter la fréquence du Caractere
            for i in 1..Longueur loop
                --Augmenter le compteur Nb_Supprimer si le i-ième caractère du texte est identique à Caractère
                if To_String(Copie_Texte)(i-Nb_Supprimer) = Caractere then
                    Copie_Texte := Delete(Copie_Texte, i-Nb_Supprimer, i-Nb_Supprimer);
                    Nb_Supprimer := Nb_Supprimer + 1;
                else
                    null;
                end if;
            end loop;

            -- Incrémenter la table des fréquences
            Table.Taille := Table.Taille + 1;
            Table.Tableau(Table.Taille).Caractere := Caractere;
            Table.Tableau(Table.Taille).Frequence := Nb_Supprimer;
        end loop;

    end Calculer_Freq;



    procedure Assembler_2Arbres(Liste_Arbres : in out L_Arbres; indice_Arbre1 : in Integer; indice_Arbre2 : in Integer) is
        Arbre_inter : Arbre;
    begin
        Arbre_inter := new T_Feuille;
        Arbre_inter.all.Frequence := Liste_Arbres.Foret(indice_Arbre1).all.Frequence+Liste_Arbres.Foret(indice_Arbre2).all.Frequence;
        Arbre_inter.all.Fils_G := Liste_Arbres.Foret(indice_Arbre1);
        Arbre_inter.all.Fils_D := Liste_Arbres.Foret(indice_Arbre2);
        Liste_Arbres.Foret(indice_Arbre1) := Arbre_inter;
        Liste_Arbres.Foret(indice_Arbre2) := null;
    end Assembler_2Arbres;




    procedure Construire_Arbre(Arbre_Huff : out Arbre; Table : in T_Frequences) is

        procedure Lister_Feuilles(Table : in T_Frequences; Listes_Arbres : out L_Arbres) is
        begin
            Listes_Arbres.Taille := Table.Taille+1;
            for k in 1..Table.Taille loop
                -- Ajouter le k-ième case du table à la liste des feuilles”
                Listes_Arbres.Foret(k) := new T_Feuille;
                Listes_Arbres.Foret(k).all.Frequence := Table.Tableau(k).Frequence;
                Listes_Arbres.Foret(k).all.Caractere := Table.Tableau(k).Caractere;
                Listes_Arbres.Foret(k).all.Fils_G := null;
                Listes_Arbres.Foret(k).all.Fils_D := null;
            end loop;
            --Ajouter le caractères '\$' aux feuilles
            Listes_Arbres.Foret(Listes_Arbres.Taille) := new T_Feuille;
            Listes_Arbres.Foret(Listes_Arbres.Taille).all.Frequence := 0;
            Listes_Arbres.Foret(Listes_Arbres.Taille).all.Caractere := 'a';
            Listes_Arbres.Foret(Listes_Arbres.Taille).all.Fils_G := null;
            Listes_Arbres.Foret(Listes_Arbres.Taille).all.Fils_D := null;
        end Lister_Feuilles;


        Liste_Arbres : L_Arbres;
        freq_min1, freq_min2, indice_Arbre1, indice_Arbre2 : Integer;
    begin
        Lister_Feuilles(Table, Liste_Arbres);
        while Liste_Arbres.Taille > 1 loop
            -- Determiner les deux arbres ayant la plus petite fréquence de Liste_Arbres
            
            -- Initialiser les fréquences minimales avec freqmin1<freqmin2
            if Liste_Arbres.Foret(1).Frequence <= Liste_Arbres.Foret(2).Frequence then
                -- Initialiser les fréquences minimales avec les deux premiers éléments dans l'ordre croissant
                freq_min1 := Liste_Arbres.Foret(1).Frequence;
                freq_min2 := Liste_Arbres.Foret(2).Frequence;
                indice_Arbre1 := 1;
                indice_Arbre2 := 2;
            else
                -- Initialiser les fréquences minimales avec les deux premiers éléments dans l'ordre décroissant
                freq_min1 := Liste_Arbres.Foret(2).Frequence;
                freq_min2 := Liste_Arbres.Foret(1).Frequence;
                indice_Arbre1 := 2;
                indice_Arbre2 := 1;
            end if;

            for indice in 3..Liste_Arbres.Taille loop
                -- Déterminer si on a un arbre avec une plus faible fréquence
                if  freq_min1 <= Liste_Arbres.Foret(indice).Frequence and freq_min2 > Liste_Arbres.Foret(indice).Frequence then
                    freq_min2 := Liste_Arbres.Foret(indice).Frequence;
                    indice_Arbre2 := indice;
                elsif freq_min1 > Liste_Arbres.Foret(indice).Frequence then
                    freq_min2 := freq_min1;
                    indice_Arbre2 := indice_Arbre1;
                    freq_min1 := Liste_Arbres.Foret(indice).Frequence;
                    indice_Arbre1 := indice;
                end if;
            end loop;

            -- Assembler ces deux arbres
            Assembler_2arbres (Liste_Arbres, indice_Arbre1, indice_Arbre2);

            -- Placer le dernier Arbre de la Liste_Arbre à la place du Second arbre
            Liste_Arbres.Foret(indice_Arbre2) := Liste_Arbres.Foret(Liste_Arbres.Taille);
            Liste_Arbres.Foret(Liste_Arbres.Taille) := null;
            Liste_Arbres.Taille := Liste_Arbres.Taille - 1;
        end loop;

        -- Attribuer à Arbre_Huff sa valeur
        Arbre_Huff := Liste_Arbres.Foret(1);
        Liste_Arbres.Foret(1) := null;
        Liste_Arbres.Taille := 0;
    end Construire_Arbre;




    procedure Vider_Arbre(Arbre_Huff : in out Arbre) is
    begin
        if Arbre_Huff /= null then
            Vider_Arbre(Arbre_Huff.all.Fils_G);
            Vider_Arbre(Arbre_Huff.all.Fils_D);
            Free(Arbre_Huff);
        else
            null;
        end if;
    end Vider_Arbre;



    procedure Fabriquer_Dict(Dict : in out T_Dictionnaire; Arbre_Huff : in Arbre) is

        procedure Fabriquer_Dict_Recursive(Dict : in out T_Dictionnaire; Arbre_Huff : in Arbre; Code : in Unbounded_String; Position : in out T_Octet) is
            pointeur : LCA;
        begin

            if Arbre_Huff.all.Fils_G=null then -- Si on a atteint une feuille, la construction des arbres interdit que le fils gauche soit null et pas le fils droit
                --Ajouter la feuille au Dictionnaire
                if Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0)))=null then
                    --Mettre le premier caractere de la file du Dictionnaire
                    Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0))) := new T_Cellule;
                    if Arbre_Huff.all.Frequence = 0 then
                        Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0))).all.Caractere := Character'val(Position);
                    else
                        Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0))).all.Caractere := Arbre_Huff.all.Caractere;
                    end if;
                    Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0))).all.Code_Huff := Code;
                    Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0))).all.Suivant := null;
                else
                    --Déterminer le dernier caractère de la file du Dictionnaire
                    pointeur := Dict(Hachage(Arbre_Huff.all.Caractere,(Arbre_Huff.all.Frequence=0)));
                    while pointeur.all.Suivant/=null loop
                        pointeur:=pointeur.all.Suivant;
                    end loop;

                    --Mettre le caractere à la fin de la file du Dictionnaire
                    pointeur.all.Suivant := new T_Cellule;
                    if Arbre_Huff.all.Frequence = 0 then
                        pointeur.all.Suivant.all.Caractere := Character'val(Position);
                    else
                        pointeur.all.Suivant.all.Caractere := Arbre_Huff.all.Caractere;
                    end if;
                    pointeur.all.Suivant.all.Code_Huff := Code;
                    pointeur.all.Suivant.all.Suivant := null;
                end if;


                Position := Position+1;
            else
                Fabriquer_Dict_Recursive(Dict, Arbre_Huff.all.Fils_G, Code & "0", Position);
                Fabriquer_Dict_Recursive(Dict, Arbre_Huff.all.Fils_D, Code & "1", Position);
            end if;
        end Fabriquer_Dict_Recursive;

        Position : T_Octet :=0;

    begin
        -- Initialiser la table de Huffman Dict
        for k in 1..27 loop
            Dict(k) := null;
        end loop;
        
        
        if Arbre_Huff.all.Fils_G=null then
            Dict(1):= new T_Cellule;
            Dict(1).all.Caractere:=Character'val(0);
            Dict(1).all.Code_Huff:=To_Unbounded_String("0");
            Dict(1).all.Suivant:=null;
        else
            Fabriquer_Dict_recursive(Dict, Arbre_Huff, To_Unbounded_String(""), Position);
        end if;


    end Fabriquer_Dict;


    function La_Donnee_Dict(Dict : in T_Dictionnaire; Caractere : in Character; Fin : in Boolean) return Unbounded_String is

        function Code_LCA(Caractere : in Character; Sda : in LCA) return Unbounded_String is
        begin
            if Sda = null then
                raise Exception_Donnee_Absente;
            elsif Sda.all.Caractere = Caractere then
                return Sda.all.Code_Huff;
            end if;
            return Code_LCA(Caractere,Sda.all.Suivant);
        end Code_LCA;

    begin
        if Fin then
            return Dict(1).Code_Huff;
        end if;

        return Code_LCA(Caractere, Dict(Hachage(Caractere, False)));
    end La_Donnee_Dict;



    procedure Caractere_LCA(Code : in Unbounded_String; Sda : in LCA; Caractere : out Character; Trouve : out Boolean) is
    begin
        if Sda=null then
            Trouve:=False;
            Caractere:='a';
        elsif Sda.all.Code_Huff = Code then
            Trouve := True;
            Caractere := Sda.all.Caractere;
        else
            Caractere_LCA(Code, Sda.all.Suivant, Caractere, Trouve);
        end if;
    end Caractere_LCA;



    function Le_Caractere_Dict(Dict : in T_Dictionnaire; Code : in Unbounded_String) return Character is
        indice : Integer := 1;
        Caractere : Character;
        Trouve : Boolean := False;
    begin
        loop
            Caractere_LCA(Code, dict(indice), Caractere, Trouve);
            indice := indice + 1;

            exit when Trouve;
        end loop;

        return Caractere;

    end Le_Caractere_Dict;



    procedure Vider_Dict(Dict : in out T_Dictionnaire) is

        procedure Vider_LCA(Sda : in out LCA) is
        begin
            if Sda /= null then
                Vider_LCA(Sda.all.Suivant);
                Free(Sda);
            else
                null;
            end if;
        end Vider_LCA;

    begin
        for i in 1..27 loop
            Vider_LCA(Dict(i));
        end loop;

    end Vider_Dict;



    function Code_Est_Present_Dict(Code : in Unbounded_String; Dict : in T_Dictionnaire) return Boolean is
        indice : Integer := 1;
        Trouve : Boolean := False;
        Caractere : Character;
    begin
        loop
            Caractere_LCA(Code, Dict(indice), Caractere, Trouve);
            indice := indice + 1;
            exit when (Trouve or indice > 27);
        end loop;
        return Trouve;
    end Code_Est_Present_Dict;

    function Convertir_Binaire_Caractere(Texte_Binaire : in Unbounded_String) return Character is
        indice : T_Octet :=0;
    begin
        for k in 1..8 loop
            indice := indice * 2 or Boolean'pos(To_String(Texte_Binaire)(k)='1');
        end loop;
        return Character'val(indice);
    end Convertir_Binaire_Caractere;


    procedure Recuperer_Arbre(Arbre_Huff : out Arbre; Texte : in out Unbounded_String) is
        Liste_Caractere : L_Caractere;
        nbr0, nbr1 : Integer := 0;
        Liste_Arbre : L_Arbres;
        Liste_Complet : L_Complets;

    begin

        if length(Texte) = 16 then
            -- Extraire l'arbre de Huffman d'un Fichier txt initialement vide
            Arbre_Huff := new T_Feuille;
            Arbre_Huff.all.Caractere := Character'Val(0);
            Arbre_Huff.all.Frequence := 0;
            Arbre_Huff.all.Fils_G := null;
            Arbre_Huff.all.Fils_D := null;
            Texte := To_Unbounded_String("0000000");
        else
            -- Extraire l'arbre de Huffman d'un Fichier txt lorsqu'il n'est pas initialement vide
            
            
            -- Obtenir la portion de caractere de la table de Huffman
            
            -- Mettre le '\$' en premiere position de la liste des caracteres
            Liste_Caractere.Taille := 1;
            Liste_Caractere.Caracteres(1) := Convertir_Binaire_Caractere(To_Unbounded_String(To_String(Texte)(1..8)));
            Texte := Delete(Texte, 1, 8);

            -- Mettre les caractères suivant
            while To_String(Texte)(1..8)/=To_String(Texte)(9..16) loop
                Liste_Caractere.Taille := Liste_Caractere.Taille + 1;
                Liste_Caractere.Caracteres(Liste_Caractere.Taille) := Convertir_Binaire_Caractere(To_Unbounded_String(To_String(Texte)(1..8)));
                Texte := Delete(Texte, 1, 8);
            end loop;

            -- Mettre le dernier caractere dans la liste
            Liste_Caractere.Taille := Liste_Caractere.Taille + 1;
            Liste_Caractere.Caracteres(Liste_Caractere.Taille) := Convertir_Binaire_Caractere(To_Unbounded_String(To_String(Texte)(1..8)));
            Texte := Delete(Texte, 1, 16);



            -- Créer l'arbre de Huffman à l'aide de sa forme binaire

            -- Initialiser les compteur
            Liste_Complet.Taille := 0;
            Liste_Arbre.Taille := 0;

            while nbr0 >= nbr1 loop
                -- Agrandir l'arbre selon le bit lu

                if To_String(Texte)(1) = '0' then
                    -- Rajouter une racine à l'arbre
                    nbr0 := nbr0 + 1;
                    Liste_Complet.Taille := Liste_Complet.Taille + 1;
                    Liste_Complet.Complets(Liste_Complet.Taille) := False;

                else
                    -- Rajouter une feuille à l'arbre
                    
                    nbr1 := nbr1 + 1;
                    -- Creer La feuille selon sa position dans la portion des caractères de la table de Huffman
                    Liste_Arbre.Taille := Liste_Arbre.Taille + 1;
                    Liste_Arbre.Foret(Liste_Arbre.Taille) := new T_Feuille;

                    if nbr1 = Character'pos(Liste_Caractere.Caracteres(1))+1 then
                        -- Donner les caracteristique de la feuille '\$'
                        Liste_Arbre.Foret(Liste_Arbre.Taille).all.Frequence := 0;
                        Liste_Arbre.Foret(Liste_Arbre.Taille).all.Caractere := Character'Val(0);
                    else
                        -- Donner les caracteristique de la feuille non '\$'
                        
                        Liste_Arbre.Foret(Liste_Arbre.Taille).all.Frequence := 1;
                        --Affecter le caractère selon sa position dans la portion des carctères de la table de Huffman
                        if nbr1 <= Character'Pos(Liste_Caractere.Caracteres(1)) then
                            Liste_Arbre.Foret(Liste_Arbre.Taille).all.Caractere := Liste_Caractere.Caracteres(nbr1 + 1);
                        else
                            Liste_Arbre.Foret(Liste_Arbre.Taille).all.Caractere := Liste_Caractere.Caracteres(nbr1);
                        end if;

                    end if;

                    Liste_Arbre.Foret(Liste_Arbre.Taille).all.Fils_G := null;
                    Liste_Arbre.Foret(Liste_Arbre.Taille).all.Fils_D := null;


                    -- Ajouter la feuille à l'arbre
                    while Liste_Complet.Taille>0 and then Liste_Complet.Complets(Liste_Complet.Taille) loop
                        Assembler_2arbres(Liste_Arbre, Liste_Arbre.Taille-1, Liste_Arbre.Taille);
                        Liste_Arbre.Foret(Liste_Arbre.Taille) := null;
                        Liste_Arbre.Taille := Liste_Arbre.Taille - 1;
                        Liste_Complet.Taille := Liste_Complet.Taille - 1;
                    end loop;

                    if Liste_Complet.Taille > 0 then
                        Liste_Complet.Complets(Liste_Complet.Taille) := True;
                    end if;
                end if;



                Texte := Delete(Texte,1, 1);
            end loop;

            Arbre_Huff := Liste_Arbre.Foret(1);
            Liste_Arbre.Foret(1) := null;


        end if;

    end Recuperer_Arbre;

    function Arbre_En_Binaire(Arbre_Huff : in Arbre) return Unbounded_String is
    begin
        if Arbre_Huff.all.Fils_G = null then
            return To_Unbounded_String("1");
        end if;
        return To_Unbounded_String("0") & Arbre_En_Binaire(Arbre_Huff.all.Fils_G) & Arbre_En_Binaire(Arbre_Huff.all.Fils_D);
    end Arbre_En_Binaire;



    function Table_En_Binaire(Dict : in T_Dictionnaire) return Unbounded_String is
        texte : Unbounded_String;
        Fichier_vide : Boolean := True;

        procedure Ajouter_Caractere_Code(Code : in Unbounded_String; Texte : in out Unbounded_String; Dict : in T_Dictionnaire; Code_Fin : in Unbounded_String) is
        begin
            if Code/=Code_Fin and then Code_Est_Present_Dict(Code,Dict) then
                Texte := Texte & Le_Caractere_Dict(Dict,Code);
            elsif Code/=Code_Fin then
                Ajouter_Caractere_Code(Code & "0", Texte, Dict, Code_Fin);
                Ajouter_Caractere_Code(Code & "1", Texte, Dict, Code_Fin);
            end if;
        end Ajouter_Caractere_Code;

    begin
        texte := To_Unbounded_String("" & Dict(1).all.Caractere);
        
        --Déterminer si le fichier est non vide
        for k in 2..27 loop
            --Déterminer si la k-ième file du dictionnaire est vide
            if Dict(k)/=null then
                Fichier_vide := False;
            end if;
        end loop;

        if not(Fichier_vide) then
            Ajouter_Caractere_Code(To_Unbounded_String(""), Texte, Dict, Dict(1).all.Code_Huff);
            texte := texte & To_String(texte)(Length(texte));
        end if;
        Convertir_Binaire(texte);
        return texte;

    end Table_En_Binaire;



    procedure Afficher_Arbre(Arbre_Huff : in Arbre) is

        procedure Afficher_Arbre_Recursif(Code : in Unbounded_String; Arbre_Huff : in Arbre) is
        begin
            if Arbre_Huff.all.Fils_G=null then
                --Afficher une feuille

                --Afficher l'espace à gauche
                for i in 1..(Length(Code)-1) loop
                    -- Afficher l’espace selon le bit correspondant
                    if To_String(Code)(i)='0' then
                        Put("|     ");
                    else
                        Put("      ");
                    end if;
                end loop;

                if Arbre_Huff.all.Frequence=0 then
                    Put("\--0--( 0) '\$'");
                elsif Character'pos(Arbre_Huff.all.Caractere)=10 then
                    Put("\--" & To_String(Code)(Length(Code)) & "--(" & Integer'Image(Arbre_Huff.all.Frequence) & ") '\n'");
                else
                    Put("\--" & To_String(Code)(Length(Code)) & "--(" & Integer'Image(Arbre_Huff.all.Frequence) & ") '" & Arbre_Huff.all.Caractere & "'");
                end if;
                New_Line;

            else
                --Afficher une racine

                --Afficher l'espace à gauche
                for i in 1..(Length(Code)-1) loop
                    -- Afficher l’espace selon le bit correspondant
                    if To_String(Code)(i)='0' then
                        Put("|     ");
                    else
                        Put("      ");
                    end if;
                end loop;

                Put("\--" & To_String(Code)(Length(Code)) & "--(" & Integer'Image(Arbre_Huff.all.Frequence) & ")");
                New_Line;
                Afficher_Arbre_Recursif(Code & "0", Arbre_Huff.all.Fils_G);
                Afficher_Arbre_Recursif(Code & "1", Arbre_Huff.all.Fils_D);
            end if;
        end Afficher_Arbre_Recursif;
    begin
        if Arbre_Huff.all.Fils_G/=null then
            --Afficher la fréquence totale
            Put("(" & Integer'Image(Arbre_Huff.all.Frequence) & ")");
            New_Line;
            
            AFFICHER_ARBRE_RECURSIF(To_Unbounded_String("0"),Arbre_Huff.all.Fils_G);
            AFFICHER_ARBRE_RECURSIF(To_Unbounded_String("1"),Arbre_Huff.all.Fils_D);
        else
            Put("--0--( 0) '\$'");
            New_Line;
        end if;
    end Afficher_Arbre;



    procedure Afficher_Dict(Dict : in T_Dictionnaire) is
    begin
        Put_Line("'\$' --> " & To_String(La_Donnee_Dict(Dict,'a',True)));
        for i in 0..255 loop
            begin
                --Ecrrire le caractère et son code correspondant
                if i=10 then
                    Put_Line("'\n' --> " & To_String(La_Donnee_Dict(Dict, Character'val(10), False)));
                else
                    Put_Line("'" & Character'Val(i) & "' --> " & To_String(La_Donnee_Dict(Dict, Character'val(i), False)));
                end if;
            exception
                when Exception_Donnee_Absente => null;
            end;
        end loop;
    end Afficher_Dict;




    procedure Convertir_Binaire(Texte : in out Unbounded_String) is
        Texte_inter : Unbounded_String := To_Unbounded_String("");

        function Convertir_Caractere_Binaire(Caractere : in Character) return Unbounded_String with
                Post => Convertir_Binaire_Caractere(Convertir_Caractere_Binaire'Result)=Caractere
        is
            indice : T_Octet := Character'pos(Caractere);
            Texte_Binaire : Unbounded_String := To_Unbounded_String("");
        begin
            for k in 1..8 loop
                -- Ajouter le k-ième bit
                if (indice-2*(indice/2))=1 then
                    Texte_Binaire := "1" & Texte_Binaire ;
                else
                    Texte_Binaire := "0" & Texte_Binaire;
                end if;
                
                indice := indice/2;
            end loop;
            return Texte_Binaire;
        end Convertir_Caractere_Binaire;

    begin
        for k in 1..Length(Texte) loop
            Texte_inter := Texte_inter & Convertir_Caractere_Binaire(To_String(Texte)(k));
        end loop;
        Texte := Texte_inter;
    end Convertir_Binaire;


    procedure Convertir_Caracteres(Texte : in out Unbounded_String) is
        Texte_inter : Unbounded_String := To_Unbounded_String("");

    begin
        Texte := Texte & (8 - (Length(Texte)-1) mod 8 - 1)*"0";
        for k in 1..Length(Texte)/8 loop
            Texte_inter := Texte_inter & Convertir_Binaire_Caractere(To_Unbounded_String(To_String(Texte)((8*(k-1)+1)..8*k)));
        end loop;
        Texte := Texte_inter;
    end Convertir_Caracteres;


end arbre_de_huffman;

