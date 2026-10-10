#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
name="R2Thunder"
set_application_title(name)

view=0
processing=0
mov_up=0
mov_down=0

tempstring="here"

currentfile=0
r2target=0
r2file[0]="No R2 selected"
r2file[1]=""
entry=0
byte=0
entries=0
createdlist=0
names=0
locations=0
sizes=0
tables=0
types=0
types2=0
foundentry=-1

numboftypes=7
TYPE_ALL=0
TYPE_TEX=1
TYPE_MDL=2
TYPE_ANI=3
TYPE_SND=4
TYPE_WOR=5
TYPE_PHY=6
TYPE_DEM=7
typeview=TYPE_ALL

files[TYPE_ALL]=0
files[TYPE_TEX]=0
files[TYPE_MDL]=0
files[TYPE_ANI]=0
files[TYPE_SND]=0
files[TYPE_WOR]=0
files[TYPE_PHY]=0
files[TYPE_DEM]=0

cur_message=0
mes[MES_CLOSED]="Closed R2."
mes[MES_ABORTD]="Export aborted."
mes[MES_EXPORT]="File exported."
mes[MES_PROCES]="Exporting file..."
message=0

type[0]=""
type[TYPE_15P1TX]="1555 Texture"
type[TYPE_14P2TX]="4444 Texture"
type[TYPE_TRACK]="World Data"
type[TYPE_MODEL]="Model Data"
type[TYPE_DCPVR]="Dreamcast PVR"
type[TYPE_ANIM]="Animation Data"
type[TYPE_PHYS]="Physics Params"
type[TYPE_SOUND]="Sound Data"
type[TYPE_UNKWN]="Unknown File"
type[TYPE_DEMO]="Demo Reel Data"

searchmemory=""
filenummemory=""

startpos_top=0
numtodisplay=22

button_x=15
button_y=5

cont=""

screen=SCR_SPLASH

EXPORTALL_PREFERCONV=1
EXPORTALL_PREFERRAW=2
exportall_file=0
exportall_dir=""
exportall_mode=0

//these have to be here or the create event gets ignored upon their re-activation, which will cause many code errors
with(obj_closbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_searcbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_switchbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_viewbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_exportbutton)
 {
 event_perform(ev_create,0)
 }

swap_screen(SCR_SPLASH)
#define Step_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if keyboard_check_released(vk_pagedown)
 {
 mov_down=0
 }

if keyboard_check_released(vk_pageup)
 {
 mov_up=0
 }

if keyboard_check(vk_pagedown)
 {
 mov_down+=1
 }

if keyboard_check(vk_pageup)
 {
 mov_up+=1
 }

if message>0
 {
 message-=1
 }

if (keyboard_check(ord("F")) && keyboard_check(vk_control))
 {
 with (obj_searcbutton)
  {
  event_user(0)
  }
 }

if (keyboard_check(ord("G")) && keyboard_check(vk_control))
 {
 with obj_searcbutton
  {
  event_user(1)
  }
 }

if (createdlist)
 {
 if keyboard_check_pressed(vk_pagedown) || mov_down=30
  {
  scroll_down(numtodisplay)
  if mov_down=30
   {
   mov_down=26
   }
  }

 if keyboard_check_pressed(vk_pageup) || mov_up=30
  {
  scroll_up(numtodisplay)
  if mov_up=30
   {
   mov_up=26
   }
  }

 if keyboard_check_pressed(vk_home)
  {
  startpos_top=0
  }

 if keyboard_check_pressed(vk_end)
  {
  startpos_top=(files[typeview]-numtodisplay)
  }


 if mouse_wheel_down()
  {
  scroll_down(5)
  }

 else if mouse_wheel_up()
  {
  scroll_up(5)
  }
 }
#define Other_30
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
game_end()
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_set_font(font0)
draw_set_color(c_lime)

draw_text(0,368,r2file[r2target])
//draw_text(100,150,tempstring)

if message>0
 {
 draw_text(0,368,mes[cur_message])
 }

if (processing)
 {
 switch screen
  {
  case SCR_SPLASH:
  draw_text(150,270,"Reading R2 directory...("+string(entry)+")")
  //draw_text(150,270,"Reading R2 directory...")
  break

  case SCR_R2OPEN:
  draw_text(0,368,"Exporting file "+string(exportall_file)+" of "+string(files[typeview])+"")
  break
  }
 }

