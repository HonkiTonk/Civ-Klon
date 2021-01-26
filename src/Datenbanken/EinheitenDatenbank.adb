package body EinheitenDatenbank is

   procedure Beschreibung (ID : in GlobaleDatentypen.EinheitenID) is
   begin
      
      Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                          AktuelleAuswahl    => 0,
                          FrageDatei         => 0,
                          FrageZeile         => 0,
                          TextDatei          => 12,
                          ErsteZeile         => Integer (ID),
                          LetzteZeile        => Integer (ID));
      
   end Beschreibung;



   procedure LebenspunkteBewegungspunkteAufMaximumSetzen (RasseExtern : in GlobaleDatentypen.Rassen; EinheitNummer : in Natural) is
   begin
      
      GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).AktuelleLebenspunkte := EinheitenListe (RasseExtern, GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).ID).MaximaleLebenspunkte;
      GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).AktuelleBewegungspunkte := EinheitenListe (RasseExtern, GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).ID).MaximaleBewegungspunkte;
      
   end LebenspunkteBewegungspunkteAufMaximumSetzen;



   procedure HeilungBewegungspunkteFürNeueRundeSetzen is
   begin
      
      RassenSchleife:
      for RasseIntern in GlobaleVariablen.EinheitenGebaut'Range (1) loop
         EinheitenSchleife:
         for EinheitNummer in GlobaleVariablen.EinheitenGebaut'Range (2) loop
            
            if GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).ID = 0 then
               exit EinheitenSchleife;

            else
               null;
            end if;

            if GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBeschäftigung = 0 then
               GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBewegungspunkte := EinheitenListe (RasseIntern, GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).ID).MaximaleBewegungspunkte;

            else
               GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBewegungspunkte := 0.00;
            end if;

            if GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBeschäftigung = 7
              and GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleLebenspunkte + Heilungsrate
              >= EinheitenListe (RasseIntern, GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).ID).MaximaleLebenspunkte then
               GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleLebenspunkte := EinheitenListe (RasseIntern, GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).ID).MaximaleLebenspunkte;
               GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBeschäftigung := 0;
               GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBeschäftigungszeit := 0;
                  
            elsif GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleBeschäftigung = 7
              and GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleLebenspunkte + Heilungsrate
              < EinheitenListe (RasseIntern, GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).ID).MaximaleLebenspunkte then
               GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleLebenspunkte := GlobaleVariablen.EinheitenGebaut (RasseIntern, EinheitNummer).AktuelleLebenspunkte + Heilungsrate;
               
            else
               null;
            end if;
            
         end loop EinheitenSchleife;
      end loop RassenSchleife;
      
   end HeilungBewegungspunkteFürNeueRundeSetzen;
   


   procedure EinheitErzeugen (RasseExtern : in GlobaleDatentypen.Rassen; StadtNummer, ID : in Positive) is -- Kann Einheiten nur in Städten erzeugen und funktioniert nicht richtig
   begin

      Position := (GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).AchsenPosition.EAchse, GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).AchsenPosition.YAchse,
                   GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).AchsenPosition.XAchse);
      EinheitenPosition := 0;
            
      EinheitenSchleife:
      for EinheitenListenplatz in GlobaleVariablen.EinheitenGebaut'Range (2) loop
            
         if GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitenListenplatz).ID = 0 then
            EinheitenPosition := EinheitenListenplatz;
            exit EinheitenSchleife;

         elsif GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitenListenplatz).AchsenPosition = GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).AchsenPosition then
            return;
            
         else
            null;
         end if;
            
      end loop EinheitenSchleife;

      case EinheitenPosition is
         when 0 =>
            return;
            
         when others =>
            GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitenPosition).ID := GlobaleDatentypen.EinheitenID (ID);
            GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitenPosition).AchsenPosition.EAchse := Position.EAchse;
            GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitenPosition).AchsenPosition.YAchse := Position.YAchse;
            GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitenPosition).AchsenPosition.XAchse := Position.XAchse;
            LebenspunkteBewegungspunkteAufMaximumSetzen (RasseExtern   => RasseExtern,
                                                         EinheitNummer => EinheitenPosition);
            GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).VerbleibendeBauzeit := 0;
            GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).AktuelleRessourcen := 0;
            GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).AktuellesBauprojekt := 0;
      end case;
            
   end EinheitErzeugen;



   procedure EinheitEntfernenMitSortieren (RasseExtern : in GlobaleDatentypen.Rassen; EinheitNummer : in Positive) is
   begin
      
      GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer) := (0, 0,    0, (0, 1, 1),    0, 0.00, 0, 0,    0, 0);      
      EinheitGebautSortieren (RasseExtern => RasseExtern);

      if GlobaleVariablen.EinheitenGebaut (RasseExtern, 1).ID = 0 and GlobaleVariablen.StadtGebaut (RasseExtern, 1).ID = 0 then
         GlobaleVariablen.RassenImSpiel (RasseExtern) := 0;
         
      else
         null;
      end if;
      
   end EinheitEntfernenMitSortieren;



   procedure EinheitEntfernenOhneSortieren (RasseExtern : in GlobaleDatentypen.Rassen; EinheitNummer : in Positive) is
   begin

      GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer) := (0, 0,    0, (0, 1, 1),    0, 0.00, 0, 0,    0, 0); 

      if GlobaleVariablen.EinheitenGebaut (RasseExtern, 1).ID = 0 and GlobaleVariablen.StadtGebaut (RasseExtern, 1).ID = 0 then
         GlobaleVariablen.RassenImSpiel (RasseExtern) := 0;
         
      else
         null;
      end if;
      
   end EinheitEntfernenOhneSortieren;
   


   procedure EinheitGebautSortieren (RasseExtern : in GlobaleDatentypen.Rassen) is
   begin

      TauschSchleife:
      for Tauschen in GlobaleVariablen.EinheitenGebautArray'Range (2) loop
         
         Sortieren (Tauschen) := GlobaleVariablen.EinheitenGebaut (RasseExtern, Tauschen);
         GlobaleVariablen.EinheitenGebaut (RasseExtern, Tauschen) := (0, 0,    0, (0, 1, 1),    0, 0.00, 0, 0,    0, 0); 
         
      end loop TauschSchleife;

      SortierenAußenSchleife:
      for Einsortieren in GlobaleVariablen.EinheitenGebautArray'Range (2) loop
         SortierenInnenSchleife:
         for Auswahl in Sortieren'Range loop
            
            if Sortieren (Auswahl).ID /= 0 then
               GlobaleVariablen.EinheitenGebaut (RasseExtern, Einsortieren) := Sortieren (Auswahl);
               Sortieren (Auswahl) := (0, 0,    0, (0, 1, 1),    0, 0.00, 0, 0,    0, 0);
               exit SortierenInnenSchleife;
               
            elsif Auswahl = Sortieren'Last then
               exit SortierenAußenSchleife;
               
            else
               null;
            end if;               
            
         end loop SortierenInnenSchleife;         
      end loop SortierenAußenSchleife;
            
   end EinheitGebautSortieren;

   

   procedure Beschäftigung (Arbeit : in Natural) is
   begin
      
      case Arbeit is
         when 0 =>
            Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                AktuelleAuswahl    => 0,
                                FrageDatei         => 0,
                                FrageZeile         => 0,
                                TextDatei          => 20,
                                ErsteZeile         => 9,
                                LetzteZeile        => 9);            
            
         when others =>
            Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                AktuelleAuswahl    => 0,
                                FrageDatei         => 0,
                                FrageZeile         => 0,
                                TextDatei          => 20,
                                ErsteZeile         => Arbeit,
                                LetzteZeile        => Arbeit);
      end case;
      
   end Beschäftigung;
   


   function BeschäftigungAbbrechenVerbesserungErsetzenBrandschatzenEinheitAuflösen (WelcheAuswahl : in Natural) return Boolean is
   begin
      
      Wahl := Auswahl.AuswahlNeu (AuswahlOderAnzeige => True,
                                  FrageDatei         => 10,
                                  FrageZeile         => 7,
                                  TextDatei          => 5,
                                  ErsteZeile         => 10,
                                  LetzteZeile        => 11);
      case Wahl is
         when -3 =>
            return True;
                     
         when others =>
            return False;
      end case;
      
   end BeschäftigungAbbrechenVerbesserungErsetzenBrandschatzenEinheitAuflösen;

end EinheitenDatenbank;
