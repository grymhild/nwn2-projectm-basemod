//::///////////////////////////////////////////////
//:: Heroism
//:: NW_S0_Heroism.nss
//:://////////////////////////////////////////////
/*
	Target gets a +2 morale bonus to Attack, saves,
	and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 11, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_ObjectVars"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HEROISM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDurationCategory = SC_DURCATEGORY_TENMINUTES;
	if( CSLGetPreferenceSwitch("ReducedHeroismDuration", FALSE ) )
	{
		iDurationCategory = SC_DURCATEGORY_MINUTES;
	}
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// Find the Familiar!
	object oTarget = HkGetSpellTarget();
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Prevent stacking with Greater Heroism.  This spell will not fail is greater heroism is in place//pkm oei 10.20.06
	if (GetHasSpellEffect(SPELL_GREATER_HEROISM,oCaster))
	{
		SendMessageToPC(oTarget, "The effects of this spell do not stack with Greater Heroism.");
		return;
	}

	if ( GetIsObjectValid(oTarget) )
	{
			effect eAttack = EffectAttackIncrease(2);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
			effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);
			effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HEROISM );

			effect eLink = EffectLinkEffects(eAttack, eSave);
			eLink = EffectLinkEffects(eLink, eSkill);
			eLink = EffectLinkEffects(eLink, eDur);

			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));

			HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId);
	}
	
	HkPostCast(oCaster);
}