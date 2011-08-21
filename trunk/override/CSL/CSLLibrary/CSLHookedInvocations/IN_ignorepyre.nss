//::///////////////////////////////////////////////
//:: Ignore the Pyre
//:: cmi_s0_ignorepyre
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:: Ignore the Pyre
//:: Invocation Type: Lesser;
//:: Spell Level Equivalent: 4
//:: When you use this invocation, you gain remarkable resilience to any one
//:: energy type (acid, cold, electricity, fire, or sonic). For 24 hours, you
//:: gain resistance equal to your invocation caster level against the energy
//:: type of your choice.
//:://////////////////////////////////////////////
// const int SPELL_I_IGNOREPYRE = 2071;
// const int Ignore_The_Pyre_A = 2072;
// const int Ignore_The_Pyre_C = 2073;
// const int Ignore_The_Pyre_E = 2074;
// const int Ignore_The_Pyre_F = 2075;
// const int Ignore_The_Pyre_S = 2076;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_IGNOREPYRE;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	int nDmgResType = DAMAGE_TYPE_ACID;
	int iDescriptor = SCMETA_DESCRIPTOR_ACID;
	int nSpellId = GetSpellId();
	if (nSpellId == Ignore_The_Pyre_A)
	{
		nDmgResType = DAMAGE_TYPE_ACID;
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
	}
	else if (nSpellId == Ignore_The_Pyre_C)
	{
		nDmgResType = DAMAGE_TYPE_COLD;
		iDescriptor = SCMETA_DESCRIPTOR_COLD;
	}
	else if (nSpellId == Ignore_The_Pyre_E)
	{
		nDmgResType = DAMAGE_TYPE_ELECTRICAL;
		iDescriptor = SCMETA_DESCRIPTOR_ELECTRICAL;
	}
	else if (nSpellId == Ignore_The_Pyre_F)
	{
		nDmgResType = DAMAGE_TYPE_FIRE;
		iDescriptor = SCMETA_DESCRIPTOR_FIRE;
	}
	else if (nSpellId == Ignore_The_Pyre_S)
	{
		nDmgResType = DAMAGE_TYPE_SONIC;
		iDescriptor = SCMETA_DESCRIPTOR_SONIC;
	}
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

	int iSpellPower = HkGetSpellPower( oCaster, 30 );
	
	effect eDmgRes = EffectDamageResistance(nDmgResType, iSpellPower);
	effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_DARKONESLUCK);
	effect eLink = EffectLinkEffects(eDur, eDmgRes);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );

	//Fire cast spell at event for the specified target
	SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration, iSpellId);
	
	HkPostCast(oCaster);
}