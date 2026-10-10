/*
get_floatfrombin(binarystring32)

converts a 32bit binary string input into an IEEE 754 float, then returns it
*/
var bin, bits_sign, bits_exponent, bits_fraction, bits_fractiontable, bits_mult, signminus, float, fraction;

bin=argument0
float=0
signminus=0
fraction=0

for(i=1; i<=string_length(bin); i+=1)
 {
 if string_char_at(bin,i)!="0" && string_char_at(bin,i)!="1"
  {
  show_message("didn't pass check 1")
  return "Not a 32-bit binary string!!"
  }
 }

if (string_length(bin))!=32
 {
 show_message("didn't pass check 2")
 return "Not a 32-bit binary string!!"
 }

//the variables for the parts of a float
bits_sign=string_copy(bin,1,1)
bits_exponent=string_copy(bin,2,8)
bits_fraction=string_copy(bin,9,24)
bits_mult=2

//generate the fractions table
for (i=0; i<24; i+=1)
 {
 var num_divide;
 num_divide=1
 repeat(i)
  {
  num_divide=(num_divide/2)
  }
 bits_fractiontable[1+i]=num_divide
 }

//add the fractions together
for(i=0; i<=24; i+=1)
 {
 if string_char_at(bits_fraction,i)="1"
  {
  fraction+=bits_fractiontable[i]
  }
 }

//get the exponent bits into a number, then decode it
bits_exponent=get_bytefrombin(bits_exponent)
bits_exponent=(bits_exponent-127)

//prepare the exponent to multiply with our fraction
repeat(bits_exponent-1)
 {
 bits_mult=(bits_mult*2)
 }

//multiply our exponent and fraction together
float=(bits_mult)*(fraction)

//is our sign bit set? if yes, flip the sign to negative
signminus=(float*2)
if bits_sign="1"
 {
 float=(float-signminus)
 }

return float
