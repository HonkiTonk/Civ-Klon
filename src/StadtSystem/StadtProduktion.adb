pragma SPARK_Mode (On);

with VerbesserungenDatenbank, KartenDatenbank, GebaeudeDatenbank;

with Wachstum, KartenPruefungen, Karten;

package body StadtProduktion is

   procedure StadtProduktionPrüfen
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      case StadtRasseNummerExtern.Rasse is
         when 0 => -- Überprüfung für alle Rassen bei Runde beenden.
            RassenSchleife:
            for RasseSchleifenwert in GlobaleDatentypen.Rassen loop
               StadtSchleife:
               for StadtNummerSchleifenwert in GlobaleVariablen.StadtGebautArray'Range (2) loop
                  
                  case
                    GlobaleVariablen.RassenImSpiel (RasseSchleifenwert)
                  is
                     when 0 =>
                        exit StadtSchleife;
                        
                     when others =>
                        null;
                  end case;
               
                  case
                    GlobaleVariablen.StadtGebaut (RasseSchleifenwert, StadtNummerSchleifenwert).ID
                  is
                     when 0 =>
                        null;
                  
                     when others =>
                        StadtProduktionPrüfenBerechnung (StadtRasseNummerExtern => (RasseSchleifenwert, StadtNummerSchleifenwert));
                  end case;
               
               end loop StadtSchleife;
            end loop RassenSchleife;
         
         when others => -- Überprüfung beim Bauen einer Stadt
            StadtProduktionPrüfenBerechnung (StadtRasseNummerExtern => StadtRasseNummerExtern);
            Wachstum.WachstumBeiStadtGründung (RasseExtern => StadtRasseNummerExtern.Rasse);
      end case;
      
   end StadtProduktionPrüfen;
   


   procedure StadtProduktionPrüfenBerechnung -- Hier auch nach Rasse unterscheiden?
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleNahrungsproduktion := 0;
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate := 0;
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleGeldgewinnung := 0;
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate := 0;

      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Korruption
        := GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Einwohner / 3;

      NutzbarerBereich := GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).StadtUmgebungGröße;
      
      YAchseSchleife:
      for YÄnderungSchleifenwert in -NutzbarerBereich .. NutzbarerBereich loop
         XAchseSchleife:
         for XÄnderungSchleifenwert in -NutzbarerBereich .. NutzbarerBereich loop

            KartenWert := KartenPruefungen.KartenPositionBestimmen (KoordinatenExtern    => GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AchsenPosition,
                                                                    ÄnderungExtern       => (0, YÄnderungSchleifenwert, XÄnderungSchleifenwert),
                                                                    ZusatzYAbstandExtern => 0);

            case
              KartenWert.YAchse
            is
               when 0 =>
                  exit XAchseSchleife;                                 
                                 
               when others =>
                  null;
            end case;
            
            case
              GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).UmgebungBewirtschaftung (YÄnderungSchleifenwert, XÄnderungSchleifenwert)
            is
               when True =>
                  GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleNahrungsproduktion
                    := GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleNahrungsproduktion
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Grund).Nahrungsgewinnung
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Ressource).Nahrungsgewinnung
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungStraße).Nahrungsbonus
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungGebiet).Nahrungsbonus;

                  GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate
                    := GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Grund).Ressourcengewinnung
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Ressource).Ressourcengewinnung
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungStraße).Ressourcenbonus
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungGebiet).Ressourcenbonus;

                  GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleGeldgewinnung
                    := GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleGeldgewinnung
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Grund).Geldgewinnung
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Ressource).Geldgewinnung
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungStraße).Geldbonus
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungGebiet).Geldbonus;

                  GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate
                    := GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Grund).Wissensgewinnung
                    + KartenDatenbank.KartenListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).Ressource).Wissensgewinnung
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungStraße).Wissensbonus
                    + VerbesserungenDatenbank.VerbesserungListe (Karten.Weltkarte (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse).VerbesserungGebiet).Wissensbonus;

               when others =>
                  null;
            end case;
                           
         end loop XAchseSchleife;
      end loop YAchseSchleife;

      WeitereNahrungsproduktionÄnderungen (StadtRasseNummerExtern => StadtRasseNummerExtern);
      WeitereProduktionrateÄnderungen (StadtRasseNummerExtern => StadtRasseNummerExtern);
      WeitereGeldgewinnungÄnderungen (StadtRasseNummerExtern => StadtRasseNummerExtern);
      WeitereForschungsrateÄnderungen (StadtRasseNummerExtern => StadtRasseNummerExtern);
      
   end StadtProduktionPrüfenBerechnung;
   
   
   
   procedure WeitereNahrungsproduktionÄnderungen
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin

      case
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Einwohner
      is
         when 0 .. 3 =>
            NahrungsverbrauchEinwohnerMultiplikator := 0;
            
         when 4 .. 9 =>
            NahrungsverbrauchEinwohnerMultiplikator := 0;
            
         when 10 .. 19 =>
            NahrungsverbrauchEinwohnerMultiplikator := 0;
            
         when others =>
            NahrungsverbrauchEinwohnerMultiplikator := 0;
      end case;
      
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleNahrungsproduktion :=
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleNahrungsproduktion
        - GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Einwohner * NahrungsverbrauchEinwohnerMultiplikator;
      
   end WeitereNahrungsproduktionÄnderungen;



   procedure WeitereProduktionrateÄnderungen
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin
      
      if
        StadtRasseNummerExtern.Rasse = 1
        and
          GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).GebäudeVorhanden (4) = True
      then
         GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate :=
           GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate + GebaeudeDatenbank.GebäudeListe (StadtRasseNummerExtern.Rasse, 4).ProduktionBonus;

      else
         null;
      end if;
      
      case
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Korruption
      is
         when 0 =>
            RessourcenverbrauchKorruptionMultiplikator := 0;
            
         when 1 .. 4 =>
            RessourcenverbrauchKorruptionMultiplikator := 0;
            
         when 5 .. 7 =>
            RessourcenverbrauchKorruptionMultiplikator := 0;
            
         when 8 .. 10 =>
            RessourcenverbrauchKorruptionMultiplikator := 0;
            
         when others =>
            RessourcenverbrauchKorruptionMultiplikator := 0;
      end case;
      
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate :=
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate
        - GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Einwohner * RessourcenverbrauchKorruptionMultiplikator;

      if
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate < 0
      then
         GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleProduktionrate := 0;
         
      else
         null;
      end if;
      
   end WeitereProduktionrateÄnderungen;



   procedure WeitereGeldgewinnungÄnderungen
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin

      case
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Korruption
      is
         when 0 =>
            GeldverbrauchKorruptionMultiplikator := 0;
            
         when 1 .. 4 =>
            GeldverbrauchKorruptionMultiplikator := 0;
            
         when 5 .. 7 =>
            GeldverbrauchKorruptionMultiplikator := 0;
            
         when 8 .. 10 =>
            GeldverbrauchKorruptionMultiplikator := 0;
            
         when others =>
            GeldverbrauchKorruptionMultiplikator := 0;
      end case;
      
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleGeldgewinnung :=
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleGeldgewinnung
        - GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Einwohner * GeldverbrauchKorruptionMultiplikator;
      
   end WeitereGeldgewinnungÄnderungen;



   procedure WeitereForschungsrateÄnderungen
     (StadtRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
   is begin

      case
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Korruption
      is
         when 0 =>
            ForschungsverbrauchKorruptionMultiplikator := 0;
            
         when 1 .. 4 =>
            ForschungsverbrauchKorruptionMultiplikator := 0;
            
         when 5 .. 7 =>
            ForschungsverbrauchKorruptionMultiplikator := 0;
            
         when 8 .. 10 =>
            ForschungsverbrauchKorruptionMultiplikator := 0;
            
         when others =>
            ForschungsverbrauchKorruptionMultiplikator := 0;
      end case;
      
      GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate :=
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate
        - GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).Einwohner * ForschungsverbrauchKorruptionMultiplikator;

      if
        GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate < 0
      then
         GlobaleVariablen.StadtGebaut (StadtRasseNummerExtern.Rasse, StadtRasseNummerExtern.Platznummer).AktuelleForschungsrate := 0;
         
      else
         null;
      end if;
      
   end WeitereForschungsrateÄnderungen;

end StadtProduktion;
