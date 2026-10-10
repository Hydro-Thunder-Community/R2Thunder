/*
r2_open()

opens an r2 file, reads the file directory, and assigns the type to each file

there are leftovers from a significant rewrite
*/
var file, r2_file, checkstring, readbyte, readstring, entriesloc, headersize, filetableloc, fileentrysize, filenumber, tempsize, templocs, temptables, tempreadtype, tempreadtype2, tempreadtype3;

//generic information about r2 files
file=file_bin_open(argument0,0)
r2_file=argument0
entriesloc=$2C
filetableloc=$1FFFF4
fileentrysize=$4C
headersize=3
entry=0
pvrcheck=""

//our temp read values
readstring=''
tempsize=0
templocs=0
temptables=0
temptype=0
temptype2=0
tempreadtype=''
tempreadtype2=''
tempreadtype3=''

//check for James Cameron Rules
checkstring="James Cameron Rules"
file_bin_seek(file,0)

for(i=0; i<string_length(checkstring); i+=1)
 {
 readbyte=file_bin_read_byte(file)
 if !string_byte_at(checkstring,i)=readbyte
  {
  file_bin_close(file)
  exit
  }
 }

//great! now time to check the number of file entries
for(i=headersize; i>=0; i-=1)
 {
 file_bin_seek(file,(entriesloc+i))
 readbyte=file_bin_read_byte(file)
 entries+=(readbyte<<8*i)
 }

//now then, can i grab a file listing? (oh dear god)
filenumber=0
/*names=ds_list_create()
sizes=ds_list_create()
locations=ds_list_create()
tables=ds_list_create()
types=ds_list_create()
types2=ds_list_create()*/

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

processing=1
screen_redraw()

var readbuf, bytebuf, pvrcheckbuf, pvrcheck, pvroffset, dcbytebuf;
readbuf=buffer_create()
bytebuf=buffer_create()
dcbytebuf=buffer_create() //dreamcast flips the data>reftable order of many files around, so the file header gets shifted over
pvrcheckbuf=buffer_create()
pvroffset=0

file_bin_close(file)

//read the file directory
repeat(entries)
 {
 buffer_load_part(readbuf,r2_file,(filetableloc+(filenumber*fileentrysize)),fileentrysize)

 buffer_set_pos(readbuf,$0C)
 templocs=buffer_read_u32(readbuf)
 //show_message(string(templocs))

 buffer_set_pos(readbuf,$10)
 tempsize=buffer_read_u32(readbuf)
 //show_message(string(tempsize))

 buffer_set_pos(readbuf,$14)
 temptables=buffer_read_u32(readbuf)
 //show_message(string(temptables))

 buffer_set_pos(readbuf,$18)
 tempstring=buffer_read_data(readbuf,11)
 //show_message(string(tempstring))

 buffer_load_part(bytebuf,r2_file,(templocs+3),1)
 readbyte=buffer_read_u8(bytebuf)
 //show_message(string(readbyte))

 //file_bin_seek(file,(filetableloc+(filenumber*fileentrysize)))
 //for(i=0; i<=fileentrysize; i+=1)
  //{
  //readbyte=file_bin_read_byte(file)

  //grab the relevant info as it is coming in
  //location
  /*if i=$0C
   {
   templocs+=readbyte
   }
  if i=$0D
   {
   templocs+=readbyte<<8
   }
  if i=$0E
   {
   templocs+=readbyte<<16
   }
  if i=$0F
   {
   templocs+=readbyte<<24
   }

  //size
  if i=$10
   {
   tempsize+=readbyte
   }
  if i=$11
   {
   tempsize+=readbyte<<8
   }
  if i=$12
   {
   tempsize+=readbyte<<16
   }
  if i=$13
   {
   tempsize+=readbyte<<24
   }

  //tables
  if i=$14
   {
   temptables+=readbyte
   }
  if i=$15
   {
   temptables+=readbyte<<8
   }
  if i=$16
   {
   temptables+=readbyte<<16
   }
  if i=$17
   {
   temptables+=readbyte<<24
   }

  readstring=string_insert(readstring,chr(readbyte),0)
  //if i=fileentrysize
   //{
   tempstring=string_copy(readstring,$19,11)*/
   /*tempreadtype=string_copy(tempstring,8,4)
   tempreadtype2=string_copy(tempstring,0,3)
   tempreadtype3=string_copy(tempstring,10,2)*/
   /*file_bin_seek(file,templocs+3)
   readbyte=file_bin_read_byte(file)*/
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

   /*readbyte=file_bin_read_byte(file)
   pvrcheck=string_insert(pvrcheck,chr(readbyte),0)
   readbyte=file_bin_read_byte(file)
   pvrcheck=string_insert(pvrcheck,chr(readbyte),0)
   readbyte=file_bin_read_byte(file)
   pvrcheck=string_insert(pvrcheck,chr(readbyte),0)
   readbyte=file_bin_read_byte(file)
   pvrcheck=string_insert(pvrcheck,chr(readbyte),0)*/

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
   //}
  //}
 //we read an entry, so move onto the next one
 filenumber+=1
 entry+=1
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
ping_message(MES_OPENED)
swap_screen(1)

//file_bin_close(file)
