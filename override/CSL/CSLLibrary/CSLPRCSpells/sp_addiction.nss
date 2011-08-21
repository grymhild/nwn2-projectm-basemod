//::///////////////////////////////////////////////
//:: Name 	Addiction
//:: FileName sp_addiction.nss
//:://////////////////////////////////////////////
/**@file Addiction
Enchantment
Level: Asn 1, Brd 2, Clr 2, Sor/Wiz 2
Components: V, S, Drug
Casting Time: 1 action
Range: Touch
Area: One living creature
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster gives the target an addiction to a drug.
A caster of level 5 or less can force the subject to
become addicted to any drug with a low addiction
rating. A 6th to 10th level caster can force an
addiction to any drug with a medium addiction
rating, and 11th to 15th level caster can force
addiction to a drug with a high addiction rating.
Casters of 16th level or higher can give the
subject an addiction to a drug with an extreme
addiction rating.

Author: 	Tenjac
Created: 	5/15/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	

	//spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ADDICTION; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);


	//SR
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Fort save
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			//determine addiction
			int nAddict = DISEASE_TERRAN_BRANDY_ADDICTION;

			if(nCasterLvl > 5)
			{
				nAddict = DISEASE_MUSHROOM_POWDER_ADDICTION;
			}
			if(nCasterLvl > 10)
			{
				nAddict = DISEASE_VODARE_ADDICTION;
			}
			if(nCasterLvl > 15)
			{
				nAddict = DISEASE_AGONY_ADDICTION;
			}

			//Construct effect
			effect eAddict = SupernaturalEffect(EffectDisease(nAddict));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oTarget);
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
