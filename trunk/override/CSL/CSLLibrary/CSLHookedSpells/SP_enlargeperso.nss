//::///////////////////////////////////////////////
//:: Enlarge Person
//:: NW_S0_EnlrgePer.nss
//:://////////////////////////////////////////////
/*
	Target creature increases in size 50%.  Gains
	+2 Strength, -2 Dexterity, -1 to Attack and
	-1 AC penalties.  Melee weapons gain +3 Dmg.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_enlargeperso();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENLARGE_PERSON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();

	// AFW-OEI 05/09/2006: Make sure the target is humanoid
	if ( !CSLGetIsHumanoid(oTarget) )
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget );
		return;
	}
	// Currently, if there are any size enlarging spells on the character casting another should fail
	if (CSLGetHasSizeIncreaseEffect(oTarget))
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}

	
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration(oCaster)));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLUnstackSpellEffects(oTarget, GetSpellId());
	CSLRemovePermanencySpells(oTarget);

	effect eLink = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
	eLink = EffectLinkEffects(eLink, EffectAttackDecrease(1, ATTACK_BONUS_MISC));
	eLink = EffectLinkEffects(eLink, EffectACDecrease(1, AC_DODGE_BONUS));
	//eLink = EffectLinkEffects(eLink, EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL ));// Should be Melee-only!
	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(3, 3 ));// Should be Melee-only!
	eLink = EffectLinkEffects(eLink, EffectSetScale(1.5));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_HIT_SPELL_ENLARGE_PERSON));

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	DelayCommand(1.5, HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration));
	
	HkPostCast(oCaster);
}

