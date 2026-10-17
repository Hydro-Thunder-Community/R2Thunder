/*
r2_open()

opens an r2 file, reads the file directory, and assigns the type to each file
*/
var file, r2_file, checkstring, checkweaselstring, readbyte, readstring, entriesloc, headersize, headerbuf, signaturebuf, versioncheck, expectedversion, filetableloc, dirbuf, fileentrysize, filenumber, tempsize, templocs, temptables, tempreadtype, tempreadtype2, tempreadtype3;

//generic information about r2 files
r2_file=argument0
entriesloc=$2C
filetableloc=$200000
fileentrysize=$4C
headersize=$88
entry=0
pvrcheck=""
expectedversion=$00

//our header read values
headerbuf=buffer_create()
signaturebuf=buffer_create()

//our directory read values
readstring=''
tempsize=0
templocs=0
temptables=0
temptype=0
temptype2=0
tempreadtype=''
tempreadtype2=''
tempreadtype3=''


//load the header into a buffer that we will read stuff from
buffer_load_part(headerbuf,r2_file,0,headersize)

//check for known signatures. if not the original, then try matching with Crank the Weasel's signature
buffer_set_pos(headerbuf,0)
signaturebuf=buffer_read_data(headerbuf,$13)

if r2sign[R2VER_ORIG]!=signaturebuf
 {
 if r2sign[R2VER_WEAS]=signaturebuf
  {
  r2signindex=1
  }
 else
  {
  buffer_destroy(headerbuf)
  buffer_destroy(signaturebuf)
  show_message("Not a valid R2 signature!")
  exit
  }
 }

//check R2 version
buffer_set_pos(headerbuf,$18)
versioncheck=buffer_read_u8(headerbuf)

if versioncheck!=expectedversion
 {
 buffer_destroy(headerbuf)
 buffer_destroy(signaturebuf)
 show_message("Not a valid R2 version!")
 exit
 }

//great! now time to check the number of file entries
buffer_set_pos(headerbuf,entriesloc)
entries=buffer_read_u32(headerbuf)

//now then, can i grab a file listing? (oh dear god)
filenumber=0

//create our lists that we will populate with info from the r2
for(i=0; i<=numboftypes; i+=1)
 {
 names[i]=ds_list_create()
 sizes[i]=ds_list_create()
 locations[i]=ds_list_create()
 tables[i]=ds_list_create()
 types[i]=ds_list_create()
 types2[i]=ds_list_create()
 filenum[i]=ds_list_create()
 }

//create our read buffers
var readbuf, bytebuf, pvrcheckbuf, pvrcheck, pvroffset, dcbytebuf;
readbuf=buffer_create()
bytebuf=buffer_create()
dcbytebuf=buffer_create() //dreamcast flips the data>reftable order of many files around, so the file header gets shifted over
pvrcheckbuf=buffer_create()
pvroffset=0

//this flag makes obj_main output info about what the program is doing
processing=1

//read the file directory section
dirbuf=buffer_create()
buffer_load_part(dirbuf,r2_file,filetableloc,(fileentrysize*entries))

//build the file list from it
var curentrypos;
curentrypos=0

