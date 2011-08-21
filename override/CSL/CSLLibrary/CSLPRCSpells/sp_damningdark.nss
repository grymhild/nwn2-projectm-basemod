//::///////////////////////////////////////////////
//:: Name 	Damning Darkness
//:: FileName sp_damng_dark.nss
//:://////////////////////////////////////////////
/**@file Damning Darkness
Evocation [Darkness, Evil]
Level: Clr 4, Darkness 4, Sor/Wiz 4
Components: V, M/DF
Casting Time: 1 action
Range: Touch
Target: Object touched
Duration: 10 minutes/level (D)
Saving Throw: None
Spell Resistance: No

This spell is similar to darkness, except that those
within the area of darkness also take unholy damage.
Creatures of good alignment take 2d6 points of
damage per round in the darkness, and creatures
neither good nor evil take 1d6 points of damage. As
with the darkness spell, the area of darkness is a
20-foot radius, and the object that serves as the
spell's target can be shrouded to block the darkness
(and thus the dam'aging effect).

Damning darkness counters or dispels any light spell
of equal or lower level.

Arcane Material Component: A dollop of pitch with a
tiny needle hidden inside it.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Combat"
#include "_CSLCore_Nwnx"
void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DAMNING_DARKNESS; // put spell constant here
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

	//

	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_DAMNDARK);
	
	object oTarget = HkGetSpellTarget();
	object oItemTarget = oTarget;
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	location lLoc = GetLocation(oTarget);

	//Check for Soul Rot
	if(CSLGetPersistentInt(oCaster, "PRC_Has_Soul_Rot"))
	{
		//Make touch
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			//Create an instance of the AOE Object using the Apply Effect function

			HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);
		}
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}