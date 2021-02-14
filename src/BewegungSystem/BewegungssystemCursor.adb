pragma SPARK_Mode (On);

with Anzeige, GlobaleVariablen, Karten, Eingabe, SchleifenPruefungen;

package body BewegungssystemCursor is

   procedure BewegungCursorRichtung (Karte : in Boolean; Richtung : in Wide_Wide_Character; RasseExtern : in GlobaleDatentypen.Rassen) is -- Hier noch Bewegung für Stadt einbauen
   begin
      
      case Richtung is
         when 'w' | '8' =>
            Änderung := (0, -1, 0);
            
         when 'a' | '4' =>
            Änderung := (0, 0, -1);
            
         when 's' | '2' =>
            Änderung := (0, 1, 0);
            
         when 'd' | '6'  =>
            Änderung := (0, 0, 1);
            
         when '1' =>
            Änderung := (0, 1, -1);

         when '3' =>
            Änderung := (0, 1, 1);
            
         when '7' =>
            Änderung := (0, -1, -1);
            
         when '9' =>
            Änderung := (0, -1, 1);
            
         when '+' =>
            Änderung := (1, 0, 0);
            
         when '-' =>
            Änderung := (-1, 0, 0);
            
         when others =>
            return;
      end case;
      
      case Karte is
         when True =>
            BewegungCursorBerechnen (ÄnderungExtern => Änderung,
                                     RasseExtern    => RasseExtern);
            
         when False =>
            BewegungCursorBerechnenStadt (ÄnderungExtern => Änderung,
                                          RasseExtern    => RasseExtern);
      end case;
      
   end BewegungCursorRichtung;



   procedure GeheZuCursor (RasseExtern : in GlobaleDatentypen.Rassen) is
   begin

      Anzeige.EinfacheAnzeige (Mit_Line => False, -- Hier noch entsprechend die Textdatei ändern, verweist auf YAchse und nicht EAchse
                               Datei    => 2,
                               Eintrag  => 1);
      
      Wert := Eingabe.GanzeZahl (WelcheDatei   => 0,
                                 WelcherText   => 0,
                                 ZahlenMinimum => Integer (Karten.Karten'First (1)), -- Integer (Karten.Karten'First (1)), -- Hierfür brauche ich auch negative Zahlen
                                 ZahlenMaximum => Integer (Karten.Karten'Last (1)));
      
      case Wert is
         when -1 =>
            Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                AktuelleAuswahl    => 1,
                                FrageDatei         => 0,
                                FrageZeile         => 0,
                                TextDatei          => 8,
                                ErsteZeile         => 12,
                                LetzteZeile        => 12);
            return;
         
         when others =>
            Position.EAchse := GlobaleDatentypen.EbeneVorhanden (Wert);
      end case;

      Anzeige.EinfacheAnzeige (Mit_Line => False,
                               Datei    => 2,
                               Eintrag  => 1);
      
      Wert := Eingabe.GanzeZahl (WelcheDatei   => 0,
                                 WelcherText   => 0,
                                 ZahlenMinimum => Integer (Karten.Karten'First (2)),
                                 ZahlenMaximum => Integer (Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße));
      
      case Wert is
         when -1 =>
            Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                AktuelleAuswahl    => 1,
                                FrageDatei         => 0,
                                FrageZeile         => 0,
                                TextDatei          => 8,
                                ErsteZeile         => 12,
                                LetzteZeile        => 12);
            return;
         
         when others =>
            Position.YAchse := GlobaleDatentypen.Kartenfeld (Wert);
      end case;
      
      Anzeige.EinfacheAnzeige (Mit_Line => False,
                               Datei    => 2,
                               Eintrag  => 2);
      Wert := Eingabe.GanzeZahl (WelcheDatei   => 0,
                                 WelcherText   => 0,
                                 ZahlenMinimum => Integer (Karten.Karten'First (3)),
                                 ZahlenMaximum => Integer (Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße));

      case Wert is
         when -1 =>
            Anzeige.AnzeigeNeu (AuswahlOderAnzeige => False,
                                AktuelleAuswahl    => 1,
                                FrageDatei         => 0,
                                FrageZeile         => 0,
                                TextDatei          => 8,
                                ErsteZeile         => 12,
                                LetzteZeile        => 12);
            return;
         
         when others =>
            Position.XAchse := GlobaleDatentypen.Kartenfeld (Wert);
      end case;
      
      GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition := Position;
      
   end GeheZuCursor;
   
   

   procedure BewegungCursorBerechnen (ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord; RasseExtern : in GlobaleDatentypen.Rassen) is
   begin
      
      if ÄnderungExtern.EAchse = 1 and GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse = Karten.Karten'Last (1) then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse := Karten.Karten'First (1);
         return;
         
      elsif Änderung.EAchse = -1 and GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse = Karten.Karten'First (1) then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse := Karten.Karten'Last (1);
         return;
         
      elsif Änderung.EAchse = 1 then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse := GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse + 1;
         return;
         
      elsif Änderung.EAchse = -1 then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse := GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition.EAchse - 1;
         return;
         
      else
         null;
      end if;
      
      KartenWert := SchleifenPruefungen.KartenUmgebung (Koordinaten    => GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition,
                                                        Änderung       => ÄnderungExtern,
                                                        ZusatzYAbstand => 0);
      
      case KartenWert.YAchse is
         when GlobaleDatentypen.Kartenfeld'First =>
            return;
              
         when others =>
            GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPosition := (KartenWert.EAchse, KartenWert.YAchse, KartenWert.XAchse);
      end case;
      
   end BewegungCursorBerechnen;



   procedure BewegungCursorBerechnenStadt (ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord; RasseExtern : in GlobaleDatentypen.Rassen) is
   begin

      if GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.YAchse + ÄnderungExtern.YAchse < Karten.Stadtkarte'First (1) then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.YAchse := Karten.Stadtkarte'Last (1);

      elsif GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.YAchse + ÄnderungExtern.YAchse > Karten.Stadtkarte'Last (1) then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.YAchse := Karten.Stadtkarte'First (1);

      else
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.YAchse := GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.YAchse + ÄnderungExtern.YAchse;
      end if;
      
      if GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.XAchse + ÄnderungExtern.XAchse < Karten.Stadtkarte'First (2) then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.XAchse := Karten.Stadtkarte'Last (2);

      elsif GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.XAchse + ÄnderungExtern.XAchse > Karten.Stadtkarte'Last (2) then
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.XAchse := Karten.Stadtkarte'First (2);

      else
         GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.XAchse := GlobaleVariablen.CursorImSpiel (RasseExtern).AchsenPositionStadt.XAchse + ÄnderungExtern.XAchse;
      end if;
      
   end BewegungCursorBerechnenStadt;

end BewegungssystemCursor;
