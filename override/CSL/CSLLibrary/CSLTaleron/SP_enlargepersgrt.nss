/*
Enlarge Person Greater
Sean Harrington
11/11/07
#1378
*/

//::///////////////////////////////////////////////
//:: Enlarge Person
//:: NW_S0_EnlrgePer.nss
//:://////////////////////////////////////////////
/*
	Target creature increases in size 50%. Gains
	+2 Strength, -2 Dexterity, -1 to Attack and
	-1 AC penalties. Melee weapons gain +3 Dmg.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 12, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
//#include "nwn2_inc_spells"
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	float fDuration = HoursToSeconds(nCasterLvl);

	// AFW-OEI 05/09/2006: Make sure the target is humanoid
	if ( !(GetIsPlayableRacialType(oTarget) ||
			GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
			GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
			GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
			GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN ||
			GetSubRace(oTarget) == RACIAL_SUBTYPE_GITHYANKI ||
			GetSubRace(oTarget) == RACIAL_SUBTYPE_GITHZERAI) )
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget ); //"*Failure-Invalid Target*"
		return;
	}

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// JBH - 08/11/05 - OEI
	// Currently, if there are any size enlarging spells on the character
	// casting another should fail
	if ( HasSizeIncreasingSpellEffect( oTarget ) == TRUE || GetHasSpellEffect( 803, oTarget )||GetHasSpellEffect( 1378, oTarget ) )
	{
		// TODO: fizzle effect?
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget ); //"Failed"
		return;
	}

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, HkGetSpellId() );
	RemovePermanencySpells(oTarget);

	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENLARGE_PERSON);

	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
	effect eAtk = EffectAttackDecrease(1, ATTACK_BONUS_MISC);
	effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
	effect eDmg = EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL);	// Should be Melee-only!
	effect eScale = EffectSetScale(1.5);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eStr, eDex);
	eLink = EffectLinkEffects(eLink, eAtk);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eScale);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = EffectLinkEffects(eLink, eVis);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));

	//Apply the VFX impact and effects
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// VFX_HIT_SPELL_ENLARGE_PERSON contains a cessation effect, so it must be applied temporarily
	// Delay increasing size for 2 seconds to let enough particles spawn from the
	//	hit fx to obscure the pop in size.
	DelayCommand(1.5, HkApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
}