package body InDerStadt is

   procedure InDerStadt (Rasse, StadtNummer : in Integer) is
   begin
      
      StadtSchleife:
      loop
    
         Put (Item => CSI & "2J" & CSI & "3J" & CSI & "H");
         KarteStadt.AnzeigeStadt (StadtNummer => StadtNummer);
         New_Line;  

         Get_Immediate (Item => Taste);
         
         case To_Lower (Item => Taste) is
            when 'w' | 's' | 'a' | 'd' | '1' | '2' | '3' | '4' | '6' | '7' | '8' | '9' =>
               BewegungssystemCursor.BewegungCursorRichtung (Karte => False,
                                                             Richtung => To_Lower (Item => Taste));

            when 'e' => -- Einwohner von Feld entfernen/zuweisen
               if GlobaleVariablen.CursorImSpiel.YAchseStadt < Karten.Stadtkarte'First (1) + 7 and GlobaleVariablen.CursorImSpiel.XAchseStadt > Karten.Stadtkarte'Last (2) - 7 then
                  null;
                  
               else
                  null;
               end if;
               
            when 'b' => -- Gebäude/Einheit bauen
               case GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuellesBauprojekt is
                  when 0 =>
                     Bauen.Bauen (Rasse       => Rasse,
                                  StadtNummer => StadtNummer);
                     
                  when others =>
                     Wahl := Auswahl.Auswahl (WelcheAuswahl => 14,
                                              WelcherText => 18);
                     case Wahl is
                        when -3 =>
                           Bauen.Bauen (Rasse       => Rasse,
                                        StadtNummer => StadtNummer);
                     
                        when others =>
                           null;
                     end case;
               end case;
               
            when 'v' => -- Gebäude verkaufen
               null;

            when 'q' =>
               return;
               
            when others =>
               null;
         end case;
         
      end loop StadtSchleife;
      
   end InDerStadt;
   
   
   
   procedure StadtBauen (Rasse, EinheitNummer : in Integer) is
   begin

      BauMöglich := True;
      
      YAchseSchleife:
      for YÄnderung in -3 .. 3 loop
         XAchseSchleife:
         for XÄnderung in -3 .. 3 loop

            KartenWert := SchleifenPruefungen.KartenUmgebung (YKoordinate => GlobaleVariablen.EinheitenGebaut (Rasse, EinheitNummer).YAchse,
                                                              XKoordinate => GlobaleVariablen.EinheitenGebaut (Rasse, EinheitNummer).XAchse,
                                                              YÄnderung   => YÄnderung,
                                                              XÄnderung   => XÄnderung);
                     
            case KartenWert.YWert is
               when -1_000_000 =>
                  exit XAchseSchleife;
                  
               when others =>
                  BauMöglich := StadtBauenPrüfen (Y => KartenWert.YWert,
                                                  X => KartenWert.XWert);
            end case;

            case BauMöglich is
               when True =>
                  null;
                  
               when False =>                  
                  Ausgabe.Fehlermeldungen (WelcheFehlermeldung => 6);
                  return;
            end case;
            
         end loop XAchseSchleife;
      end loop YAchseSchleife;

      for A in GlobaleVariablen.StadtGebaut'Range (2) loop
         
         if GlobaleVariablen.StadtGebaut (Rasse, A).ID /= 0 then
            null;
            
         elsif A = GlobaleVariablen.StadtGebaut'Last (2) and GlobaleVariablen.StadtGebaut (Rasse, A).ID /= 0 then
            Ausgabe.Fehlermeldungen (WelcheFehlermeldung => 7);
            
         else
            if A = 1 and Rasse = GlobaleVariablen.Rasse then
               Stadtart := 1;
               
            elsif Rasse = GlobaleVariablen.Rasse then
               Stadtart := 2;
               
            elsif A = 1 and Rasse /= GlobaleVariablen.Rasse then
               Stadtart := 3;
               
            else
               Stadtart := 4;
            end if;

            GlobaleVariablen.StadtGebaut (Rasse, A) := 
              (Stadtart, GlobaleVariablen.EinheitenGebaut (Rasse, EinheitNummer).YAchse, GlobaleVariablen.EinheitenGebaut (Rasse, EinheitNummer).XAchse, False, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
               "000000000000000000000000", To_Unbounded_Wide_Wide_String (Source => "Name"),
               (0 => (0 => True, others => False), 
                others => (others => False)));
               
            YAchsenSchleife:
            for YÄnderung in -1 .. 1 loop
               XAchsenSchleife:
               for XÄnderung in -1 .. 1 loop
                  
                  KartenWert := SchleifenPruefungen.KartenUmgebung (YKoordinate => GlobaleVariablen.EinheitenGebaut (Rasse, EinheitNummer).YAchse,
                                                                    XKoordinate => GlobaleVariablen.EinheitenGebaut (Rasse, EinheitNummer).XAchse,
                                                                    YÄnderung   => YÄnderung,
                                                                    XÄnderung   => XÄnderung);
                     
                  case KartenWert.YWert is
                     when -1_000_000 =>
                        exit XAchsenSchleife;
                        
                     when others =>
                        case Karten.Karten (KartenWert.YWert, KartenWert.XWert).Grund is
                           when 2 | 29 .. 31 =>
                              GlobaleVariablen.StadtGebaut (Rasse, A).AmWasser := True;
                              exit YAchsenSchleife;
                        
                           when others =>
                              null;
                        end case;
                  end case;
                  
               end loop XAchsenSchleife;
            end loop YAchsenSchleife;
            
            StadtProduktionPrüfen (Rasse       => Rasse,
                                   StadtNummer => A);

            EinheitenDatenbank.EinheitEntfernen (Rasse         => Rasse,
                                                 EinheitNummer => EinheitNummer);
            
            if Rasse = GlobaleVariablen.Rasse then
               GlobaleVariablen.StadtGebaut (Rasse, A).Name := Eingabe.StadtName;
               
            else
               null;
            end if;           

            return;
         end if;
         
      end loop;
      
   end StadtBauen;



   procedure StadtProduktionPrüfen (Rasse, StadtNummer : in Integer) is
   begin
      
      case Rasse is
         when 0 => -- Überprüfung für alle Rassen bei Runde beenden.
            RassenSchleife:
            for Rassen in GlobaleVariablen.StadtGebaut'Range (1) loop
               StadtSchleife:
               for Stadt in GlobaleVariablen.StadtGebaut'Range (2) loop
               
                  case GlobaleVariablen.StadtGebaut (Rassen, Stadt).ID is
                     when 0 =>
                        exit StadtSchleife;
                  
                     when others =>
                        StadtProduktionPrüfenBerechnung (Rasse       => Rassen,
                                                         StadtNummer => Stadt);             
                  end case;
               
               end loop StadtSchleife;
            end loop RassenSchleife;
         
         when others => -- Überprüfung beim Bauen einer Stadt
            StadtProduktionPrüfenBerechnung (Rasse       => Rasse,
                                             StadtNummer => StadtNummer);
      end case;
      
   end StadtProduktionPrüfen;
   


   procedure StadtProduktionPrüfenBerechnung (Rasse, StadtNummer : in Integer) is
   begin
      
      GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleNahrungsproduktion := 0;
      GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleProduktionrate := 0;
      GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleGeldgewinnung := 0;
      GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleForschungsrate := 0;
      
      YAchseSchleife:
      for YÄnderung in GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).UmgebungBewirtschaftung'Range (1) loop
         XAchseSchleife:
         for XÄnderung in GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).UmgebungBewirtschaftung'Range (2) loop

            KartenWert := SchleifenPruefungen.KartenUmgebung (YKoordinate => GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).YAchse,
                                                              XKoordinate => GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).YAchse,
                                                              YÄnderung   => YÄnderung,
                                                              XÄnderung   => XÄnderung);

            case KartenWert.YWert is
               when -1_000_000 =>
                  exit XAchseSchleife;                                 
                                 
               when others =>
                  GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleNahrungsproduktion
                    := GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleNahrungsproduktion
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Grund).Nahrungsgewinnung
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Ressource).Nahrungsgewinnung
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungStraße).Nahrungsbonus
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungGebiet).Nahrungsbonus;

                  GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleProduktionrate
                    := GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleProduktionrate
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Grund).Ressourcengewinnung
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Ressource).Ressourcengewinnung
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungStraße).Ressourcenbonus
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungGebiet).Ressourcenbonus;

                  GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleGeldgewinnung
                    := GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleGeldgewinnung
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Grund).Geldgewinnung
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Ressource).Geldgewinnung
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungStraße).Geldbonus
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungGebiet).Geldbonus;

                  GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleForschungsrate
                    := GlobaleVariablen.StadtGebaut (Rasse, StadtNummer).AktuelleForschungsrate
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Grund).Wissensgewinnung
                    + KartenDatenbank.KartenObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).Ressource).Wissensgewinnung
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungStraße).Wissensbonus
                    + VerbesserungenDatenbank.VerbesserungObjektListe (Karten.Karten (KartenWert.YWert, KartenWert.XWert).VerbesserungGebiet).Wissensbonus;
            end case;
                           
         end loop XAchseSchleife;
      end loop YAchseSchleife;
      
   end StadtProduktionPrüfenBerechnung;
   


   function StadtBauenPrüfen (Y, X : in Integer) return Boolean is
   begin
      
      RassenSchleife:
      for A in GlobaleVariablen.StadtGebaut'Range (1) loop
         StadtSchleife:
         for B in GlobaleVariablen.StadtGebaut'Range (2) loop
            
            if GlobaleVariablen.StadtGebaut (A, B).ID = 0 then
               exit StadtSchleife;
               
            elsif GlobaleVariablen.StadtGebaut (A, B).YAchse = Y and GlobaleVariablen.StadtGebaut (A, B).XAchse = X then
               return False;
               
            else
               null;
            end if;
            
         end loop StadtSchleife;
      end loop RassenSchleife;

      return True;
      
   end StadtBauenPrüfen;   

end InDerStadt;
