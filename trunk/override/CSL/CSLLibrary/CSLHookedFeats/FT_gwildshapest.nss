//::///////////////////////////////////////////////
//:: Gaze attack for shifter forms
//:: x2_s1_petrgaze
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

	Petrification gaze  for polymorph type
	basilisk and medusa

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 09, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Polymorph"
#include "_SCInclude_Transmutation"

void main()
{
	//scSpellMetaData = SCMeta_FT_gwildshapest();
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	// Enforce artifical use limit on that ability
	//--------------------------------------------------------------------------
	if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
	{
			FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
			return;
	}

	//--------------------------------------------------------------------------
	// Make sure we are not blind
	//--------------------------------------------------------------------------
	if( CSLIsGazeAttackBlocked(OBJECT_SELF))
	{
		return;
	}

	//--------------------------------------------------------------------------
	// Calculate Save DC
	//--------------------------------------------------------------------------
	int iDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY_MEDIUM);

	float fDelay;
	object oTarget = HkGetSpellTarget();
	int nHitDice = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	location lTargetLocation = HkGetSpellTargetLocation();
	int iSpellId = GetSpellId();
	object oSelf = OBJECT_SELF;

	//--------------------------------------------------------------------------
	// Loop through all available targets in spellcone
	//--------------------------------------------------------------------------
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

			if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				DelayCommand(fDelay,  SCDoPetrification(nHitDice, oSelf, oTarget, iSpellId, iDC));
				//Get next target in spell area
			}
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}

}