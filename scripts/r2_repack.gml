/*
r2_repack(r2files_dir)

repacks an r2 with the files contained in a directory
*/

var dirinput, r2entrysize, r2header, r2dir, r2filemetadata, r2filetabledata, r2filedata, r2mergedata, r2files, r2fileadd, r2filetableadd, r2filename, tables, headerentry, r2dir_table, r2dir_filename, r2dir_size, r2dir_loc, baseloc;

r2dir_loc=$00
r2dir_size=$04
r2dir_table=$08
r2dir_filename=$0C
r2entrysize=$4C
baseloc=$800000

dirinput=get_directory_alt("Select the directory to repack from.","")

if dirinput=""
 {
 ping_message(MES_ABORTD)
 exit
 }

dirinput=(dirinput+string("\"))

r2header=buffer_create()
buffer_load(r2header,(dirinput+"r2_header.r2raw"))
buffer_set_size(r2header,($200000))
buffer_save(r2header,dirinput+"HT.R2")

buffer_set_pos(r2header,$2C)
r2files=buffer_read_u32(r2header)

r2repack_max=r2files

r2dir=buffer_create()
buffer_load(r2dir,(dirinput+"r2_directory.r2raw"))
buffer_set_size(r2dir,($600000))

processing=1
r2repack=1
tables=buffer_create()
r2filetabledata=buffer_create()
r2filedata=buffer_create()

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

 buffer_save_append(r2filedata,dirinput+"HT.R2_filedata")
 buffer_save_append(r2filetabledata,dirinput+"HT.R2_filedata")

 //show_message(string(r2filemetadata[1]))

 var tabledatasize;
 tabledatasize=(16+(r2filemetadata[1]*16))

 //show_message(string(tabledatasize))

 //show_message(string(16+(r2filemetadata[1]*16)))

 baseloc=(baseloc+(r2filemetadata[0]+4)+tabledatasize)
 r2repack_file+=1

 buffer_clear(tables)
 buffer_clear(r2filedata)
 buffer_clear(r2filetabledata)
 screen_redraw()
 }

r2mergedata=buffer_create()
buffer_load(r2mergedata,dirinput+"HT.R2_filedata")
file_delete(dirinput+"HT.R2_filedata")

buffer_save_append(r2dir,dirinput+"HT.R2")
buffer_save_append(r2mergedata,dirinput+"HT.R2")

processing=0
r2repack=0
