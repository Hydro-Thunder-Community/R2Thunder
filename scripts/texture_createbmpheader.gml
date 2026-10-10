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

writefile=get_save_filename("BMP files|*.bmp",""+string(name)+".bmp")

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


/*
OLD CODE
createstr[$00]=$42
createstr[$01]=$4D
createstr[$02]=$38
createstr[$03]=$30
createstr[$04]=$00
createstr[$05]=$00
createstr[$06]=$00
createstr[$07]=$00
createstr[$08]=$00
createstr[$09]=$00

switch type
 {
 case TYPE_15P1TX:
 headersize=$35
 createstr[$0A]=$36
 createstr[$0B]=$00
 createstr[$0C]=$00
 createstr[$0D]=$00

 loopwrite=0
 do
  {
  createstr[($1F+loopwrite)]=$00
  loopwrite+=1
  }
 until loopwrite=23
 break

 case TYPE_14P2TX:
 headersize=$7B
 createstr[$0A]=$7C
 createstr[$0B]=$00
 createstr[$0C]=$00
 createstr[$0D]=$00

 createstr[$1E]=$03

 loopwrite=0
 do
  {
  createstr[($1F+loopwrite)]=$00
  loopwrite+=1
  }
 until loopwrite=$5D
 //write the color masking bits to the appropriate places, in order of red, green, blue
 createstr[$37]=$0F
 createstr[$3A]=$F0
 createstr[$3E]=$0F
 break
 }

createstr[$0E]=$28
createstr[$0F]=$00
createstr[$10]=$00
createstr[$11]=$00

//convert the width into hex and add it to the header string
var temp1, temp2, temp3;
temp1=xsize

temp1=(temp1/16)
temp2=(frac(temp1))
if temp2>0
 {
 temp2=(temp2*16)
 }

temp1=floor(temp1)
temp1=(temp1/16)
temp3=(frac(temp1))

if temp3>0
 {
 temp3=(temp3*16)
 }

temp1=floor(temp1)

temp3=(temp3)<<4
temp3=(temp3+temp2)

createstr[$12]=temp3
createstr[$13]=temp1
temp1=0
temp2=0
temp3=0

createstr[$14]=$00
createstr[$15]=$00

//convert the height into hex and add it to the header string
temp1=ysize

temp1=(temp1/16)
temp2=(frac(temp1))
if temp2>0
 {
 temp2=(temp2*16)
 }

temp1=floor(temp1)
temp1=(temp1/16)
temp3=(frac(temp1))

if temp3>0
 {
 temp3=(temp3*16)
 }

temp1=floor(temp1)

temp3=(temp3)<<4
temp3=(temp3+temp2)

createstr[$16]=temp3
createstr[$17]=temp1

createstr[$18]=$00
createstr[$19]=$00
createstr[$1A]=$01
createstr[$1B]=$00
createstr[$1C]=$10
createstr[$1D]=$00
writefile=get_save_filename("BMP files|*.bmp",""+string(name)+".bmp")

if writefile=""
 {
 ping_message(MES_ABORTD)
 return ""
 }

ping_message(MES_PROCES)
screen_redraw()

wrtfl=file_bin_open(writefile,2)

if file_exists(writefile)
 {
 file_bin_rewrite(wrtfl)
 file_bin_seek(wrtfl,0)
 for(i=0; i<=headersize; i+=1)
  {
  file_bin_write_byte(wrtfl,createstr[i])
  }

 file_bin_close(wrtfl)
 processing=0
 return writefile
 }
