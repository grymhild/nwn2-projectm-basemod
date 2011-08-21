//::///////////////////////////////////////////////
//:: Radiant Aura OnEnter
//:: cmi_s2_radntauraA
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2007
//:://////////////////////////////////////////////
//:: Based on Aura of Despair

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_FT_radiantaura(); //SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	effect eABPenalty = EffectAttackDecrease(2);
	effect eACPenalty = EffectACDecrease(2);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	
	effect eLink = EffectLinkEffects(eABPenalty, eACPenalty);
	eLink = EffectLinkEffects(eSavePenalty, eLink);
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA);
	
	// Doesn't work on self
	if (oTarget != oCaster)
	{
		SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA, FALSE));		

	    //Faction Check
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
	        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(1));			
		}
	}
}