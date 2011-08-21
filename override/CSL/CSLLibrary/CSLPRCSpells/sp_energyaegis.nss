//::///////////////////////////////////////////////
//:: Name 	Energy Aegis
//:: FileName sp_enrgy_aegis.nss
//:://////////////////////////////////////////////
/**@file Energy Aegis
Abjuration
Level: Cleric 3, duskblade 3, sorcerer/wizard 3
Components: V, DF
Casting time: 1 immediate action
Range: Close
Target: One creature
Duration: 1 round
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

When you cast energy aegis, speify an energy type
(acid, cold, electricity, fire, or sonic). Against
the next attack using this energy type that targets
the subject, it gains resistance 20.
SPELL_ENERGY_AEGIS_ACID
SPELL_ENERGY_AEGIS_COLD
SPELL_ENERGY_AEGIS_ELEC
SPELL_ENERGY_AEGIS_FIRE
SPELL_ENERGY_AEGIS_SONIC
**/
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENERGY_AEGIS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------	
	object oTarget = HkGetSpellTarget();
	int nSpell = HkGetSpellId();
	int nDamType;
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDur = RoundsToSeconds(1);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,FALSE, SPELL_ENERGY_AEGIS, oCaster);

	if(nSpell == SPELL_ENERGY_AEGIS_ACID)
	{
		nDamType = DAMAGE_TYPE_ACID;
	}

	else if(nSpell == SPELL_ENERGY_AEGIS_COLD)
	{
		nDamType = DAMAGE_TYPE_COLD;
	}

	else if(nSpell == SPELL_ENERGY_AEGIS_ELEC)
	{
		nDamType = DAMAGE_TYPE_ELECTRICAL;
	}

	else if(nSpell == SPELL_ENERGY_AEGIS_FIRE)
	{
		nDamType = DAMAGE_TYPE_FIRE;
	}

	else if(nSpell == SPELL_ENERGY_AEGIS_SONIC)
	{
		nDamType = DAMAGE_TYPE_SONIC;
	}

	else
	{
		
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
		return;
	}

	effect eBuff = EffectDamageResistance(nDamType, 20, 0);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





