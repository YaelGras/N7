with Ada.Text_IO; use Ada.Text_IO;
with arbre_de_huffman; use arbre_de_huffman;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with System.Assertions; use System.Assertions;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with Ada.Command_Line; use Ada.Command_Line;


procedure Decompression is
    
    -- Affiche l'utilisation de la commande 
    procedure Afficher_Usage is
    begin
        New_Line;
        Put_Line("Usage : " & Command_Name & " Option Nom_Fichier");
        New_Line;
        Put_Line("Option (facultative) : ");
        Put_Line("         -b ou --bavard : Affichage de l'Arbre de Huffman et de la table associée");
        New_Line;
        Put_Line("Nom_Fichier : Nom des fichiers à décompresser en .hff");
        New_Line;
    end Afficher_Usage;
    
    procedure Decomprimer_Fichier(Nom_Fichier_Hff : in Unbounded_String; Bavard : in Boolean) is

        procedure Lire(Fichier_Hff : in String; Texte : out Unbounded_String) is
            File          : Ada.Streams.Stream_IO.File_Type;
            S             : Stream_Access;
        begin
            Open(File, In_File, Fichier_Hff);
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

        procedure Ecrire_Decompression(File : in out Ada.Streams.Stream_IO.File_Type; Caractere : in Character) is
            S             : Stream_Access;
        begin
            S := Stream(File);
            Character'Write(S, Caractere);
        end Ecrire_Decompression;



        Arbre_Huff    : Arbre;
        Dictionnaire  : T_Dictionnaire;
        Texte         : Unbounded_String;

        Code	   : Unbounded_String;
        Fini_Txt : Boolean;
        
        Fichier_Txt     : Ada.Streams.Stream_IO.File_Type;

    begin
        -- Créer l'arbre de Huffman
        Lire(To_String(Nom_Fichier_Hff), Texte);
        Convertir_Binaire(Texte);
        Recuperer_Arbre(Arbre_Huff, Texte);
        Fabriquer_Dict(Dictionnaire, Arbre_Huff);
        
        if Bavard then
            Afficher_Arbre(Arbre_Huff);
            Afficher_Dict(Dictionnaire);
        end if;
        

        Vider_Arbre(Arbre_Huff);

        Create(Fichier_Txt, Out_File, To_String(Nom_Fichier_Hff)(1..Length(Nom_Fichier_Hff)-4));
        
        
        
        -- Encoder tous les caracteres du texte et les enregistrer dans le fichier .hff
        Code := To_Unbounded_String("");
        for indice in 1..Length(Texte) loop
            Code := Code & To_String(Texte)(indice);
            Fini_Txt :=  La_Donnee_Dict(Dictionnaire, '0', True) = Code; -- On regarde si nous sommes à la fin du texte
            if not(Fini_Txt) and Code_Est_Present_Dict(Code, Dictionnaire) then
                Ecrire_Decompression(Fichier_Txt, Le_Caractere_Dict(Dictionnaire, Code));
                Code := To_Unbounded_String("");
            end if;
            
        end loop;

        Vider_Dict(Dictionnaire);
        Close(Fichier_Txt);

    end Decomprimer_Fichier;
    
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
                if To_String(Nom_Fichier)((Length(Nom_Fichier)-3)..Length(Nom_Fichier)) /= ".hff" then
                    raise Exception_Name_Error;
                end if;

                Decomprimer_Fichier(Nom_Fichier, Bavard);
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
     
end Decompression;
