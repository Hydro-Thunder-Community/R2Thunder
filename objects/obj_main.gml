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
r2sign[R2VER_ORIG]="James Cameron Rules"
r2sign[R2VER_WEAS]="Hydro Thunder Rules"
r2signindex=0
r2unpack=0
r2repack=0
r2merging=0
r2repack_max=0
r2repack_file=0
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

scroll_curpercent=0
scroll_maxpercentage=232
scroll_hold=0
scrbar_pos=29
scrolling=0

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
mes[MES_ABORTP]="Packing aborted."
mes[MES_EXPORT]="File exported."
mes[MES_PROCES]="Exporting file..."
mes[MES_PACKED]="R2 packed successfully."
mes[MES_ERROR1]="No files in directory!"
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
with(obj_unpackbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_repackbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_nextbutton)
 {
 event_perform(ev_create,0)
 }
with(obj_prevbutton)
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

if (keyboard_check(vk_alt) && keyboard_check(vk_f4))
 {
 game_end()
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
  if (files[typeview]-numtodisplay)>=0
   {
   startpos_top=(files[typeview]-numtodisplay)
   }
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

if message>0
 {
 draw_text(0,368,mes[cur_message])
 }

if (processing)
 {
 switch screen
  {
  case SCR_SPLASH:
  if (!exportall_mode) && (!r2repack) && (!r2merging)
   {
   draw_text(150,270,"Reading R2 directory and#checking file types...("+string(entry)+")")
   }
  else if (exportall_mode)
   {
   draw_text(0,368,"Exporting file "+string(exportall_file)+" of "+string(files[typeview])+"")
   }
  else if (r2repack)
   {
   draw_text(0,368,"Packing file "+string(r2repack_file)+" of "+string(r2repack_max)+"")
   }
  else if (r2merging)
   {
   draw_text(0,368,"Merging into final R2...")
   }
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
 draw_rectangle_color(0,0,512,306,c_black,c_black,c_black,c_black,false)
 if view=0
  {
  draw_text(0,0,"Name:        Size:    Type:           File:")
  }
 else
  {
  draw_text(0,0,"Name:        R2Type: Location:  RefTableEntr:")
  }

 var yposoffset, displayed, scrup_on, scrdown_on, scrbar_on, calcpos, divnum;
 yposoffset=0
 display=numtodisplay
 scrup_on=0
 scrdown_on=0
 scrbar_on=0
 divnum=files[typeview]-numtodisplay
 if divnum=0
  {
  divnum=1
  }
 calcpos=floor(29+startpos_top*(scroll_maxpercentage/(divnum)))
 scrbar_pos=calcpos

 if (!scrolling)
  {
  if (mouse_y>scrbar_pos && mouse_y<scrbar_pos+(sprite_get_height(spr_scrollbar))) && (mouse_x>482 && mouse_x<512)
   {
   scrbar_on=1
   if mouse_check_button(mb_left) && scroll_hold=0
    {
    scrolling=1
    }
   }
  else if (mouse_y>scrbar_pos+(sprite_get_height(spr_scrollbar) && mouse_y<482)) && (mouse_x>482 && mouse_x<512)
   {
   if mouse_check_button_pressed(mb_left) || scroll_hold>30
    {
    scroll_down(numtodisplay*(files[typeview]/1000))
    if scroll_hold>30
     {
     scroll_hold=26
     }
    }
   }
  else if (mouse_y<scrbar_pos && mouse_y>30) && (mouse_x>482 && mouse_x<512)
   {
   if mouse_check_button_pressed(mb_left) || scroll_hold>30
    {
    scroll_up(numtodisplay*(files[typeview]/1000))
    if scroll_hold>30
     {
     scroll_hold=26
     }
    }
   }
  if mouse_check_button(mb_left)
   {
   scroll_hold+=1
   }
  else
   {
   scroll_hold=0
   }
  }
 else if (scrolling)
  {
  scrbar_pos=mouse_y-7
  scrbar_on=1
  if scrbar_pos<28
   {
   scrbar_pos=28
   }
  else if scrbar_pos>261
   {
   scrbar_pos=261
   }

  if calcpos<>scrbar_pos
   {
   startpos_top=floor((scrbar_pos-30)*(files[typeview]/scroll_maxpercentage))

   if startpos_top>(files[typeview]-numtodisplay)
    {
    startpos_top=(files[typeview]-numtodisplay)
    }

   if startpos_top<0
    {
    startpos_top=0
    }

   //calcpos=floor(29+startpos_top*(scroll_maxpercentage/(files[typeview]-numtodisplay)))
   if !mouse_check_button(mb_left)
    {
    scrolling=0
    scrbar_on=0
    }
   }
  }

  if (scrolling) && !mouse_check_button(mb_left)
   {
   scrolling=0
   scrbar_on=0
   }

 if (mouse_y>0 && mouse_y<30) && (mouse_x>482 && mouse_x<512) && (!scrolling)
  {
  scrup_on=1
  if mouse_check_button_pressed(mb_left) || scroll_hold>30
   {
   scroll_up(numtodisplay)
   if scroll_hold>30
    {
    scroll_hold=25
    }
   }
  }

 if (mouse_y>276 && mouse_y<306) && (mouse_x>482 && mouse_x<512) && (!scrolling)
  {
  scrdown_on=1
  if mouse_check_button_pressed(mb_left) || scroll_hold>30
   {
   scroll_down(numtodisplay)
   if scroll_hold>30
    {
    scroll_hold=25
    }
   }
  }

 draw_sprite(spr_scrollbar,scrbar_on,482,scrbar_pos)
 draw_sprite(spr_scrolltri,scrup_on,482,0)
 draw_sprite_ext(spr_scrolltri,scrdown_on,482,306,1,-1,0,c_white,1)

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

  if (mouse_y>ypos-yposoffset && mouse_y<(ypos+12-yposoffset) && mouse_x>=xpos && mouse_x<xpos+482) && (!instance_exists(obj_contrbutton)) && ((startpos_top+i)<files[typeview]) && (!scrolling)
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
    draw_text_color(xpos+231,ypos-yposoffset,locdraw,col,col,col,col,1)
    draw_text_color(xpos+352,ypos-yposoffset,tabledraw,col,col,col,col,1)
    }
    draw_text_color(xpos,ypos-yposoffset,namedraw,col,col,col,col,1)
   }
  }
 yposoffset=0
 }
