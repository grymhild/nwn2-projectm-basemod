//::///////////////////////////////////////////////
//:: Name 	Solid Fog
//:: FileName sp_solid_fog.nss
//:://////////////////////////////////////////////
/**@file Solid Fog
Conjuration (Creation)
Level: Sor/Wiz 4, Hexblade 4
Components: V, S, M
Duration: 1 min./level
Spell Resistance: No

This spell functions like fog cloud, but in addition
to obscuring sight, the solid fog is so thick that
any creature attempting to move through it progresses
at a speed of 5 feet, regardless of its normal speed,
and it takes a -2 penalty on all melee attack and
melee damage rolls. The vapors prevent effective
ranged weapon attacks (except for magic rays and the
like). A creature or object that falls into solid fog
is slowed, so that each 10 feet of vapor that it
passes through reduces falling damage by 1d6. A
creature can't take a 5-foot step while in solid fog.

However, unlike normal fog, only a severe wind
(31+ mph) disperses these vapors, and it does so in
1 round.

Solid fog can be made permanent with a permanency
spell. A permanent solid fog dispersed by wind
reforms in 10 minutes.

Material Component: A pinch of dried, powdered peas
				combined with powdered animal hoof.
**/

///////////////////////////////////////////////////////
// Author: Tenjac
// Date: 	17.9.06
//////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SOLID_FOG; // put spell constant here
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
	object oTarget = HkGetSpellTarget();
	int nMetaMagic = HkGetMetaMagicFeat();
	int iSpellPower = HkGetSpellPower(oCaster, 15);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );

	effect eAOE = EffectAreaOfEffect(AOE_PER_SOLID_FOG, "", "", "", sAOETag);

	// Duration Effects
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, HkGetSpellTargetLocation(),fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


