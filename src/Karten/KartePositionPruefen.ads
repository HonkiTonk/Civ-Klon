pragma SPARK_Mode (On);

with GlobaleRecords, GlobaleDatentypen;
use GlobaleDatentypen;

with Karten;
use Karten;

package KartePositionPruefen is
   
   function KartenPositionBestimmen
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionBestimmen'Result.YAchse = 0
                        then
                          KartenPositionBestimmen'Result.XAchse = 0)
            and
              (if
                         KartenPositionBestimmen'Result.XAchse = 0
                           then
                             KartenPositionBestimmen'Result.YAchse = 0)
            and
              KartenPositionBestimmen'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionBestimmen'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);

private
   
   type PositionArray is array (GlobaleDatentypen.EbeneVorhanden'Range) of GlobaleRecords.AchsenKartenfeldPositivRecord;
   type PositionFeldArray is array (GlobaleDatentypen.EbeneVorhanden'Range) of GlobaleDatentypen.Kartenfeld;
   type ÜberhangArray is array (GlobaleDatentypen.EbeneVorhanden'Range) of Integer;
      
   PolYAchse : PositionFeldArray;
   PolXAchse : PositionFeldArray;
   
   ZwischenPositionAchse : PositionArray;
   
   ÜberhangYAchse : ÜberhangArray;
   ÜberhangXAchse : ÜberhangArray;
   
   
   type ÄnderungArray is array (GlobaleDatentypen.EbeneVorhanden'Range) of GlobaleDatentypen.Kartenfeld;
   
   EAchse : ÄnderungArray;
   YAchse : ÄnderungArray;
   XAchse : ÄnderungArray;   
   
   function KartenPositionXZylinder
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionXZylinder'Result.YAchse = 0
                        then
                          KartenPositionXZylinder'Result.XAchse = 0)
            and
              (if
                         KartenPositionXZylinder'Result.XAchse = 0
                           then
                             KartenPositionXZylinder'Result.YAchse = 0)
            and
              KartenPositionXZylinder'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionXZylinder'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function KartenPositionYZylinder
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionYZylinder'Result.YAchse = 0
                        then
                          KartenPositionYZylinder'Result.XAchse = 0)
            and
              (if
                         KartenPositionYZylinder'Result.XAchse = 0
                           then
                             KartenPositionYZylinder'Result.YAchse = 0)
            and
              KartenPositionYZylinder'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionYZylinder'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function KartenPositionTorus
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionTorus'Result.YAchse = 0
                        then
                          KartenPositionTorus'Result.XAchse = 0)
            and
              (if
                         KartenPositionTorus'Result.XAchse = 0
                           then
                             KartenPositionTorus'Result.YAchse = 0)
            and
              KartenPositionTorus'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionTorus'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function KartenPositionKugel
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionKugel'Result.YAchse = 0
                        then
                          KartenPositionKugel'Result.XAchse = 0)
            and
              (if
                         KartenPositionKugel'Result.XAchse = 0
                           then
                             KartenPositionKugel'Result.YAchse = 0)
            and
              KartenPositionKugel'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionKugel'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function KartenPositionViereck
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionViereck'Result.YAchse = 0
                        then
                          KartenPositionViereck'Result.XAchse = 0)
            and
              (if
                         KartenPositionViereck'Result.XAchse = 0
                           then
                             KartenPositionViereck'Result.YAchse = 0)
            and
              KartenPositionViereck'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionViereck'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function KartenPositionKugelGedreht
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           ((if
                      KartenPositionKugelGedreht'Result.YAchse = 0
                        then
                          KartenPositionKugelGedreht'Result.XAchse = 0)
            and
              (if
                         KartenPositionKugelGedreht'Result.XAchse = 0
                           then
                             KartenPositionKugelGedreht'Result.YAchse = 0)
            and
              KartenPositionKugelGedreht'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              KartenPositionKugelGedreht'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function PositionBestimmenEAchseFest
     (EAchseExtern : in GlobaleDatentypen.EbeneVorhanden;
      ÄnderungEAchseExtern : in GlobaleDatentypen.EbeneVorhanden)
      return GlobaleDatentypen.Ebene;
   
   function PositionBestimmenYAchseFest
     (YAchseExtern : in GlobaleDatentypen.KartenfeldPositiv;
      ÄnderungYAchseExtern : in GlobaleDatentypen.Kartenfeld)
      return GlobaleDatentypen.KartenfeldPositivMitNullwert
     with
       Pre =>
         (YAchseExtern <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße),
         Post =>
           (PositionBestimmenYAchseFest'Result <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße);
   
   function PositionBestimmenXAchseFest
     (XAchseExtern : in GlobaleDatentypen.KartenfeldPositiv;
      ÄnderungXAchseExtern : in GlobaleDatentypen.Kartenfeld)
      return GlobaleDatentypen.KartenfeldPositivMitNullwert
     with
       Pre =>
         (XAchseExtern <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           (PositionBestimmenXAchseFest'Result <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);

   function PositionBestimmenXWechsel
     (XAchseExtern : in GlobaleDatentypen.KartenfeldPositiv;
      ÄnderungXAchseExtern : in GlobaleDatentypen.Kartenfeld;
      ArrayPositionExtern : in GlobaleDatentypen.EbeneVorhanden)
      return GlobaleDatentypen.KartenfeldPositiv
     with
       Pre =>
         (XAchseExtern <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           (PositionBestimmenXWechsel'Result <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);

   function PositionBestimmenYWechsel
     (YAchseExtern : in GlobaleDatentypen.KartenfeldPositiv;
      ÄnderungYAchseExtern : in GlobaleDatentypen.Kartenfeld;
      ArrayPositionExtern : in GlobaleDatentypen.EbeneVorhanden)
      return GlobaleDatentypen.KartenfeldPositiv
     with
       Pre =>
         (YAchseExtern <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße),
         Post =>
           (PositionBestimmenYWechsel'Result <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße);
   
   function PositionBestimmen_Y_X_Wechsel
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           (PositionBestimmen_Y_X_Wechsel'Result.YAchse > 0
            and
              PositionBestimmen_Y_X_Wechsel'Result.XAchse > 0
            and
              PositionBestimmen_Y_X_Wechsel'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              PositionBestimmen_Y_X_Wechsel'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);
   
   function PositionBestimmen_X_Y_Wechsel
     (KoordinatenExtern : in GlobaleRecords.AchsenKartenfeldPositivRecord;
      ÄnderungExtern : in GlobaleRecords.AchsenKartenfeldRecord)
      return GlobaleRecords.AchsenKartenfeldPositivRecord
     with
       Pre =>
         (KoordinatenExtern.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
          and
            KoordinatenExtern.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße),
         Post =>
           (PositionBestimmen_X_Y_Wechsel'Result.YAchse > 0
            and
              PositionBestimmen_X_Y_Wechsel'Result.XAchse > 0
            and
              PositionBestimmen_X_Y_Wechsel'Result.YAchse <= Karten.Kartengrößen (Karten.Kartengröße).YAchsenGröße
            and
              PositionBestimmen_X_Y_Wechsel'Result.XAchse <= Karten.Kartengrößen (Karten.Kartengröße).XAchsenGröße);

end KartePositionPruefen;
