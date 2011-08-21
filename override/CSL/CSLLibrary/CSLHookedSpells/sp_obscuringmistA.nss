//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist.nss
//:://////////////////////////////////////////////
/*
	All people within the AoE get 20% conceal.
*/
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_OBSCURING_MIST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis2 = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
	effect eLink = EffectLinkEffects(eVis2, EffectConcealment(20));
	//Capture the first target object in the shape.

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));

	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, iSpellId );

}
