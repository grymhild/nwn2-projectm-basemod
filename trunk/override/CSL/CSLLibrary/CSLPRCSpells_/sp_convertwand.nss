//::///////////////////////////////////////////////
//:: Name 	Convert Wand
//:: FileName sp_convert_wand.nss
//:://////////////////////////////////////////////
/**@file Convert Wand
Transmutation
Level: Clr 5
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Wand touched
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: No

This spell temporarily transforms a magic wand of
any type into a healing wand with the same number
of charges remaining. At the end of the spell's
duration, the wand's original effect is restored,
and any charges that were depleted remain so. The
spell level of the wand determines how powerful a
healing instrument the wand becomes:

Spell Level 	New Wand Type


1st 		Wand of cure light wounds

2nd 		Wand of cure moderate wounds

3rd 		Wand of cure serious wounds

4th 		Wand of cure critical wounds


For example, a 10th-level cleric can transform a wand
of lightning bolt (3rd'level spell) into a wand of
cure serious wounds for 10 minutes.

[11:43] <Primogenitor> Spam ahoy!
[11:43] <Primogenitor> 1) Store the current spellID, caster level, DC, & spell level on the wand from cast spell itemproperty.
[11:43] <Primogenitor> Include PRC itemproperties for caster level & DC
[11:43] <Primogenitor> 2) Add a new temporary cast spell itemproperty
[11:43] <Primogenitor> Include PRC itemproperty for casterlevel & DC
[11:43] <Primogenitor> (since cures are hostile to undead).
[11:43] <Primogenitor> 3) Mark the item with a local variable.
[11:43] <Primogenitor> 4) Modify the spellhook so non-cure spells cast from an item with that variable dont work.
[11:43] <Primogenitor> 5) Add a check to the spellhook that if the item has the local but no cure itemprops, clear the local and continue the spell.
[11:44] <Primogenitor> (this copes with logoff symptoms where the temp ip is lost and after the temp ip has expired)
[11:44] <Primogenitor> 6) Add lots of sanity checks. Not a wand, already a curing wand, etc.
[11:44] <Primogenitor> done ;)
[11:52] <Primogenitor> Oh, Tenjac dont forget to add a temporary Restricted Use : Cleric IP too ;)
[11:53] <Primogenitor> And its probably worth adding a clause that says "if I target a creature, get the first wand in its inventory"

Author: 	Tenjac
Created: 	7/3/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"

void WandCounter(object oCaster, object oSkin, object oNewWand, int nCounter);


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONVERT_WAND; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTargetWand = HkGetSpellTarget();
	int nLevel;
	int nSpellID;
	itemproperty ipSpell;

	//Check to be sure the target is a wand. If a creature, get first wand.
	if(GetObjectType(oTargetWand) == OBJECT_TYPE_CREATURE)
	{
		object oTest = GetFirstItemInInventory(oTargetWand);

		while(GetIsObjectValid(oTest))
		{
			if(GetBaseItemType(oTest) == BASE_ITEM_MAGICWAND)
			{
				oTargetWand = oTest;
				break;
			}
			oTest = GetNextItemInInventory(oTargetWand);
		}
	}

	//Make sure it's a wand
	if(GetBaseItemType(oTargetWand) != BASE_ITEM_MAGICWAND)
	{
		FloatingTextStringOnCreature("The target item is not a wand", oCaster, FALSE);
		return;
	}

	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = (60.0f * nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

	int nDC;

	//Get spell level
	itemproperty ipTest = GetFirstItemProperty(oTargetWand);

	while(GetIsItemPropertyValid(ipTest))
	{
		if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
		{
			//Get row
			int nRow = GetItemPropertySubType(ipTest);

			//Get spellID
			nSpellID = StringToInt(Get2DAString("iprp_spells", "SpellIndex", nRow));

			//Get spell level
			nLevel = StringToInt(Get2DAString("spells", "Innate", nSpellID));

		}
		if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_DC)
		{
			int nSubType = GetItemPropertySubType(ipTest);
			nSubType = StringToInt(Get2DAString("iprp_spells", "SpellIndex", nSubType));

			if(nSubType == nSpellID)
			{
				nDC = GetItemPropertyCostTableValue (ipTest);
			}
		}
		ipTest = GetNextItemProperty(oTargetWand);
	}

	//if it is already a healing wand, abort
	if(nSpellID == SPELL_CURE_MINOR_WOUNDS ||
		nSpellID == SPELL_CURE_LIGHT_WOUNDS ||
		nSpellID == SPELL_CURE_MODERATE_WOUNDS ||
		nSpellID == SPELL_CURE_SERIOUS_WOUNDS ||
		nSpellID == SPELL_CURE_CRITICAL_WOUNDS ||
		nSpellID == SPELL_HEAL)
	{
		FloatingTextStringOnCreature("The target wand is already a healing wand.", oCaster, FALSE);
		return;
	}

	//Store the current spellID, caster level, DC, & spell level on the wand from cast spell itemproperty
	SetLocalInt(oTargetWand, "PRC_ConvertWandSpellID", nSpellID);
	SetLocalInt(oTargetWand, "PRC_ConvertWandDC", nDC);
	SetLocalInt(oTargetWand, "PRC_ConvertWandCL", HkGetCasterLevel(oTargetWand));

	//Determine ip
	if(nLevel > 4)
	{
		nLevel = 4;
	}

	switch(nLevel)
	{
		case 0: ipSpell = ItemPropertyCastSpell(SPELL_CURE_MINOR_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);

		case 1: ipSpell = ItemPropertyCastSpell(SPELL_CURE_LIGHT_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
				break;

		case 2: ipSpell = ItemPropertyCastSpell(SPELL_CURE_MODERATE_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
				break;

		case 3: ipSpell = ItemPropertyCastSpell(SPELL_CURE_SERIOUS_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
				break;

		case 4: ipSpell = ItemPropertyCastSpell(SPELL_CURE_CRITICAL_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
				break;

		default: break;
	}

	//Set up Cleric req
	itemproperty ipCleric = ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC);

	//Add props
	CSLSafeAddItemProperty(oTargetWand, ipSpell, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
	CSLSafeAddItemProperty(oTargetWand, ipCleric, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

	//Mark the item with a local variable
	SetLocalInt(oTargetWand, "PRC_IsConvertedWand", 1);

}



