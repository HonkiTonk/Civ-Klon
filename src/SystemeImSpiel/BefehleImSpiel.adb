pragma SPARK_Mode (On);

with GlobaleKonstanten, GlobaleTexte;

with EinheitenDatenbank;

with InDerStadt, BewegungssystemEinheiten, BewegungssystemCursor, Auswahl, NaechstesObjekt, Verbesserungen, Anzeige, Diplomatie, Cheat, StadtBauen, EinheitSuchen, StadtSuchen,
     Eingabe, FeldInformationen, ForschungAllgemein, EinheitenAllgemein;

package body BefehleImSpiel is

   function Befehle
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
      return Integer
   is begin 
      
      Befehl := Eingabe.Tastenwert;

      case
        Befehl
      is
         when GlobaleDatentypen.Tastenbelegung_Bewegung_Enum'Range =>
            BewegungssystemCursor.BewegungCursorRichtung (KarteExtern       => True,
                                                          RichtungExtern    => Befehl,
                                                          RasseExtern       => RasseExtern);
            
         when GlobaleDatentypen.Auswählen =>
            AuswahlEinheitStadt (RasseExtern => RasseExtern);
                 
         when GlobaleDatentypen.Menü_Zurück =>
            return Auswahl.Auswahl (FrageDateiExtern  => GlobaleTexte.Leer,
                                    TextDateiExtern   => GlobaleTexte.Menü_Auswahl,
                                    FrageZeileExtern  => 0,
                                    ErsteZeileExtern  => 1,
                                    LetzteZeileExtern => 6);

         when GlobaleDatentypen.Bauen =>
            BaueStadt (RasseExtern => RasseExtern);
           
         when GlobaleDatentypen.Forschung =>
            Technologie (RasseExtern => RasseExtern);
            
         when GlobaleDatentypen.Tech_Baum =>
            ForschungAllgemein.ForschungsBaum (RasseExtern => RasseExtern);
            
         when GlobaleDatentypen.Nächste_Stadt =>
            NaechstesObjekt.NächsteStadt (RasseExtern => RasseExtern);
            
         when GlobaleDatentypen.Einheit_Mit_Bewegungspunkte =>
            NaechstesObjekt.NächsteEinheit (RasseExtern           => RasseExtern,
                                             BewegungspunkteExtern => NaechstesObjekt.Hat_Bewegungspunkte);
            
         when GlobaleDatentypen.Alle_Einheiten =>
            NaechstesObjekt.NächsteEinheit (RasseExtern           => RasseExtern,
                                             BewegungspunkteExtern => NaechstesObjekt.Egal_Bewegeungspunkte);
            
         when GlobaleDatentypen.Einheiten_Ohne_Bewegungspunkte =>
            NaechstesObjekt.NächsteEinheit (RasseExtern           => RasseExtern,
                                             BewegungspunkteExtern => NaechstesObjekt.Keine_Bewegungspunkte);
            
         when GlobaleDatentypen.Tastenbelegung_Befehle_Enum'Range =>                     
            EinheitBefehle (RasseExtern  => RasseExtern,
                            BefehlExtern => Befehl);
            
         when GlobaleDatentypen.Infos =>
            FeldInformationen.Aufteilung (RasseExtern => RasseExtern);

         when GlobaleDatentypen.Diplomatie =>
            Diplomatie.DiplomatieAuswählen (RasseExtern => RasseExtern);

         when GlobaleDatentypen.GeheZu =>
            BewegungssystemCursor.GeheZuCursor (RasseExtern => RasseExtern);

         when GlobaleDatentypen.Stadt_Umbenennen =>
            StadtUmbenennen (RasseExtern => RasseExtern);
            
         when GlobaleDatentypen.Stadt_Abreißen =>
            StadtAbreißen (RasseExtern => RasseExtern);
            
         when GlobaleDatentypen.Stadt_Suchen =>
            StadtSuchenNachNamen := StadtSuchen.StadtNachNamenSuchen;
            
         when GlobaleDatentypen.Runde_Beenden =>
            return -1_000;
            
         when GlobaleDatentypen.Cheatmenü =>
            Cheat.Menü (RasseExtern => RasseExtern);
            
            -- when 39 =>
            -- Meldungen von Städte
            -- null;
            
            -- when 40 =>
            -- Meldungen von Einheiten
            -- null;
         
         when GlobaleDatentypen.Nicht_Vorhanden =>
            null;
      end case;

      return 1;
      
   end Befehle;
   
   
   
   procedure AuswahlEinheitStadt
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
   is begin
      
      EinheitNummer := EinheitSuchen.KoordinatenEinheitMitRasseSuchen (RasseExtern       => RasseExtern,
                                                                       KoordinatenExtern => GlobaleVariablen.CursorImSpiel (RasseExtern).Position);
      StadtNummer := StadtSuchen.KoordinatenStadtMitRasseSuchen (RasseExtern       => RasseExtern,
                                                                 KoordinatenExtern => GlobaleVariablen.CursorImSpiel (RasseExtern).Position);

      if
        EinheitNummer /= 0
        and
          StadtNummer /= 0
      then
         StadtOderEinheit := Auswahl.AuswahlJaNein (FrageZeileExtern => 15);

         EinheitOderStadt (RasseExtern         => RasseExtern,
                           AuswahlExtern       => StadtOderEinheit,
                           StadtNummerExtern   => StadtNummer,
                           EinheitNummerExtern => EinheitNummer);               
         
      elsif
        StadtNummer /= 0
      then
         EinheitOderStadt (RasseExtern         => RasseExtern,
                           AuswahlExtern       => GlobaleKonstanten.JaKonstante,
                           StadtNummerExtern   => StadtNummer,
                           EinheitNummerExtern => EinheitNummer);
         
      elsif
        EinheitNummer /= 0
      then
         Transportiert := EinheitSuchen.IstEinheitAufTransporter (EinheitRassePlatznummer => (RasseExtern, EinheitNummer));
         if
           GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).WirdTransportiert = 0
           and
             Transportiert = False
         then
            EinheitOderStadt (RasseExtern         => RasseExtern,
                              AuswahlExtern       => GlobaleKonstanten.NeinKonstante,
                              StadtNummerExtern   => StadtNummer,
                              EinheitNummerExtern => EinheitNummer);
            return;

         else
            null;
         end if;
         
         if
           GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).WirdTransportiert /= 0
         then
            EinheitTransportNummer := EinheitenAllgemein.EinheitTransporterAuswählen (EinheitRasseNummerExtern => (RasseExtern, GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).WirdTransportiert));

         else
            EinheitTransportNummer := EinheitenAllgemein.EinheitTransporterAuswählen (EinheitRasseNummerExtern => (RasseExtern, EinheitNummer));
         end if;
                  
         case
           EinheitTransportNummer
         is
            when 0 =>
               null;
                        
            when others =>
               EinheitOderStadt (RasseExtern         => RasseExtern,
                                 AuswahlExtern       => GlobaleKonstanten.NeinKonstante,
                                 StadtNummerExtern   => StadtNummer,
                                 EinheitNummerExtern => EinheitTransportNummer);
         end case;
               
      else
         null;
      end if;
      
   end AuswahlEinheitStadt;



   procedure EinheitOderStadt
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum;
      AuswahlExtern : in Integer;
      StadtNummerExtern : in GlobaleDatentypen.MaximaleStädteMitNullWert;
      EinheitNummerExtern : in GlobaleDatentypen.MaximaleEinheitenMitNullWert)
   is begin
      
      case
        AuswahlExtern
      is
         when GlobaleKonstanten.JaKonstante =>
            GlobaleVariablen.CursorImSpiel (RasseExtern).PositionStadt.YAchse := 1;
            GlobaleVariablen.CursorImSpiel (RasseExtern).PositionStadt.XAchse := 1;
            InDerStadt.InDerStadt (StadtRasseNummerExtern => (RasseExtern, StadtNummerExtern));
            return;
            
         when others =>
            null;
      end case;
      
      if
        GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummerExtern).Beschäftigung /= GlobaleDatentypen.Nicht_Vorhanden
        and then
          EinheitenAllgemein.BeschäftigungAbbrechenVerbesserungErsetzenBrandschatzenEinheitAuflösen (7) = True
      then
         GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummerExtern).Beschäftigung := GlobaleDatentypen.Nicht_Vorhanden;
                  
      elsif
        GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummerExtern).Bewegungspunkte = 0.00
      then
         null;
                     
      else
         BewegungssystemEinheiten.BewegungEinheitenRichtung (EinheitRasseNummerExtern => (RasseExtern, EinheitNummerExtern));
      end if;
      
   end EinheitOderStadt;
   
   
   
   procedure BaueStadt
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
   is begin
      
      EinheitNummer := EinheitSuchen.KoordinatenEinheitMitRasseSuchen (RasseExtern       => RasseExtern,
                                                                       KoordinatenExtern => GlobaleVariablen.CursorImSpiel (RasseExtern).Position);
      case
        EinheitNummer
      is
         when 0 =>
            return;
            
         when others =>
            null;
      end case;
      
      if 
        EinheitenDatenbank.EinheitenListe (RasseExtern, GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).ID).EinheitTyp = 1
        and
          GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).Bewegungspunkte > 0.00
      then
         StadtBauen.StadtBauen (EinheitRasseNummerExtern => (RasseExtern, EinheitNummer));
                     
      else
         null;
      end if;
      
   end BaueStadt;
   
   
   
   procedure Technologie
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
   is begin
      
      case
        GlobaleVariablen.Wichtiges (RasseExtern).Forschungsprojekt
      is
         when 0 =>
            ForschungAllgemein.Forschung (RasseExtern => RasseExtern);
            return;
            
         when others =>
            null;
      end case;
                    
      case
        Auswahl.AuswahlJaNein (FrageZeileExtern => 17)
      is
         when GlobaleKonstanten.JaKonstante =>
            ForschungAllgemein.Forschung (RasseExtern => RasseExtern);
                     
         when others =>
            null;
      end case;
      
   end Technologie;
   
   
   
   procedure EinheitBefehle
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum;
      BefehlExtern : in GlobaleDatentypen.Tastenbelegung_Befehle_Enum)
   is begin
                     
      EinheitNummer := EinheitSuchen.KoordinatenEinheitMitRasseSuchen (RasseExtern       => RasseExtern,
                                                                       KoordinatenExtern => GlobaleVariablen.CursorImSpiel (RasseExtern).Position);
      if
        EinheitNummer = 0
      then
         return;
                  
      else
         null;
      end if;

      if
        GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).ID /= 1
        and
          (BefehlExtern = GlobaleDatentypen.Straße_Bauen
           or
             BefehlExtern = GlobaleDatentypen.Mine_Bauen
           or
             BefehlExtern = GlobaleDatentypen.Farm_Bauen
           or
             BefehlExtern = GlobaleDatentypen.Festung_Bauen
           or
             BefehlExtern = GlobaleDatentypen.Wald_Aufforsten
           or
             BefehlExtern = GlobaleDatentypen.Roden_Trockenlegen)
      then
         Anzeige.EinzeiligeAnzeigeOhneAuswahl (TextDateiExtern => GlobaleTexte.Fehlermeldungen,
                                               TextZeileExtern => 3);

      elsif
        GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).ID = 1
        and
          BefehlExtern = GlobaleDatentypen.Plündern
      then
         Anzeige.EinzeiligeAnzeigeOhneAuswahl (TextDateiExtern => GlobaleTexte.Fehlermeldungen,
                                               TextZeileExtern => 3);
                     
      elsif
        GlobaleVariablen.EinheitenGebaut (RasseExtern, EinheitNummer).Bewegungspunkte = 0.00
      then
         Anzeige.EinzeiligeAnzeigeOhneAuswahl (TextDateiExtern => GlobaleTexte.Fehlermeldungen,
                                               TextZeileExtern => 8);
                     
      else
         Verbesserungen.Verbesserung (EinheitRasseNummerExtern => (RasseExtern, EinheitNummer),
                                      BefehlExtern             => BefehlExtern);
      end if;
      
   end EinheitBefehle;
   
   
   
   procedure StadtUmbenennen
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
   is begin
      
      StadtNummer := StadtSuchen.KoordinatenStadtMitRasseSuchen (RasseExtern       => RasseExtern,
                                                                 KoordinatenExtern => GlobaleVariablen.CursorImSpiel (RasseExtern).Position);
      if
        StadtNummer = GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch
      then
         null;
                  
      else
         GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer).Name := Eingabe.StadtName;
      end if;
      
   end StadtUmbenennen;
   
   
   
   procedure StadtAbreißen
     (RasseExtern : in GlobaleDatentypen.Rassen_Verwendet_Enum)
   is begin
      
      StadtNummer := StadtSuchen.KoordinatenStadtMitRasseSuchen (RasseExtern       => RasseExtern,
                                                                 KoordinatenExtern => GlobaleVariablen.CursorImSpiel (RasseExtern).Position);
      case
        StadtNummer
      is
         when GlobaleKonstanten.RückgabeEinheitStadtNummerFalsch =>
            return;
            
         when others =>
            null;
      end case;
         
      AbreißenAuswahl := Auswahl.AuswahlJaNein (FrageZeileExtern => 30);
      case
        AbreißenAuswahl
      is
         when GlobaleKonstanten.JaKonstante =>
            GlobaleVariablen.StadtGebaut (RasseExtern, StadtNummer) := GlobaleKonstanten.LeererWertStadt;
            
         when others =>
            null;
      end case;
      
   end StadtAbreißen;

end BefehleImSpiel;
