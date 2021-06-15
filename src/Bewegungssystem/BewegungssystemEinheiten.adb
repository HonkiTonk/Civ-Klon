pragma SPARK_Mode (On);

with GlobaleKonstanten;

with EinheitenDatenbank, VerbesserungenDatenbank;

with Karte, Diplomatie, Sichtbarkeit, BewegungBlockiert, EinheitSuchen, KartenPruefungen, Eingabe, BewegungPassierbarkeitPruefen, BewegungLadenEntladen, StadtSuchen;

package body BewegungssystemEinheiten is

   procedure BewegungEinheitenRichtung
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      Karte.AnzeigeKarte (RasseExtern => EinheitRasseNummerExtern.Rasse);

      BewegenSchleife:
      loop
              
         case
           Eingabe.Tastenwert
         is
            when 1 =>
               Änderung := (0, -1, 0);
            
            when 2 =>
               Änderung := (0, 0, -1);
            
            when 3 =>
               Änderung := (0, 1, 0);
            
            when 4  =>
               Änderung := (0, 0, 1);
            
            when 5 =>
               Änderung := (0, -1, -1);
            
            when 6 =>
               Änderung := (0, -1, 1);
            
            when 7 =>
               Änderung := (0, 1, -1);

            when 8 =>
               Änderung := (0, 1, 1);

            when 9 =>
               Änderung := (1, 0, 0);
               
            when 10 =>
               Änderung := (-1, 0, 0);
            
            when others =>
               return;
         end case;

         KartenWert := KartenPruefungen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition,
                                                                 ÄnderungExtern       => Änderung,
                                                                 ZusatzYAbstandExtern => 0);
         
         case
           KartenWert.YAchse
         is               
            when 0 =>
               Bewegung := GlobaleDatentypen.Leer;
               
            when others =>
               Bewegung := BewegungPassierbarkeitPruefen.FeldFürDieseEinheitPassierbarNeu (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                                                            NeuePositionExtern       => (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse));
         end case;

         case
           Bewegung
         is
            when GlobaleDatentypen.Beladen_Bewegung_Möglich =>
               BewegungLadenEntladen.TransporterBeladen (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                         ÄnderungExtern           => Änderung);
               return;
               
            when others =>
               Blockiert := BewegungBlockiert.BlockiertStadtEinheit (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                                     NeuePositionExtern       => (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse));
         end case;

         if
           (Bewegung = GlobaleDatentypen.Normale_Bewegung_Möglich
            or
              Bewegung = GlobaleDatentypen.Transporter_Stadt_Möglich)
           and
             Blockiert = GlobaleDatentypen.Normale_Bewegung_Möglich
         then
            BewegungEinheitenBerechnung (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                         NeuePositionExtern       => (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse));
               
         elsif
           (Bewegung = GlobaleDatentypen.Normale_Bewegung_Möglich
            or
              Bewegung = GlobaleDatentypen.Transporter_Stadt_Möglich)
           and
             Blockiert = GlobaleDatentypen.Gegner_Blockiert
         then
            GegnerWert := EinheitSuchen.KoordinatenEinheitOhneSpezielleRasseSuchen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                                                                    KoordinatenExtern => (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse));
            Diplomatie.GegnerAngreifenOderNicht (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                 GegnerExtern             => GegnerWert);
            if
              GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleLebenspunkte <= 0
            then
               return;
               
            else
               BewegungEinheitenBerechnung (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                            NeuePositionExtern       => (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse));
            end if;
              
         else
            null;
         end if;

         if
           GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte <= 0.00
         then
            return;
            
         else
            Karte.AnzeigeKarte (RasseExtern => EinheitRasseNummerExtern.Rasse);
         end if;
         
      end loop BewegenSchleife;
      
   end BewegungEinheitenRichtung;

   

   procedure BewegungEinheitenBerechnung
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      NeuePositionExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
   is begin

      case
        StraßeUndFlussPrüfen (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                NeuePositionExtern       => NeuePositionExtern)
      is
         when 1 | 2 =>
            BewegungspunkteModifikator := 0.50;
            
         when 10 | 11 =>
            BewegungspunkteModifikator := 1.00;

         when others =>
            BewegungspunkteModifikator := 0.00;
      end case;

      case
        Karten.Weltkarte (NeuePositionExtern.EAchse, NeuePositionExtern.YAchse, NeuePositionExtern.XAchse).Grund
      is
         when  1 | 7 | 9 | 32 =>
            if
              GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte < 1.00
            then
               GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte := 0.00;
               return;
               
            else                     
               GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte
                 := GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte - 2.00 + BewegungspunkteModifikator;
            end if;
               
         when others =>
            GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte
              := GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte - 1.00 + BewegungspunkteModifikator;
      end case;

      if
        GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte < 0.00
      then
         GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AktuelleBewegungspunkte := 0.00;
         -- Hier nicht return, da Bewegung zwar erfolgreich aber jetzt noch die Rechnungen durchlaufen müssen.
                  
      else
         null;
      end if;

      if
        EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).KannTransportieren = 0
      then
         null;
         
      elsif
        StadtSuchen.KoordinatenStadtMitRasseSuchen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                                    KoordinatenExtern => NeuePositionExtern) = GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch
      then
         BewegungLadenEntladen.TransporterladungVerschieben (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                             NeuePositionExtern       => NeuePositionExtern);

      else
         BewegungLadenEntladen.TransporterStadtEntladen (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                                         NeuePositionExtern       => NeuePositionExtern);
      end if;

      case
        GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).WirdTransportiert
      is
         when 0 =>
            null;
            
         when others =>
            BewegungLadenEntladen.EinheitAusTransporterEntfernen (EinheitRasseNummerExtern  => EinheitRasseNummerExtern,
                                                                  AuszuladendeEinheitExtern => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).WirdTransportiert);
            GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).WirdTransportiert := 0;
      end case;
      
      case
        GlobaleVariablen.RassenImSpiel (EinheitRasseNummerExtern.Rasse)
      is
         when 2 =>
            null;
            
         when others =>            
            GlobaleVariablen.CursorImSpiel (EinheitRasseNummerExtern.Rasse).AchsenPosition := NeuePositionExtern;
      end case;      
      
      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition := NeuePositionExtern;
      Sichtbarkeit.SichtbarkeitsprüfungFürEinheit (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
      
      KontaktSchleife:
      for FremdeSichtbarkeitSchleifenwert in GlobaleDatentypen.RassenImSpielArray'Range loop
         
         if
           FremdeSichtbarkeitSchleifenwert = EinheitRasseNummerExtern.Rasse
           or
             GlobaleVariablen.RassenImSpiel (FremdeSichtbarkeitSchleifenwert) = 0
         then
            null;
            
         elsif
           Karten.Weltkarte (NeuePositionExtern.EAchse, NeuePositionExtern.YAchse, NeuePositionExtern.XAchse).Sichtbar (FremdeSichtbarkeitSchleifenwert) = True
         then
            Diplomatie.Erstkontakt (EigeneRasseExtern => EinheitRasseNummerExtern.Rasse,
                                    FremdeRasseExtern => FremdeSichtbarkeitSchleifenwert);
            
         else
            null;
         end if;
         
      end loop KontaktSchleife;
      
   end BewegungEinheitenBerechnung;



   function StraßeUndFlussPrüfen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      NeuePositionExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return Integer
   is begin

      if
        EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (1) = True
        and
          EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (3) = False
      then
         BonusBeiBewegung := 0;

         case
           Karten.Weltkarte (NeuePositionExtern.EAchse, NeuePositionExtern.YAchse, NeuePositionExtern.XAchse).VerbesserungStraße
         is
            when 5 .. 19 =>
               BonusBeiBewegung := BonusBeiBewegung + 1;

            when 20 .. VerbesserungenDatenbank.VerbesserungListe'Last =>
               BonusBeiBewegung := BonusBeiBewegung + 10;
                  
            when others =>
               null;
         end case;               

         case
           Karten.Weltkarte (NeuePositionExtern.EAchse, NeuePositionExtern.YAchse, NeuePositionExtern.XAchse).Fluss
         is
            when 0 =>
               null;

            when others =>
               BonusBeiBewegung := BonusBeiBewegung + 1;
         end case;
            
         return BonusBeiBewegung;

      else
         return 0;
      end if;
      
   end StraßeUndFlussPrüfen;

end BewegungssystemEinheiten;