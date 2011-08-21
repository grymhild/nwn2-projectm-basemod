//::///////////////////////////////////////////////
//:: Fiendish Resilience
//:: NW_S0_FiendResl
//:://////////////////////////////////////////////
/*
	Grants the selected target 6 HP of regeneration
	every round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"



void main()
{
	//scSpellMetaData = SCMeta_IN_fiendishresi();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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

	int nHealAmt = 0;
	nHealAmt = iSpellPower / 3;
	int iDuration = 10 + HkGetSpellDuration( oCaster, 30, CLASS_TYPE_WARLOCK );
	if (GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_25, oCaster, TRUE))
	{
		nHealAmt *= 2;
		iDuration *= 2;
	}
	effect eRegen = EffectRegenerate(nHealAmt, 6.0);
	effect eDur = EffectVisualEffect(VFX_DUR_FEAT_FIENDISH_RES);
	effect eLink = EffectLinkEffects(eRegen, eDur);
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	
	HkPostCast(oCaster);
}