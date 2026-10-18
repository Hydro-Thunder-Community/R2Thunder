#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
mouseon=0
col[0]=c_green
col[1]=c_lime
#define Step_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if instance_exists(obj_contrbutton)
 {
 exit
 }

if (mouse_x>=x && mouse_x<=x+sprite_get_width(sprite_index)) && (mouse_y>=y && mouse_y<=y+sprite_get_height(sprite_index))
 {
 mouseon=1
 if (mouse_check_button_pressed(mb_left))
  {
  event_user(0)
  }
 }
else
 {
 mouseon=0
 }

if keyboard_check(vk_control) && keyboard_check_pressed(vk_right)
 {
 event_user(2)
 }

if keyboard_check(vk_control) && keyboard_check_pressed(vk_left)
 {
 event_user(3)
 }
#define Other_10
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
switch obj_main.screen
 {
 case SCR_R2OPEN:
 with obj_main
  {
  var searchstr,strreturn;
  strreturn=-1
  searchstr=get_string("Enter the asset name to search for.",searchmemory)
  searchmemory=searchstr

  if string_length(searchstr)=11
   {
   strreturn=ds_list_find_index(names[typeview],searchstr)
   }
  else
   {
   for (i=0; i<files[typeview]; i+=1)
    {
    var compare, pos, length;
    pos=0
    length=string_length(searchstr)
    compare[0]=string_copy(ds_list_find_value(names[typeview],i),pos,length)
    compare[1]=string_copy(ds_list_find_value(names[typeview],i),pos+1,length)
    compare[2]=string_copy(ds_list_find_value(names[typeview],i),pos+2,length)
    compare[3]=string_copy(ds_list_find_value(names[typeview],i),pos+3,length)
    compare[4]=string_copy(ds_list_find_value(names[typeview],i),pos+4,length)
    compare[5]=string_copy(ds_list_find_value(names[typeview],i),pos+5,length)
    compare[6]=string_copy(ds_list_find_value(names[typeview],i),pos+6,length)
    compare[7]=string_copy(ds_list_find_value(names[typeview],i),pos+7,length)
    compare[8]=string_copy(ds_list_find_value(names[typeview],i),pos+8,length)
    compare[9]=string_copy(ds_list_find_value(names[typeview],i),pos+9,length)
    compare[10]=string_copy(ds_list_find_value(names[typeview],i),pos+10,length)

    if compare[0]=searchstr || compare[1]=searchstr || compare[2]=searchstr || compare[3]=searchstr || compare[4]=searchstr || compare[5]=searchstr || compare[6]=searchstr || compare[7]=searchstr || compare[8]=searchstr || compare[9]=searchstr || compare[10]=searchstr
     {
     strreturn=i //ds_list_find_index(filenum[typeview],i)
     //show_message(string(strreturn))
     break
     }
    }
   }

  if strreturn!=-1
   {
   startpos_top=strreturn
   foundentry=strreturn
   if startpos_top>(entries-numtodisplay)
    {
    startpos_top=(entries-numtodisplay)
    }
   }
  }
 break
 }
#define Other_11
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
switch obj_main.screen
 {
 case SCR_R2OPEN:
 with obj_main
  {
  var searchstr, strreturn, numb;
  searchstr=get_string("Enter the file number to go to.",filenummemory)
  filenummemory=searchstr

  if !(is_real(searchstr))
   {
   show_message("Not a number!")
   exit
   }

  searchstr=real(searchstr)


  for(i=0; i<3; i+=1)
   {
   numb=ds_list_find_index(filenum[typeview],searchstr)

   if i=2
    {
    if numb=-1
     {
     i=0
     searchstr-=1
     }
    }
   }

  if searchstr>0
   {
   if searchstr>files[typeview]
    {
    searchstr=files[typeview]
    }
   startpos_top=(numb)
   if startpos_top>(files[typeview]-numtodisplay)
    {
    startpos_top=(files[typeview]-numtodisplay)
    if startpos_top<0
     {
     startpos_top=0
     }
    }
   foundentry=(numb)
   }
  }
 break
 }
