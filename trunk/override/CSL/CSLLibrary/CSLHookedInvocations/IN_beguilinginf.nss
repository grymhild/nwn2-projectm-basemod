//::///////////////////////////////////////////////
//:: Invocation: Beguiling Influence
//:: NW_S0_IBeguInfl.nss
//:://////////////////////////////////////////////
/*
	Gives a +6 bonus to Bluff, Diplomacy & Intimidate
	for 24 hours.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_beguilinginf();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iBonus = HkGetWarlockBonus(oCaster);
	effect eLink = EffectVisualEffect(VFX_DUR_INVOCATION_BEGUILE_INFLUENCE);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CHARISMA, iBonus));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_BLUFF, iBonus));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_TAUNT, iBonus));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, iBonus));
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	
	HkPostCast(oCaster);
}

