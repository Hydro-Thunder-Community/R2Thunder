/*
csh_unpack(samplerate)

takes a csh file and outputs every sample into wav format
*/

var file, folder, samplerate, samplelist, sampleoffset, samplesize, samplefile, numfiles, filesbuf, samplebuf, offsetbuf, tempbuf, dataoffset, cshname;

samplerate=argument0
exportall_mode=1
samplefile=""

file=get_open_filename("Hydro Thunder CSH files|*.CSH","")

if file=""
 {
 ping_message(MES_ABORTD)
 exportall_mode=0
 exit
 }

var find;
find=string_length(file)
do
 {
 if string_char_at(file,find)!="\"
  {
  find-=1
  }
 }
until (string_char_at(file,find))="\"

cshname=string_copy(file,find+1,(string_length(file)-find-4))

exportall_dir=get_directory_alt("Select directory to output to.","")

if exportall_dir=""
 {
 ping_message(MES_ABORTD)
 exportall_mode=0
 exit
 }

//read how many samples are in the file
filesbuf=buffer_create()
buffer_load_part(filesbuf,file,$0C,4)
buffer_set_pos(filesbuf,0)

numfiles=buffer_read_u32(filesbuf)
buffer_destroy(filesbuf)

//show_message(string(numfiles))

//get the sizes of all the samples
samplebuf=buffer_create()
for (i=0; i<numfiles; i+=1)
 {
 buffer_load_part(samplebuf,file,($10+(i*4)),4)
 buffer_set_pos(samplebuf,0)
 samplesize[i]=buffer_read_u32(samplebuf)
 buffer_clear(samplebuf)
 }

buffer_destroy(samplebuf)

//get the offset, which is the number of bytes from the beginning of the DCS header
offsetbuf=buffer_create()
buffer_load_part(offsetbuf,file,$08,4)
buffer_set_pos(offsetbuf,0)
sampleoffset=buffer_read_u32(offsetbuf)

//calculate where the sample data begins
dataoffset=($10+(numfiles*8))+(sampleoffset)

//setup for showing the info output
processing=1
typeview=TYPE_ALL
files[TYPE_ALL]=numfiles

//extract the sound samples
for (i=0; i<numfiles; i+=1)
 {
 tempbuf=buffer_create()
 buffer_load_part(tempbuf,file,dataoffset,samplesize[i])
 samplefile=sound_createwavheader(""+cshname+"_"+string(i)+"",samplesize[i],samplerate)
 buffer_save_append(tempbuf,samplefile)
 buffer_clear(tempbuf)
 dataoffset+=samplesize[i]
 exportall_file+=1
 screen_redraw()
 }

exportall_file=0
files[TYPE_ALL]=0
processing=0

ping_message(MES_EXPORT)
