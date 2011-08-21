//::///////////////////////////////////////////////
//:: Invocation: Leaps and Bounds
//:: NW_S0_ILeapsBnd.nss
//:://////////////////////////////////////////////
/*
	Gives a +4 Dexterity bonus and a +4 Tumble Skill
	Bonus for 24 hours.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_leapsbounds();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	
	//int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	int iBonus = CSLGetMin( HkGetWarlockBonus(oCaster), 2 );
	effect eLink = EffectVisualEffect(VFX_DUR_INVOCATION_LEAPS_BOUNDS);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, iBonus));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_TUMBLE, iBonus));
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	
	HkPostCast(oCaster);
}