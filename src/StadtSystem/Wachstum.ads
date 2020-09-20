with Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Unbounded, StadtWerteFestlegen, Einlesen, GlobaleVariablen, GebaeudeDatenbank, EinheitenDatenbank;
use Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Unbounded;

package Wachstum is
   
   procedure Wachstum;

private
   
   procedure WachstumEinwohner (Rasse, StadtNummer : in Integer);
   procedure WachstumProduktion (Rasse, StadtNummer : in Integer);

end Wachstum;
