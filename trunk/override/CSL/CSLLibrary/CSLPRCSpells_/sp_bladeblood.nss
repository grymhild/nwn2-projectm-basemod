//::///////////////////////////////////////////////
//:: Name 	Blade of Blood
//:: FileName sp_blade_blood.nss
//:://////////////////////////////////////////////
/**@file Blade of Blood
Necromancy
Level: Assassin 1, blackguards 1, cleric 1,
		duskblade 1, sorcerer/wizard 1
Components: V,S
Casting Time: 1 swift action
Range: Touch
Target: Weapon touched
Duration: 1 round/level or until dicharged
Saving Throw: None
Spell Resistance: No

This spell infuses the weapon touched with baleful
energy. The next time this weapon strikes a
living creature, blade of blood discharges. The
spell deals an extra 1d6 points of damage against
the target of the attack. You can voluntarily take
5 hit points of damage to empower the weapon to deal
an extra 2d6 points of damage(for a total of 3d6
points of extra damage).

The weapon loses this property if its wielder drops
it or otherwise loses contact with it.

**/
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLADE_OF_BLOOD; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//


	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nSpell = HkGetSpellId();
	int nHPLoss;
	//float fDur = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int nMetaMagic = HkGetMetaMagicFeat();


	int nDamBonus = d6(1);

	if(nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDamBonus = 6;
	}

	if(nSpell == SPELL_BLADE_OF_BLOOD_EMP)
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(DAMAGE_TYPE_MAGICAL, 5), oCaster);
		nDamBonus = d6(3);

		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDamBonus = 18;
		}

		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oCaster);
	}

	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDamBonus += (nDamBonus/2);
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nDamBonus, DAMAGE_TYPE_MAGICAL), oCaster, fDuration);

	//Set up removal
	itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);

	CSLSafeAddItemProperty(oWeapon, ipHook, fDuration);

	AddEventScript(oWeapon, EVENT_ONHIT, "prc_evnt_bloodb", FALSE, FALSE);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}