pragma SPARK_Mode (On);

with Ada.Strings.Wide_Wide_Unbounded;
use Ada.Strings.Wide_Wide_Unbounded;

with GlobaleDatentypen, GlobaleRecords, GlobaleVariablen;
use GlobaleDatentypen, GlobaleRecords;

with Karten;

package StadtSuchen is
   
   function KoordinatenStadtMitRasseSuchen
     (RasseExtern : in GlobaleDatentypen.Rassen;
      KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return GlobaleDatentypen.MaximaleStädteMitNullWert
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße
          and
            GlobaleVariablen.RassenImSpiel (RasseExtern) /= 0);
   
   function KoordinatenStadtOhneRasseSuchen
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return GlobaleRecords.RassePlatznummerRecord
     with
       Pre  =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if KoordinatenStadtOhneRasseSuchen'Result.Rasse > 0 then GlobaleVariablen.RassenImSpiel (KoordinatenStadtOhneRasseSuchen'Result.Rasse) /= 0));

   function KoordinatenStadtOhneSpezielleRasseSuchen
     (RasseExtern : in GlobaleDatentypen.Rassen;
      KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord)
      return GlobaleRecords.RassePlatznummerRecord
     with
       Pre  =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße
          and
            GlobaleVariablen.RassenImSpiel (RasseExtern) /= 0),
         Post =>
           ((if KoordinatenStadtOhneSpezielleRasseSuchen'Result.Rasse > 0 then GlobaleVariablen.RassenImSpiel (KoordinatenStadtOhneSpezielleRasseSuchen'Result.Rasse) /= 0));
   
   function AnzahlStädteErmitteln
     (RasseExtern : in GlobaleDatentypen.Rassen)
      return Natural
     with
       Pre =>
         (GlobaleVariablen.RassenImSpiel (RasseExtern) /= 0);
   
   function StadtNachNamenSuchen
     return GlobaleRecords.RassePlatznummerRecord;

private
   
   AnzahlStädte : Natural;
   
   StadtName : Unbounded_Wide_Wide_String;

end StadtSuchen;
