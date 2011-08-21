//::///////////////////////////////////////////////
//:: Name 		Bone Blade
//:: FileName 	sp_bone_blade.nss
//:://////////////////////////////////////////////
/**@file Boneblade
Necromancy [Evil]
Level: Blk 2, Clr 3
Components: V, S, F, Undead
Casting Time: 1 action
Range: Touch
Effect: One bone that becomes a blade
Duration: 10 minutes/level

The caster changes a bone at least 6 inches long into
a longsword, short sword, or greatsword (caster's choice).
This weapon has a +1 enhancement bonus on attacks and
damage for every five caster levels (at least +1,
maximum +4). Furthermore, this blade deals an extra +1d6
points of damage to living targets and an additional +1d6
points of damage to good'aligned targets.

This spell confers no proficiency with the blade, but the
caster doesn't need to be the one wielding the blade for
it to be effective.

Focus: A 6-inch-long bone.

SPELL_BONEBLADE_GREATSWORD
SPELL_BONEBLADE_LONGSWORD
SPELL_BONEBLADE_SHORTSWORD


Author: 	Tenjac
Created: 	3/9/2006
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
	int iSpellId = SPELL_BONEBLADE; // put spell constant here
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
	int nMetaMagic = HkGetMetaMagicFeat();
	int nEnhance = 1;
	int nSpell = HkGetSpellId();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	string sSword;
	int nRandom = d3(1);
	


	//Check for undeath
	if( CSLGetIsUndead(oCaster) )
	{
		//Summon blade
		if(nSpell == SPELL_BONEBLADE_GREATSWORD)
		{
			if(nRandom == 1)
			{
				sSword = "wswgs071";
			}

			if(nRandom == 2)
			{
				sSword = "wswgs072";
			}

			else
			{
				sSword = "wswgs073";
			}
		}

		if(nSpell == SPELL_BONEBLADE_LONGSWORD)
		{
			if(nRandom == 1)
			{
				sSword = "wswls091";
			}

			if(nRandom == 2)
			{
				sSword = "wswls092";
			}

			else
			{
				sSword = "wswls093";
			}
		}

		if(nSpell == SPELL_BONEBLADE_SHORTSWORD)
		{
			if(nRandom == 1)
			{
				sSword = "wswss071";
			}

			if(nRandom == 2)
			{
				sSword = "wswss072";
			}

			else
			{
				sSword = "wswss073";
			}
		}

		//Create sword
		object oSword = CreateItemOnObject(sSword, oCaster, 1);

		//+1 per 5 levels
		if(nCasterLvl > 9)
		{
			nEnhance = 2;
		}

		if(nCasterLvl > 14)
		{
			nEnhance = 3;
		}

		if(nCasterLvl > 19)
		{
			nEnhance = 4;
		}

		IPSetWeaponEnhancementBonus(oSword, nEnhance);

		//+1d6 good
		itemproperty ipProp = ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, d6(1));

		CSLSafeAddItemProperty(oSword, ipProp, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

		//+1d6 living, use onHit Unique Power
		itemproperty ipBlade = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
		CSLSafeAddItemProperty(oSword, ipBlade, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

		AddEventScript(oSword, EVENT_ONHIT, "prc_evnt_bonebld", TRUE, FALSE);


		//Schedule deletion of item
		DelayCommand(fDuration, DestroyObject(oSword));

	}
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


