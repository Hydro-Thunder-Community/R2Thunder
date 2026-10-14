/*
r2_close()

closes the r2 file, and goes back to the main screen
*/
swap_screen(0)

for(i=0; i<=numboftypes; i+=1)
 {
 ds_list_clear(names[i])
 ds_list_clear(sizes[i])
 ds_list_clear(locations[i])
 ds_list_clear(tables[i])
 ds_list_clear(types[i])
 ds_list_clear(types2[i])
 ds_list_clear(filenum[i])

 ds_list_destroy(names[i])
 ds_list_destroy(sizes[i])
 ds_list_destroy(locations[i])
 ds_list_destroy(tables[i])
 ds_list_destroy(types[i])
 ds_list_destroy(types2[i])
 ds_list_destroy(filenum[i])

 files[i]=0
 }

currentfile=0
entries=0
startpos_top=0
createdlist=0
opened=0
typeview=0
r2signindex=0

ping_message(MES_CLOSED)
