package body SpielEinstellungen is

   function SpielEinstellungen return Integer is
   begin

      Wahl := 1;

      AuswahlSchleife:
      loop

         case Wahl is
            when 1 =>
               Wahl := KartengrößeWählen;

            when 2 =>
               Wahl := KartenartWählen;

            when 3 =>            
               Wahl := KartentemperaturWählen;
               
            when 4 =>
               Wahl := SpieleranzahlWählen;

            when 5 =>
               Wahl := RasseWählen;

            when 6 =>
               exit AuswahlSchleife;

            when 0 =>
               return 0;
               
            when -1 =>
               return -1;

            when others =>
               Put_Line (Item => "SpielEinstellungen.SpielEinstellungen, when others =>");
               return 0;
         end case;

      end loop AuswahlSchleife;

      KartenGenerator.KartenGenerator;
      StartwerteErmitteln;
         
      return ImSpiel.ImSpiel;
              
   end SpielEinstellungen;



   function KartengrößeWählen return Integer is
   begin
      
      KartengrößeSchleife:
      loop
         
         Wahl := Auswahl.Auswahl (WelcheAuswahl => 1, WelcherText => 2);
         
         case Wahl is
            when 1 .. 9 =>
               Karten.Kartengröße := Wahl;
               return 2;
               
            when 10 =>
               ZufälligeKartengrößeWählen.Reset (ZufälligeKartenGrößeGewählt);
               Karten.Kartengröße := ZufälligeKartengrößeWählen.Random (ZufälligeKartengrößeGewählt);
               return 2;
               
            when 0 =>
               return 0;
               
            when -1 =>
               return -1;
               
            when others =>
               null;
         end case;

         Put (Item => CSI & "2J" & CSI & "H");
                  
      end loop KartengrößeSchleife;
      
   end KartengrößeWählen;



   function KartenartWählen return Integer is
   begin
            
      KartenartSchleife:
      loop

         Wahl := Auswahl.Auswahl (WelcheAuswahl => 2, WelcherText => 3);
                  
         case Wahl is
            when 1 .. 3 =>
               KartenGenerator.Kartenart := Wahl;
               return 3;
               
            when 6 =>
               ZufälligeKartenartWählen.Reset (ZufälligeKartenartGewählt);
               KartenGenerator.Kartenart := ZufälligeKartenartWählen.Random (ZufälligeKartenartGewählt);
               return 3;
               
            when -2 =>
               return 1;
               
            when 0 =>
               return 0;
               
            when -1 =>
               return -1;
               
            when others =>
               null;
         end case;

         Put (Item => CSI & "2J" & CSI & "H");                  

      end loop KartenartSchleife;
      
   end KartenartWählen;



   function KartentemperaturWählen return Integer is
   begin
            
      KartentemperaturSchleife:
      loop

         Wahl := Auswahl.Auswahl (WelcheAuswahl =>  3, WelcherText => 4);
                  
         case Wahl is
            when 1 .. 3 =>
               KartenGenerator.Kartentemperatur := Wahl;
               return 4;
               
            when 6 =>
               ZufälligeKartentemperaturWählen.Reset (ZufälligeKartentemperaturGewählt);
               KartenGenerator.Kartentemperatur := ZufälligeKartentemperaturWählen.Random (ZufälligeKartentemperaturGewählt);
               return 4;
               
            when -2 =>
               return 2;
               
            when 0 =>
               return 0;
               
            when -1 =>
               return -1;
               
            when others =>
               null;
         end case;

         Put (Item => CSI & "2J" & CSI & "H");
                  
      end loop KartentemperaturSchleife;
      
   end KartentemperaturWählen;



   function SpieleranzahlWählen return Integer is
   begin
      
      SpieleranzahlSchleife:
      loop

         Wahl := Auswahl.Auswahl (WelcheAuswahl => 4, WelcherText => 5);
         
         case Wahl is
            when 1 .. 18 =>
               GlobaleVariablen.SpielerAnzahl := Wahl;
               return 5;

            when 19 => 
               ZufälligeSpieleranzahlWählen.Reset (ZufälligeSpieleranzahlGewählt);
               GlobaleVariablen.SpielerAnzahl := ZufälligeSpieleranzahlWählen.Random (ZufälligeSpieleranzahlGewählt);
               return 5;
               
            when -2 =>
               return 3;
               
            when 0 =>
               return 0;
               
            when -1 =>
               return -1;
               
            when others =>
               null;
         end case;

         Put (Item => CSI & "2J" & CSI & "H");
         
      end loop SpieleranzahlSchleife;
      
   end SpielerAnzahlWählen;


   
   function RasseWählen return Integer is
   begin

      RasseSchleife:
      loop
         
         Wahl := Auswahl.Auswahl (WelcheAuswahl => 5, WelcherText => 6);

         case Wahl is
            when 1 .. 18 =>      
               Anzeige.AnzeigeLangerText (WelcherText => 7, WelcheZeile => Wahl);
               Wahl2 := Auswahl.Auswahl (WelcheAuswahl => 6, WelcherText => 18);
               case Wahl2 is
                  when -3 =>
                     GlobaleVariablen.Rasse := Wahl;
                     GlobaleVariablen.RassenImSpiel (GlobaleVariablen.Rasse) := 1;
                     return 6;
                     
                  when others =>
                     null;
               end case;

            when 19 =>
               ZufälligeRasseWählen.Reset (ZufälligeRasseGewählt);
               GlobaleVariablen.Rasse := ZufälligeRasseWählen.Random (ZufälligeRasseGewählt);
               GlobaleVariablen.RassenImSpiel (GlobaleVariablen.Rasse) := 1;
               return 6;
               
            when -2 =>
               return 4;
               
            when 0 =>
               return 0;
               
            when -1 =>
               return -1;
               
            when others =>
               null;
         end case;               

         Put (Item => CSI & "2J" & CSI & "H");
         
      end loop RasseSchleife;
      
   end RasseWählen;



   procedure StartwerteErmitteln is
   begin
      
      case GlobaleVariablen.SpielerAnzahl is
         when 1 =>
            null;
            
         when others =>
            RassenAusgewählt := 1;
            RassenWählen.Reset (RassenGewählt);

            RassenWählenSchleife:
            loop

               Rasse := RassenWählen.Random (RassenGewählt);
               
               if GlobaleVariablen.RassenImSpiel (Rasse) = 0 then
                  GlobaleVariablen.RassenImSpiel (Rasse) := 2;
                  RassenAusgewählt := RassenAusgewählt + 1;

                  if RassenAusgewählt = GlobaleVariablen.SpielerAnzahl then
                     exit RassenWählenSchleife;
                     
                  else
                     null;
                  end if;
                  
               else
                  null;
               end if;               
               
            end loop RassenWählenSchleife;
      end case;
      
      SpieleranzahlWerteFestlegen:
      for Rasse in GlobaleVariablen.RassenImSpiel'Range loop
        
         case GlobaleVariablen.RassenImSpiel (Rasse) is
            when 0 =>
               null;
               
            when others =>
               SicherheitsTestWert := 0;
         
               StartwerteFestlegenSchleife:
               loop
                  
                  Koordinaten := ((0, 0), (0, 0));
                  GezogeneWerte := ZufallsGeneratoren.YXPosition;

                  PrüfungEinheit := UmgebungPrüfen (YPosition => GezogeneWerte.YWert,
                                                    XPosition => GezogeneWerte.XWert,
                                                    Rasse     => Rasse);

                  case PrüfungEinheit is
                     when True =>
                        exit StartwerteFestlegenSchleife;
                        
                     when False =>
                        SicherheitsTestWert := SicherheitsTestWert + 1;
                  end case;

                  case SicherheitsTestWert is
                     when 10_000 =>
                        Put_Line ("Keine geeignete Startposition für Rasse" & Rasse'Wide_Wide_Image & " gefunden!");
                        delay 1.5;
                        exit StartwerteFestlegenSchleife;
                        
                     when others =>
                        null;
                  end case;
         
               end loop StartwerteFestlegenSchleife;
               
         end case;
         
      end loop SpieleranzahlWerteFestlegen;

      GlobaleVariablen.CursorImSpiel.YAchse := GlobaleVariablen.EinheitenGebaut (GlobaleVariablen.Rasse, 1).YAchse;
      GlobaleVariablen.CursorImSpiel.XAchse := GlobaleVariablen.EinheitenGebaut (GlobaleVariablen.Rasse, 1).XAchse;
      GlobaleVariablen.CursorImSpiel.YAchseAlt := GlobaleVariablen.CursorImSpiel.YAchse;
      GlobaleVariablen.CursorImSpiel.XAchseAlt := GlobaleVariablen.CursorImSpiel.XAchse;
      
   end StartwerteErmitteln;



   function UmgebungPrüfen (YPosition, XPosition : in GlobaleDatentypen.Kartenfeld; Rasse : in Integer) return Boolean is
   begin
      
      PrüfungGrund := SchleifenPruefungen.KartenGrund (Ebene       => 0,
                                                       YKoordinate => YPosition,
                                                       XKoordinate => XPosition);

      case PrüfungGrund is
         when False =>
            return False;
            
         when True =>
            PositionWert := SchleifenPruefungen.KoordinatenEinheitOhneRasseSuchen (YAchse => YPosition,
                                                                                   XAchse => XPosition);
      end case;

      case PositionWert.Rasse is
         when SchleifenPruefungen.RückgabeWert =>
            Koordinaten (1) := (YPosition, XPosition);
            YAchseSchleife:
            for YÄnderung in GlobaleDatentypen.LoopRangeMinusEinsZuEins'Range loop
               XAchseSchleife:
               for XÄnderung in GlobaleDatentypen.LoopRangeMinusEinsZuEins'Range loop

                  KartenWert := SchleifenPruefungen.KartenUmgebung (YKoordinate    => YPosition,
                                                                    XKoordinate    => XPosition,
                                                                    YÄnderung      => YÄnderung,
                                                                    XÄnderung      => XÄnderung,
                                                                    ZusatzYAbstand => 0);
                  case KartenWert.YWert is
                     when GlobaleDatentypen.Kartenfeld'First =>
                        exit XAchseSchleife;
                  
                     when others =>
                        if YÄnderung /= 0 or XÄnderung /= 0 then
                           PrüfungGrund := SchleifenPruefungen.KartenGrund (Ebene       => 0,
                                                                            YKoordinate => KartenWert.YWert,
                                                                            XKoordinate => KartenWert.XWert);

                           case PrüfungGrund is
                              when False =>
                                 PlatzBelegt := (1, 1);
            
                              when True =>
                                 PlatzBelegt := SchleifenPruefungen.KoordinatenEinheitOhneRasseSuchen (YAchse => KartenWert.YWert,
                                                                                                       XAchse => KartenWert.XWert);
                           end case;                    
                           
                           case PlatzBelegt.Rasse is
                              when SchleifenPruefungen.RückgabeWert =>
                                    Koordinaten (2) := (KartenWert.YWert, KartenWert.XWert);
                                    StartpunktFestlegen (Rasse => Rasse);
                                 return True;
                                 
                              when others =>
                                 null;
                           end case;
                                             
                        else
                           null;
                        end if;
                  end case;

               end loop XAchseSchleife;
            end loop YAchseSchleife;
                           
         when others =>
            null;
      end case;
         
      return False;
      
   end UmgebungPrüfen;



   procedure StartpunktFestlegen (Rasse : in Integer) is
   begin

      GlobaleVariablen.EinheitenGebaut (Rasse, 1).ID := 1;
      GlobaleVariablen.EinheitenGebaut (Rasse, 1).YAchse := Koordinaten (1).YWert;
      GlobaleVariablen.EinheitenGebaut (Rasse, 1).XAchse := Koordinaten (1).XWert;
      EinheitenDatenbank.LebenspunkteBewegungspunkteAufMaximumSetzen (Rasse, 1);

      GlobaleVariablen.EinheitenGebaut (Rasse, 2).ID := 2;
      GlobaleVariablen.EinheitenGebaut (Rasse, 2).YAchse := Koordinaten (2).YWert;
      GlobaleVariablen.EinheitenGebaut (Rasse, 2).XAchse := Koordinaten (2).XWert;
      EinheitenDatenbank.LebenspunkteBewegungspunkteAufMaximumSetzen (Rasse, 2);     
      
   end StartpunktFestlegen;

end SpielEinstellungen;
