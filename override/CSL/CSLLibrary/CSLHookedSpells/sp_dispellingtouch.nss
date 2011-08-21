//::///////////////////////////////////////////////
//:: Name 	Dispelling Touch
//:: FileName sp_dispell_tch.nss
//:://////////////////////////////////////////////
/**@file Dispelling Touch
Abjuration
Level: Duskblade 3, sorcerer/wizard 2
Components: V,S
Casting Time: 1 standard action
Range: Touch
Target: One touched creature, object, or spell
		effect
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You can use dispelling touch to end an ongoing
spell that has been cast on a creature or object,
or a spell tha has a noticeable ongoing effect. You
mkae a dispel check (1d20 + your caster level, max
+10) against the spell effect with the highest
caster level. If that check fails, you make dispel
checks against progressively weaker spells until
you dispel one spell or you fail all your checks.
Magic items carried by a creature are not affected.
**/

/*
	PRC_SPELL_EVENT_ATTACK is set when a
		touch or ranged attack is used
	<END NOTES TO SCRIPTER>
*/
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary


#include "_HkSpell"
#include "_SCInclude_Abjuration"
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
	int iSpellId = SPELL_DISPELLING_TOUCH; // put spell constant here
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
	//do spell
	//--------------------------------------------------------------------------
	int nMetaMagic = HkGetMetaMagicFeat();

	//INSERT SPELL CODE HERE
	//int iAttackRoll = 0; 	//placeholder

	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		//AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_DISPEL_MAGIC, oTarget, nMetaMagic, TRUE, nCasterLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(SPELL_DISPELLING_TOUCH, TRUE),SPELL_DISPELLING_TOUCH ) );
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
