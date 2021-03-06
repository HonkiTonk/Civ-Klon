pragma SPARK_Mode (On);

with GlobaleKonstanten;

with ZufallGeneratorenKarten, KartePositionPruefen;

package body KartenGeneratorStandard is

   procedure StandardKarte
   is begin
      
      case
        Karten.Kartenart
      is
         when GlobaleDatentypen.Nur_Land =>
            GenerierungNurLand;
            return;
            
         when others =>
            -- Zu beachten, diese Werte sind nur dazu da um belegte Felder zu ermitteln. Nicht später durch die Zuweisungen weiter unten verwirren lassen!
            Karten.GeneratorKarte := (others => (others => (GlobaleDatentypen.Leer)));
      end case;
      
      EisSchleife:
      for EisSchleifenwert in Karten.WeltkarteArray'First (3) .. Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße loop
         
         Karten.Weltkarte (0, 1, EisSchleifenwert).Grund := GlobaleDatentypen.Eis;
         Karten.Weltkarte (0, Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße, EisSchleifenwert).Grund := GlobaleDatentypen.Eis;
         
      end loop EisSchleife;
      
      YAchseSchleife:
      for YAchseSchleifenwert in Karten.WeltkarteArray'First (2) + GlobaleKonstanten.Eisrand .. Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße - GlobaleKonstanten.Eisrand loop
         XAchseSchleife:
         for XAchseSchleifenwert in Karten.WeltkarteArray'First (3) .. Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße loop
               
            if
              Karten.Weltkarte (0, YAchseSchleifenwert, XAchseSchleifenwert).Grund = GlobaleDatentypen.Leer
              and
                Karten.Kartenart = GlobaleDatentypen.Nur_Land
            then
               Karten.Weltkarte (0, YAchseSchleifenwert, XAchseSchleifenwert).Grund := GlobaleDatentypen.Flachland;

            elsif
              Karten.Weltkarte (0, YAchseSchleifenwert, XAchseSchleifenwert).Grund = GlobaleDatentypen.Leer
            then
               Karten.Weltkarte (0, YAchseSchleifenwert, XAchseSchleifenwert).Grund := GlobaleDatentypen.Wasser;

            else
               null;
            end if;
            
            case Karten.Kartenart is
               when GlobaleDatentypen.Pangäa =>
                  GenerierungPangäa (YAchseExtern => YAchseSchleifenwert,
                                      XAchseExtern => XAchseSchleifenwert);
                  
               when others =>                     
                  GenerierungKartenart (YAchseExtern => YAchseSchleifenwert,
                                        XAchseExtern => XAchseSchleifenwert);
            end case;
            
         end loop XAchseSchleife;
      end loop YAchseSchleife;
      
   end StandardKarte;



   procedure GenerierungKartenart
     (YAchseExtern, XAchseExtern : in GlobaleDatentypen.KartenfeldPositiv)
   is begin

      BeliebigerLandwert := ZufallGeneratorenKarten.ZufälligerWert;

      case
        Karten.GeneratorKarte (YAchseExtern, XAchseExtern)
      is
         when GlobaleDatentypen.Eis | GlobaleDatentypen.Wasser =>
            null;

         when GlobaleDatentypen.Leer =>
            if
              YAchseExtern <= Karten.WeltkarteArray'First (2) + GlobaleKonstanten.Eisschild
              or
                YAchseExtern >= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße - GlobaleKonstanten.Eisschild
            then
               if
                 BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Landmasse_Eisschild)
               then
                  Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
                  GenerierungLandmasse (YPositionLandmasseExtern => YAchseExtern,
                                        XPositionLandmasseExtern => XAchseExtern);
                  
               elsif
                 BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Land_Eisschild)
               then
                  Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
                           
               else
                  null;
               end if;
                              
            else
               if
                 BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Landmasse_Normal)
               then
                  Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
                  GenerierungLandmasse (YPositionLandmasseExtern => YAchseExtern,
                                        XPositionLandmasseExtern => XAchseExtern);
                  
               elsif
                 BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Land_Normal)
               then
                  Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
                  
               else
                  null;
               end if;
            end if;

         when others =>
            if
              BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Land_Sonstiges)
            then                           
               Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
               
            else
               null;
            end if;
      end case;
      
   end GenerierungKartenart;

   
   
   procedure GenerierungLandmasse
     (YPositionLandmasseExtern, XPositionLandmasseExtern : in GlobaleDatentypen.KartenfeldPositiv)
   is begin
      
      YAchseLandflächeErzeugenSchleife:
      for YÄnderungEinsSchleifenwert in -Karten.GrößeLandart (Karten.Kartenart) / 2 .. Karten.GrößeLandart (Karten.Kartenart) / 2 loop
         XAchseLandflächeErzeugenSchleife:
         for XÄnderungEinsSchleifenwert in -Karten.GrößeLandart (Karten.Kartenart) / 2 .. Karten.GrößeLandart (Karten.Kartenart) / 2 loop
            
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern    => (0, YPositionLandmasseExtern, XPositionLandmasseExtern),
                                                                        ÄnderungExtern       => (0, YÄnderungEinsSchleifenwert, XÄnderungEinsSchleifenwert));

            if
              KartenWert.YAchse <= Karten.WeltkarteArray'First (2)
              or
                KartenWert.YAchse = Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            then
               null;
               
            else
               GenerierungLandmasseFläche (YAchseExtern  => KartenWert.YAchse,
                                            XAchseExtern  => KartenWert.XAchse);
            end if;
            
         end loop XAchseLandflächeErzeugenSchleife;
      end loop YAchseLandflächeErzeugenSchleife;
      
      -- Funktioniert nicht mit Kontinenten bei kleinen Karten weil der Abstandswert zu groß ist! An Kartengrößen angepasste Werte anlegen, wie bei der Kartenanzeige.
      YAchseAbstandFlächenSchleife:
      for YÄnderungZweiSchleifenwert in -FelderVonLandartZuLandart (Karten.Kartenart) .. FelderVonLandartZuLandart (Karten.Kartenart) loop
         XAchseAbstandFlächenSchleife:
         for XÄnderungZweiSchleifenwert in -FelderVonLandartZuLandart (Karten.Kartenart) .. FelderVonLandartZuLandart (Karten.Kartenart) loop
            
            KartenWert := KartePositionPruefen.KartenPositionBestimmen (KoordinatenExtern => (0, YPositionLandmasseExtern, XPositionLandmasseExtern),
                                                                        ÄnderungExtern    => (0, YÄnderungZweiSchleifenwert, XÄnderungZweiSchleifenwert));
            
            if
              KartenWert.XAchse = 0
            then
               null;
               
            elsif
              Karten.GeneratorKarte (KartenWert.YAchse, KartenWert.XAchse) = GlobaleDatentypen.Eis
              or
                Karten.GeneratorKarte (KartenWert.YAchse, KartenWert.XAchse) = GlobaleDatentypen.Wasser
            then
               null;
                  
            else
               Karten.GeneratorKarte (KartenWert.YAchse, KartenWert.XAchse) := GlobaleDatentypen.Flachland;  
            end if;
            
         end loop XAchseAbstandFlächenSchleife;
      end loop YAchseAbstandFlächenSchleife; 
      
   end GenerierungLandmasse;
   
   
   
   procedure GenerierungLandmasseFläche
     (YAchseExtern, XAchseExtern : in GlobaleDatentypen.KartenfeldPositiv)
   is begin
   
      BeliebigerLandwert := ZufallGeneratorenKarten.ZufälligerWert;
      
      if
        BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Land_Fläche_Frei)
        and
          Karten.GeneratorKarte (YAchseExtern, XAchseExtern) = GlobaleDatentypen.Leer
      then
         Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
         Karten.GeneratorKarte (YAchseExtern, XAchseExtern) := Eis;

      elsif
        BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Land_Fläche_Belegt)
      then
         Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
         Karten.GeneratorKarte (YAchseExtern, XAchseExtern) := GlobaleDatentypen.Eis;
               
      else
         null;
      end if;
         
      
   end GenerierungLandmasseFläche;



   procedure GenerierungPangäa
     (YAchseExtern, XAchseExtern : in GlobaleDatentypen.KartenfeldPositiv)
   is begin
      
      if
        YAchseExtern = Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße / 2
        and
          XAchseExtern = Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße / 2
      then
         GenerierungLandmasse (YPositionLandmasseExtern => YAchseExtern,
                               XPositionLandmasseExtern => XAchseExtern);
        
      else
         BeliebigerLandwert := ZufallGeneratorenKarten.ZufälligerWert;
         if
           BeliebigerLandwert >= WahrscheinlichkeitenFürLand (Karten.Kartenart, Land_Sonstiges)
         then
            Karten.Weltkarte (0, YAchseExtern, XAchseExtern).Grund := GlobaleDatentypen.Flachland;
            Karten.GeneratorKarte (YAchseExtern, XAchseExtern) := GlobaleDatentypen.Eis;
         
         else
            null;
         end if;
      end if;
      
   end GenerierungPangäa;
   
   
   
   procedure GenerierungNurLand
   is begin
      
      EisSchleife:
      for EisSchleifenwert in Karten.WeltkarteArray'First (3) .. Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße loop
         
         Karten.Weltkarte (0, 1, EisSchleifenwert).Grund := GlobaleDatentypen.Eis;
         Karten.Weltkarte (0, Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße, EisSchleifenwert).Grund := GlobaleDatentypen.Eis;
         
      end loop EisSchleife;
      
      YAchseSchleife:
      for YAchseSchleifenwert in Karten.WeltkarteArray'First (2) + GlobaleKonstanten.Eisrand .. Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße - GlobaleKonstanten.Eisrand loop
         XAchseSchleife:
         for XAchseSchleifenwert in Karten.WeltkarteArray'First (3) .. Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße loop
            
            Karten.Weltkarte (0, YAchseSchleifenwert, XAchseSchleifenwert).Grund := GlobaleDatentypen.Flachland;
            
         end loop XAchseSchleife;
      end loop YAchseSchleife;
      
   end GenerierungNurLand;

end KartenGeneratorStandard;
