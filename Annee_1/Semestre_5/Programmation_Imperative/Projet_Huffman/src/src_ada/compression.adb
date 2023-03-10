with Ada.Text_IO; use Ada.Text_IO;
with arbre_de_huffman; use arbre_de_huffman;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with System.Assertions; use System.Assertions;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with Ada.Command_Line; use Ada.Command_Line;

procedure Compression is




    -- Affiche l'utilisation de la commande 
    procedure Afficher_Usage is
    begin
        New_Line;
        Put_Line("Usage : " & Command_Name & " Option Nom_Fichier");
        New_Line;
        Put_Line("Option (facultative) : ");
        Put_Line("         -b ou --bavard : Affichage de l'Arbre de Huffman et de la table associée, ainsi que le rapport de compression");
        New_Line;
        Put_Line("Nom_Fichier : Nom des fichiers à compresser en .txt");
        New_Line;
    end Afficher_Usage;

    procedure Comprimer_Fichier(Nom_Fichier : in Unbounded_String; Option_b : in Boolean) is

        procedure Lire(Fichier_Txt : in String; Texte : out Unbounded_String) is
            File          : Ada.Streams.Stream_IO.File_Type;
            S             : Stream_Access;
        begin
            Open(File, In_File, Fichier_Txt);
            S := Stream(File);
            Texte := To_Unbounded_String("");
            begin
                while not End_of_File(File) loop
                    Texte := Texte & Character'Input(S);
                end loop;
            exception
                when Ada.IO_Exceptions.End_Error => null; --Fin du fichier
            end;

            Close(File);
        end Lire;

        procedure Ecrire_Compression(File_out : in out Ada.Streams.Stream_IO.File_Type; Texte_hff : in out Unbounded_String) is
            
            S_out 		: Stream_Access;
        begin
            
            S_out := Stream(File_out);
            Convertir_Caracteres(Texte_hff);
            for k in 1..Length(Texte_hff) loop
                Character'Write(S_out, To_String(Texte_hff)(k));
            end loop;
            
        end Ecrire_Compression;



        Arbre_Huff    : Arbre;
        Frequences    : T_frequences;
        Dictionnaire  : T_Dictionnaire;
        Texte         : Unbounded_String;

        Texte_Hff	   : Unbounded_String;
        Nom_Fichier_Hff : Unbounded_String;
        File_out      : Ada.Streams.Stream_IO.File_Type;

    begin
        -- Créer l'arbre de Huffman
        Lire(To_String(Nom_Fichier), Texte);
        Calculer_Freq(Frequences, Texte);
        Construire_Arbre(Arbre_Huff, Frequences);
        Fabriquer_Dict(Dictionnaire, Arbre_Huff);
        if Option_b then
            Afficher_Arbre(Arbre_Huff);
            Afficher_Dict(Dictionnaire);
        end if;


        -- Enregistrer la Table et L'arbre de Huffman dans le texte du fichier compresser.
        Texte_Hff := Table_En_Binaire(Dictionnaire) & Arbre_En_Binaire(Arbre_Huff);
        Vider_Arbre(Arbre_Huff);

        -- Encoder tous les caracteres du texte et les enregistrer dans le fichier .hff

        for indice in 1..Length(Texte) loop
            Texte_Hff := Texte_Hff & La_Donnee_Dict(Dictionnaire, To_String(Texte)(indice), False);
        end loop;
        Texte_Hff := Texte_Hff & La_Donnee_Dict(Dictionnaire, 'a', True);

        if Option_b then
            if Length(Texte) /= 0 then
                Put_Line("Le rapport de compression pour ce fichier est de : " & Float'Image(Float(Length(Texte_Hff))/Float(8*Length(Texte)))); 
            else 
                Put_Line("Aucun rapport de compression ne peut être affiché car le fichier " & To_String(Nom_Fichier) & " à compresser est vide");
            end if;
        end if;
        
                        
                
        
        Nom_Fichier_Hff := Nom_Fichier & ".hff";
        Create (File_out, Out_File, To_String(Nom_Fichier_Hff));
        Ecrire_Compression(File_out, Texte_Hff);        
        Close(File_out);
        Vider_Dict(Dictionnaire);


    end Comprimer_Fichier;
    
    Count_File 	: Integer;
    Nom_Fichier	  : Unbounded_String;
    Bavard           : Boolean := False;
    Exception_Name_Error : exception;
    Exception_Not_File_Found : exception;

begin
    if Argument_Count = 0 then
        raise Exception_Not_File_Found;
    else
        if Argument(1) = "-b" or Argument(1) = "--bavard" then
            Bavard := True;
            Count_File := 2;
            if Argument_Count = 1 then
                raise Exception_Not_File_Found;
            end if;
            
        else
            Bavard := False;
            Count_File := 1;
        end if;
        
        while Count_File <= Argument_Count loop
            begin 
                Nom_Fichier := To_Unbounded_String(Argument(Count_File));
                
                -- On regarde d'abord si le nom du fichier correspond à un format que l'on peut compresser
                if Length(Nom_Fichier) < 4 then
                    raise Exception_Name_Error; -- Le fichier ne peut pas avoir l'extension .txt
                end if;
                if To_String(Nom_Fichier)((Length(Nom_Fichier)-3)..Length(Nom_Fichier)) /= ".txt" then
                    raise Exception_Name_Error;
                end if;

                Comprimer_Fichier(Nom_Fichier, Bavard);
            exception
                when Exception_Name_Error =>
                    if Count_File = 1 then 
                        Put_Line (Argument(Count_File) & " ne correspond ni a une option ni a un fichier dans le bon format pour cette commande");
                    else 
                        Put_Line ("Le fichier " & Argument(Count_File) & " n'est pas dans le format attendu");
                    end if;
                    
                when Ada.IO_Exceptions.Name_Error =>
                    Put_Line ("Le fichier " & Argument(Count_File) & " n'existe pas");
            end ;
            
            Count_File := Count_File + 1;
        end loop;      
        

    end if;
    
exception
    when Exception_Not_File_Found =>
        Put_Line("Aucun fichier n'a été écrit dans la commande"); 
        Afficher_Usage;
end Compression;
