//::///////////////////////////////////////////////
//:: Forceward(a) OnEnter
//:: sg_s0_forcewardA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Spell Description
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 3, 2004
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
		

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	//int 	iDieType 		= 0;
	//int 	iNumDice 		= 0;
	//int 	iBonus 		= 0;
	//int 	iDamage 		= 0;

	//float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	location lBehindLocation;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(!CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
	{
		if(!HkResistSpell(oCaster, oTarget))
		{
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
			{
				AssignCommand(oTarget, ClearAllActions());
				lBehindLocation=CSLGenerateNewLocation(oTarget,SC_DISTANCE_SHORT,CSLGetOppositeDirection(GetFacing(oTarget)),GetFacing(oTarget));
				DelayCommand(0.2,AssignCommand(oTarget, JumpToLocation(lBehindLocation)));
			}
		}
	}

}
