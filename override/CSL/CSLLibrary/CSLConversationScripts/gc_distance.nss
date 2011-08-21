// gc_distance(string sTagA, string sTagB, string sCheck)
/*
   This script compares the distance between objects A and B against sCheck.

   Parameters:
     string sTagA  = Tag of object A. If blank, use OWNER.
     string sTagB  = Tag of object B.
     string sCheck = Conditional to compare distance(A,B) to.
                     "<3.0"  - distance < 3.0m
                     "=10.0" - distance == 10.0m
                     "!4.0"  - distance != 4.0m
*/
// BMA-OEI 1/14/06
// ChazM 9/20/06 - fixed inc.

#include "_CSLCore_Math"
//#include "_CSLCore_Messages"
#include "_CSLCore_Messages"
	
int StartingConditional(string sTagA, string sTagB, string sCheck)
{
	object oObjectA = CSLGetTarget(sTagA, CSLTARGET_OWNER);
	object oObjectB = GetNearestObjectByTag(sTagB, oObjectA);
	float fDistance = GetDistanceBetween(oObjectA, oObjectB);
	
	string sOperator = GetStringLeft(sCheck, 1);

	float fCompare = StringToFloat(GetStringRight(sCheck, GetStringLength(sCheck) - 1));

	return CSLCheckVariableFloat(fDistance, sOperator, fCompare);
}