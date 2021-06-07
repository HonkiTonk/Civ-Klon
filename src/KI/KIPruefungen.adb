pragma SPARK_Mode (On);

with GlobaleKonstanten;

with KIKonstanten, KIDatentypen;

with KartenPruefungen, EinheitSuchen, BewegungPassierbarkeitPruefen, KIAufgabenVerteilt;

package body KIPruefungen is
   
   function StadtUmgebungPrüfen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
   is begin
      
      VerbesserungAnlegen := KIKonstanten.NullKoordinate;      
      
      StadtSchleife:
      for StadtNummerSchleifenwert in GlobaleVariablen.StadtGebautArray'Range (2) loop
         
         if
           GlobaleVariablen.StadtGebaut (EinheitRasseNummerExtern.Rasse, StadtNummerSchleifenwert).ID > 0
         then
            VerbesserungAnlegen := StadtUmgebungUnverbessert (StadtRasseNummerExtern => (EinheitRasseNummerExtern.Rasse, StadtNummerSchleifenwert),
                                                              EinheitNummerExtern    => EinheitRasseNummerExtern.Platznummer);
            
         else
            null;
         end if;
         
         case
           VerbesserungAnlegen.YAchse
         is
            when 0 =>
               null;
               
            when others =>
               return VerbesserungAnlegen;
         end case;
         
      end loop StadtSchleife;
      
      return VerbesserungAnlegen;
      
   end StadtUmgebungPrüfen;
   
   
   
   function StadtUmgebungUnverbessert
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      EinheitNummerExtern : in GlobaleDatentypen.MaximaleEinheiten)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
   is begin
      
      YAchseSchleife:
      for YÄnderungSchleifenwert in GlobaleDatentypen.LoopRangeMinusEinsZuEins'Range loop
         XAchseSchleife:
         for XÄnderungSchleifenwert in GlobaleDatentypen.LoopRangeMinusEinsZuEins'Range loop
            
            KartenWertEins := KartenPruefungen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AchsenPosition,
                                                                        ÄnderungExtern       => (0, YÄnderungSchleifenwert, XÄnderungSchleifenwert),
                                                                        ZusatzYAbstandExtern => 0);
            
            case
              KartenWertEins.YAchse
            is
               when 0 =>
                  exit XAchseSchleife;
                  
               when others =>
                  null;
            end case;
            
            EinheitAufFeld := EinheitSuchen.KoordinatenEinheitOhneRasseSuchen (KoordinatenExtern => KartenWertEins);
            
            if
              BewegungPassierbarkeitPruefen.FeldFürDieseEinheitPassierbarNeu (EinheitRasseNummerExtern => (StadtRasseNummerExtern.Rasse, EinheitNummerExtern),
                                                                               NeuePositionExtern       => KartenWertEins)
              = GlobaleDatentypen.Normale_Bewegung_Möglich
              and
                (Karten.Weltkarte (KartenWertEins.EAchse, KartenWertEins.YAchse, KartenWertEins.XAchse).VerbesserungGebiet = 0
                 or
                   Karten.Weltkarte (KartenWertEins.EAchse, KartenWertEins.YAchse, KartenWertEins.XAchse).VerbesserungStraße = 0)
                and
                  (EinheitAufFeld.Platznummer = GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch
                   or
                     EinheitAufFeld.Platznummer = EinheitNummerExtern)
              and
                Karten.Weltkarte (KartenWertEins.EAchse, KartenWertEins.YAchse, KartenWertEins.XAchse).DurchStadtBelegterGrund
            in
              GlobaleKonstanten.FeldBelegung (StadtRasseNummerExtern.Rasse, 1) .. GlobaleKonstanten.FeldBelegung (StadtRasseNummerExtern.Rasse, 2)
            then               
               case
                 KIAufgabenVerteilt.EinheitAufgabeZiel (AufgabeExtern         => KIDatentypen.Verbesserung_Anlegen,
                                                        RasseExtern           => StadtRasseNummerExtern.Rasse,
                                                        ZielKoordinatenExtern => VerbesserungAnlegen)
               is
                  when False =>
                     return KartenWertEins;
                  
                  when True =>
                     null;
               end case;
               
            else
               null;
            end if;
            
         end loop XAchseSchleife;
      end loop YAchseSchleife;
      
      return KIKonstanten.NullKoordinate;
      
   end StadtUmgebungUnverbessert;
   
   
   
   function UmgebungStadtBauenPrüfen     
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      MindestBewertungFeldExtern : in GlobaleDatentypen.GesamtproduktionStadt)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
   is begin
      
      FeldGutUndFrei := KartenfeldUmgebungPrüfen (EinheitRasseNummerExtern   => EinheitRasseNummerExtern,
                                                   KoordinatenExtern          => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition,
                                                   MindestBewertungFeldExtern => MindestBewertungFeldExtern);
      
      case
        FeldGutUndFrei
      is
         when False =>
            null;
            
         when True =>
            return KIKonstanten.NullKoordinate;
      end case;
      
      YAchseKoordinatePrüfen := 2;
      XAchseKoordinatePrüfen := 2;
      YAchseKoordinatenSchonGeprüft := YAchseKoordinatePrüfen - 1;
      XAchseKoordinatenSchonGeprüft := XAchseKoordinatePrüfen - 1;
      
      KartenfeldSuchenSchleife:
      loop
         YAchseKartenfeldSuchenSchleife:
         for YAchseSchleifenwert in -YAchseKoordinatePrüfen .. YAchseKoordinatePrüfen loop
            XAchseKartenfeldSuchenSchleife:
            for XAchseSchleifenwert in -XAchseKoordinatePrüfen .. XAchseKoordinatePrüfen loop
               
               KartenWertEins := KartenPruefungen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition,
                                                                           ÄnderungExtern       => (0, YAchseSchleifenwert, XAchseSchleifenwert),
                                                                           ZusatzYAbstandExtern => 0);
            
               case
                 KartenWertEins.YAchse
               is
                  when 0 =>
                     exit XAchseKartenfeldSuchenSchleife;
                  
                  when others =>
                     null;
               end case;
                           
               if
                 YAchseKoordinatenSchonGeprüft >= abs YAchseSchleifenwert
                 and
                   XAchseKoordinatenSchonGeprüft >= abs XAchseSchleifenwert
               then
                  FeldGutUndFrei := False;
               
               else
                  FeldGutUndFrei := KartenfeldUmgebungPrüfen (EinheitRasseNummerExtern   => EinheitRasseNummerExtern,
                                                               KoordinatenExtern          => KartenWertEins,
                                                               MindestBewertungFeldExtern => MindestBewertungFeldExtern);
               end if;
               
               case
                 FeldGutUndFrei
               is
                  when False =>
                     null;
                     
                  when True =>
                     if
                       KIAufgabenVerteilt.EinheitAufgabeZiel (AufgabeExtern         => KIDatentypen.Stadt_Bauen,
                                                              RasseExtern           => EinheitRasseNummerExtern.Rasse,
                                                              ZielKoordinatenExtern => VerbesserungAnlegen)
                       = False
                     then
                        return KartenWertEins;
                  
                     else
                        null;
                     end if;
               end case;
            
            end loop XAchseKartenfeldSuchenSchleife;
         end loop YAchseKartenfeldSuchenSchleife;
         
         if
           YAchseKoordinatePrüfen >= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
           and
             XAchseKoordinatePrüfen > Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße
         then
            exit KartenfeldSuchenSchleife;
            
         else
            null;
         end if;
         
         if
           YAchseKoordinatePrüfen < Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
         then
            YAchseKoordinatePrüfen := YAchseKoordinatePrüfen + 1;
            YAchseKoordinatenSchonGeprüft := YAchseKoordinatePrüfen - 1;
            
         else
            null;
         end if;
            
         if
           XAchseKoordinatePrüfen <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße
         then
            XAchseKoordinatePrüfen := XAchseKoordinatePrüfen + 1;
            XAchseKoordinatenSchonGeprüft := XAchseKoordinatePrüfen - 1;
            
         else
            null;
         end if;
         
      end loop KartenfeldSuchenSchleife;
      
      return GlobaleKonstanten.RückgabeKartenPositionFalsch;
      
   end UmgebungStadtBauenPrüfen;
   
   
   
   function KartenfeldUmgebungPrüfen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord;
      KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      MindestBewertungFeldExtern : in GlobaleDatentypen.GesamtproduktionStadt)
         return Boolean
   is begin
      
      EinheitAufFeld := EinheitSuchen.KoordinatenEinheitOhneRasseSuchen (KoordinatenExtern => KoordinatenExtern);
      
      if
        EinheitAufFeld.Platznummer = GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch
        or
          EinheitAufFeld = EinheitRasseNummerExtern
      then
         null;
            
      else
         return False;
      end if;
      
      case
        Karten.Weltkarte (KoordinatenExtern.EAchse, KoordinatenExtern.YAchse, KoordinatenExtern.XAchse).DurchStadtBelegterGrund
      is
         when 0 =>
            null;
            
         when others =>
            return False;
      end case;
      
      if
        Karten.Weltkarte (KoordinatenExtern.EAchse, KoordinatenExtern.YAchse, KoordinatenExtern.XAchse).Felderwertung >= MindestBewertungFeldExtern
      then
         null;
         
      else
         return False;
      end if;
      
      case
        Karten.Weltkarte (KoordinatenExtern.EAchse, KoordinatenExtern.YAchse, KoordinatenExtern.XAchse).Grund
      is
         when 1 .. 2 | 31 =>
            return False;
         
         when others =>
            null;
      end case;
      
      YAchseUmgebungSchleife:
      for YAchseUmgebungSchleifenwert in GlobaleDatentypen.LoopRangeMinusDreiZuDrei'Range loop
         XAchseUmgebungSchleife:
         for XAchseUmgebungSchleifenwert in GlobaleDatentypen.LoopRangeMinusDreiZuDrei'Range loop
            
            KartenWertZwei := KartenPruefungen.KartenPositionBestimmen (KoordinatenExtern    => KoordinatenExtern,
                                                                        ÄnderungExtern       => (0, YAchseUmgebungSchleifenwert, XAchseUmgebungSchleifenwert),
                                                                        ZusatzYAbstandExtern => 0);
            
            case
              KartenWertZwei.YAchse
            is
               when 0 =>
                  exit XAchseUmgebungSchleife;
                  
               when others =>
                  null;
            end case;
               
            if
              Karten.Weltkarte (KartenWertZwei.EAchse, KartenWertZwei.YAchse, KartenWertZwei.XAchse).DurchStadtBelegterGrund > 0
            then
               return False;
               
            else
               null;
            end if;
            
         end loop XAchseUmgebungSchleife;
      end loop YAchseUmgebungSchleife;
      
      return True;
      
   end KartenfeldUmgebungPrüfen;

end KIPruefungen;
