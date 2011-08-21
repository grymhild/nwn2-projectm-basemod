//::///////////////////////////////////////////////
//:: Name 	Seeking Ray
//:: FileName sp_seeking_ray.nss
//:://////////////////////////////////////////////
/**@file Seeking Ray
Evocation
Level: Duskblade 2, sorcerer/wizard 2
Components: V,S
Casting Time: 1 standard action
Range: Medium
Effect: Ray
Duration: Instantaneous; see text
Saving Throw: None
Spell Resistance: Yes

You create a ray that deals 4d6 points of electricity
damage if it strikes your target. While this ray
requires a ranged touch attack to strike an opponent,
it ignores concealment and cover (but not total
concealment or total cover), and it does not take the
standard penalty for firing into melee.

In addition to the damage it deals, the ray creates a
link of energy between you and the subject. If this
ray struck the target and dealt damage, you gain a +4
bonus on attacks you make with ray spells (including
another casting of this one, if desired) against the
subject for 1 round per caster level. If you cast
seeking ray a second time on a creature that is still
linked to you from a previous casting, the duration
of the new link overlaps (does not stack with) the
remaining duration of the previous one.

**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date: 	26.9.06
//////////////////////////////////////////////////////
//#include "prc_alterations"
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
	
	return iAttackRoll; 	//return TRUE if spell charges should be decremented
}
*/




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SEEKING_RAY; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	//int nPenetr = nCasterLevel + SPGetPenetr();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int iTouch = CSLTouchAttackRanged(oTarget);
	
	//Beam VFX. Ornedan is my hero.
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND, !iTouch), oTarget, 1.0f);

	
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			//Touch attack code goes here
			int iDamage = HkApplyMetamagicVariableMods(d4(4), 24);
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );

			ApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(DAMAGE_TYPE_ELECTRICAL, iDamage), oTarget);

			//Apply VFX for duration to enable "seeking" - add code to prc_inc_sp_touch!
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, fDuration);
		}
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}