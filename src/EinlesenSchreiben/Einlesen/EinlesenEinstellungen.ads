pragma SPARK_Mode (On);

with Ada.Streams.Stream_IO;
use Ada.Streams.Stream_IO;

package EinlesenEinstellungen is

   procedure EinlesenEinstellungen;
   
private   
      
   DateiEinstellungenEinlesen : File_Type;

end EinlesenEinstellungen;
