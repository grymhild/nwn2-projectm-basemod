//::///////////////////////////////////////////////
//:: Lesser Aura of Cold
//:: cmi_s0_lauracold
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Lesser Aura of Cold
//:: Caster Level(s): Cleric 3, Druid 3, Paladin 4, Ranger 4
//:: Innate Level: 3
//:: School: Transmutation
//:: Descriptor(s): Cold
//:: Component(s): Verbal, Somatic
//:: Range: Personal
//:: Area of Effect / Target: 5-ft.-radius sphere centered on you
//:: Duration: 1 round/level
//:: You are covered in a thin layer of white frost and frigid cold emanates
//:: from your body, dealing 1d6 points of cold damage at the start of your
//:: round to each creature within 5 feet.
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_AURA_COLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, TRUE  );
	effect eAOE = EffectAreaOfEffect(VFX_MOB_LESSER_AURA_COLD, "", "", "", sAOETag);
	effect eVis = EffectVisualEffect(924);
	
	
	effect	eLink		=	EffectLinkEffects(eAOE, eVis);

	
	//Determine duration
	fDuration = HkApplyMetamagicDurationMods(fDuration);

	//Generate the object
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, fDuration);
	
	HkPostCast(oCaster);
}