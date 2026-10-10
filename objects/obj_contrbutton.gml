#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/

choices=7
choice[0]="All"
choice[1]="Textures"
choice[2]="Models"
choice[3]="Anim Data"
choice[4]="Sound Data"
choice[5]="World Data"
choice[6]="Phys Data"
choice[7]="Demo Data"
#define Step_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if keyboard_check_pressed(vk_escape)
 {
 instance_destroy()
 }
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_set_halign(fa_left)

draw_rectangle_color(x,y,x+350,y+80,c_navy,c_navy,c_navy,c_navy,false)

for (i=0; i<=choices; i+=1)
 {
 var col;
 if i<=3
  {
  ypos=(y+21)+(13*i)
  xpos=x+12
  }
 else if i<=7
  {
  ypos=(y+21)+(13*(i-4))
  xpos=x+115
  }
 else
  {
  ypos=(y+21)+(13*(i-8))
  xpos=x+208
  }

 if (mouse_y>ypos && mouse_y<(ypos+12) && mouse_x>=xpos && mouse_x<xpos+(string_length(choice[i])*11))
  {
  col=c_lime
  if mouse_check_button_pressed(mb_left)
   {
   obj_main.typeview=i
   obj_main.startpos_top=0
   ping_message(MES_TFILES)
   with(self)
    {
    instance_destroy()
    }
   }
  }
 else
  {
  col=c_green
  }

 draw_text_color(xpos,ypos,choice[i],col,col,col,col,1)
 }

draw_text_color(x+60,y,"Filter which data type?",c_lime,c_lime,c_lime,c_lime,1)
draw_set_halign(fa_left)
