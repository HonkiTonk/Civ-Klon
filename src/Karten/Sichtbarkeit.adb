pragma SPARK_Mode (On);
  
with KartePositionPruefen, EinheitSuchen, StadtSuchen, Diplomatie;

package body Sichtbarkeit is

   procedure SichtbarkeitsprüfungFürRasse
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
   is begin
      
      EinheitenSchleife:
      for EinheitNummerSchleifenwert in GlobaleVariablen.EinheitenGebautArray'Range (2) loop

         case
           GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummerSchleifenwert).ID
         is
            when 0 =>
               null;
            
            when others =>
               SichtbarkeitsprüfungFürEinheit (EinheitRasseNummerExtern => (RasseExtern, EinheitNummerSchleifenwert));
         end case;
         
      end loop EinheitenSchleife;

      StädteSchleife:
      for StadtNummerSchleifenwert in GlobaleVariablen.StadtGebautArray'Range (2) loop

         case
           GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummerSchleifenwert).ID
         is
            when GlobaleDatentypen.Leer =>
               null;
               
            when others =>
               SichtbarkeitsprüfungFürStadt (StadtRasseNummerExtern => (RasseExtern, StadtNummerSchleifenwert));
         end case;
         
      end loop StädteSchleife;
      
   end SichtbarkeitsprüfungFürRasse;



   procedure SichtbarkeitsprüfungFürEinheit
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      AktuellerGrund := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position.EAchse,
                                          GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position.YAchse,
                                          GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position.XAchse).Grund;
      
      case
        AktuellerGrund
      is
         when GlobaleDatentypen.Gebirge =>
            SichtweiteObjekt := 3;

         when GlobaleDatentypen.Dschungel =>
            SichtweiteObjekt := 1;
               
         when others =>
            SichtweiteObjekt := 2;
      end case;

      YÄnderungEinheitenSchleife:
      for YÄnderungSchleifenwert in -SichtweiteObjekt .. SichtweiteObjekt loop            
         XÄnderungEinheitenSchleife:
         for XÄnderungSchleifenwert in -SichtweiteObjekt .. SichtweiteObjekt loop
            
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position,
                                                                        ÄnderungExtern      => (0, YÄnderungSchleifenwert, XÄnderungSchleifenwert));
            
            if
              KartenWert.YAchse = 0
            then
               null;
               
            elsif
              YÄnderungSchleifenwert = 0
              and
                XÄnderungSchleifenwert = 0
            then
               SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                   KoordinatenExtern => KartenWert);
              
            else
               SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                   KoordinatenExtern => KartenWert);
            end if;
            
         end loop XÄnderungEinheitenSchleife;
      end loop YÄnderungEinheitenSchleife;
      
   end SichtbarkeitsprüfungFürEinheit;



   procedure SichtbarkeitsprüfungFürStadt
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      if
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).EinwohnerArbeiter (1) < 10
      then
         SichtweiteObjekt := 2;
            
      else
         SichtweiteObjekt := 3;
      end if;

      YÄnderungStadtSchleife:         
      for YÄnderungSchleifenwert in -SichtweiteObjekt .. SichtweiteObjekt loop            
         XÄnderungStadtSchleife:
         for XÄnderungSchleifenwert in -SichtweiteObjekt .. SichtweiteObjekt loop
            
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Position,
                                                                        ÄnderungExtern      => (0, YÄnderungSchleifenwert, XÄnderungSchleifenwert));
            
            case
              KartenWert.YAchse
            is
               when 0 =>
                  null;
                  
               when others =>            
                  SichtbarkeitSetzen (RasseExtern       => StadtRasseNummerExtern.Rasse,
                                      KoordinatenExtern => KartenWert);
            end case;
                        
         end loop XÄnderungStadtSchleife;
      end loop YÄnderungStadtSchleife;
      
   end SichtbarkeitsprüfungFürStadt;
   
   
   
   procedure SichtbarkeitSetzen
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum;
      KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
   is begin      
      
      case
        Karten.Weltkarte (KoordinatenExtern.EAchse, KoordinatenExtern.YAchse, KoordinatenExtern.XAchse).Sichtbar (RasseExtern)
      is
         when True =>
            return;
            
         when False =>
            Karten.Weltkarte (KoordinatenExtern.EAchse, KoordinatenExtern.YAchse, KoordinatenExtern.XAchse).Sichtbar (RasseExtern) := True;
      end case;
      
      FremdeEinheitStadt := EinheitSuchen.KoordinatenEinheitOhneSpezielleRasseSuchen (RasseExtern       => RasseExtern,
                                                                                      KoordinatenExtern => KoordinatenExtern);
      
      case
        FremdeEinheitStadt.Rasse
      is
         when GlobaleDatentypen.Leer =>
            null;
            
         when others =>
            Diplomatie.Erstkontakt (EigeneRasseExtern => RasseExtern,
                                    FremdeRasseExtern => FremdeEinheitStadt.Rasse);
            return;
      end case;
      
      FremdeEinheitStadt := StadtSuchen.KoordinatenStadtOhneSpezielleRasseSuchen (RasseExtern       => RasseExtern,
                                                                                  KoordinatenExtern => KoordinatenExtern);
      
      case
        FremdeEinheitStadt.Rasse
      is
         when GlobaleDatentypen.Leer =>
            null;
            
         when others =>
            Diplomatie.Erstkontakt (EigeneRasseExtern => RasseExtern,
                                    FremdeRasseExtern => FremdeEinheitStadt.Rasse);
      end case;
      
   end SichtbarkeitSetzen;

end Sichtbarkeit;
