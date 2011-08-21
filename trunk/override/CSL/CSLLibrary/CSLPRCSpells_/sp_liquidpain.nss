//::///////////////////////////////////////////////
//:: Name 	Liquid Pain
//:: FileName sp_liquid_pain.nss
//:://////////////////////////////////////////////
/**@file Liquid Pain
Necromancy
Level: Pain 4, Sor/Wiz 4
Components: V, S, F
Casting Time: 1 day
Range: Touch
Target: One living creature
Duration: Permanent
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster takes a subject already in great pain,
wracked with disease, the victim of torture, or
dying of a wound, for example-and captures its pain
in liquid form. This physical manifestation of agony
can be used to create magic items or enhance spells. It
can also be used as a potent drug.

Focus: A jar, vial, or other container for the liquid pain.

Author: 	Tenjac
Created: 	5/19/06
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
	int iSpellId = SPELL_LIQUID_PAIN; // put spell constant here
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
	
	object oTarget = HkGetSpellTarget();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	effect eVis = EffectVisualEffect(VFX_COM_BLOOD_CRT_RED);
	int nCasterLvl = HkGetCasterLevel(oCaster);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_LIQUID_PAIN, oCaster);

	//SR
	if(!HkResistSpell(OBJECT_SELF, oTarget ))
		{
		//Save
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			//Check for pain
			if(CSLGetHasEffectType(oTarget,EFFECT_TYPE_DISEASE) ||
				CSLGetHasEffectType(oTarget,EFFECT_TYPE_POISON) ||
				GetHasSpellEffect(SPELL_ETERNITY_OF_TORTURE, oTarget) ||
				GetHasSpellEffect(SPELL_WRACK, oTarget) ||
				GetHasSpellEffect(SPELL_WAVE_OF_PAIN, oTarget) ||
				GetHasSpellEffect(SPELL_AVASCULAR_MASS, oTarget) ||
				GetHasSpellEffect(SPELL_RED_FESTER, oTarget))
			{
				if(!GetLocalInt(oTarget, "PRC_AgonyExtracted"))
				{
					//Create liquid pain in caster's inventory
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					CreateItemOnObject("prc_agony", oCaster, 1);
					SetLocalInt(oTarget, "PRC_AgonyExtracted", 1);
					DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "PRC_AgonyExtracted"));
				}
			}
			}

	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}






