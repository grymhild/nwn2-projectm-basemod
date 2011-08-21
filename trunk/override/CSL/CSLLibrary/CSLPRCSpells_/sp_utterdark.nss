//::///////////////////////////////////////////////
//:: Name 	Utterdark
//:: FileName sp_utterdark.nss
//:://////////////////////////////////////////////
/**@file Utterdark
Conjuration (Creation) [Evil]
Level: Darkness 8, Demonic 8, Sor/Wiz 9
Components: V, S, M/DF
Casting Time: 1 hour
Range: Close (25 ft. + 5 ft./2 levels)
Area: 100-ft./level radius spread, centered on caster
Duration: 1 hour/level
Saving Throw: None
Spell Resistance: No

Utterdark spreads from the caster, creating an area
of cold, cloying magical darkness. This darkness is
similar to that created by the deeper darkness spell,
but no magical light counters or dispels it.
Furthermore, evil aligned creatures can see in this
darkness as if it were simply a dimly lighted area.

Arcane Material Component: A black stick, 6 inches
long, with humanoid blood smeared upon it.

Author: 	Tenjac
Created: 	5/21/06

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_misc_const"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UTTERDARK; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	

	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_UTTERDARK);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	location lLoc = GetLocation(oCaster);

	//Create an instance of the AOE Object using the Apply Effect function

	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}