with Ada.Text_IO; use Ada.Text_IO;
with arbre_de_huffman; use arbre_de_huffman;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with System.Assertions; use System.Assertions;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;

procedure test_arbre_huffman is
    
    Arbre_test    : Arbre; 
    Frequences    : T_frequences;
    Dictionnaire  : T_Dictionnaire;
    File          : Ada.Streams.Stream_IO.File_Type;
    S             : Stream_Access;
    Texte         : Unbounded_String;
                                    
    procedure test_la_donnee_dict(Dict : in T_Dictionnaire; Numero : in Integer) is
    begin
        case Numero is
            when 0 =>
                Put_Line(To_String(La_Donnee_Dict(Dict,Character'Val(0),True)));
                pragma Assert (La_Donnee_Dict(Dict,Character'Val(0),True)=To_Unbounded_String("0"));-- '\$'
                begin 
                    pragma Assert (La_Donnee_Dict(Dict,'z',False) = To_Unbounded_String("0")); -- pas dans le dictionnaire
                exception
                    when Exception_Donnee_Absente =>
                        Put_Line("Caracère absent");
                end;
            when 1 =>
                pragma Assert (La_Donnee_Dict(Dict,'a',False)=To_Unbounded_String("1"));-- 'a' se code avec 97 et 01100001 (qui est écrit 6 fois)
                pragma Assert (La_Donnee_Dict(Dict,Character'Val(0),True)=To_Unbounded_String("00"));-- '\$'
                pragma Assert (La_Donnee_Dict(Dict,Character'Val(10),False)=To_Unbounded_String("01"));-- '\n' se code avec 10 et 00001010 (qui est écrit 1 fois)
                begin 
                    pragma Assert (La_Donnee_Dict(Dict,'y',False) = To_Unbounded_String("0")); -- pas dans le dictionnaire
                exception
                    when Exception_Donnee_Absente =>
                        Put_Line("Caracère absent");
                end;
            when others =>
                pragma Assert (La_Donnee_Dict(Dict,'a',False)=To_Unbounded_String("0"));-- 'a' se code avec 97 et 01100001 (qui est écrit 5 fois)
                pragma Assert (La_Donnee_Dict(Dict,'b',False)=To_Unbounded_String("10"));-- 'b' se code avec 98 et 01100010 (qui est écrit 3 fois)
                pragma Assert (La_Donnee_Dict(Dict,'c',False)=To_Unbounded_String("110"));-- 'c' se code avec 99 et 01100011 (qui est écrit 2 fois)
                pragma Assert (La_Donnee_Dict(Dict,'d',False)=To_Unbounded_String("11101"));-- 'd' se code avec 100 et 01100100 (qui est écrit 1 fois)
                pragma Assert (La_Donnee_Dict(Dict,Character'Val(0),True)=To_Unbounded_String("11100"));-- '\$'
                pragma Assert (La_Donnee_Dict(Dict,Character'Val(10),False)=To_Unbounded_String("1111"));-- '\n' se code avec 10 et 00001010 (qui est écrit 1 fois)
                begin 
                    pragma Assert (La_Donnee_Dict(Dict,'x',False) = To_Unbounded_String("0")); -- pas dans le dictionnaire
                exception
                    when Exception_Donnee_Absente =>
                        Put_Line("Caracère absent");
                end;
        end case;
        
        
    end test_la_donnee_dict;
    
    
    
    procedure test_le_caractere_dict(Dict : in T_Dictionnaire; Numero : in Integer) is
    begin
        case Numero is
            when 0 =>
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("0"))=Character'Val(0));-- '\$'
                begin
                    pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("101")) = 'e'); -- pas dans le dictionnaire
                exception
                    when system.assertions.assert_failure =>
                        Put_Line("Code absent");
                end;
            when 1 =>
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("1"))='a');-- 'a' se code avec 97 et 01100001 (qui est écrit 6 fois)
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("00"))=Character'Val(0));-- '\$'     
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("01"))=Character'Val(10));-- '\n' se code avec 10 et 00001010 (qui est écrit 1 fois)
                begin
                    pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("101")) = 'f'); -- pas dans le dictionnaire
                exception
                    when system.assertions.assert_failure =>
                        Put_Line("Code absent");
                end;
            when others =>
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("0"))='a');-- 'a' se code avec 97 et 01100001 (qui est écrit 5 fois)
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("10"))='b');-- 'b' se code avec 98 et 01100010 (qui est écrit 3 fois)
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("110"))='c');-- 'c' se code avec 99 et 01100011 (qui est écrit 2 fois)
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("11101"))='d');-- 'd' se code avec 100 et 01100100 (qui est écrit 1 fois)
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("11100"))=Character'Val(3));-- '\$'
                pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("1111"))=Character'Val(10));-- '\n' se code avec 10 et 00001010 (qui est écrit 1 fois)
                begin
                    pragma Assert (Le_Caractere_Dict(Dict,To_Unbounded_String("101")) = 'u'); -- pas dans le dictionnaire
                exception
                    when system.assertions.assert_failure =>
                        Put_Line("Code absent");
                end;
        end case;
        
    end test_le_caractere_dict;
    
    
    
    procedure test_code_est_present_dict(Dict : in T_Dictionnaire; Numero : in Integer) is
    begin
        case Numero is
            when 0 =>
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("0"),Dict));-- '\$'
                pragma Assert (not Code_Est_Present_Dict(To_Unbounded_String("101"),Dict));-- pas dans le dictionnaire
            when 1 =>
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("1"),Dict));-- 'a' se code avec 97 et 01100001 (qui est écrit 6 fois)
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("00"),Dict));-- '\$'
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("01"),Dict));-- '\n' se code avec 10 et 00001010 (qui est écrit 1 fois)
                pragma Assert (not Code_Est_Present_Dict(To_Unbounded_String("101"),Dict));-- pas dans le dictionnaire
            when others =>
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("0"),Dict));-- 'a' se code avec 97 et 01100001 (qui est écrit 5 fois)
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("10"),Dict));-- 'b' se code avec 98 et 01100010 (qui est écrit 3 fois)
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("110"),Dict));-- 'c' se code avec 99 et 01100011 (qui est écrit 2 fois)
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("11101"),Dict));-- 'd' se code avec 100 et 01100100 (qui est écrit 1 fois)
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("11100"),Dict));-- '\$'
                pragma Assert (Code_Est_Present_Dict(To_Unbounded_String("1111"),Dict));-- '\n' se code avec 10 et 00001010 (qui est écrit 1 fois)
                pragma Assert (not Code_Est_Present_Dict(To_Unbounded_String("101"),Dict));-- pas dans le dictionnaire
        end case;
    end test_code_est_present_dict;
    
    
    
    procedure test_arbre_en_binaire(Arbre_Huff : in Arbre; Numero : in Integer) is
    begin
        case Numero is
            when 0 => pragma Assert (Arbre_En_Binaire(Arbre_Huff)=To_Unbounded_String("1"));
            when 1 => pragma Assert (Arbre_En_Binaire(Arbre_Huff)=To_Unbounded_String("00111"));
            when others => pragma Assert (Arbre_En_Binaire(Arbre_Huff)=To_Unbounded_String("01010100111"));
        end case;
    end test_arbre_en_binaire;

    
    
    procedure test_table_en_binaire(Dict : in T_Dictionnaire; Numero : in Integer) is 
    begin
        case Numero is
            when 0 => pragma Assert (Table_En_Binaire(Dict)=To_Unbounded_String("00000000"));-- ['\$']
            when 1 => pragma Assert (Table_En_Binaire(Dict)=To_Unbounded_String("00000000"&"00001010"&"01100001"&"01100001"));-- ['\$','\n','a']
            when others => pragma Assert (Table_En_Binaire(Dict)=To_Unbounded_String("00000011"&"01100001"&"01100010"&"01100011"&"01100100"&"00001010"&"00001010"));-- ['\$','a','b','c','d','\n']
        end case;
    end test_table_en_binaire;
    
    

    procedure test_afficher_arbre(Arbre_Huff : in Arbre) is
    begin
        Afficher_Arbre(Arbre_Huff);
    end test_afficher_arbre;
    
    
    
    procedure test_afficher_dict(Dict : T_Dictionnaire) is
    begin
        Afficher_Dict(Dict);
    end test_afficher_dict;
    
    
    procedure test_convertir_binaire(Texte: in Unbounded_String; Numero : in Integer) is 
        Texte_Binaire : Unbounded_String := Texte;
    begin
        case Numero is
            when 0 => 
                Convertir_Binaire(Texte_Binaire);
                pragma Assert (Texte_Binaire=To_Unbounded_String("")); -- Fichier txt vide
            when 1 => 
                Convertir_Binaire(Texte_Binaire);
                pragma Assert (Texte_Binaire=To_Unbounded_String("01100001011000010110000101100001011000010110000100001010")); -- "aaaaaa\n"
            when others => 
                Convertir_Binaire(Texte_Binaire);
                pragma Assert (Texte_Binaire=To_Unbounded_String("011000010110000101100001011000010110000101100010011000100110001001100011011000110110010000001010"));-- "aaaaabbbccd\n"
        end case;
    end test_convertir_binaire;

    procedure test_convertir_binaire(Texte: in Unbounded_String) is 
        Texte_Convertis : Unbounded_String := Texte;
    begin
        Convertir_Binaire(Texte_Convertis);
        Convertir_Caracteres(Texte_Convertis);
        pragma Assert (Texte_Convertis=Texte);
    end test_convertir_binaire;

    procedure test_recuperer_arbre(Numero : in Integer) is 
        Texte: Unbounded_String;
        Arbre_test : Arbre;
    begin
        case Numero is
            when 0 => Texte := To_Unbounded_String("00000000" & "1" & "0000000");
            when 1 => Texte := To_Unbounded_String("00000000"&"00001010"&"01100001"&"01100001" & "00111" & "000");
            when others => Texte := To_Unbounded_String("00000011"&"01100001"&"01100010"&"01100011"&"01100100"&"00001010"&"00001010" & "01010100111" & "00000");
        end case;
        Recuperer_Arbre(Arbre_test, Texte);                
        Afficher_Arbre(Arbre_test);
    end test_recuperer_arbre;
    
