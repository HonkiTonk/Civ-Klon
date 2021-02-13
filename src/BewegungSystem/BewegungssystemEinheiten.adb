pragma SPARK_Mode (On);

with Ada.Wide_Wide_Text_IO, Ada.Wide_Wide_Characters.Handling;
use Ada.Wide_Wide_Text_IO, Ada.Wide_Wide_Characters.Handling;

with SchleifenPruefungen, KartenDatenbank, Karte, EinheitenDatenbank, Diplomatie, Sichtbarkeit, VerbesserungenDatenbank;

package body BewegungssystemEinheiten is

   procedure BewegungEinheitenRichtung (EinheitRasseNummer : in GlobaleRecords.RassePlatznummerRecord) is
   begin

      Karte.AnzeigeKarte (RasseExtern => EinheitRasseNummer.Rasse);

      BewegenSchleife:
      loop
      
         Get_Immediate (Item => Richtung);
         Richtung := To_Lower (Item => Richtung);
              
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
         
         RückgabeWert := ZwischenEbene (EinheitRasseNummer => EinheitRasseNummer,
                                         ÄnderungExtern       => Änderung);

         case RückgabeWert is
            when 1 => -- Einheit wurde bewegt.          
               Sichtbarkeit.SichtbarkeitsprüfungFürEinheit (EinheitRasseNummer => EinheitRasseNummer);
               
            when others => -- Einheit wurde nicht bewegt.
               null;
         end case;
         
         if GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte = 0.00 then
            return;

         elsif GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleLebenspunkte <= 0 then
            return;
               
         else
            Karte.AnzeigeKarte (RasseExtern => EinheitRasseNummer.Rasse);
         end if;
         
      end loop BewegenSchleife;
      
   end BewegungEinheitenRichtung;
   


   -- 1 = Bewegung auf Feld möglich.
   -- 0 = Außerhalb der Karte, Feld blockiert durch eigene Einheit oder Kampf gegen gegnerische Einheit verloren.
   -- -1 = Gegnerische Einheit oder Stadt auf dem Feld.
   function ZwischenEbene (EinheitRasseNummer : in GlobaleRecords.RassePlatznummerRecord; ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord) return GlobaleDatentypen.LoopRangeMinusEinsZuEins is
   begin

      KartenWert := SchleifenPruefungen.KartenUmgebung (Koordinaten    => GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AchsenPosition,
                                                        Änderung       => ÄnderungExtern,
                                                        ZusatzYAbstand => 0);

      case KartenWert.YAchse is
         when GlobaleDatentypen.Kartenfeld'First =>
            return 0;
            
         when others =>
            FeldPassierbar := FeldFürDieseEinheitPassierbar (EinheitRasseNummer => EinheitRasseNummer,
                                                              NeuePosition          => (GlobaleDatentypen.EbeneVorhanden (KartenWert.EAchse), GlobaleDatentypen.KartenfeldPositiv (KartenWert.YAchse),
                                                                                        GlobaleDatentypen.KartenfeldPositiv (KartenWert.XAchse)));
      end case;

      case FeldPassierbar is
         when True =>
            null;
            
         when False =>
            return 0;
      end case;

      GegnerWert := BefindetSichDortEineEinheit (RasseExtern    => EinheitRasseNummer.Rasse,
                                                 NeuePosition  => (GlobaleDatentypen.EbeneVorhanden (KartenWert.EAchse), GlobaleDatentypen.KartenfeldPositiv (KartenWert.YAchse),
                                                                   GlobaleDatentypen.KartenfeldPositiv (KartenWert.XAchse)));

      if GegnerWert.Rasse = EinheitRasseNummer.Rasse and GegnerWert.Platznummer = 1 then
         return 0;

      elsif GegnerWert.Platznummer = SchleifenPruefungen.RückgabeWertEinheitNummer then
         BewegungEinheitenBerechnung (EinheitRasseNummer => EinheitRasseNummer,
                                      NeuePosition          => (GlobaleDatentypen.EbeneVorhanden (KartenWert.EAchse), GlobaleDatentypen.KartenfeldPositiv (KartenWert.YAchse),
                                                                GlobaleDatentypen.KartenfeldPositiv (KartenWert.XAchse)));
         return 1;
         
      else
         ErgebnisGegnerAngreifen := Diplomatie.GegnerAngreifenOderNicht (EinheitRasseNummer => EinheitRasseNummer,
                                                                         Gegner                => GegnerWert);

         case ErgebnisGegnerAngreifen is
            when True =>
               BewegungEinheitenBerechnung (EinheitRasseNummer => EinheitRasseNummer,
                                            NeuePosition          => (GlobaleDatentypen.EbeneVorhanden (KartenWert.EAchse), GlobaleDatentypen.KartenfeldPositiv (KartenWert.YAchse),
                                                                      GlobaleDatentypen.KartenfeldPositiv (KartenWert.XAchse)));
               return 1;
               
            when False =>
               return 0;
         end case;
      end if;
      
   end ZwischenEbene;



   function FeldFürDieseEinheitPassierbar (EinheitRasseNummer : in GlobaleRecords.RassePlatznummerRecord; NeuePosition : in GlobaleRecords.AchsenKartenfeldPositivRecord) return Boolean is
   begin
      
      
      if EinheitenDatenbank.EinheitenListe (EinheitRasseNummer.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).ID).Passierbarkeit = 3 then
         null;
               
      elsif EinheitenDatenbank.EinheitenListe (EinheitRasseNummer.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).ID).Passierbarkeit
        /= KartenDatenbank.KartenListe (Karten.Karten (NeuePosition.EAchse, NeuePosition.YAchse, NeuePosition.XAchse).Grund).Passierbarkeit then
         case EinheitenDatenbank.EinheitenListe (EinheitRasseNummer.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).ID).Passierbarkeit is
            when 2 =>
               Stadtnummer := SchleifenPruefungen.KoordinatenStadtMitRasseSuchen (RasseExtern  => EinheitRasseNummer.Rasse,
                                                                                  Koordinaten  => NeuePosition);
         
               case Stadtnummer is
                  when 0 =>
                     return False;
               
                  when others =>
                     null;
               end case;
                     
            when others =>
               return False;
         end case;
            
      else
         null;
      end if;

      return True;
      
   end FeldFürDieseEinheitPassierbar;
   
   
   
   function BefindetSichDortEineEinheit (RasseExtern : GlobaleDatentypen.RassenMitNullwert; NeuePosition : in GlobaleRecords.AchsenKartenfeldPositivRecord) return GlobaleRecords.RassePlatznummerRecord is
   begin

      GegnerEinheitWert := SchleifenPruefungen.KoordinatenEinheitOhneRasseSuchen (Koordinaten => NeuePosition);

      if GegnerEinheitWert.Rasse = RasseExtern then
         return (GegnerEinheitWert.Rasse, 1);

      elsif GegnerEinheitWert.Rasse = GlobaleDatentypen.RassenMitNullwert'First then
         null;
                  
      else
         return GegnerEinheitWert;
      end if;

      GegnerStadtWert := SchleifenPruefungen.KoordinatenStadtOhneRasseSuchen (Koordinaten => NeuePosition);

      if GegnerStadtWert.Rasse = RasseExtern then
         return (GegnerStadtWert.Rasse, 0);
         
      else
         return GegnerStadtWert;
      end if;
      
   end BefindetSichDortEineEinheit;

   

   procedure BewegungEinheitenBerechnung (EinheitRasseNummer : in GlobaleRecords.RassePlatznummerRecord; NeuePosition : in GlobaleRecords.AchsenKartenfeldPositivRecord) is
   begin
      
      case StraßeUndFlussPrüfen (EinheitRasseNummer => EinheitRasseNummer,
                                 NeuePosition          => NeuePosition) is         
         when 1 | 2 =>
            BewegungspunkteModifikator := 0.50;
            
         when 10 | 11 =>
            BewegungspunkteModifikator := 1.00;

         when others =>
            BewegungspunkteModifikator := 0.00;
      end case;

      case Karten.Karten (NeuePosition.EAchse, NeuePosition.YAchse, NeuePosition.XAchse).Grund is
         when  1 | 7 | 9 | 32 =>
            if GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte < 1.00 then
               GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte := 0.00;
               return;
                     
            else                     
               GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte
                 := GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte - 2.00 + BewegungspunkteModifikator;
            end if;
               
         when others =>
            GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte
              := GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte - 1.00 + BewegungspunkteModifikator;
      end case;

      if GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte < 0.00 then
         GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AktuelleBewegungspunkte := 0.00;
                  
      else
         null;
      end if;

      GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).AchsenPosition := NeuePosition;
      GlobaleVariablen.CursorImSpiel (EinheitRasseNummer.Rasse).AchsenPosition := NeuePosition;
                       
   end BewegungEinheitenBerechnung;



   function StraßeUndFlussPrüfen (EinheitRasseNummer : in GlobaleRecords.RassePlatznummerRecord; NeuePosition : in GlobaleRecords.AchsenKartenfeldPositivRecord) return Integer is
   begin

      case EinheitenDatenbank.EinheitenListe (EinheitRasseNummer.Rasse, GlobaleVariablen.EinheitenGebaut (EinheitRasseNummer.Rasse, EinheitRasseNummer.Platznummer).ID).Passierbarkeit is
         when 1 =>
            BonusBeiBewegung := 0;

            case Karten.Karten (NeuePosition.EAchse, NeuePosition.YAchse, NeuePosition.XAchse).VerbesserungStraße is
               when 5 .. 19 =>
                  BonusBeiBewegung := BonusBeiBewegung + 1;

               when 20 .. VerbesserungenDatenbank.VerbesserungListe'Last =>
                  BonusBeiBewegung := BonusBeiBewegung + 10;
                  
               when others =>
                  null;
            end case;               

            case Karten.Karten (NeuePosition.EAchse, NeuePosition.YAchse, NeuePosition.XAchse).Fluss is
               when 0 =>
                  null;

               when others =>
                  BonusBeiBewegung := BonusBeiBewegung + 1;
            end case;
            
            return BonusBeiBewegung;

         when others =>
            return 0;
      end case;
      
   end StraßeUndFlussPrüfen;

end BewegungssystemEinheiten;
