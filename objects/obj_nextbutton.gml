#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
mouseon=0
fade=1
col[0]=c_green
col[1]=c_lime
#define Step_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if instance_exists(obj_contrbutton) || obj_main.searchmemory=""
 {
 fade=0.5
 exit
 }
else
 {
 fade=1
 }

if (mouse_x>=x+1 && mouse_x<=x+sprite_get_width(sprite_index)) && (mouse_y>=y && mouse_y<=y+sprite_get_height(sprite_index))
 {
 mouseon=1
 if (mouse_check_button_pressed(mb_left))
  {
  with (obj_searcbutton)
   {
   event_user(2)
   }
  }
 }
else
 {
 mouseon=0
 }
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_set_halign(fa_middle)

draw_sprite_ext(sprite_index,mouseon,x,y,1,1,0,c_white,fade)
switch obj_main.screen
 {
 case 1:
 draw_text_color(x+28,y+(sprite_height/8),"Next",col[mouseon],col[mouseon],col[mouseon],col[mouseon],1)
 break

 case 7:
 draw_text(x+58,y+6,"Back")
 break
 }

draw_set_halign(fa_left)
