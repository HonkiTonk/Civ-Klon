package body Eingabe is

   function GanzeZahl return Integer is -- Als String mit Längenbegrenzung, wozu auch Unbounded? Hier direkt eine Fehlermeldung einbauen, bei der Eingabe ungültiger Werte?
   begin

      Zahl := To_Unbounded_Wide_Wide_String (Source => Get_Line);
      If To_Wide_Wide_String (Source => Zahl)'Length = 0 then
         return -1;
         
      else
         null;
      end if;
      
      for A in To_Wide_Wide_String (Source => Zahl)'Range loop
         if To_Wide_Wide_String (Source => Zahl) (A) = '0' or To_Wide_Wide_String (Source => Zahl) (A) = '1' or To_Wide_Wide_String (Source => Zahl) (A) = '2' or To_Wide_Wide_String (Source => Zahl) (A) = '3'
           or To_Wide_Wide_String (Source => Zahl) (A) = '4' or To_Wide_Wide_String (Source => Zahl) (A) = '5' or To_Wide_Wide_String (Source => Zahl) (A) = '6' or To_Wide_Wide_String (Source => Zahl) (A) = '7'
           or To_Wide_Wide_String (Source => Zahl) (A) = '8' or To_Wide_Wide_String (Source => Zahl) (A) = '9' then
            null;
         else
            return -1;
         end if;
      end loop;
      
      return Integer'Wide_Wide_Value (To_Wide_Wide_String (Source => Zahl));
      
   end GanzeZahl;

   

   function StadtName return Unbounded_Wide_Wide_String is
   begin
      
      Put_Line (Item => To_Wide_Wide_String (Source => GlobaleVariablen.TexteEinlesen (19, 32)));
      Name := To_Unbounded_Wide_Wide_String (Source => Get_Line);
      
      return Name;
      
   end StadtName;



   function SpielstandName return Unbounded_Wide_Wide_String is
   begin            
      
      Put_Line (Item => To_Wide_Wide_String (Source => GlobaleVariablen.TexteEinlesen (19, 40)));
      Name := To_Unbounded_Wide_Wide_String (Source => Get_Line);
      
      return Name;
      
   end SpielstandName;

end Eingabe;
