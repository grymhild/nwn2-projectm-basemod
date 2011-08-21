//::///////////////////////////////////////////////
//:: Name 	Divine Sacrifice
//:: FileName sp_divine_sac.nss
//:://////////////////////////////////////////////
/**@file Divine Sacrifice
Necromancy
Level: Paladin 1
Compnonents: V,S
Casting Time: 1 standard action
Range: Personal
Target: Self
Duration: 1 round/level or until discharged

You can sacrifice life force to increase the damage
you deal. When you cast the spell, you can sacrifice
up to 10 of your hit points. For every 2 hp you
sacrifice, on your next successful attack you deal
+1d6 damage, to a maximum of +5d6 on that attack.
Your ability to deal this extra damage ends when you
successfully attack or when the spell duration ends.
Sacrificed hit points count as normal lethal damage,
even if you have the regenration ability.

Author: 	Tenjac
Created: 	6/22/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIVINE_SACRIFICE; // put spell constant here
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
	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nSpell = HkGetSpellId();
	int nDam;
	int nHPLoss;
	//float fDur = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	nDam = d6(1);
	nHPLoss = 2;
	/*	
	if(nSpell == SPELL_DIVINE_SACRIFICE_2)
	{
		nDam = d6(1);
		nHPLoss = 2;
	}
	else if(nSpell == SPELL_DIVINE_SACRIFICE_4)
	{
		nDam = d6(2);
		nHPLoss = 4;
	}
	else if(nSpell == SPELL_DIVINE_SACRIFICE_6)
	{
		nDam = d6(3);
		nHPLoss = 6;
	}
	else if(nSpell == SPELL_DIVINE_SACRIFICE_8)
	{
		nDam = d6(4);
		nHPLoss = 8;
	}
	else if(nSpell == SPELL_DIVINE_SACRIFICE_10)
	{
		nDam = d6(5);
		nHPLoss = 10;
	}
	*/

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nHPLoss, DAMAGE_TYPE_DIVINE), oCaster);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nDam, DAMAGE_TYPE_MAGICAL), oCaster, fDuration);

	//Set up removal
	itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);

	CSLSafeAddItemProperty(oWeapon, ipHook, fDuration);

	AddEventScript(oWeapon, EVENT_ONHIT, "prc_evnt_dvnsac", FALSE, FALSE);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




