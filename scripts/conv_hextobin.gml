/*
conv_hextobin(byte)

converts a one byte long real value into a string of binary
*/
var bin, split, hextable, finalstring;

bin=argument0

//split the byte in half using bitwise and
split[0]=(bin & $0F)
split[1]=(bin & $F0)

//shift the highest 4 bits down
split[1]=(split[1]>>4)

//create a lookup table of every 4 bits combination
hextable[0]="0000"
hextable[1]="0001"
hextable[2]="0010"
hextable[3]="0011"
hextable[4]="0100"
hextable[5]="0101"
hextable[6]="0110"
hextable[7]="0111"
hextable[8]="1000"
hextable[9]="1001"
hextable[10]="1010"
hextable[11]="1011"
hextable[12]="1100"
hextable[13]="1101"
hextable[14]="1110"
hextable[15]="1111"

//build and return the binary string
finalstring=string(hextable[split[1]])+string(hextable[split[0]])
return finalstring
