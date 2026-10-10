/*
ping_message(messageid)

pings obj_main to display a message for 3 seconds, based on the id given. which is a global constant
*/
with obj_main
 {
 cur_message=argument0
 if argument0=MES_OPENED
  {
  mes[MES_OPENED]="James Cameron Rules! "+string(entries)+" entries."
  }
 else if argument0=MES_TFILES
  {
  mes[MES_TFILES]=""+string(files[typeview])+" files of this type."
  }
 message=180
 }