if (processing)
 {
 exit
 }

switch screen
 {
 case SCR_SPLASH:
 draw_sprite(spr_splash,0,140,140)
 draw_text(150,202,"AxlThunder's Thunder Hacker#Version: 0.5")
 break
 }


if (createdlist)
 {
 draw_rectangle_color(1,0,511,305,c_black,c_black,c_black,c_black,false)
 if view=0
  {
  draw_text(0,0,"Name:        Size:    Type:           FileNum:")
  }
 else
  {
  draw_text(0,0,"Name:        R2Type:  Location:  RefTableEntr:")
  }
 var yposoffset, displayed;
 yposoffset=0
 display=numtodisplay
 for (i=0; i<display; i+=1)
  {
  var namedraw, sizedraw, locdraw, type2draw, tabledraw, typedraw, xpos, ypos, yposoffset, col;
  xpos=0
  ypos=15+(13*i)
  namedraw=ds_list_find_value(names[typeview],startpos_top+i)
  sizedraw=ds_list_find_value(sizes[typeview],startpos_top+i)
  typedraw=ds_list_find_value(types[typeview],startpos_top+i)
  type2draw=ds_list_find_value(types2[typeview],startpos_top+i)
  locdraw=ds_list_find_value(locations[typeview],startpos_top+i)
  tabledraw=ds_list_find_value(tables[typeview],startpos_top+i)
  filedraw=ds_list_find_value(filenum[typeview],startpos_top+i)
  /*switch typeview
   {
   case TYPE_TEX:
   if typedraw<>TYPE_15P1TX && typedraw<>TYPE_14P2TX
    {
    yposoffset+=13
    if (startpos_top+i)<entries
     {
     display+=1
     }
    continue
    }
   break

   case TYPE_WOR:
   if typedraw<>TYPE_TRACK
    {
    yposoffset+=13
    if (startpos_top+i)<entries
     {
     display+=1
     }
    continue
    }
   break

   case TYPE_MDL:
   if typedraw<>TYPE_MODEL
    {
    yposoffset+=13
    if (startpos_top+i)<entries
     {
     display+=1
     }
    continue
    }
   break
   }*/

  if (mouse_y>ypos-yposoffset && mouse_y<(ypos+12-yposoffset) && mouse_x>=xpos && mouse_x<xpos+512) && (!instance_exists(obj_contrbutton)) && ((startpos_top+i)<files[typeview])
   {
   if foundentry=(startpos_top+i)
    {
    foundentry=-1
    }
   col=c_lime
   if mouse_check_button_pressed(mb_left)
    {
    var q;
    q=show_message_ext(namedraw+"#Size: "+string(sizedraw)+"#FileNum: "+string(1+(filedraw))+"#Type: "+string(type[typedraw])+"#R2FileType: "+string(type2draw)+"#Location: "+string(locdraw)+"#RefTableEntries: "+string(tabledraw)+"##What do you wish to do with this asset?","Extract","","Go back")
    if q=1
     {
     r2_extract(namedraw,typedraw,type2draw,locdraw,sizedraw,tabledraw)
     }
    }
   }
  else
   {
   col=c_green
   }

  if foundentry=(startpos_top+i)
   {
   col=c_red
   }
  if (startpos_top+i)<files[typeview]
   {
   if view=0
    {
    draw_text_color(xpos+142,ypos-yposoffset,sizedraw,col,col,col,col,1)
    draw_text_color(xpos+242,ypos-yposoffset,type[typedraw],col,col,col,col,1)
    draw_text_color(xpos+416,ypos-yposoffset,1+(filedraw),col,col,col,col,1)
    }
   else
    {
    draw_text_color(xpos+142,ypos-yposoffset,type2draw,col,col,col,col,1)
    draw_text_color(xpos+241,ypos-yposoffset,locdraw,col,col,col,col,1)
    draw_text_color(xpos+362,ypos-yposoffset,tabledraw,col,col,col,col,1)
    }
    draw_text_color(xpos,ypos-yposoffset,namedraw,col,col,col,col,1)
   }
  }
 yposoffset=0
 }
