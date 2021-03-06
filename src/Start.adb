pragma SPARK_Mode (On);

with Ada.Wide_Wide_Text_IO;
use Ada.Wide_Wide_Text_IO;

with GlobaleTexte;

-- with Programmanalyse;

with Einlesen, Anzeige, Hauptmenue, Intro, SchreibenVerzeichnisse;

procedure Start
is begin

   -- Programmanalyse.Auswahl;

   SchreibenVerzeichnisse.SchreibenVerzeichnisse;

   case
     Einlesen.Einlesen
   is
      when True =>
         Intro.Intro;
         Hauptmenue.Hauptmenü;

         Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDateiExtern => GlobaleTexte.Leer,
                                        TextDateiExtern        => GlobaleTexte.Start,
                                        ÜberschriftZeileExtern => 0,
                                        ErsteZeileExtern       => 8,
                                        LetzteZeileExtern      => 8,
                                        AbstandAnfangExtern    => GlobaleTexte.Neue_Zeile,
                                        AbstandMitteExtern     => GlobaleTexte.Keiner,
                                        AbstandEndeExtern      => GlobaleTexte.Keiner);

      when False =>
         -- Nicht über Anzeige regeln, da die benötigten Dateien ja gar nicht eingelesen wurden!
         Put_Line (Item => "Benötigte Dateien nicht gefunden (Start.EinlesenErgebnis => False)!");
   end case;

end Start;
