//::///////////////////////////////////////////////
//:: Name 	Extract Drug
//:: FileName sp_extract_drug.nss
//:://////////////////////////////////////////////
/**@file Extract Drug
Conjuration (Creation)
Level: Brd 1, Clr 1, Drd 1, Sor/Wiz 1
Components: V S, F
Casting Time: 1 minute
Range: Touch
Effect: One dose of a drug
Duration: Permanent

The caster infuses a substance with energy and
creates a magical version of a drug. The magical
version manifests as greenish fumes that rise from
the chosen focus. The fumes must then be inhaled
as a standard action within 1 round to get the
drug's effects.

The type of drug extracted depends on the substance
used.
			Drug Extracted 		Effect on Focus

Material

	Metal 		Baccaran 			Metal's hardness drops by l.
	Stone 		Vodare 			Stone's hardness drops by 1.
	Water 		Sannish 			Water becomes brackish and foul.
	Air 		Mordayn 			Foul odor fills the vapor area
	Wood 		Mushroom powder 	Wood takes on a permanent foul odor



There may be other drugs that can be extracted with
rarer substances, at the DM's discretion.

Focus: 15 lb. or 1 cubic foot of the material in question.


Author: 	Tenjac
Created: 	7/3/06
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
	int iSpellId = SPELL_EXTRACT_DRUG; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//

	//SPSetSchool();

	
	int nSpell = HkGetSpellId();
	int nMetaMagic = HkGetMetaMagicFeat();

	if(nSpell == SPELL_EXTRACT_BACCARAN)
	{
		ActionCastSpellAtObject(SPELL_BACCARAN, oCaster, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}

	if(nSpell == SPELL_EXTRACT_VODARE)
	{
			ActionCastSpellAtObject(SPELL_VODARE, oCaster, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}

	if(nSpell == SPELL_EXTRACT_SANNISH)
	{
			ActionCastSpellAtObject(SPELL_SANNISH, oCaster, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}

	if(nSpell == SPELL_EXTRACT_MUSHROOM_POWDER)
	{
			ActionCastSpellAtObject(SPELL_MUSHROOM_POWDER, oCaster, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

