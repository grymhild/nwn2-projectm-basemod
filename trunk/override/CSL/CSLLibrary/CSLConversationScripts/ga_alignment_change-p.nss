/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
//#include "inc_ap"
void main(int iGoodEvil, int iLawfulChaotic)
{

object oPC = GetPCSpeaker();

//Change alignment...
int iPCGoodEvil			= GetAlignmentGoodEvil(oPC);
int iPCLawfulChaotic	= GetAlignmentLawChaos(oPC);

if( iPCGoodEvil == ALIGNMENT_GOOD ) iPCGoodEvil = 100;
else if( iPCGoodEvil == ALIGNMENT_NEUTRAL ) iPCGoodEvil = 50;
else if( iPCGoodEvil == ALIGNMENT_EVIL ) iPCGoodEvil = 0;

if( iPCLawfulChaotic == ALIGNMENT_LAWFUL ) iPCLawfulChaotic = 100;
else if( iPCLawfulChaotic == ALIGNMENT_NEUTRAL ) iPCLawfulChaotic = 50;
else if( iPCLawfulChaotic == ALIGNMENT_CHAOTIC ) iPCLawfulChaotic = 0;

int iSumGoodEvil 		= iGoodEvil-iPCGoodEvil;
int iSumLawfulChaotic	= iLawfulChaotic-iPCLawfulChaotic;

AdjustAlignment(oPC, ALIGNMENT_GOOD, iSumGoodEvil);
AdjustAlignment(oPC, ALIGNMENT_LAWFUL, iSumLawfulChaotic);
}