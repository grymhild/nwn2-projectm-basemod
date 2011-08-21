//::///////////////////////////////////////////////
//:: Trip Vine - OnEnter
//:: cmi_s0_tripvinea
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Trip Vine
//:: Transmutation
//:: Level: Druid 2, Ranger 2
//:: Components: VS
//:: Range: Medium
//:: Area: 20-ft.-radius
//:: Duration: 3 minutes
//:: Saving Throw: Reflex negates
//:: Spell Resistance: No
//:: Trip vine causes plants within the area to grow together to form a tangle.
//:: Any creature entering or within the affected area must succeed on a Reflex
//:: save or be knocked down.
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_TRIP_VINE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	effect eKD = EffectKnockdown();
	effect eVis = EffectVisualEffect(VFX_DUR_WEB);
	effect eLink = EffectLinkEffects(eKD, eVis);
	object oTarget = GetEnteringObject();

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
	{
		if( !CSLGetIsIncorporeal(oTarget) ) //if( (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));

			if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC()))
			{
				//Fire cast spell at event for the target
				
				//Entangle effect and Web VFX impact
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), iSpellId );
			}
		}
	}
}