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
  var q;
  q=show_question("Export all files of the current filter?")

  if (q)
   {
   with obj_main
    {
    exportall_file=0
    exportall_mode=show_message_ext("Do you prefer converted(where possible), or raw?","Conv.","Raw","")
    if exportall_mode=0
     {
     ping_message(MES_ABORTD)
     exit
     }

    exportall_dir=get_directory_alt("Select directory to output to.","")

    if exportall_dir=""
     {
     ping_message(MES_ABORTD)
     exit
     }
    processing=1
    screen_redraw()
    var export, export_max;
    export=0
    export_max=files[typeview]
    repeat(export_max)
     {
     var nameexp, sizeexp, locexp, type2exp, tableexp, typeexp;
     nameexp=ds_list_find_value(names[typeview],export)
     sizeexp=ds_list_find_value(sizes[typeview],export)
     typeexp=ds_list_find_value(types[typeview],export)
     type2exp=ds_list_find_value(types2[typeview],export)
     locexp=ds_list_find_value(locations[typeview],export)
     tableexp=ds_list_find_value(tables[typeview],export)
     fileexp=ds_list_find_value(filenum[typeview],export)

     r2_extract(nameexp,typeexp,type2exp,locexp,sizeexp,tableexp)
     exportall_file+=1
     export+=1
     screen_redraw()
     }
    processing=0
    exportall_file=0
    exportall_dir=""
    ping_message(MES_EXPORT)
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
switch obj_main.screen
 {
 case SCR_R2OPEN:
 draw_text_color(x+58,y+(sprite_height/8),"Export All",col[mouseon],col[mouseon],col[mouseon],col[mouseon],1)
 break

 case 7:
 draw_text(x+58,y+6,"Back")
 break
 }

draw_set_halign(fa_left)
