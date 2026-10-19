/*
r2_repack(r2files_dir)

repacks an r2 with the files contained in a directory
*/

var dirinput, r2entrysize, r2header, r2dir, r2filemetadata, r2filetabledata, r2filedata, r2mergedata, r2files, r2fileadd, r2filetableadd, r2filename, tables, headerentry, r2dir_table, r2dir_filename, r2dir_size, r2dir_loc, r2dir_chksum, r2dir_val1, r2dir_val2, baseloc;

//locations of generic info about r2 directory lists
r2dir_loc=$00
r2dir_size=$04
r2dir_table=$08
r2dir_filename=$0C
r2dir_sign=$18
r2dir_chksum=$40
r2dir_val1=$44
r2dir_val2=$48
r2entrysize=$4C

r2files=0
baseloc=$800000

//the three values that end an r2 dir entry
chksumvalue=$200000
unknownvalue1=$150000
unknownvalue2=$350000

dirinput=get_directory_alt("Select the directory to repack from.","")

if dirinput=""
 {
 ping_message(MES_ABORTP)
 exit
 }

//add a \ at the end to make things more convenient
dirinput=(dirinput+string("\"))

r2header=buffer_create()

//eliminate the need for this
buffer_load(r2header,(dirinput+"r2_header.r2raw"))

//do we have a directory to build from?
var filefind, filename;
filefind=file_find_first((dirinput)+"files\*.r2raw",0)

if filefind=""
 {
 ping_message(MES_ERROR1)
 exit
 }

//yes, now build part of the directory
r2dir=buffer_create()
buffer_set_size(r2dir,($600000))

do
 {
 filename=string_copy(filefind,(string_length(filefind)-16),11)

 buffer_set_pos(r2dir,r2dir_filename+(r2entrysize*r2files))
 buffer_write_string(r2dir,filename)

 buffer_set_pos(r2dir,r2dir_sign+(r2entrysize*r2files))
 buffer_write_string(r2dir,"axlthu")

 buffer_set_pos(r2dir,r2dir_chksum+(r2entrysize*r2files))
 buffer_write_u32(r2dir,chksumvalue)

 buffer_set_pos(r2dir,r2dir_val1+(r2entrysize*r2files))
 buffer_write_u32(r2dir,unknownvalue1)

 buffer_set_pos(r2dir,r2dir_val2+(r2entrysize*r2files))
 buffer_write_u32(r2dir,unknownvalue2)

 chksumvalue+=500
 unknownvalue1+=1000
 unknownvalue2+=900

 r2files+=1
 filefind=file_find_next()
 }
until filefind=""

file_find_close()

//put in the header info that we need to until we can generate a complete header
buffer_set_pos(r2header,$2C)
buffer_write_u32(r2header,r2files)

buffer_set_pos(r2header,$38)
buffer_write_string(r2header,"axlthu")

buffer_set_pos(r2header,$60)
buffer_write_string(r2header,"axlthu")

buffer_set_size(r2header,($200000))
buffer_save(r2header,dirinput+"HT.R2")

//give obj_main the max number of files to be written for display on screen
r2repack_max=r2files

processing=1
r2repack=1
tables=buffer_create()
r2filetabledata=buffer_create()
r2filedata=buffer_create()

//build the other part of the directory
for(i=0; i<r2files; i+=1)
 {
 buffer_set_pos(r2dir,r2dir_filename+(r2entrysize*i))

 r2filename=buffer_read_data(r2dir,11)
 r2fileadd=(dirinput+"files\"+r2filename+".r2raw")
 r2filetableadd=(dirinput+"files\"+r2filename+".r2raw_reftable")

 buffer_load_part(tables,r2filetableadd,0,4)
 buffer_set_pos(tables,0)
 r2filemetadata[0]=(file_size(r2fileadd)-4)
 r2filemetadata[1]=buffer_read_u32(tables)

 buffer_set_pos(r2dir,r2dir_loc+(r2entrysize*i))
 buffer_write_u32(r2dir,(baseloc))
 buffer_set_pos(r2dir,r2dir_size+(r2entrysize*i))
 buffer_write_u32(r2dir,(r2filemetadata[0]))
 buffer_set_pos(r2dir,r2dir_table+(r2entrysize*i))
 buffer_write_u32(r2dir,(r2filemetadata[1]))

 buffer_load(r2filedata,r2fileadd)
 buffer_load(r2filetabledata,r2filetableadd)

 //this contains the file data, we will append it to the r2 at the end
 buffer_save_append(r2filedata,dirinput+"HT.R2_filedata")
 buffer_save_append(r2filetabledata,dirinput+"HT.R2_filedata")

 var tabledatasize;
 tabledatasize=(16+(r2filemetadata[1]*16))

 baseloc=(baseloc+(r2filemetadata[0]+4)+tabledatasize)
 r2repack_file+=1

 buffer_clear(tables)
 buffer_clear(r2filedata)
 buffer_clear(r2filetabledata)
 screen_redraw()
 }

r2repack=0
r2merging=1

screen_redraw()

//merge everything together to form an r2
r2mergedata=buffer_create()
buffer_load(r2mergedata,dirinput+"HT.R2_filedata")
file_delete(dirinput+"HT.R2_filedata")

buffer_save_append(r2dir,dirinput+"HT.R2")
buffer_save_append(r2mergedata,dirinput+"HT.R2")

buffer_destroy(r2mergedata)
buffer_destroy(r2dir)
buffer_destroy(r2header)
buffer_destroy(tables)
buffer_destroy(r2filedata)
buffer_destroy(r2filetabledata)

processing=0
r2merging=0

ping_message(MES_PACKED)
