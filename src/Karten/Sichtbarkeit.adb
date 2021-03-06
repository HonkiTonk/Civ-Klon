pragma SPARK_Mode (On);

with EinheitenDatenbank;
  
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
      
      if
        EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse,
                                           GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (GlobaleDatentypen.Luft) = True
        or
          EinheitenDatenbank.EinheitenListe (EinheitRasseNummerExtern.Rasse,
                                             GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).ID).Passierbarkeit (GlobaleDatentypen.Weltraum) = True
      then
         SichtbarkeitsprüfungOhneBlockade (EinheitRasseNummerExtern => EinheitRasseNummerExtern);
         return;
         
      else
         null;
      end if;
      
      KoordinatenEinheit := GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position;
      
      case
        Karten.Weltkarte (KoordinatenEinheit.EAchse, KoordinatenEinheit.YAchse, KoordinatenEinheit.XAchse).Grund
      is
         when GlobaleDatentypen.Gebirge =>
            SichtweiteObjekt := 3;

         when GlobaleDatentypen.Dschungel =>
            SichtweiteObjekt := 1;
               
         when others =>
            SichtweiteObjekt := 2;
      end case;

      YQuadrantEinsSchleife:
      for YQuadrantEinsSchleifenwert in 0 .. SichtweiteObjekt loop
         XQuadrantEinsSchleife:
         for XQuadrantEinsSchleifenwert in 0 .. SichtweiteObjekt loop
        
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern => KoordinatenEinheit,
                                                                        ÄnderungExtern    => (0, -YQuadrantEinsSchleifenwert, XQuadrantEinsSchleifenwert));
            
            if
              KartenWert.XAchse = 0
            then
               null;
               
            elsif
              YQuadrantEinsSchleifenwert <= 1
              and
                XQuadrantEinsSchleifenwert <= 1
            then
               SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                   KoordinatenExtern => KartenWert);
               
            elsif
              YQuadrantEinsSchleifenwert in 2 .. 3
              and
                XQuadrantEinsSchleifenwert <= 1
            then
               YÄnderungSchleife:
               for YÄnderungSchleifenwert in 2 .. YQuadrantEinsSchleifenwert loop
                  XÄnderungSchleife:
                  for XÄnderungSchleifenwert in 0 .. XQuadrantEinsSchleifenwert loop
                    
                     SichtbarkeitTesten := SichtbarkeitBlockadeTesten (KoordinatenExtern => KartenWert,
                                                                       YÄnderungExtern   => YÄnderungSchleifenwert - 1,
                                                                       XÄnderungExtern   => -XÄnderungSchleifenwert,
                                                                       SichtweiteExtern  => SichtweiteObjekt);
                     
                     if
                       SichtbarkeitTesten = False
                     then
                        exit YÄnderungSchleife;
                        
                     elsif
                       YÄnderungSchleifenwert = YQuadrantEinsSchleifenwert
                       and
                         XÄnderungSchleifenwert = XQuadrantEinsSchleifenwert
                     then
                        SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                            KoordinatenExtern => KartenWert);
                        
                     else
                        null;
                     end if;
                     
                  end loop XÄnderungSchleife;
               end loop YÄnderungSchleife;
               
            elsif
              YQuadrantEinsSchleifenwert <= 1
              and
                XQuadrantEinsSchleifenwert in 2 .. 3
            then
               YÄnderungSchleife22:
               for YÄnderungSchleifenwert in 0 .. YQuadrantEinsSchleifenwert loop
                  XÄnderungSchleife22:
                  for XÄnderungSchleifenwert in 2 .. XQuadrantEinsSchleifenwert loop
               
                     SichtbarkeitTesten := SichtbarkeitBlockadeTesten (KoordinatenExtern => KartenWert,
                                                                       YÄnderungExtern   => YÄnderungSchleifenwert,
                                                                       XÄnderungExtern   => -(XÄnderungSchleifenwert - 1),
                                                                       SichtweiteExtern  => SichtweiteObjekt);
                  
                     if
                       SichtbarkeitTesten = False
                     then
                        exit YÄnderungSchleife22;
                        
                     elsif
                       YÄnderungSchleifenwert = YQuadrantEinsSchleifenwert
                       and
                         XÄnderungSchleifenwert = XQuadrantEinsSchleifenwert
                     then
                        SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                            KoordinatenExtern => KartenWert);
                        
                     else
                        null;
                     end if;
                     
                  end loop XÄnderungSchleife22;
               end loop YÄnderungSchleife22;
               
            else
               YÄnderungSchleife7:
               for YÄnderungSchleifenwert in 2 .. YQuadrantEinsSchleifenwert loop
                  XÄnderungSchleife7:
                  for XÄnderungSchleifenwert in 2 .. XQuadrantEinsSchleifenwert loop
                     
                     SichtbarkeitTesten := SichtbarkeitBlockadeTesten (KoordinatenExtern => KartenWert,
                                                                       YÄnderungExtern   => YÄnderungSchleifenwert - 1,
                                                                       XÄnderungExtern   => -(XÄnderungSchleifenwert - 1),
                                                                       SichtweiteExtern  => SichtweiteObjekt);
                  
                     if
                       SichtbarkeitTesten = False
                     then
                        exit YÄnderungSchleife7;
                        
                     elsif
                       YÄnderungSchleifenwert = YQuadrantEinsSchleifenwert
                       and
                         XÄnderungSchleifenwert = XQuadrantEinsSchleifenwert
                     then
                        SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                            KoordinatenExtern => KartenWert);
                        
                     else
                        null;
                     end if;
                     
                  end loop XÄnderungSchleife7;
               end loop YÄnderungSchleife7;
            end if;            
            
         end loop XQuadrantEinsSchleife;
      end loop YQuadrantEinsSchleife;
      
   end SichtbarkeitsprüfungFürEinheit;
   
   
   
   procedure SichtbarkeitsprüfungFürEinheitNeu
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      KoordinatenEinheit := GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position;
      
      case
        Karten.Weltkarte (KoordinatenEinheit.EAchse, KoordinatenEinheit.YAchse, KoordinatenEinheit.XAchse).Grund
      is
         when GlobaleDatentypen.Gebirge =>
            SichtweiteObjekt := 3;

         when GlobaleDatentypen.Dschungel =>
            SichtweiteObjekt := 1;
               
         when others =>
            SichtweiteObjekt := 2;
      end case;

      YQuadrantEinsSchleife:
      for YQuadrantEinsSchleifenwert in 0 .. SichtweiteObjekt loop
         XQuadrantEinsSchleife:
         for XQuadrantEinsSchleifenwert in 0 .. SichtweiteObjekt loop
        
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern => KoordinatenEinheit,
                                                                        ÄnderungExtern    => (0, -YQuadrantEinsSchleifenwert, XQuadrantEinsSchleifenwert));
            
            if
              KartenWert.XAchse = 0
            then
               null;
               
            elsif
              YQuadrantEinsSchleifenwert <= 1
              and
                XQuadrantEinsSchleifenwert <= 1
            then
               SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                   KoordinatenExtern => KartenWert);
               
            elsif
              YQuadrantEinsSchleifenwert in 2 .. 3
              and
                XQuadrantEinsSchleifenwert <= 1
            then
               YÄnderungSchleife:
               for YÄnderungSchleifenwert in 2 .. YQuadrantEinsSchleifenwert loop
                  XÄnderungSchleife:
                  for XÄnderungSchleifenwert in 0 .. XQuadrantEinsSchleifenwert loop
                    
                     SichtbarkeitTesten := SichtbarkeitBlockadeTesten (KoordinatenExtern => KartenWert,
                                                                       YÄnderungExtern   => YÄnderungSchleifenwert - 1,
                                                                       XÄnderungExtern   => -XÄnderungSchleifenwert,
                                                                       SichtweiteExtern  => SichtweiteObjekt);
                     
                     if
                       SichtbarkeitTesten = False
                     then
                        exit YÄnderungSchleife;
                        
                     elsif
                       YÄnderungSchleifenwert = YQuadrantEinsSchleifenwert
                       and
                         XÄnderungSchleifenwert = XQuadrantEinsSchleifenwert
                     then
                        SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                            KoordinatenExtern => KartenWert);
                        
                     else
                        null;
                     end if;
                     
                  end loop XÄnderungSchleife;
               end loop YÄnderungSchleife;
               
            elsif
              YQuadrantEinsSchleifenwert <= 1
              and
                XQuadrantEinsSchleifenwert in 2 .. 3
            then
               YÄnderungSchleife22:
               for YÄnderungSchleifenwert in 0 .. YQuadrantEinsSchleifenwert loop
                  XÄnderungSchleife22:
                  for XÄnderungSchleifenwert in 2 .. XQuadrantEinsSchleifenwert loop
               
                     SichtbarkeitTesten := SichtbarkeitBlockadeTesten (KoordinatenExtern => KartenWert,
                                                                       YÄnderungExtern   => YÄnderungSchleifenwert,
                                                                       XÄnderungExtern   => -(XÄnderungSchleifenwert - 1),
                                                                       SichtweiteExtern  => SichtweiteObjekt);
                  
                     if
                       SichtbarkeitTesten = False
                     then
                        exit YÄnderungSchleife22;
                        
                     elsif
                       YÄnderungSchleifenwert = YQuadrantEinsSchleifenwert
                       and
                         XÄnderungSchleifenwert = XQuadrantEinsSchleifenwert
                     then
                        SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                            KoordinatenExtern => KartenWert);
                        
                     else
                        null;
                     end if;
                     
                  end loop XÄnderungSchleife22;
               end loop YÄnderungSchleife22;
               
            else
               YÄnderungSchleife7:
               for YÄnderungSchleifenwert in 2 .. YQuadrantEinsSchleifenwert loop
                  XÄnderungSchleife7:
                  for XÄnderungSchleifenwert in 2 .. XQuadrantEinsSchleifenwert loop
                     
                     SichtbarkeitTesten := SichtbarkeitBlockadeTesten (KoordinatenExtern => KartenWert,
                                                                       YÄnderungExtern   => YÄnderungSchleifenwert - 1,
                                                                       XÄnderungExtern   => -(XÄnderungSchleifenwert - 1),
                                                                       SichtweiteExtern  => SichtweiteObjekt);
                  
                     if
                       SichtbarkeitTesten = False
                     then
                        exit YÄnderungSchleife7;
                        
                     elsif
                       YÄnderungSchleifenwert = YQuadrantEinsSchleifenwert
                       and
                         XÄnderungSchleifenwert = XQuadrantEinsSchleifenwert
                     then
                        SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                            KoordinatenExtern => KartenWert);
                        
                     else
                        null;
                     end if;
                     
                  end loop XÄnderungSchleife7;
               end loop YÄnderungSchleife7;
            end if;            
            
         end loop XQuadrantEinsSchleife;
      end loop YQuadrantEinsSchleife;
      
   end SichtbarkeitsprüfungFürEinheitNeu;
   
   
   
   function SichtbarkeitBlockadeTesten
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      YÄnderungExtern, XÄnderungExtern : in GlobaleDatentypen.LoopRangeMinusZweiZuZwei;
      SichtweiteExtern : in GlobaleDatentypen.LoopRangeMinusDreiZuDrei)
      return Boolean
   is begin
      
      KartenWertZwei := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern => KoordinatenExtern,
                                                                      ÄnderungExtern    => (0, YÄnderungExtern, XÄnderungExtern));
      if
        KartenWertZwei.XAchse = 0
      then
         null;
         
      elsif
        Karten.Weltkarte (KartenWertZwei.EAchse, KartenWertZwei.YAchse, KartenWertZwei.XAchse).Grund = GlobaleDatentypen.Gebirge
        or
          (Karten.Weltkarte (KartenWertZwei.EAchse, KartenWertZwei.YAchse, KartenWertZwei.XAchse).Grund = GlobaleDatentypen.Dschungel
           and
             SichtweiteExtern /= 3)
      then
         return False;
         
      else
         null;
      end if;
      
      return True;
      
   end SichtbarkeitBlockadeTesten;
   
   
   
   procedure SichtbarkeitsprüfungOhneBlockade
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
         
      SichtweiteObjekt := 3;

      YÄnderungEinheitenSchleife:
      for YÄnderungSchleifenwert in -SichtweiteObjekt .. SichtweiteObjekt loop            
         XÄnderungEinheitenSchleife:
         for XÄnderungSchleifenwert in -SichtweiteObjekt .. SichtweiteObjekt loop
            
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).Position,
                                                                        ÄnderungExtern    => (0, YÄnderungSchleifenwert, XÄnderungSchleifenwert));
            
            case
              KartenWert.YAchse
            is
               when 0 =>
                  null;
                  
               when others =>            
                  SichtbarkeitSetzen (RasseExtern       => EinheitRasseNummerExtern.Rasse,
                                      KoordinatenExtern => KartenWert);
            end case;
            
         end loop XÄnderungEinheitenSchleife;
      end loop YÄnderungEinheitenSchleife;
      
   end SichtbarkeitsprüfungOhneBlockade;



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
