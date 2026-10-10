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
 if mouse_check_button_pressed(mb_left)
  {
  var g;
  g=get_open_filename("Hydro Thunder R2 files|*.r2","")
  if file_exists(g)
   {
   with (obj_main)
    {
    r2_open(g)
    }
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

draw_sprite(sprite_index,mouseon,x,y)
draw_text_color(x+58,y+(sprite_height/8),"Open R2",col[mouseon],col[mouseon],col[mouseon],col[mouseon],1)

draw_set_halign(fa_left)