while (entry<entries)
 {
 buffer_set_pos(dirbuf,$00+curentrypos)
 templocs=buffer_read_u32(dirbuf)

 buffer_set_pos(dirbuf,$04+curentrypos)
 tempsize=buffer_read_u32(dirbuf)

 buffer_set_pos(dirbuf,$08+curentrypos)
 temptables=buffer_read_u32(dirbuf)

 buffer_set_pos(dirbuf,$0C+curentrypos)
 tempstring=buffer_read_data(dirbuf,11)

 buffer_load_part(bytebuf,r2_file,(templocs+3),1)
 readbyte=buffer_read_u8(bytebuf)

 tempreadtype2=readbyte
 tempreadtype=string_copy(tempstring,10,1)

 //dreamcast specific file type detection
 if tempreadtype2=$00
  {
  buffer_load_part(dcbytebuf,r2_file,(templocs+3+(temptables*16)),1)
  tempreadtype2=buffer_read_u8(dcbytebuf)
  }

 temptype=r2_checkfiletype(tempreadtype2,tempreadtype)
 
 //check for dreamcast pvr, but first we need to seek to where the header is located
 switch readbyte
  {
  case $42:
  //file_bin_seek(file,templocs+$14)
  pvroffset=templocs+$14
  break

  case $4D:
  case $54:
  //file_bin_seek(file,templocs+$28)
  pvroffset=templocs+$28
  break

  default:
  pvroffset=0
  break
  }

 //read where the header would be if it was one
 buffer_load_part(pvrcheckbuf,r2_file,pvroffset,4)
 buffer_set_pos(pvrcheckbuf,0)
 pvrcheck=buffer_read_data(pvrcheckbuf,4)

 if pvrcheck="PVRT"
  {
  temptype=TYPE_DCPVR
  }

 pvrcheck=""

 //add all of the info we grabbed to the ds lists
 ds_list_add(types[TYPE_ALL],temptype)
 ds_list_add(types2[TYPE_ALL],tempreadtype2)
 ds_list_add(names[TYPE_ALL],tempstring)
 ds_list_add(sizes[TYPE_ALL],tempsize)
 ds_list_add(locations[TYPE_ALL],templocs)
 ds_list_add(tables[TYPE_ALL],temptables)
 ds_list_add(filenum[TYPE_ALL],entry)
 files[TYPE_ALL]+=1

 switch temptype
  {
  case TYPE_14P2TX:
  case TYPE_15P1TX:
  case TYPE_DCPVR:
  ds_list_add(types[TYPE_TEX],temptype)
  ds_list_add(types2[TYPE_TEX],tempreadtype2)
  ds_list_add(names[TYPE_TEX],tempstring)
  ds_list_add(sizes[TYPE_TEX],tempsize)
  ds_list_add(locations[TYPE_TEX],templocs)
  ds_list_add(tables[TYPE_TEX],temptables)
  ds_list_add(filenum[TYPE_TEX],entry)
  files[TYPE_TEX]+=1
  break

  case TYPE_MODEL:
  ds_list_add(types[TYPE_MDL],temptype)
  ds_list_add(types2[TYPE_MDL],tempreadtype2)
  ds_list_add(names[TYPE_MDL],tempstring)
  ds_list_add(sizes[TYPE_MDL],tempsize)
  ds_list_add(locations[TYPE_MDL],templocs)
  ds_list_add(tables[TYPE_MDL],temptables)
  ds_list_add(filenum[TYPE_MDL],entry)
  files[TYPE_MDL]+=1
  break

  case TYPE_TRACK:
  ds_list_add(types[TYPE_WOR],temptype)
  ds_list_add(types2[TYPE_WOR],tempreadtype2)
  ds_list_add(names[TYPE_WOR],tempstring)
  ds_list_add(sizes[TYPE_WOR],tempsize)
  ds_list_add(locations[TYPE_WOR],templocs)
  ds_list_add(tables[TYPE_WOR],temptables)
  ds_list_add(filenum[TYPE_WOR],entry)
  files[TYPE_WOR]+=1
  break

  case TYPE_ANIM:
  ds_list_add(types[TYPE_ANI],temptype)
  ds_list_add(types2[TYPE_ANI],tempreadtype2)
  ds_list_add(names[TYPE_ANI],tempstring)
  ds_list_add(sizes[TYPE_ANI],tempsize)
  ds_list_add(locations[TYPE_ANI],templocs)
  ds_list_add(tables[TYPE_ANI],temptables)
  ds_list_add(filenum[TYPE_ANI],entry)
  files[TYPE_ANI]+=1
  break

  case TYPE_SOUND:
  ds_list_add(types[TYPE_SND],temptype)
  ds_list_add(types2[TYPE_SND],tempreadtype2)
  ds_list_add(names[TYPE_SND],tempstring)
  ds_list_add(sizes[TYPE_SND],tempsize)
  ds_list_add(locations[TYPE_SND],templocs)
  ds_list_add(tables[TYPE_SND],temptables)
  ds_list_add(filenum[TYPE_SND],entry)
  files[TYPE_SND]+=1
  break

  case TYPE_PHYS:
  ds_list_add(types[TYPE_PHY],temptype)
  ds_list_add(types2[TYPE_PHY],tempreadtype2)
  ds_list_add(names[TYPE_PHY],tempstring)
  ds_list_add(sizes[TYPE_PHY],tempsize)
  ds_list_add(locations[TYPE_PHY],templocs)
  ds_list_add(tables[TYPE_PHY],temptables)
  ds_list_add(filenum[TYPE_PHY],entry)
  files[TYPE_PHY]+=1
  break

  case TYPE_DEMO:
  ds_list_add(types[TYPE_DEM],temptype)
  ds_list_add(types2[TYPE_DEM],tempreadtype2)
  ds_list_add(names[TYPE_DEM],tempstring)
  ds_list_add(sizes[TYPE_DEM],tempsize)
  ds_list_add(locations[TYPE_DEM],templocs)
  ds_list_add(tables[TYPE_DEM],temptables)
  ds_list_add(filenum[TYPE_DEM],entry)
  files[TYPE_DEM]+=1
  break
  }

 //reset the temp values we add to for the next read
 readstring=''
 tempsize=0
 temptables=0
 templocs=0
 temptype=0

 //we read an entry, so move onto the next one
 filenumber+=1
 entry+=1
 curentrypos=(entry*fileentrysize)
 buffer_clear(readbuf)
 buffer_clear(bytebuf)
 buffer_clear(dcbytebuf)
 buffer_clear(pvrcheckbuf)
 screen_redraw()
 }

