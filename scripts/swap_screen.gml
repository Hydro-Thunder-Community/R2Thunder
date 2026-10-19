/*
swap_screen(screenid)

swaps the screen number over, and activates/deactivates objects relevant to each one
*/
screen=argument0
with (obj_button)
 {
 instance_destroy()
 }
switch screen
 {
 case SCR_SPLASH:
 instance_deactivate_object(obj_searcbutton)
 instance_deactivate_object(obj_closbutton)
 instance_deactivate_object(obj_switchbutton)
 instance_deactivate_object(obj_viewbutton)
 instance_deactivate_object(obj_nextbutton)
 instance_deactivate_object(obj_prevbutton)
 instance_deactivate_object(obj_exportbutton)
 instance_activate_object(obj_openbutton)
 instance_activate_object(obj_unpackbutton)
 instance_activate_object(obj_opencshbutton)
 instance_activate_object(obj_repackbutton)
 break

 case SCR_R2OPEN:
 instance_deactivate_object(obj_openbutton)
 instance_deactivate_object(obj_unpackbutton)
 instance_deactivate_object(obj_repackbutton)
 instance_deactivate_object(obj_opencshbutton)
 instance_activate_object(obj_nextbutton)
 instance_activate_object(obj_prevbutton)
 instance_activate_object(obj_searcbutton)
 instance_activate_object(obj_closbutton)
 instance_activate_object(obj_switchbutton)
 instance_activate_object(obj_viewbutton)
 instance_activate_object(obj_exportbutton)
 break
 }
