pragma SPARK_Mode (On);

with KIDatentypen;

with KIBewegung;

package body KINahkampfOrbital is

   procedure KINahkampfOrbital (EinheitRasseNummer : in GlobaleRecords.RassePlatznummerRecord) is
   begin
      
      KIBewegung.KIBewegung (EinheitRasseNummer => EinheitRasseNummer,
                             Aufgabe            => KIDatentypen.Erkunden);
      
   end KINahkampfOrbital;

end KINahkampfOrbital;
