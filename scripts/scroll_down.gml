/*
scroll_down(amount)

scrolls down in the file list by the number of times specified in the argument
*/
var add;
add=0

/*switch typeview
 {
 case TYPE_TEX:
 if (ds_list_find_value(types,startpos_top)<>TYPE_15P1TX) && (ds_list_find_value(types,startpos_top)<>TYPE_14P2TX)
  {
  for (i=0; i<9999; i+=1)
   {
   add+=1
   if (ds_list_find_value(types,(startpos_top+i))=TYPE_15P1TX) || (ds_list_find_value(types,startpos_top+i)=TYPE_14P2TX)
    {
    break
    }
   }
  }
 break

 case TYPE_WOR:
 if (ds_list_find_value(types,startpos_top)<>TYPE_TRACK)
  {
  for (i=0; i<9999; i+=1)
   {
   add+=1
   if (ds_list_find_value(types,(startpos_top+i))=TYPE_TRACK)
    {
    break
    }
   }
  }
 break

 case TYPE_MDL:
 if (ds_list_find_value(types,startpos_top)<>TYPE_MODEL)
  {
  for (i=0; i<9999; i+=1)
   {
   add+=1
   if (ds_list_find_value(types,(startpos_top+i))=TYPE_MODEL)
    {
    break
    }
   }
  }
 break
 }*/

repeat(argument0+add)
 {
 if (startpos_top+(numtodisplay))<files[typeview]
  {
  startpos_top+=1
  }
 }
