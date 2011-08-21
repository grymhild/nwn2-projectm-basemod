//::///////////////////////////////////////////////
//:: Name 	Sicken Evil
//:: FileName sp_sickn_evil.nss
//:://////////////////////////////////////////////
/**@file Sicken Evil
Necromancy [Good]
Level: Sanctified 5
Components: V, S, Sacrifice
Casting Time: 1 standard action
Range: Personal
Area: 20-ft.-radius emanation
Duration: 1 minute/level (D)
Saving Throw: None
Spell Resistance: Yes

You emanate a powerful aura that sickens evil
creatures within the specified area.

Sacrifice: 1d4 points of Strength damage.

<Flaming_Sword> sickened: The character takes a -2
penalty on all attack rolls, saving throws, skill
checks and ability checks.

Author: 	Tenjac
Created: 	6/30/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SICKEN_EVIL; // put spell constant here
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

	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(VFX_PER_20_FT_INVIS);
	
	object oTarget = HkGetSpellTarget();
	object oItemTarget = oTarget;
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//int nMetaMagic = HkGetMetaMagicFeat();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	location lLoc = HkGetSpellTargetLocation();


	//Create an instance of the AOE Object using the Apply Effect function

	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);

	CSLSpellGoodShift(oCaster);
	DelayCommand(fDuration, SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d4(), 0));
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}