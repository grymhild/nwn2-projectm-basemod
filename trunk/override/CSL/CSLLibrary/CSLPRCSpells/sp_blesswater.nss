//::///////////////////////////////////////////////
//:: Name 	Bless Water
//:: FileName sp_bless_water.nss
//:://////////////////////////////////////////////
/** @file Bless Water
Transmutation [Good]
Level: 	Clr 1, Pal 1
Components: 	V, S, M
Casting Time: 	1 minute
Range: 	Touch
Target: 	Flask of water touched
Duration: 	Instantaneous
Saving Throw: 	Will negates (object)
Spell Resistance: 	Yes (object)

This transmutation imbues a flask (1 pint) of water with positive energy, turning it into holy water.
Material Component

5 pounds of powdered silver (worth 25 gp).
*/
////////////////////////////////////////////////////
// Author: Tenjac
// Date: 4.10.06
////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLESS_WATER; // put spell constant here
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

	CreateItemOnObject("x1_wmgrenade005", oCaster, 1);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

