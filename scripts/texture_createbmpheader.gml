/*
texture_createbmpheader(name,formattype,width,height)

creates a bmp file with a header of the given parameters, and returns the file name

TYPE_15P1TX - 15 bits color, 1 bit alpha
TYPE_14P2TX - 12 bits color, 4 bits alpha. this type requires a longer header with color bit masking
*/

var type, createstr, xsize, ysize, wrtfl, writefile, headersize, loopwrite, check, headerbuf;
name=argument0
type=argument1
xsize=argument2
ysize=argument3
check=0

headerbuf=buffer_create()
buffer_write_hex(headerbuf,"424D3830000000000000")
buffer_set_pos(headerbuf,$0A)

switch type
 {
 case TYPE_15P1TX:
 buffer_write_hex(headerbuf,"3600000028000000")
 break

 case TYPE_14P2TX:
 buffer_write_hex(headerbuf,"7C00000028000000")
 break
 }

buffer_set_pos(headerbuf,$12)
buffer_write_u32(headerbuf,xsize)
buffer_set_pos(headerbuf,$16)
buffer_write_u32(headerbuf,ysize)
buffer_set_pos(headerbuf,$1A)

switch type
 {
 case TYPE_15P1TX:
 buffer_write_hex(headerbuf,"01001000000000000000000000000000000000000000000000000000")
 break

 case TYPE_14P2TX:
 buffer_write_hex(headerbuf,"01001000030000000000000000000000000000000000000000000000000F0000F00000000F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
 break
 }

if (!exportall_mode)
 {
 writefile=get_save_filename("BMP files|*.bmp",""+string(name)+".bmp")
 }
else if (exportall_mode)
 {
 writefile=(exportall_dir+string("\")+string(name)+".bmp")
 }

if writefile=""
 {
 ping_message(MES_ABORTD)
 return ""
 }

ping_message(MES_PROCES)
screen_redraw()

buffer_save(headerbuf,writefile)
buffer_destroy(headerbuf)
return writefile