#define Other_12
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
switch obj_main.screen
 {
 case SCR_R2OPEN:
 with obj_main
  {
  var searchstr,strreturn;
  strreturn=-1
  searchstr=searchmemory
  if searchstr=""
   {
   exit
   }
  if string_length(searchstr)=11
   {
   strreturn=ds_list_find_index(names[typeview],searchstr)
   }
  else
   {
   for (i=startpos_top+1; i<files[typeview]; i+=1)
    {
    var compare, pos, length;
    length=string_length(searchstr)
    pos=0
    compare[0]=string_copy(ds_list_find_value(names[typeview],i),pos,length)
    compare[1]=string_copy(ds_list_find_value(names[typeview],i),pos+1,length)
    compare[2]=string_copy(ds_list_find_value(names[typeview],i),pos+2,length)
    compare[3]=string_copy(ds_list_find_value(names[typeview],i),pos+3,length)
    compare[4]=string_copy(ds_list_find_value(names[typeview],i),pos+4,length)
    compare[5]=string_copy(ds_list_find_value(names[typeview],i),pos+5,length)
    compare[6]=string_copy(ds_list_find_value(names[typeview],i),pos+6,length)
    compare[7]=string_copy(ds_list_find_value(names[typeview],i),pos+7,length)
    compare[8]=string_copy(ds_list_find_value(names[typeview],i),pos+8,length)
    compare[9]=string_copy(ds_list_find_value(names[typeview],i),pos+9,length)
    compare[10]=string_copy(ds_list_find_value(names[typeview],i),pos+10,length)

    if compare[0]=searchstr || compare[1]=searchstr || compare[2]=searchstr || compare[3]=searchstr || compare[4]=searchstr || compare[5]=searchstr || compare[6]=searchstr || compare[7]=searchstr || compare[8]=searchstr || compare[9]=searchstr || compare[10]=searchstr
     {
     strreturn=i
     break
     }
    }
   }

  if strreturn!=-1
   {
   startpos_top=strreturn
   foundentry=strreturn
   if startpos_top>(entries-numtodisplay)
    {
    startpos_top=(entries-numtodisplay)
    }
   }
  }
 break
 }
#define Other_13
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
switch obj_main.screen
 {
 case SCR_R2OPEN:
 with obj_main
  {
  var searchstr,strreturn;
  strreturn=-1
  searchstr=searchmemory
  if searchstr=""
   {
   exit
   }
  if string_length(searchstr)=11
   {
   strreturn=ds_list_find_index(names[typeview],searchstr)
   }
  else
   {
   for (i=startpos_top-1; i>0; i-=1)
    {
    var compare, pos, length;
    length=string_length(searchstr)
    pos=0
    compare[0]=string_copy(ds_list_find_value(names[typeview],i),pos,length)
    compare[1]=string_copy(ds_list_find_value(names[typeview],i),pos+1,length)
    compare[2]=string_copy(ds_list_find_value(names[typeview],i),pos+2,length)
    compare[3]=string_copy(ds_list_find_value(names[typeview],i),pos+3,length)
    compare[4]=string_copy(ds_list_find_value(names[typeview],i),pos+4,length)
    compare[5]=string_copy(ds_list_find_value(names[typeview],i),pos+5,length)
    compare[6]=string_copy(ds_list_find_value(names[typeview],i),pos+6,length)
    compare[7]=string_copy(ds_list_find_value(names[typeview],i),pos+7,length)
    compare[8]=string_copy(ds_list_find_value(names[typeview],i),pos+8,length)
    compare[9]=string_copy(ds_list_find_value(names[typeview],i),pos+9,length)
    compare[10]=string_copy(ds_list_find_value(names[typeview],i),pos+10,length)

    if compare[0]=searchstr || compare[1]=searchstr || compare[2]=searchstr || compare[3]=searchstr || compare[4]=searchstr || compare[5]=searchstr || compare[6]=searchstr || compare[7]=searchstr || compare[8]=searchstr || compare[9]=searchstr || compare[10]=searchstr
     {
     strreturn=i
     break
     }
    }
   }

  if strreturn!=-1
   {
   startpos_top=strreturn
   foundentry=strreturn
   if startpos_top>(entries-numtodisplay)
    {
    startpos_top=(entries-numtodisplay)
    }
   }
  }
 break
 }
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_set_halign(fa_middle)

draw_sprite(sprite_index,mouseon,x,y)
switch obj_main.screen
 {
 case 1:
 draw_text_color(x+58,y+(sprite_height/8),"Find",col[mouseon],col[mouseon],col[mouseon],col[mouseon],1)
 break

 case 7:
 draw_text(x+58,y+6,"Back")
 break
 }

draw_set_halign(fa_left)
