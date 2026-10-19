/*
sound_createwavheader(name,size,samplerate)

creates a wav header of the given parameters, and returns the file name
*/
var samplerate, filesize, bytespersec, createstr, buff, file, name;

name=argument0
samplerate=argument2
bytespersec=(samplerate*2)
filesize=(argument1-5)+(36)
samplesize=(argument1-4)

buff=buffer_create()

buffer_write_hex(buff,"52494646")
buffer_set_pos(buff,4)
buffer_write_u32(buff,filesize)
buffer_set_pos(buff,8)
buffer_write_hex(buff,"57415645666D74201000000001000100")
buffer_set_pos(buff,24)
buffer_write_u32(buff,samplerate)
buffer_set_pos(buff,28)
buffer_write_u32(buff,bytespersec)
buffer_set_pos(buff,32)
buffer_write_hex(buff,"0200100064617461")
buffer_set_pos(buff,40)
buffer_write_u32(buff,samplesize)

if (!exportall_mode)
 {
 file=get_save_filename("WAV files|*.wav",""+string(name)+".wav")
 }
else if (exportall_mode)
 {
 file=(exportall_dir+string("\")+string(name)+".wav")
 }

ping_message(MES_PROCES)
screen_redraw()

buffer_save(buff,file)
buffer_destroy(buff)

return file
