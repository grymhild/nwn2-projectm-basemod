//::///////////////////////////////////////////////
//:: Name 	Lantern Light
//:: FileName sp_lantrn_lght.nss
//:://////////////////////////////////////////////
/**@file Lantern Light
Evocation [Good, Light]
Level: Cleric 1, paladin 1, sorcerer/wizard 1, vassal
of Bahamut 1
Components: S, Abstinence
Casting Time: 1 standard action
Range: Close (25ft + 5ft/2 leves)
Effect: Ray
Duration: 1 round/level
Saving Throw: None
Spell Resistance: Yes

Rays of holy light flash from your eyes. You can fire
1 ray per 2 caster levels, but no more than 1 ray per
round. You must succeed on a ranged touch attack to
hit a target, The target takes 1d6 points of damage
from each ray.

Abstinance: You must obstain from sexual intercourse
for 24 hours before casting this spell.

Author: 	Tenjac
Created: 	7/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
#include "_HkSpell"
#include "_CSLCore_Combat"
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LANTERN_LIGHT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------

	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	float fMaxDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

	//INSERT SPELL CODE HERE
	int iAttackRoll = 0; 	//placeholder

	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		//Touch attack code goes here
		int iDamage = HkApplyMetamagicVariableMods(d6(), 6);
		iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE, oCaster );
			
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}