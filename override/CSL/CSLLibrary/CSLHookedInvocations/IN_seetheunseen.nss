//::///////////////////////////////////////////////
//:: Invocation: See the Unseen
//:: NW_S0_ISeeUnsen.nss
//:://////////////////////////////////////////////
/*
	Caster gains Darkvision & See Invisibility for
	24 hours.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_seetheunseen();
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
	

	
	int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_SEE_INVISIBILITY);
	eLink = EffectLinkEffects(eLink, EffectSeeInvisible());
	eLink = EffectLinkEffects(eLink, EffectDarkVision());
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, iSpellPower));
	CSLUnstackSpellEffects(oCaster, GetSpellId() );
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	
	HkPostCast(oCaster);
}