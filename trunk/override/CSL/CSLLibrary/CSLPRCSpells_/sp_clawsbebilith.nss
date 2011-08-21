//::///////////////////////////////////////////////
//:: Name: 	Claws of the Bebilith
//:: Filename: sp_claw_bebil.nss
//::///////////////////////////////////////////////
/**Claws of the Bebilith
Transmutation [Evil]
Level: Corrupt 5
Components: V, S, Corrupt
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/level

The caster gains claws that deal damage based on
her size (see below) and can catch and tear an
opponent's armor and shield. If the opponent has
both armor and a shield, roll 1d6: A result of 1-4
indicates the armor is affected, and a result of 5-6
affects the shield.

The caster makes a grapple check whenever she hits
with a claw attack, adding to the opponent's roll any
enhancement bonus from magic possessed by the
opponent's armor or shield. If the caster wins, the
armor or shield is torn away and ruined.

				Caster Size 		Claw Damage

				Fine 					1

				Diminutive 				1d2

				Tiny 					ld3

				Small 					ld4

				Medium-size 				ld6

				Large 					1d8

				Huge 					2d6

				Gargantuan 				2d8

				Colossal 				4d6

Corruption Cost: 1d6 points of Dexterity damage.


@author Written By: Tenjac
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
	int iSpellId = SPELL_CLAWS_OF_THE_BEBILITH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}


	//vars
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nClawSize = CSLGetSizeCategory(oTarget);
	int nBaseDamage;
	int nMetaMagic = HkGetMetaMagicFeat();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	// Determine base damage
	switch(nClawSize)
	{
		case 0: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d2; break;
		case 1: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d2; break;
		case 2: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3; break;
		case 3: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d4; break;
		case 4: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d6; break;
		case 5: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d8; break;
		case 6: nBaseDamage = IP_CONST_MONSTERDAMAGE_2d6; break;
		case 7: nBaseDamage = IP_CONST_MONSTERDAMAGE_2d8; break;
	}
	// Catch exceptions here
	if (nClawSize < 0) nBaseDamage = IP_CONST_MONSTERDAMAGE_1d2;
	else if (nClawSize > 7) nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6;

	// Create the creature weapon
	object oLClaw 	= GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster);
	object oRClaw 	= GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCaster);

	// Add the base damage
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oLClaw, fDuration);
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oRClaw, fDuration);

	//Set up property
	itemproperty ipClaws = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));

	//Add event script
	AddEventScript(oLClaw, EVENT_ONHIT, "prc_evnt_clbebil", TRUE, FALSE);
	AddEventScript(oRClaw, EVENT_ONHIT, "prc_evnt_clbebil", TRUE, FALSE);

	//Add props
	CSLSafeAddItemProperty(oLClaw, ipClaws, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	CSLSafeAddItemProperty(oRClaw, ipClaws, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}