//::///////////////////////////////////////////////
//:: Minor Malison (OnEnter)
//:: sg_s0_minmalisA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Enchantment
	Level: Sor/Wiz 3
	Components: V
	Casting Time: 1 action
	Range: Short
	Area: 30 ft radius emanation
	Duration: 2 rounds/level
	Saving Throw: None
	Spell Resistance: Yes

	This spell allows the caster to adversely affect
	all the saving throws of his enemies. Opponents
	under the influence of this spell receive a -1
	penalty to all saving throws.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 5, 2004
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
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	//int 	iDieType 		= 0;
	//int 	iNumDice 		= 0;
	int 	iBonus 		= 1;
	//int 	iDamage 		= 0;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpVis 	= EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, iBonus);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(GetIsObjectValid(oCaster))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MINOR_MALISON));
			if(!HkResistSpell(oCaster, oTarget))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSavePenalty, oTarget);
			}
		}
	}
}
