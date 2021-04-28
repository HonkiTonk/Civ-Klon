pragma SPARK_Mode (On);

package KIDatentypen is

   type Einheit_Aufgabe_Enum is (Keine_Aufgabe, Stadt_Bauen, Flucht, Erkunden, Verbesserung_Anlegen, Angreifen, Verteidigen, Fertig);
   type Stadt_Aufgabe_Enum is (Keine_Aufgabe, Einheit_Bauen, Gebäude_Bauen);
   type Einheit_Befehl_Ermitteln_Enum is (Anfang, Stadt_Bauen, Einheit_Bewegen, Verbesserung, Einheit_Auflösen, Fliehen, Fertig);

   -- 1 = Norden = (-1, 0), 2 = Nord_Ost = (-1, 1), 3 = Osten = (0, 1), 4 = Süd_Osten = (1, 1), 5 = Süden = (1, 0), 6 = Süd_West = (1, -1), 7 = Westen = (0, -1), 8 = Nord_West = (-1, -1)
   type Richtung_Enum is (Beliebig, Norden, Nord_Ost, Osten, Süd_Ost, Süden, Süd_West, Westen, Nord_West);

end KIDatentypen;