//we did it! make sure the user knows, and swap the screen over to the file directory view
createdlist=1
r2target=1
processing=0
currentfile=argument0

if r2unpack=0
 {
 ping_message(MES_OPENED)
 swap_screen(SCR_R2OPEN)
 }
 
else if r2unpack=1
 {
 exportall_file=0
 exportall_mode=2

 exportall_dir=get_directory_alt("Select directory to unpack to.","")

 if exportall_dir=""
  {
  r2_close()
  ping_message(MES_ABORTD)
  exit
  }
 processing=1
 screen_redraw()
 
 buffer_save(dirbuf,(exportall_dir+string("\")+"r2_directory.r2raw"))
 buffer_save(headerbuf,(exportall_dir+string("\")+"r2_header.r2raw"))
 
 directory_create(exportall_dir+string("\files\"))
 exportall_dir=(exportall_dir+string("\files\"))
 
 var export, export_max;
 export=0
 export_max=files[TYPE_ALL]
 repeat(export_max)
  {
  var nameexp, sizeexp, locexp, type2exp, tableexp, typeexp;
  nameexp=ds_list_find_value(names[TYPE_ALL],export)
  sizeexp=ds_list_find_value(sizes[TYPE_ALL],export)
  typeexp=ds_list_find_value(types[TYPE_ALL],export)
  type2exp=ds_list_find_value(types2[TYPE_ALL],export)
  locexp=ds_list_find_value(locations[TYPE_ALL],export)
  tableexp=ds_list_find_value(tables[TYPE_ALL],export)
  fileexp=ds_list_find_value(filenum[TYPE_ALL],export)

  r2_extract(nameexp,typeexp,type2exp,locexp,sizeexp,tableexp)
  exportall_file+=1
  export+=1
  screen_redraw()
  }
 processing=0
 exportall_file=0
 exportall_mode=0
 exportall_dir=""
 ping_message(MES_EXPORT)
 r2unpack=0
 r2_close()
 }

//destroy our buffers, we don't need them anymore
buffer_destroy(readbuf)
buffer_destroy(bytebuf)
buffer_destroy(dcbytebuf)
buffer_destroy(pvrcheckbuf)
buffer_destroy(dirbuf)
buffer_destroy(headerbuf)
buffer_destroy(signaturebuf)
