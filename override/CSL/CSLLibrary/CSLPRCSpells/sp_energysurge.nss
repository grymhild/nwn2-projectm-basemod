//::///////////////////////////////////////////////
//:: Name 	Energy Surge
//:: FileName sp_energy_srg.nss
//:://////////////////////////////////////////////
/**@file Energy Surge
Transmutation [See text]
Duskblade 3, sorcerer/wizard 3
Components: V
Casting time: 1 swift action
Range: Close
Target: One weapon
Duration: 1 round
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You temporarily imbue a weapon with elemental
energy. When you cast this spell, specify an
energy type (acid, cold, electricity, fire, or
sonic). This spell is a spell of that type, and
the target weapon is sheathed in that energy. If
the attack is successful, it deals an extra 2d6
points of energy damage.

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
	int iSpellId = SPELL_ENERGY_SURGE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}


	
	
	object oTarget = HkGetSpellTarget();
	int nSpell = HkGetSpellId();
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDur = RoundsToSeconds(1);
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nDamType;
	
	int nDam = HkApplyMetamagicVariableMods(d6(2), 12);

	//Get the item to be enhanced
	if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	{
		if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
		{
			oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		}
		else if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)))
		{
			oTarget = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
		}

		else
		{
			
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
			return;
		}
	}

	//Determine damage type
	if(nSpell == SPELL_ENERGY_SURGE_ACID)
	{
		nDamType = IP_CONST_DAMAGETYPE_ACID;
	}

	else if(nSpell == SPELL_ENERGY_SURGE_COLD)
	{
		nDamType = IP_CONST_DAMAGETYPE_COLD;
	}

	else if(nSpell == SPELL_ENERGY_SURGE_ELEC)
	{
		nDamType = IP_CONST_DAMAGETYPE_ELECTRICAL;
	}

	else if(nSpell == SPELL_ENERGY_SURGE_FIRE)
	{
		nDamType = IP_CONST_DAMAGETYPE_FIRE;
	}

	else if(nSpell == SPELL_ENERGY_SURGE_SONIC)
	{
		nDamType = IP_CONST_DAMAGETYPE_SONIC;
	}

	else
	{
		return;
	}

	itemproperty ipBuff = ItemPropertyDamageBonus(nDamType, nDam);

	CSLSafeAddItemProperty(oTarget, ipBuff, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
