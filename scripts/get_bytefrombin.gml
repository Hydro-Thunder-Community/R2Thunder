/*
get_bytefrombin(binarystring8)

takes a binary string and returns a real number
*/
var bin, number;

bin=argument0
number=0

for (i=0; i<8; i+=1)
 {
 var mult;
 mult=1
 if i>0
  {
  repeat(i)
   {
   mult=(mult*2)
   }
  }
 if string_char_at(bin,8-i)="1"
  {
  number+=mult
  }
 }

return number
