//::///////////////////////////////////////////////
//:: Corpse Visage - On Enter (A)
//:: sg_s0_corpvisa.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Illusion
	Level: Sor/Wiz 1
	Components: V, S
	Casting Time: 1 action
	Range: Touch
	Target: One creature
	Duration: 1 round/caster level
	Saving Throw: Will negates
	Spell Resistance: Yes

	This spell transforms your face or the face of
	any creature touched by you into a horrifying
	visage of a rotting corpse. Creatures with
	Intelligence 5 or higher and with 1 Hit Die or
	less (or who are 1st level or lower) must make
	a successful Will saving throw when first viewing
	the corpse visage or flee in terror for 1-4 rounds.

	Corpse Visage does not distinguish between friend
	and foe, and all who view it are subject to its
	effects. If the spell is cast upon an unwilling
	victim, the victim is allowed a Will saving throw
	to avoid the effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: June 3, 2004
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
	int iSpellLevel = 1;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDuration 		= HkApplyDurationCategory(HkApplyMetamagicVariableMods( d4(), 4 ));
	fDuration = HkApplyMetamagicDurationMods( fDuration );
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDurVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR); // Visible impact effect
	effect eFear 	= EffectFrightened();
	effect eLink 	= EffectLinkEffects(eDurVis, eFear);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CORPSE_VISAGE));

	if( GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 5) return;
	if( GetHitDice(oTarget) > 1 ) return;

	if( GetObjectSeen(oCaster,oTarget) )
	{
		if(!HkResistSpell(oCaster, oTarget))
		{
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
	}
}
