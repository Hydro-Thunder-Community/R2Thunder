/*
check_r2filetype(r2filetype,secondtolastcharacteroffilename)

returns the file type to be stored in the database built while analyzing the file directory
the second to last character of the file name is(currently) required to distinguish the unknown third texture type, 12 bits color, 4 bits alpha format textures and 15 bits color, 1 bit alpha textures from each other
*/
var compare, compare2;

compare=argument0
compare2=argument1

if compare2="9"
 {
 return TYPE_UNKWN
 }

if compare=$42
 {
 return TYPE_15P1TX
 }

else if compare=$4D
 {
 if compare2="2"
  {
  return TYPE_14P2TX
  }
 else
  {
  return TYPE_15P1TX
  }
 }

else if compare=$41
 {
 return TYPE_ANIM
 }

else if compare=$54
 {
 if compare2="2"
  {
  return TYPE_14P2TX
  }
 else
  {
  return TYPE_15P1TX
  }
 }

else if compare=$47
 {
 return TYPE_MODEL
 }

else if compare=$48
 {
 return TYPE_TRACK
 }

else if compare=$50
 {
 return TYPE_PHYS
 }

else if compare=$53
 {
 return TYPE_SOUND
 }

else if compare=$44
 {
 return TYPE_DEMO
 }

else if compare=$4B
 {
 return TYPE_UNKWN
 }

else
 {
 return TYPE_UNKWN
 }
