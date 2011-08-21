/*
This is the main UI interface handler that manages which controls are visible at any time. Common hooks in the UI
are routed thru this, as are various features and changes in default elements.

Make sure this compiles, it's pretty obvious since it updates the players stats in the top left corner as it's primary duty ( make sure that is first if as it gets called the most
*/

void main( string sDesc = "", string string0="", string string1="", string string2="", string string3="", string string4="", string string5="", string string6="", string string7="", string string8="", string string9="" )
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	SendMessageToPC( oChar, sDesc+": 0:"+string0+"  1:"+string1+"  2:"+string2+"  3:"+string3+"  4:"+string4+"  5:"+string5+"  6:"+string6+"  7:"+string7+"  8:"+string8+"  9:"+string9 );
}