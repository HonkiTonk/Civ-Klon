pragma SPARK_Mode (On);

with Ada.Wide_Wide_Text_IO, Ada.Float_Text_IO;
use Ada.Wide_Wide_Text_IO;

with GlobaleDatentypen;

with Anzeige;

package body Ladezeiten is

   procedure LadezeitenSpielweltErstellen (WelcheZeit : in Positive) is
   begin

      Gesamtzeit := 0.00;
      
      Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDatei => GlobaleDatentypen.Leer,
                                     TextDatei        => GlobaleDatentypen.Ladezeiten,
                                     ÜberschriftZeile => 0,
                                     ErsteZeile       => WelcheZeit,
                                     LetzteZeile      => WelcheZeit,
                                     AbstandAnfang    => GlobaleDatentypen.Keiner,
                                     AbstandMitte     => GlobaleDatentypen.Keiner,
                                     AbstandEnde      => GlobaleDatentypen.Kleiner_Abstand);
      
      case WelcheZeit is
         when 1 =>
            ZeitAuswahlSchleife:
            for VerschiedeneZeiten in LadezeitenSpielweltErstellenZeit'Range (2) loop
               ZeitUnterschiedSchleife:
               for ZeitAnfangEnde in LadezeitenSpielweltErstellenZeit'Range (1) loop
                  
                  case ZeitAnfangEnde is
                     when 2 =>
                        Gesamtzeit := Gesamtzeit + Float (LadezeitenSpielweltErstellenZeit (ZeitAnfangEnde, VerschiedeneZeiten) - LadezeitenSpielweltErstellenZeit (ZeitAnfangEnde - 1, VerschiedeneZeiten));

                     when 1 =>
                        null;
                  end case;
                  
               end loop ZeitUnterschiedSchleife;
            end loop ZeitAuswahlSchleife;
            Ada.Float_Text_IO.Put (Item => Gesamtzeit,
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            Get_Immediate (Item => Warten);
            
         when others =>
            Ada.Float_Text_IO.Put (Item => Float (LadezeitenSpielweltErstellenZeit (2, WelcheZeit) - LadezeitenSpielweltErstellenZeit (1, WelcheZeit)),
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            New_Line;
      end case;
                  
   end LadezeitenSpielweltErstellen;




   procedure Speichern (WelcheZeit : in Positive) is
   begin
      
      Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDatei => GlobaleDatentypen.Leer,
                                     TextDatei        => GlobaleDatentypen.Ladezeiten,
                                     ÜberschriftZeile => 0,
                                     ErsteZeile       => WelcheZeit + AufschlagSpeichern,
                                     LetzteZeile      => WelcheZeit + AufschlagSpeichern,
                                     AbstandAnfang    => GlobaleDatentypen.Keiner,
                                     AbstandMitte     => GlobaleDatentypen.Keiner,
                                     AbstandEnde      => GlobaleDatentypen.Kleiner_Abstand);

      case WelcheZeit is
         when others =>
            Ada.Float_Text_IO.Put (Item => Float (Speicherzeiten (2, WelcheZeit) - Speicherzeiten (1, WelcheZeit)),
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            Get_Immediate (Item => Warten);
      end case;
      
   end Speichern;
   
   
   
   procedure Laden (WelcheZeit : in Positive) is
   begin
      
      Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDatei => GlobaleDatentypen.Leer,
                                     TextDatei        => GlobaleDatentypen.Ladezeiten,
                                     ÜberschriftZeile => 0,
                                     ErsteZeile       => WelcheZeit + AufschlagLaden,
                                     LetzteZeile      => WelcheZeit + AufschlagLaden,
                                     AbstandAnfang    => GlobaleDatentypen.Keiner,
                                     AbstandMitte     => GlobaleDatentypen.Keiner,
                                     AbstandEnde      => GlobaleDatentypen.Kleiner_Abstand);

      case WelcheZeit is
         when others =>
            Ada.Float_Text_IO.Put (Item => Float (LadenLadezeiten (2, WelcheZeit) - LadenLadezeiten (1, WelcheZeit)),
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            Get_Immediate (Item => Warten);
      end case;
      
   end Laden;
   
   
   
   procedure SpielStart (WelcheZeit : in Positive) is
   begin
      
      Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDatei => GlobaleDatentypen.Leer,
                                     TextDatei        => GlobaleDatentypen.Ladezeiten,
                                     ÜberschriftZeile => 0,
                                     ErsteZeile       => WelcheZeit + AufschlagSpielstart,
                                     LetzteZeile      => WelcheZeit + AufschlagSpielstart,
                                     AbstandAnfang    => GlobaleDatentypen.Keiner,
                                     AbstandMitte     => GlobaleDatentypen.Keiner,
                                     AbstandEnde      => GlobaleDatentypen.Kleiner_Abstand);

      case WelcheZeit is
         when others =>
            Ada.Float_Text_IO.Put (Item => Float (SpielStartzeiten (2, WelcheZeit) - SpielStartzeiten (1, WelcheZeit)) + Float (SpielStartzeiten (2, WelcheZeit + 1) - SpielStartzeiten (1, WelcheZeit + 1)),
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            Get_Immediate (Item => Warten);
      end case;
            
   end SpielStart;



   procedure BerechnungenNachZugendeAllerSpieler (WelcheZeit : in Positive) is
   begin
      
      Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDatei => GlobaleDatentypen.Leer,
                                     TextDatei        => GlobaleDatentypen.Ladezeiten,
                                     ÜberschriftZeile => 0,
                                     ErsteZeile       => WelcheZeit + AufschlagZwischenDenRunden,
                                     LetzteZeile      => WelcheZeit + AufschlagZwischenDenRunden,
                                     AbstandAnfang    => GlobaleDatentypen.Keiner,
                                     AbstandMitte     => GlobaleDatentypen.Keiner,
                                     AbstandEnde      => GlobaleDatentypen.Kleiner_Abstand);

      case WelcheZeit is
         when others =>
            Ada.Float_Text_IO.Put (Item => Float (BerechnungenNachZugendeAllerSpielerZeiten (2, WelcheZeit) - BerechnungenNachZugendeAllerSpielerZeiten (1, WelcheZeit)),
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            Get_Immediate (Item => Warten);
      end case;
            
      
   end BerechnungenNachZugendeAllerSpieler;



   procedure KIZeit (WelcheZeit : in Positive) is
   begin
      
      Anzeige.AnzeigeOhneAuswahlNeu (ÜberschriftDatei => GlobaleDatentypen.Leer,
                                     TextDatei        => GlobaleDatentypen.Ladezeiten,
                                     ÜberschriftZeile => 0,
                                     ErsteZeile       => WelcheZeit + AufschlagKIRechenzeit,
                                     LetzteZeile      => WelcheZeit + AufschlagKIRechenzeit,
                                     AbstandAnfang    => GlobaleDatentypen.Keiner,
                                     AbstandMitte     => GlobaleDatentypen.Keiner,
                                     AbstandEnde      => GlobaleDatentypen.Kleiner_Abstand);

      case WelcheZeit is
         when others =>
            Ada.Float_Text_IO.Put (Item => Float (KIZeiten (2, WelcheZeit) - KIZeiten (1, WelcheZeit)),
                                   Fore => 1,
                                   Aft  => 6,
                                   Exp  => 0);
            Get_Immediate (Item => Warten);
      end case;
      
   end KIZeit;

end Ladezeiten;
