pragma SPARK_Mode (On);

with Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Unbounded, Ada.Characters.Wide_Wide_Latin_9;
use Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Unbounded, Ada.Characters.Wide_Wide_Latin_9;

with SchleifenPruefungen, GebaeudeDatenbank, KartenDatenbank, Karten, VerbesserungenDatenbank, Sichtbarkeit, Anzeige;

package body KarteStadt is

   procedure AnzeigeStadt (StadtRasseUndNummer : GlobaleRecords.RasseUndPlatznummerRecord) is
   begin

      Put (Item => CSI & "2J" & CSI & "3J" & CSI & "H");

      Stadtumgebungsgröße := GlobaleVariablen.StadtGebaut (StadtRasseUndNummer.Rasse, StadtRasseUndNummer.Platznummer).StadtUmgebungGröße;

      YAchsenabstraktion := -Stadtumgebungsgröße;
      CursorYAchsePlus := -10;
      CursorXAchsePlus := -10;
      
      YAchseSchleife:
      for YAchse in Karten.Stadtkarte'Range (1) loop
         XAchseSchleife:
         for XAchse in Karten.Stadtkarte'Range (2) loop
                        
            if YAchse < Karten.Stadtkarte'First (1) + 7 and XAchse > Karten.Stadtkarte'Last (2) - 7 then               
               if YAchsenabstraktion > Stadtumgebungsgröße then
                  for Umgebung in 0 .. 6 loop
                     
                     if YAchse = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse
                       and XAchse + GlobaleDatentypen.Kartenfeld (Umgebung) = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse then
                        Put (Item => CSI & "5m" & GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).CursorGrafik & CSI & "0m");

                     else
                        Put (Item => " ");
                     end if;
                     
                  end loop;
                  
                  New_Line;
                  exit XAchseSchleife;

               elsif Stadtumgebungsgröße = 1 and YAchse < 3 then
                  for Umgebung in 0 .. 6 loop                  
                                          
                     if YAchse = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse
                       and XAchse + GlobaleDatentypen.Kartenfeld (Umgebung) = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse then
                        Put (Item => CSI & "5m" & GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).CursorGrafik & CSI & "0m");

                     else
                        Put (Item => " ");
                     end if;
                     
                  end loop;
                  
                  New_Line;
                  exit XAchseSchleife;

               elsif Stadtumgebungsgröße = 2 and YAchse < 2 then
                  for Umgebung in 0 .. 6 loop               
                                          
                     if YAchse = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse
                       and XAchse + GlobaleDatentypen.Kartenfeld (Umgebung) = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse then
                        Put (Item => CSI & "5m" & GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).CursorGrafik & CSI & "0m");

                     else                                            
                        Put (Item => " ");
                     end if;
                     
                  end loop;
                  
                  New_Line;
                  exit XAchseSchleife;
                  
               else
                  UmgebungsSchleife:
                  for Umgebung in GlobaleDatentypen.LoopRangeMinusDreiZuDrei'Range loop

                     Cursor := CursorKonstant + Umgebung;
                     if YAchse = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse and XAchse + Cursor = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse then
                        Put (Item => CSI & "5m" & GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).CursorGrafik & CSI & "0m");
                        CursorYAchsePlus := YAchse - 4;

                        if Umgebung < -Stadtumgebungsgröße or Umgebung > Stadtumgebungsgröße then
                           null;
                           
                        else
                           CursorXAchsePlus := Umgebung;
                        end if;
                           
                     elsif Umgebung < -Stadtumgebungsgröße then
                        Put (Item => " ");
                           
                     elsif Umgebung > Stadtumgebungsgröße then
                        Put (Item => " ");

                     else
                        KartenWert := SchleifenPruefungen.KartenUmgebung (Koordinaten    => GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition,
                                                                          Änderung       => (0, YAchsenabstraktion, Umgebung),
                                                                          ZusatzYAbstand => 0);

                        case KartenWert.YAchse is
                           when GlobaleDatentypen.Kartenfeld'First =>
                              Put (Item => " ");

                           when others =>
                              Sichtbarkeit.Sichtbarkeit (InDerStadt  => True,
                                                         Koordinaten => (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse),
                                                         RasseExtern => StadtRasseUndNummer.Rasse);
                        end case;
                     end if;

                  end loop UmgebungsSchleife;

                  New_Line;
                  YAchsenabstraktion := YAchsenabstraktion + 1;
                  exit XAchseSchleife;
               end if;
               
            elsif YAchse = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse and XAchse = GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse then
               Put (Item => CSI & "5m" & GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).CursorGrafik & CSI & "0m");

            elsif YAchse < Karten.Stadtkarte'First (1) + 7 and XAchse = Karten.Stadtkarte'Last (2) - 7 then
               Put (Item => " ");

            elsif YAchse = Karten.Stadtkarte'First (1) + 7 and XAchse >= Karten.Stadtkarte'Last (2) - 7 then
               Put (Item => " ");

            elsif YAchse = 1 and XAchse < 13 then
               if GlobaleVariablen.StadtGebaut (StadtRasseUndNummer.Rasse, StadtRasseUndNummer.Platznummer).GebäudeVorhanden (Integer (XAchse)) /= '0' then
                  Put (Item => GebaeudeDatenbank.GebäudeListe (StadtRasseUndNummer.Rasse, Integer (XAchse)).GebäudeGrafik);

               else
                  Sichtbarkeit.Farben (Einheit      => 0,
                                       Verbesserung => 0,
                                       Ressource    => 0,
                                       Grund        => Karten.Karten (0, GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition.YAchse,
                                         GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition.XAchse).Grund,
                                       Cursor       => False,
                                       RasseExtern  => StadtRasseUndNummer.Rasse,
                                       RasseIntern  => 0);
               end if;

            elsif YAchse = 2 and XAchse < 13 then
               if GlobaleVariablen.StadtGebaut (StadtRasseUndNummer.Rasse, StadtRasseUndNummer.Platznummer).GebäudeVorhanden (Integer (XAchse) + 12) /= '0' then
                  Put (Item => GebaeudeDatenbank.GebäudeListe (StadtRasseUndNummer.Rasse, Integer (XAchse) + 12).GebäudeGrafik);

               else
                  Sichtbarkeit.Farben (Einheit      => 0,
                                       Verbesserung => 0,
                                       Ressource    => 0,
                                       Grund        => Karten.Karten (0, GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition.YAchse,
                                         GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition.XAchse).Grund,
                                       Cursor       => False,
                                       RasseExtern  => StadtRasseUndNummer.Rasse,
                                       RasseIntern  => 0);
               end if;

            else
               Sichtbarkeit.Farben (Einheit      => 0,
                                    Verbesserung => 0,
                                    Ressource    => 0,
                                    Grund        => Karten.Karten (0, GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition.YAchse,
                                      GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPosition.XAchse).Grund,
                                    Cursor       => False,
                                    RasseExtern  => StadtRasseUndNummer.Rasse,
                                    RasseIntern  => 0);
            end if;

            case XAchse is
               when Karten.Stadtkarte'Last (2) =>
                  New_Line;
                  
               when others =>
                  null;
            end case;
            
         end loop XAchseSchleife;
      end loop YAchseSchleife;

      Beschreibung (RasseExtern => StadtRasseUndNummer.Rasse);
      InformationenStadt (YAufschlag  => CursorYAchsePlus,
                          XAufschlag  => CursorXAchsePlus,
                          RasseExtern => StadtRasseUndNummer.Rasse);
      if GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse = 1 and GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse < 13 then
         if GlobaleVariablen.StadtGebaut (StadtRasseUndNummer.Rasse, StadtRasseUndNummer.Platznummer).GebäudeVorhanden (Integer (GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse))
           /= '0' then
            GebaeudeDatenbank.Beschreibung (ID => Integer (GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse));
            
         else
            null;
         end if;

      elsif GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.YAchse = 2 and GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse < 13 then
         if GlobaleVariablen.StadtGebaut (StadtRasseUndNummer.Rasse, StadtRasseUndNummer.Platznummer).GebäudeVorhanden (Integer (GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse) + 12)
           /= '0' then
            GebaeudeDatenbank.Beschreibung (ID => Integer (GlobaleVariablen.CursorImSpiel (StadtRasseUndNummer.Rasse).AchsenPositionStadt.XAchse) + 12);
            
         else
            null;
         end if;
        
      else
         null;
      end if;

      New_Line;
      
   end AnzeigeStadt;
   


   procedure FarbenStadt is
   begin
      
      null;
      
   end FarbenStadt;
   
   
   
   procedure InformationenStadt (YAufschlag, XAufschlag : in GlobaleDatentypen.Kartenfeld; RasseExtern : GlobaleDatentypen.Rassen) is
   begin      
      
      Nahrungsgewinnung := 0;
      Ressourcengewinnung := 0;
      Geldgewinnung := 0;
      Wissensgewinnung := 0;

      KartenWert := SchleifenPruefungen.KartenUmgebung (Koordinaten    => GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition,
                                                        Änderung       => (0, YAufschlag, XAufschlag),
                                                        ZusatzYAbstand => 0);

      case KartenWert.YAchse is
         when GlobaleDatentypen.Kartenfeld'First =>
            YAchse := -10;
         
         when others =>
            YAchse := GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.YAchse + YAufschlag;
      end case;

      if XAufschlag = -10 then
         XAchse := XAufschlag;

      else         
         XAchse := KartenWert.XAchse;
      end if;
      
      if YAchse = -10 or XAchse = -10 then
         null;
         
      else
         if Karten.Karten (0, YAchse, XAchse).Hügel = True and Karten.Karten (0, YAchse, XAchse).Grund /= 6 then
            Anzeige.EinfacheAnzeige (Mit_Line => False,
                                     Datei    => 3,
                                     Eintrag  => 1);
            KartenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).Grund);

            Nahrungsgewinnung := Nahrungsgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Nahrungsgewinnung;
            Ressourcengewinnung := Ressourcengewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Ressourcengewinnung;
            Geldgewinnung := Geldgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Geldgewinnung;
            Wissensgewinnung := Wissensgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Wissensgewinnung;
         
         elsif Karten.Karten (0, YAchse, XAchse).Hügel = True then
            KartenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).Grund);

            Nahrungsgewinnung := Nahrungsgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Nahrungsgewinnung;
            Ressourcengewinnung := Ressourcengewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Ressourcengewinnung;
            Geldgewinnung := Geldgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Geldgewinnung;
            Wissensgewinnung := Wissensgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Wissensgewinnung;
               
         else         
            KartenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).Grund);

            Nahrungsgewinnung := Nahrungsgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Nahrungsgewinnung;
            Ressourcengewinnung := Ressourcengewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Ressourcengewinnung;
            Geldgewinnung := Geldgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Geldgewinnung;
            Wissensgewinnung := Wissensgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Grund).Wissensgewinnung;
         end if;
      
         if Karten.Karten (0, YAchse, XAchse).Ressource /= 0 then
            KartenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).Ressource);

            Nahrungsgewinnung := Nahrungsgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Ressource).Nahrungsgewinnung;
            Ressourcengewinnung := Ressourcengewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Ressource).Ressourcengewinnung;
            Geldgewinnung := Geldgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Ressource).Geldgewinnung;
            Wissensgewinnung := Wissensgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Ressource).Wissensgewinnung;
         
         else
            null;
         end if;
      
         if Karten.Karten (0, YAchse, XAchse).VerbesserungGebiet /= 0 then
            VerbesserungenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).VerbesserungGebiet);

            Nahrungsgewinnung := Nahrungsgewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungGebiet).Nahrungsbonus;
            Ressourcengewinnung := Ressourcengewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungGebiet).Ressourcenbonus;
            Geldgewinnung := Geldgewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungGebiet).Geldbonus;
            Wissensgewinnung := Wissensgewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungGebiet).Wissensbonus;
         
         else
            null;
         end if;
      
         if Karten.Karten (0, YAchse, XAchse).VerbesserungStraße /= 0 then
            VerbesserungenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).VerbesserungStraße);

            Nahrungsgewinnung := Nahrungsgewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungStraße).Nahrungsbonus;
            Ressourcengewinnung := Ressourcengewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungStraße).Ressourcenbonus;
            Geldgewinnung := Geldgewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungStraße).Geldbonus;
            Wissensgewinnung := Wissensgewinnung + VerbesserungenDatenbank.VerbesserungListe (Karten.Karten (0, YAchse, XAchse).VerbesserungStraße).Wissensbonus;
         
         else
            null;
         end if;
      
         if Karten.Karten (0, YAchse, XAchse).Fluss /= 0 then
            KartenDatenbank.Beschreibung (ID => Karten.Karten (0, YAchse, XAchse).Fluss);

            Nahrungsgewinnung := Nahrungsgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Fluss).Nahrungsgewinnung;
            Ressourcengewinnung := Ressourcengewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Fluss).Ressourcengewinnung;
            Geldgewinnung := Geldgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Fluss).Geldgewinnung;
            Wissensgewinnung := Wissensgewinnung + KartenDatenbank.KartenListe (Karten.Karten (0, YAchse, XAchse).Fluss).Wissensgewinnung;
         
         else
            null;
         end if;
            
         New_Line;
         
         Anzeige.EinfacheAnzeige (Mit_Line => False,
                                  Datei    => 3,
                                  Eintrag  => 2);
         Put_Line (Item => Nahrungsgewinnung'Wide_Wide_Image);
         
         Anzeige.EinfacheAnzeige (Mit_Line => False,
                                  Datei    => 3,
                                  Eintrag  => 3);
         Put (Item => Ressourcengewinnung'Wide_Wide_Image);
         
         Anzeige.EinfacheAnzeige (Mit_Line => False,
                                  Datei    => 3,
                                  Eintrag  => 4);
         Put (Item => Geldgewinnung'Wide_Wide_Image);
         
         Anzeige.EinfacheAnzeige (Mit_Line => False,
                                  Datei    => 3,
                                  Eintrag  => 5);
         Put_Line (Item => Wissensgewinnung'Wide_Wide_Image);
      end if;
      
   end InformationenStadt;
   


   procedure Beschreibung (RasseExtern : in GlobaleDatentypen.Rassen) is
   begin

      RasseUndPlatznummer := SchleifenPruefungen.KoordinatenStadtOhneRasseSuchen (Koordinaten => GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition);

      case RasseUndPlatznummer.Platznummer is
         when SchleifenPruefungen.RückgabeWertEinheitNummer =>
            null; -- Sollte nie eintreten, da entweder aus der Stadt aufgerufen oder nur wenn die Kartenprüfung bereits eine Stadt gefunden hat
      
         when others =>
            -- Allgemeine Stadtinformationen, nur sichtbar wenn das Kartenfeld aufgedackt ist und sich dort eine Stadt befindet
            case GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).ID is
               when 1 =>
                  Anzeige.EinfacheAnzeige (Mit_Line => False,
                                           Datei    => 3,
                                           Eintrag  => 6);
                  
               when 2 =>
                  Anzeige.EinfacheAnzeige (Mit_Line => False,
                                           Datei    => 3,
                                           Eintrag  => 7);
                  
               when 3 =>
                  Anzeige.EinfacheAnzeige (Mit_Line => False,
                                           Datei    => 3,
                                           Eintrag  => 8);
                  
               when others =>
                  Anzeige.EinfacheAnzeige (Mit_Line => False,
                                           Datei    => 3,
                                           Eintrag  => 9);
            end case;
            Put (Item => To_Wide_Wide_String (Source => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).Name) & "    ");
            Anzeige.EinfacheAnzeige (Mit_Line => False,
                                     Datei    => 3,
                                     Eintrag  => 10);
            Put_Line (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).Einwohner'Wide_Wide_Image);

            -- "Volle" Stadtinformationen, nur sichtbar wenn eigene Stadt oder wenn Cheat aktiviert ist                      
            if RasseUndPlatznummer.Rasse = RasseExtern or GlobaleVariablen.FeindlicheInformationenSehen = True then
               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 11);
               Put (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuelleNahrungsmittel'Wide_Wide_Image);
               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 12);
               Put_Line (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuelleNahrungsproduktion'Wide_Wide_Image);
                        
               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 13);
               Put (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuelleProduktionrate'Wide_Wide_Image);
               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 14);
               Put_Line (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuelleGeldgewinnung'Wide_Wide_Image);

               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 15);
               Put (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuelleForschungsrate'Wide_Wide_Image); 
               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 16);
               Put_Line (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).Korruption'Wide_Wide_Image);
                        
               Anzeige.EinfacheAnzeige (Mit_Line => False,
                                        Datei    => 3,
                                        Eintrag  => 17);
               case GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuellesBauprojekt is
                  when 0 => -- Nichts                     
                     Anzeige.EinfacheAnzeige (Mit_Line => False,
                                              Datei    => 3,
                                              Eintrag  => 18);
            
                  when 1 .. 9_999 => -- Gebäude
                     Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                         AktuelleAuswahl    => 1,
                                         FrageDatei         => 0,
                                         FrageZeile         => 0,
                                         TextDatei          => 9,
                                         ErsteZeile         => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuellesBauprojekt - 1_000,
                                         LetzteZeile        => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuellesBauprojekt - 1_000);

                  when others => -- Einheiten
                     Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                         AktuelleAuswahl    => 1,
                                         FrageDatei         => 0,
                                         FrageZeile         => 0,
                                         TextDatei          => 9,
                                         ErsteZeile         => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuellesBauprojekt - 10_000,
                                         LetzteZeile        => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).AktuellesBauprojekt - 10_000);
               end case;
                                              
               Put (Item => "    " & To_Wide_Wide_String (Source => GlobaleVariablen.TexteEinlesenNeu (9, 13)));   
               Put_Line (Item => GlobaleVariablen.StadtGebaut (RasseUndPlatznummer.Rasse, RasseUndPlatznummer.Platznummer).VerbleibendeBauzeit'Wide_Wide_Image);

            else
               null;
            end if;
      end case;
      
      New_Line;
      
   end Beschreibung;

end KarteStadt;
