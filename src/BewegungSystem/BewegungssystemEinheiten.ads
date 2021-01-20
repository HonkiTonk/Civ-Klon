with Ada.Wide_Wide_Text_IO, Ada.Wide_Wide_Characters.Handling;
use Ada.Wide_Wide_Text_IO, Ada.Wide_Wide_Characters.Handling;

with SchleifenPruefungen, GlobaleDatentypen, GlobaleVariablen, KartenDatenbank, Karten, Karte, EinheitenDatenbank, Kampfsystem, Diplomatie, Auswahl, Sichtbarkeit, GlobaleRecords;
use GlobaleDatentypen;

package BewegungssystemEinheiten is

   procedure BewegungEinheitenRichtung (RasseExtern : GlobaleDatentypen.Rassen; EinheitNummer : in Integer) with
     Pre => EinheitNummer > 0;
   
private

   Angreifen : Boolean;
   Gewonnen : Boolean;

   Richtung : Wide_Wide_Character;
      
   XÄnderung : GlobaleDatentypen.LoopRangeMinusEinsZuEins;
   YÄnderung : GlobaleDatentypen.LoopRangeMinusEinsZuEins;
   
   Wahl : Integer;
   BereitsImKrieg : Integer;

   Stadtnummer : Integer;

   KartenWert : GlobaleRecords.AchsenAusKartenfeld;
   GegnerEinheitWert : GlobaleRecords.RasseUndPlatznummerRecord;
   GegnerStadtWert : GlobaleRecords.RasseUndPlatznummerRecord;
   
   procedure BewegungEinheitenBerechnung (RasseExtern : in GlobaleDatentypen.Rassen; EinheitNummer : in Integer; YÄnderung, XÄnderung : in GlobaleDatentypen.LoopRangeMinusEinsZuEins) with
     Pre => (YÄnderung /= 0 or XÄnderung /= 0) and EinheitNummer > 0;

end BewegungssystemEinheiten;
