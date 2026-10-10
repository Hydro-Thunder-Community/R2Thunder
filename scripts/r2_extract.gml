/*
r2_extract(assetname,assettype,r2filetype,assetlocation,assetsize,assetreftableentries)

extracts a file from the r2, in either converted or a .r2raw file. if exported raw, the reftable gets written to a .r2raw_reftable file

there's a bunch of commented out code here leftover from a significant rewrite
*/
var file, writefile, extracttype, EXTR_RAW, EXTR_CONV, assetname, assettype, assetloc, assetsize, grabwidth, grabheight, readbyte, tempstring, tempstring2, tempstring3, readwoffset, readhoffset, data, bmpoffset, reftablesize, reftablebytes, reftablefile, reftableminus;

//set our constants for both extraction types
EXTR_RAW=2
EXTR_CONV=1

assetname=argument0
assettype=argument1
assettype2=argument2
assetloc=argument3
assetsize=argument4
assettables=argument5
readhoffset=0
readwoffset=0
grabwidth=0
grabheight=0
byte=0
data[0]=0 //I DIDN'T END UP USING THIS LMAO
bmpoffset=0
writefile=0
reftableminus=0

//detection for conversion
if (!exportall_mode)
 {
 if assettype=TYPE_15P1TX || assettype=TYPE_14P2TX || assettype=TYPE_SOUND
  {
  extracttype=show_message_ext("Extract with conversion, or raw?","Convert","Raw","")
  }
 else
  {
  extracttype=EXTR_RAW
  }
 }
else if exportall_mode=1
 {
 switch assettype
  {
  case TYPE_15P1TX:
  case TYPE_14P2TX:
  case TYPE_SOUND:
  extracttype=EXTR_CONV
  break

  default:
  extracttype=EXTR_RAW
  break
  }
 }
else if exportall_mode=2
 {
 extracttype=EXTR_RAW
 }


//file=file_bin_open(currentfile,0)
if extracttype=EXTR_RAW
 {
 var rawfile;
 //file_bin_seek(file,(assetloc))
 if (!exportall_mode)
  {
  texfile=get_save_filename("R2RAW files|*.r2raw",""+string(assetname)+".r2raw")
  }
 else
  {
  texfile=(exportall_dir+string("\")+string(assetname)+".r2raw")
  }
 if texfile=""
  {
  ping_message(MES_ABORTD)
  exit
  }
 ping_message(MES_PROCES)
 screen_redraw()
 /*writefile=file_bin_open(texfile,2)
 file_bin_rewrite(writefile)
 file_bin_close(writefile)*/
 var filebuf, reftablebuf;
 filebuf=buffer_create()
 buffer_load_part(filebuf,currentfile,assetloc,(assetsize+2))
 buffer_save(filebuf,texfile)
 buffer_destroy(filebuf)

 reftablesize=(assettables+1)
 reftablebytes=(reftablesize*$10)
 reftablebuf=buffer_create()
 buffer_load_part(reftablebuf,currentfile,assetloc+(assetsize+3),reftablebytes)
 buffer_save(reftablebuf,(string(texfile))+string("_reftable"))
 buffer_destroy(reftablebuf)
 /*for(i=0; i<=(assetsize+(2)); i+=1)
  {
  readbyte=file_bin_read_byte(file)
  file_bin_write_byte(writefile,readbyte)
  }*/

 /*reftablefile=file_bin_open((string(texfile))+string("_reftable"),2)
 reftablesize=(assettables+1)
 reftablebytes=(reftablesize*$10)
 file_bin_seek(file,(assetloc+(assetsize+3)))
 for(i=0; i<(reftablebytes); i+=1)
  {
  readbyte=file_bin_read_byte(file)
  file_bin_write_byte(reftablefile,readbyte)
  }*/
 //file_bin_close(file)
 //file_bin_close(writefile)
 //file_bin_close(reftablefile)
 if (!exportall_mode)
  {
  ping_message(MES_EXPORT)
  processing=0
  }
 }

else if extracttype=EXTR_CONV
 {
 switch assettype
  {
  case TYPE_15P1TX:
  case TYPE_14P2TX:
  file=file_bin_open(currentfile,0)
  if assettype2=$42
   {
   readhoffset=$0C
   readwoffset=$08
   readimgoffset=$14
   }
  else if assettype2=$4D || assettype2=$54
   {
   readhoffset=$18
   readwoffset=$14
   readimgoffset=$28
   }

  for(i=1; i>=0; i-=1)
   {
   file_bin_seek(file,(assetloc+(readwoffset+i)))
   readbyte=file_bin_read_byte(file)
   grabwidth+=(readbyte<<8*i)
   }

  for(i=1; i>=0; i-=1)
   {
   file_bin_seek(file,(assetloc+(readhoffset+i)))
   readbyte=file_bin_read_byte(file)
   grabheight+=(readbyte<<8*i)
   }

  switch assettype
   {
   case TYPE_15P1TX:
   bmpoffset=$36
   break

   case TYPE_14P2TX:
   bmpoffset=$7C
   break
   }
  file_bin_close(file)
  var texfile;
  //file_bin_seek(file,(assetloc+readimgoffset))
  texfile=texture_createbmpheader(assetname,assettype,grabwidth,grabheight)
  if texfile=""
   {
   exit
   }
  var texturebuf;
  texturebuf=buffer_create()
  buffer_load_part(texturebuf,currentfile,(assetloc+readimgoffset),(assetsize-(readimgoffset-4)))
  buffer_save_append(texturebuf,texfile)
  buffer_destroy(texturebuf)

  /*writefile=file_bin_open(texfile,2)
  file_bin_seek(writefile,bmpoffset)
  for(i=0; i<=(assetsize-(readimgoffset-1)); i+=1)
   {
   readbyte=file_bin_read_byte(file)
   file_bin_write_byte(writefile,readbyte)
   }*/
  if (!exportall_mode)
   {
   ping_message(MES_EXPORT)
   }
  break

  case TYPE_SOUND:
  var soundbuf, soundoffset, soundfile, soundsamplerate;
  soundsamplerate=31000
  soundoffset=8
  soundfile=sound_createwavheader(assetname,assetsize,soundsamplerate)

  soundbuf=buffer_create()
  buffer_load_part(soundbuf,currentfile,(assetloc+soundoffset),(assetsize-4))
  buffer_save_append(soundbuf,soundfile)
  buffer_destroy(soundbuf)

  if (!exportall_mode)
   {
   ping_message(MES_EXPORT)
   }
  break
  }
 }
