//::///////////////////////////////////////////////
//:: Filter (OnEnter)
//:: sg_s0_filterA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Abjuration
	Level: Sor/Wiz 2
	Components: V, S
	Casting Time: 1 action
	Range: Touch
	Area: 10 ft sphere around creature touched
	Duration: 1 turn/level
	Saving Throw: None
	Spell Resistance: No

	This spell creates an invisible globe of protection
	that filters out all noxious elements from poisonous
	vapors created by spells (such as Stinking Cloud),
	making them immune to damage and any penalties from
	said effects. Effects from dragon's breath (such as
	a green dragon's chlorine gas) cause half-damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 1, 2004
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= GetEnteringObject();
	//location lTarget 		= HkGetSpellTargetLocation();
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration; 		//= HkGetSpellDuration(iCasterLevel);


	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImmune1 = EffectSpellImmunity(SPELL_STINKING_CLOUD);
	effect eImmune2 = EffectSpellImmunity(SPELL_CLOUDKILL);
	effect eImmune3 = EffectSpellImmunity(SPELL_IGEDRAZAARS_MIASMA);
	effect eImmune4 = EffectSpellImmunity(SPELL_CHROMATIC_ORB_GREEN);
	effect eImmune5 = EffectSpellImmunity(SPELLABILITY_TYRANT_FOG_MIST);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eImmune1, eImmune2);
	eLink = EffectLinkEffects(eLink, eImmune3);
	eLink = EffectLinkEffects(eLink, eImmune4);
	eLink = EffectLinkEffects(eLink, eImmune5);
	eLink = EffectLinkEffects(eLink, eDur);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FILTER, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

}