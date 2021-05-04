pragma SPARK_Mode (On);

with Karten;

package body KarteneigenschaftSuchen is

   function KartenGrundEinheitSuchen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleDatentypen.KartenGrund
   is begin

      Grund := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.EAchse,
                                 GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.YAchse,
                                 GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.XAchse).Grund;
      
      return Grund;
      
   end KartenGrundEinheitSuchen;



   function KartenFlussEinheitSuchen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleDatentypen.KartenGrund
   is begin

      Fluss := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.EAchse,
                                 GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.YAchse,
                                 GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.XAchse).Fluss;
      
      return Fluss;
      
   end KartenFlussEinheitSuchen;
   
   

   function KartenStraßeEinheitSuchen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleDatentypen.KartenVerbesserung
   is begin

      Straße := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.EAchse,
                                   GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.YAchse,
                                   GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.XAchse).VerbesserungStraße;
      
      return Straße;
      
   end KartenStraßeEinheitSuchen;
   
   

   function KartenVerbesserungEinheitSuchen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleDatentypen.KartenVerbesserung
   is begin

      Verbesserung := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.EAchse,
                                        GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.YAchse,
                                        GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.XAchse).VerbesserungGebiet;
      
      return Verbesserung;
      
   end KartenVerbesserungEinheitSuchen;
   
   

   function KartenRessourceEinheitSuchen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleDatentypen.KartenGrund
   is begin

      Ressource := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.EAchse,
                                     GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.YAchse,
                                     GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.XAchse).Ressource;
      
      return Ressource;
      
   end KartenRessourceEinheitSuchen;
   
   
   
   function KartenBelegterGrundEinheitSuchen
     (EinheitRasseNummerExtern : in GlobaleRecords.RassePlatznummerRecord)
      return GlobaleDatentypen.BelegterGrund
   is begin

      BelegterStadtGrund := Karten.Weltkarte (GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.EAchse,
                                              GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.YAchse,
                                              GlobaleVariablen.EinheitenGebaut (EinheitRasseNummerExtern.Rasse, EinheitRasseNummerExtern.Platznummer).AchsenPosition.XAchse).DurchStadtBelegterGrund;
      
      return BelegterStadtGrund;
      
   end KartenBelegterGrundEinheitSuchen;

end KarteneigenschaftSuchen;
