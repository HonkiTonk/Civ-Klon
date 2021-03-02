pragma SPARK_Mode (On);

with GlobaleDatentypen, DatenbankRecords;
use GlobaleDatentypen;

package VerbesserungenDatenbank is

   LeererWertVerbesserungListe : constant DatenbankRecords.VerbesserungListeRecord := (' ', -- 1. Wert = VerbesserungGrafik
                                                                                       13, -- 2. Wert = Passierbarkeit
                                                                                       0, 0, 0, 0, 0); -- 3. Wert = Nahrungsbonus, 4. Wert = Ressourcenbonus, 5. Wert = Geldbonus, 6. Wert = Wissensbonus,
                                                                                                       -- 7. Wert = Verteidigungsbonus
      
   -- 1 = Cursor kann passieren, 2 = Wassereinheiten können passieren, 4 = Landeinheiten können passieren, 8 = Lufteinheiten können passieren
   -- Addieren für genaue Passierbarkeit
   type VerbesserungListeArray is array (GlobaleDatentypen.KartenVerbesserung'Range) of DatenbankRecords.VerbesserungListeRecord;
   VerbesserungListe : VerbesserungListeArray := (LeererWertVerbesserungListe, -- Nullwert, notwendig da sonst das Aufrechnen der Stadtwerte nicht funktioniert.
                                                  ('♣',    13,    0, 0, 0, 0, 3), -- 1 Eigene Hauptstadt
                                                  ('♠',    13,    0, 0, 0, 0, 2), -- 2 Eigene Stadt
                                                  ('⌂',    13,    0, 0, 0, 0, 3), -- 3 Andere Hauptstadt
                                                  ('¤',    13,    0, 0, 0, 0, 2), -- 4 Andere Stadt
                                                  ('╬',    13,    0, 0, 1, 0, 0), -- 5 Straßenkreuzung
                                                  ('═',    13,    0, 0, 1, 0, 0), -- 6 Straße waagrecht
                                                  ('║',    13,    0, 0, 1, 0, 0), -- 7 Straße senkrecht
                                                  ('╔',    13,    0, 0, 1, 0, 0), -- 8 Straßenkurve
                                                  ('╗',    13,    0, 0, 1, 0, 0), -- 9 Straßenkurve

                                                  ('╚',    13,    0, 0, 1, 0, 0), -- 10 Straßenkurve
                                                  ('╝',    13,    0, 0, 1, 0, 0), -- 11 Straßenkurve
                                                  ('╩',    13,    0, 0, 1, 0, 0), -- 12 Straßenkreuzung
                                                  ('╦',    13,    0, 0, 1, 0, 0), -- 13 Straßenkreuzung

                                                  ('╠',    13,    0, 0, 1, 0, 0), -- 14 Straßenkreuzung
                                               
                                                  ('╣',    13,    0, 0, 1, 0, 0), -- 15 Straßenkreuzung
                                                  ('╞',    13,    0, 0, 1, 0, 0), -- 16 Straßenendstück links
                                                  ('╡',    13,    0, 0, 1, 0, 0), -- 17 Straßenendstück rechts
                                                  ('╨',    13,    0, 0, 1, 0, 0), -- 18 Straßenendstück unten
                                                  ('╥',    13,    0, 0, 1, 0, 0), -- 19 Straßenendstück oben
                                                  ('F',    13,    2, 0, 1, 0, 1), -- 20 Farm
                                                  ('M',    13,    0, 2, 1, 0, 1), -- 21 Mine
                                                  ('B',    13,    0, 0, 0, 0, 2), -- 22 Festung
                                                  ('S',    9,    0, 0, 0, 0, 0)); -- 23 Sperre

   procedure Beschreibung (ID : in GlobaleDatentypen.KartenVerbesserung) with
     Pre => (ID > 0);
   
end VerbesserungenDatenbank;
