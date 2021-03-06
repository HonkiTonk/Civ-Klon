pragma SPARK_Mode (On);

with Ada.Strings.Wide_Wide_Unbounded; 
use Ada.Strings.Wide_Wide_Unbounded;

with GlobaleDatentypen;

package GlobaleTexte is

   type Welche_Datei_Enum is (Leer, Start, Feste_Abfragen, Spiel_Einstellungen, Rassen_Beschreibung_Lang, Menü_Auswahl, Beschreibungen_Kartenfelder_Kurz, Beschreibungen_Kartenfelder_Lang, Fehlermeldungen, Zeug,
                              Fragen, Ladezeiten, Beschreibungen_Einheiten_Kurz, Beschreibungen_Einheiten_Lang, Beschreibungen_Verbesserungen_Kurz, Beschreibungen_Verbesserungen_Lang, Beschreibungen_Gebäude_Kurz,
                              Beschreibungen_Gebäude_Lang, Beschreibungen_Forschung_Kurz, Beschreibungen_Forschung_Lang, Beschreibungen_Beschäftigung_Kurz, Beschreibungen_Beschäftigung_Lang, Städtenamen_KI, Cheat_Menü,
                              Rassen_Beschreibung_Kurz, Beschreibung_Forschung_Ermöglicht, Allgemeine_Informationen, Würdigungen);

   type Welcher_Abstand_Enum is (Keiner, Kleiner_Abstand, Großer_Abstand, Neue_Zeile);
   
   type SprachenEinlesenArray is array (1 .. 100) of Unbounded_Wide_Wide_String;
   SprachenEinlesen : SprachenEinlesenArray;

   type TexteEinlesenNeuArray is array (1 .. GlobaleDatentypen.TextDateien'Last, 1 .. 104) of Unbounded_Wide_Wide_String;
   TexteEinlesenNeu : TexteEinlesenNeuArray := (others => (others => (To_Unbounded_Wide_Wide_String (Source => "|"))));

end GlobaleTexte;
