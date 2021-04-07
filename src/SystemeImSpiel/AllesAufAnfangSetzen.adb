pragma SPARK_Mode (On);

with GlobaleVariablen;

with Karten;

package body AllesAufAnfangSetzen is

   procedure AllesAufAnfangSetzen
   is begin
      
      GlobaleVariablen.RassenImSpiel := (others => 0);
      GlobaleVariablen.EinheitenGebaut := (others => (others => GlobaleVariablen.LeererWertEinheit));
      GlobaleVariablen.StadtGebaut := (others => (others => GlobaleVariablen.LeererWertStadt));
      GlobaleVariablen.Wichtiges := (others => GlobaleVariablen.LeererWertWichtigesZeug);
      GlobaleVariablen.Diplomatie := (others => (others => GlobaleVariablen.Kein_Kontakt));
      GlobaleVariablen.RundenAnzahl := 1;
      GlobaleVariablen.RasseAmZugNachLaden := 0;
      GlobaleVariablen.CursorImSpiel := (others => GlobaleVariablen.LeererWertCursor);

      Karten.Weltkarte := (others => (others => (others => Karten.LeererWertWeltkarte)));
      Karten.Kartengrößen := ((20, 20, 12), (40, 40, 50), (80, 80, 200), (120, 80, 300), (120, 160, 600), (160, 160, 800), (240, 240, 1_800), (320, 320, 3200), (1_000, 1_000, 31_250), (1, 1, 1));
            
   end AllesAufAnfangSetzen;

end AllesAufAnfangSetzen;
