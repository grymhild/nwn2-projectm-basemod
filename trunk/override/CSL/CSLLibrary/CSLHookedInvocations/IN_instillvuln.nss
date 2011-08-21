//::///////////////////////////////////////////////
//:: Instill Vulnerability
//:: cmi_s0_instvuln
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Instill Vulnerability
//:: Invocation Type: Dark;
//:: Spell Level Equivalent: 7
//:: You imbue a single creature within 30 feet with vulnerability to a
//:: particular type of energy (acid, cold, electricity, fire, or sonic). A
//:: successful Fortitude save negates the effect.
//:: 
//:: The vulnerability lasts for 24 hours or until you use the invocation on the
//:: creature a second time, in which case the first effect ends and the new
//:: vulnerability and duration take effect.
//:://////////////////////////////////////////////
// const int Instill_Vulnerability = 2078;
// const int Instill_Vuln_A = 2079;
// const int Instill_Vuln_C = 2080;
// const int Instill_Vuln_E = 2081;
// const int Instill_Vuln_F = 2082;
// const int Instill_Vuln_S = 2083;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = Instill_Vulnerability;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	int iDescriptor = SCMETA_DESCRIPTOR_ACID;
	int nDmgResType = DAMAGE_TYPE_ACID;
	int nSpellId = GetSpellId();
	if (nSpellId == Instill_Vuln_A)
	{
		nDmgResType = DAMAGE_TYPE_ACID;
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
	}
	else if (nSpellId == Instill_Vuln_C)
	{
		nDmgResType = DAMAGE_TYPE_COLD;
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
	}
	else if (nSpellId == Instill_Vuln_E)
	{
		nDmgResType = DAMAGE_TYPE_ELECTRICAL;
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
	}
	else if (nSpellId == Instill_Vuln_F)
	{
		nDmgResType = DAMAGE_TYPE_FIRE;
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
	}
	else if (nSpellId == Instill_Vuln_S)
	{
		nDmgResType = DAMAGE_TYPE_SONIC;
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
	}
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS) );

	
	

	object	oTarget = HkGetSpellTarget();
	effect	eVuln = EffectDamageImmunityDecrease(nDmgResType, 50);
	eVuln = SetEffectSpellId(eVuln, Instill_Vulnerability);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		//Signal spell cast at event
		SignalEvent(oTarget, EventSpellCastAt(oTarget, iSpellId));

			//Make Will Save
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oCaster, TRUE)) )
			{
				CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS,oCaster, oTarget, Instill_Vulnerability );
				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
				//Apply Effect and VFX
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, oTarget, fDuration);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
	}
	
	HkPostCast(oCaster);
}