begin
    
    -- Test avec fichier vide
    Open(File, In_File, "fichier_test_0.txt");
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
    Put_Line(To_String(Texte));
    
    Calculer_freq(Frequences, Texte);
    Construire_Arbre(Arbre_test, Frequences);
    Fabriquer_Dict(Dictionnaire, Arbre_test);

    test_la_donnee_dict(Dictionnaire,0);
    test_le_caractere_dict(Dictionnaire,0);
    test_code_est_present_dict(Dictionnaire,0);
    test_arbre_en_binaire(Arbre_test,0);
    test_table_en_binaire(Dictionnaire,0);
    test_afficher_arbre(Arbre_test);
    test_afficher_dict(Dictionnaire);
    test_convertir_binaire(Texte,0);
    test_convertir_binaire(Texte);
    test_recuperer_arbre(0);
    

    Vider_Arbre(Arbre_test);             -- Sera testé avec Valgrind
    Vider_Dict(Dictionnaire);            -- Sera testé avec Valgrind
    
    -- Test avec un caractère
    Open(File, In_File, "fichier_test_1.txt");
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
    New_Line;
    New_Line;
    Put_Line(To_String(Texte));
    
    Calculer_freq(Frequences, Texte);
    Construire_Arbre(Arbre_test, Frequences);
    Fabriquer_Dict(Dictionnaire, Arbre_test);

    test_la_donnee_dict(Dictionnaire,1);
    test_le_caractere_dict(Dictionnaire,1);
    test_code_est_present_dict(Dictionnaire,1);
    test_arbre_en_binaire(Arbre_test,1);
    test_table_en_binaire(Dictionnaire,1);
    test_afficher_arbre(Arbre_test);
    test_afficher_dict(Dictionnaire);
    test_convertir_binaire(Texte,1);
    test_convertir_binaire(Texte);
    test_recuperer_arbre(1);
    

    Vider_Arbre(Arbre_test);             -- Sera testé avec Valgrind
    Vider_Dict(Dictionnaire);            -- Sera testé avec Valgrind
    
    -- Test avec plusieurs caractères
    Open(File, In_File, "fichier_test_2.txt");
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
    New_Line;
    New_Line;
    Put_Line(To_String(Texte));
    
    Calculer_freq(Frequences, Texte);
    Construire_Arbre(Arbre_test, Frequences);
    Fabriquer_Dict(Dictionnaire, Arbre_test);

    test_la_donnee_dict(Dictionnaire,2);
    test_le_caractere_dict(Dictionnaire,2);
    test_code_est_present_dict(Dictionnaire,2);
    test_arbre_en_binaire(Arbre_test,2);
    test_table_en_binaire(Dictionnaire,2);
    test_afficher_arbre(Arbre_test);
    test_afficher_dict(Dictionnaire);
    test_convertir_binaire(Texte,2);
    test_convertir_binaire(Texte);
    test_recuperer_arbre(2);
    

    Vider_Arbre(Arbre_test);             -- Sera testé avec Valgrind
    Vider_Dict(Dictionnaire);            -- Sera testé avec Valgrind

    New_Line;
    Put_Line("Tous les tests : OK !!!");
end test_arbre_huffman;
