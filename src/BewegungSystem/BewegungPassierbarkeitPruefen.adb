pragma SPARK_Mode (On);

with GlobaleKonstanten;

with EinheitenDatenbank, KartenDatenbank;

with EinheitSuchen, StadtSuchen;

package body BewegungPassierbarkeitPruefen is
   
   -- 1 = Boden, 2 = Wasser, 3 = Luft, 4 = Weltraum, 5 = Unterwasser, 6 = Unterirdisch, 7 = Planeteninneres
   function FeldFürDieseEinheitPassierbarNeu
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      NeuePositionExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return GlobaleDatentypen.Bewegung_Enum
   is begin

      case
        EinfachePassierbarkeitPrüfen (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                       NeuePositionExtern       => NeuePositionExtern)
      is
         when True =>
            return GlobaleDatentypen.Normale_Bewegung_Möglich;
            
         when False =>
            null;
      end case;
      
      BewegungMöglich := GlobaleDatentypen.Leer;
      
      PassierbarSchleife:
      for PassierbarkeitSchleifenwert in GlobaleDatentypen.PassierbarkeitType'Range loop
         if
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (1) = True
           and
             PassierbarkeitSchleifenwert = 1
         then
            BewegungMöglich := Boden (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                       NeuePositionExtern       => NeuePositionExtern);

         elsif
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (2) = True
           and
             PassierbarkeitSchleifenwert = 2
         then
            BewegungMöglich := Wasser (EinheitRasseNummerExtern => EinheitRasseNummerExtern,
                                        NeuePositionExtern       => NeuePositionExtern);
         
         elsif
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (3) = True
           and
             PassierbarkeitSchleifenwert = 3
         then
            null;
         
         elsif
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (4) = True
           and
             PassierbarkeitSchleifenwert = 4
         then
            null;
         
         elsif
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (5) = True
           and
             PassierbarkeitSchleifenwert = 5
         then
            null;
         
         elsif
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (6) = True
           and
             PassierbarkeitSchleifenwert = 6
         then
            null;
         
         elsif
           EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (7) = True
           and
             PassierbarkeitSchleifenwert = 7
         then
            null;
         
         else
            null; -- Nicht für eine Passierbarkeit nutzen, da sonst bei einer Änderung immer alles im else angepasst werden muss!
         end if;

         case
           BewegungMöglich
         is
            when GlobaleDatentypen.Leer | GlobaleDatentypen.Keine_Bewegung_Möglich =>
               null;
               
            when others =>
               return BewegungMöglich;
         end case;

      end loop PassierbarSchleife;
      
      return GlobaleDatentypen.Keine_Bewegung_Möglich;

   end FeldFürDieseEinheitPassierbarNeu;
   
   
   
   function EinfachePassierbarkeitPrüfen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      NeuePositionExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return Boolean
   is begin
      
      PassierbarkeitNummer := KartenDatenbank.KartenListe (Karten.Weltkarte (NeuePositionExtern.EAchse, NeuePositionExtern.YAchse, NeuePositionExtern.XAchse).Grund).Passierbarkeit;
      
      return EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse,
                                                GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (PassierbarkeitNummer);
      
   end EinfachePassierbarkeitPrüfen;


   function Boden
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      NeuePositionExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return GlobaleDatentypen.Bewegung_Enum
   is begin
      
      TransporterNummer := EinheitSuchen.KoordinatenTransporterMitRasseSuchen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                                                               KoordinatenExtern => NeuePositionExtern);

      case
        TransporterNummer
      is
         when GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch =>
            return GlobaleDatentypen.Keine_Bewegung_Möglich;
               
         when others =>
            null;
      end case;

      if
        EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).KannTransportiertWerden > 0
        and
          EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).KannTransportiertWerden 
            <= EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, TransporterNummer).ID).KannTransportieren
      then
         Transportplatz := 0;
         FreierPlatzSchleife:
         for FreierPlatzSchleifenwert in GlobaleRecords.TransporterArray'Range loop
                        
            case
              GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, TransporterNummer).Transportiert (FreierPlatzSchleifenwert)
            is
               when 0 =>
                  Transportplatz := FreierPlatzSchleifenwert;
                  exit FreierPlatzSchleife;
                              
               when others =>
                  null;
            end case;
                        
         end loop FreierPlatzSchleife;

         case
           Transportplatz
         is
            when 0 =>
               return GlobaleDatentypen.Keine_Bewegung_Möglich;
                           
            when others =>
               return Beladen_Bewegung_Möglich;
         end case;

      else
         return GlobaleDatentypen.Keine_Bewegung_Möglich;
      end if;
      
   end Boden;



   function Wasser
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      NeuePositionExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return
     GlobaleDatentypen.Bewegung_Enum
   is begin
         
      case
        StadtSuchen.KoordinatenStadtMitRasseSuchen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                                    KoordinatenExtern => NeuePositionExtern)
      is
         when GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch =>
            return GlobaleDatentypen.Keine_Bewegung_Möglich;
               
         when others =>
            null;
      end case;

      if
        EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).KannTransportieren /= 0
      then
         Transportplatz := 0;
         BelegterPlatzSchleife:
         for
           BelegterPlatzSchleifenwert
         in
           GlobaleRecords.TransporterArray'Range
         loop
                        
            case
              GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Transportiert (BelegterPlatzSchleifenwert)
            is
               when 0 =>
                  null;
                              
               when others =>
                  Transportplatz := 1;
                  exit BelegterPlatzSchleife;
            end case;
                
         end loop BelegterPlatzSchleife;

         case
           Transportplatz
         is
            when 0 =>
               return GlobaleDatentypen.Transporter_Stadt_Möglich;
                          
            when others =>
               return GlobaleDatentypen.Keine_Bewegung_Möglich;
         end case;

      else
         return GlobaleDatentypen.Normale_Bewegung_Möglich;
      end if;

   end Wasser;

end BewegungPassierbarkeitPruefen;
