pragma SPARK_Mode (On);

with KIDatentypen, KIKonstanten;

with EinheitSuchen, KartenPruefungen, Karten, BewegungPassierbarkeitPruefen, EinheitenAllgemein;

package body KINahkampfBodenAufgabeFestlegen is

   procedure NahkampfBodenAufgabeFestlegen
     (GewählteAufgabeExtern : in Natural;
      EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      case
        GewählteAufgabeExtern
      is
         -- Stadt bewachen
         when 1 =>
            StadtBewachen (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Stadtumgebung zerstören
         when 2 =>
            StadtUmgebungZerstören (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Einheit auflösen
         when 3 =>
            EinheitenAllgemein.EinheitEntfernen (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Fliehen
         when 4 =>
            Fliehen (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Sich heilen
         when 5 =>
            Heilen (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Sich befestigen
         when 6 =>
            Befestigen (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Einheit verbessern
         when 7 =>
            EinheitVerbessern (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Angreifen
         when 8 =>
            Angreifen (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
              
            -- Erkunden
         when 9 =>
            Erkunden (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
            
            -- Nichts tun
         when others =>
            GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Keine_Aufgabe;
            GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Beschäftigung := GlobaleDatentypen.Keine;
      end case;
      
   end NahkampfBodenAufgabeFestlegen;
   
   
   
   procedure StadtBewachen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      EinheitNummer := 1;
      
      StadtSchleife:
      for StadtNummerSchleifenwert in GlobaleVariablen.StadtGebautArray'Range (2) loop
         
         if
           GlobaleVariablen.StadtGebaut (EinheitRasseNummerExtern.Rasse, StadtNummerSchleifenwert).ID > 0
         then
            EinheitNummer := EinheitSuchen.KoordinatenEinheitMitRasseSuchen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                                                             KoordinatenExtern => GlobaleVariablen.StadtGebaut (EinheitRasseNummerExtern.Rasse, StadtNummerSchleifenwert).Position);
            
         else
            null;
         end if;
         
         case
           EinheitNummer
         is
            when 0 =>
               GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIZielKoordinaten
                 := GlobaleVariablen.StadtGebaut (EinheitRasseNummerExtern.Rasse, StadtNummerSchleifenwert).Position;
               GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Stadt_Bewachen;
               return;
               
            when others =>
               null;
         end case;
         
      end loop StadtSchleife;
      
   end StadtBewachen;
   
   
   
   procedure StadtUmgebungZerstören     
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      null;
      
   end StadtUmgebungZerstören;
   
   
   
   procedure Fliehen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin      
      
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Flucht;
      
   end Fliehen;
     
   
   
   procedure Heilen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Einheit_Heilen;
      
   end Heilen;
   
   
   
   procedure Befestigen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Einheit_Festsetzen;
      
   end Befestigen;
   
   
   
   procedure EinheitVerbessern
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Einheit_Verbessern;
      
   end EinheitVerbessern;
   
   
   
   procedure Angreifen     
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      null;
      
   end Angreifen;
   
   
   
   procedure Erkunden     
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin      
            
      KartenYReichweite := 1;
      KartenXReichweite := 1;
      KartenYGeprüft := 0;
      KartenXGeprüft := 0; 
      
      UnbekanntesFeldSuchenSchleife:
      for FeldSuchenSchleifenwert in 1 .. 15 loop
         YAchseSchleife:
         for YÄnderungSchleifenwert in -KartenYReichweite .. KartenYReichweite loop
            XAchseSchleife:
            for XÄnderungSchleifenwert in -KartenXReichweite .. KartenXReichweite loop
            
               if
                 KartenYGeprüft >= abs (YÄnderungSchleifenwert)
               then
                  null;
                  
               elsif
                 KartenXGeprüft >= abs (XÄnderungSchleifenwert)
               then
                  null;
                  
               else               
                  KartenWert := KartenPruefungen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position,
                                                                          ÄnderungExtern       => (0, YÄnderungSchleifenwert, XÄnderungSchleifenwert));
            
                  exit XAchseSchleife when KartenWert.YAchse = 0;
                  
                  if
                    Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Sichtbar (EinheitRasseNummerExtern.Rasse) = False
                    and
                      BewegungPassierbarkeitPruefen.FeldFürDieseEinheitPassierbarNeu (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                                                       NeuePositionExtern       => KartenWert)
                    = GlobaleDatentypen.Normale_Bewegung_Möglich
                  then
                     GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Erkunden;
                     GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIZielKoordinaten := KartenWert;
                     return;
                     
                  else
                     null;
                  end if;
               end if;
            
            end loop XAchseSchleife;
         end loop YAchseSchleife;
         
         if
           KartenYReichweite >= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
           and
             KartenXReichweite >= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße
         then
            exit UnbekanntesFeldSuchenSchleife;
            
         else
            null;
         end if;     
         
         if
           KartenYReichweite < Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
         then            
            KartenYGeprüft := KartenYReichweite;
            KartenYReichweite := KartenYReichweite + 1;
            
         else
            null;
         end if;
         
         if
           KartenXReichweite < Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße
         then            
            KartenXGeprüft := KartenXReichweite;
            KartenXReichweite := KartenXReichweite + 1;
            
         else
            null;
         end if;        
         
      end loop UnbekanntesFeldSuchenSchleife;
      
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIBeschäftigt := KIDatentypen.Keine_Aufgabe;
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).KIZielKoordinaten := KIKonstanten.NullKoordinate;
      
   end Erkunden;

end KINahkampfBodenAufgabeFestlegen;
