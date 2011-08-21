//::///////////////////////////////////////////////
//:: Name 	Resonating Resistance
//:: FileName sp_res_resist.nss
//:://////////////////////////////////////////////
/**@file Resonating Resistance
Transmutation
Level: Clr 5, Mortal Hunter 4, Sor/Wiz 5
Components: V, Fiend
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 1 minute/level

The caster improves his spell resistance. Each time
a foe attempts to bypass the caster's spell
resistance, it must make a spell resistance check
twice. If either check fails, the foe fails to bypass
the spell resistance.

The caster must have spell resistance as an
extraordinary ability for resonating resistance to
function. Spell resistance granted by a magic item or
the spell resistance spell does not improve.

Author: 	Tenjac
Created: 	7/5/06
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
	int iSpellId = SPELL_RESONATING_RESISTANCE; // put spell constant here
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
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = (60.0f * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	int nMetaMagic = HkGetMetaMagicFeat();
	effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	

	//if is a fiend
	if((GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL) && ( CSLGetIsOutsider(oCaster) ))
	{
		//has spell SR on hide
		object oSkin = CSLGetPCSkin(oCaster);
		itemproperty iTest = GetFirstItemProperty(oSkin);
		int bValid = FALSE;

		while(GetIsItemPropertyValid(iTest))
		{
			if(GetItemPropertyType(iTest) == ITEM_PROPERTY_SPELL_RESISTANCE)
			{
				bValid = TRUE;
			}
			iTest = GetNextItemProperty(oSkin);
		}

		if(bValid == TRUE)
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, fDuration);
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

