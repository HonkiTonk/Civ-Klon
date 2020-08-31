with Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Unbounded, Einlesen, GlobaleVariablen, Auswahl;
use Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Unbounded;

package EinheitenDatenbank is

   type Einheiten is record
      
      -- 1 = Cursor kann passieren, 2 = Wassereinheiten können passieren, 4 = Landeinheiten können passieren, 8 = Lufteinheiten können passieren
      -- Addieren für genaue Passierbarkeit
      
      Anzeige : Wide_Wide_Character;
      
      SiedlerLandeinheitSeeeinheitLufteinheit : Integer; -- 1 = Siedler, 2 = Nahkampfland, 3 = Fernkampfland, 4 = Nahkampfsee, 5 = Fernkampfsee, 6 = Nahkampfluft, 7 = Fernkampfluft
      PreisGeld : Integer;
      PreisRessourcen : Integer;
      Anforderungen : Wide_Wide_Character;

      Passierbarkeit : Integer;
      MaximaleLebenspunkte : Integer;
      MaximaleBewegungspunkte : Integer;

      Beförderungsgrenze : Integer;
      MaximalerRang : Integer;
      Reichweite : Integer;
      Angriff : Integer;
      Verteidigung : Integer;
      
   end record;

   type EinheitenListeArry is array (1 .. 50) of Einheiten;
   EinheitenListe : constant EinheitenListeArry := (('S', 1, 10, 10, '0',    1, 3, 1,    30, 3, 1, 1, 1), -- Siedler

                                                    ('L', 2, 25, 20, '0',    1, 5, 1,    30, 3, 1, 2, 1), -- Steinbeilkämpfer
                                                    ('L', 2, 25, 20, '1',    1, 5, 1,    30, 3, 1, 2, 1), -- Bogenschütze
                                                    
                                                    ('L', 3, 50, 5, '0',     1, 3, 3,    30, 3, 3, 8, 1), -- Kanone

                                                    ('S', 4, 20, 10, '0',    2, 2, 1,    30, 3, 1, 1, 1), -- Segelschiff
                                                    ('S', 5, 20, 10, '0',    2, 3, 3,    30, 3, 1, 1, 1), -- Kanonenschiff
                                                    
                                                    ('F', 6, 100, 10, '0',   3, 8, 1,    30, 3, 1, 10, 1), -- Jäger
                                                    ('F', 7, 100, 10, '0',   3, 8, 1,    30, 3, 1, 10, 1), -- Bomber
                                                    
                                                    others => ('@', 0, 0, 0, '0', 0, 0, 0, 1, 1, 0, 0, 1));

   procedure Beschreibung (ID : in Integer);
   procedure LebenspunkteBewegungspunkteAufMaximumSetzen (Rasse, Platznummer : in Integer);
   procedure HeilungBewegungspunkteFürNeueRundeSetzen;
   procedure EinheitErzeugen (YAchse, XAchse, Rasse, ID : in Integer);
   procedure EinheitEntfernen (Rasse, Platznummer : in Integer);
   procedure Beschäftigung (Arbeit : in Wide_Wide_Character);

   function BeschäftigungAbbrechen return Boolean;
   function EinheitAuflösen return Boolean;

private
   
   Wahl : Integer;
   
   Heilungsrate : constant Integer := 10;

end EinheitenDatenbank;