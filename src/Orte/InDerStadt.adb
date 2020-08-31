package body InDerStadt is

   procedure InDerStadt (Rasse, StadtPositionInListe : in Integer) is
   begin
      
      Karte.AnzeigeStadt (Stadtnummer => StadtPositionInListe);
      
      StadtSchleife:
      loop

      Get_Immediate (Taste);
         
         case To_Lower (Taste) is
            when 'w' | 's' | 'a' | 'd' | '1' | '2' | '3' | '4' | '6' | '7' | '8' | '9' =>
               BewegungssystemCursor.BewegungCursorRichtung (False, To_Lower (Taste));
               Karte.AnzeigeStadt (Stadtnummer => StadtPositionInListe);

            when 'q' =>
               return;
               
            when others =>
               null;
         end case;
         
      end loop StadtSchleife;
      
   end InDerStadt;
   
   
   
   procedure StadtBauen (Listenplatz, Rasse : in Integer) is
   begin

      BauMöglich := True;
      
      YAchseSchleife:
      for Y in -3 .. 3 loop
         XAchseSchleife:
         for X in -3 .. 3 loop
                     
            if GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).YAchse + Y > Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße or GlobaleVariablen.StadtGebaut (Listenplatz, Rasse).YAchse + Y < Karten.Karten'First (1) then
               exit XAchseSchleife;

            elsif GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).XAchse + X > Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße then
               Überhang := GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).XAchse + X - Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße;
               BauMöglich := StadtBauenPrüfen (Y => GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).YAchse + Y, X => Überhang);
                     
                     
            elsif GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).XAchse + X < Karten.Karten'First (1) then
               Überhang := GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).XAchse + X + Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße;
               BauMöglich := StadtBauenPrüfen (Y => GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).YAchse + Y, X => Überhang);
                     
            else
               BauMöglich := StadtBauenPrüfen (Y => GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).YAchse + Y, X => GlobaleVariablen.EinheitenGebaut (Listenplatz, Rasse).XAchse + X);
            end if;

            case BauMöglich is
               when True =>
                  null;
                  
               when False =>                  
                  Fehlermeldungen.Fehlermeldungen (WelcheFehlermeldung => 6);
                  return;
            end case;
         
         end loop XAchseSchleife;
      end loop YAchseSchleife;

      for A in GlobaleVariablen.StadtGebaut'Range (2) loop
         
         if GlobaleVariablen.StadtGebaut (Rasse, A).ID /= 0 then
            null;
            
         elsif A = GlobaleVariablen.StadtGebaut'Last (2) and GlobaleVariablen.StadtGebaut (Rasse, A).ID /= 0 then
            Fehlermeldungen.Fehlermeldungen (WelcheFehlermeldung => 7);
            
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
              (Stadtart, GlobaleVariablen.EinheitenGebaut (Rasse, Listenplatz).YAchse, GlobaleVariablen.EinheitenGebaut (Rasse, Listenplatz).XAchse, 1, 0, 0, 0, 0, 0, 0, 0, 0, "00000000000000000000", To_Unbounded_Wide_Wide_String ("Name"));
            EinheitenDatenbank.EinheitEntfernen (Rasse => Rasse, Platznummer => Listenplatz);

            GlobaleVariablen.StadtGebaut (Listenplatz, Rasse).Name := Eingabe.StadtName;
         end if;
         
      end loop;
                           
   end StadtBauen;



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
