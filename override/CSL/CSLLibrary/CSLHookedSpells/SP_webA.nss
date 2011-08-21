//::///////////////////////////////////////////////
//:: Web: On Enter
//:: NW_S0_WebA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a mass of sticky webs that cling to
	and entangle targets who fail a Reflex Save
	Those caught can make a new save every
	round.  Movement in the web is 1/5 normal.
	The higher the creatures Strength the faster
	they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_WEB;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_CREATION;
	if ( GetSpellId() == SPELL_GREATER_SHADOW_CONJURATION_WEB )
	{
		//iSpellId=SPELL_GREATER_SHADOW_CONJURATION_WEB;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eLink = EffectLinkEffects( EffectEntangle(), EffectVisualEffect(VFX_DUR_WEB) );
	eLink = SetEffectSpellId(eLink, SPELL_WEB);
	
	object oTarget = GetEnteringObject();

	// * the lower the number the faster you go
	int nSlow = 65 - ( GetAbilityScore(oTarget, ABILITY_STRENGTH)*2 );
	if (nSlow <= 0)
	{
		nSlow = 1;
	}

	if (nSlow > 99)
	{
		nSlow = 99;
	}

	effect eSlow = EffectMovementSpeedDecrease(nSlow);
	eSlow = SetEffectSpellId(eSlow, iSpellId );
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
			// if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
			if( !CSLGetIsIncorporeal( oTarget ) ) // AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
			{
				//Fire cast spell at event for the target
				SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), iSpellId ));
				//Spell resistance check
				//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
				//{
					//Make a Fortitude Save to avoid the effects of the entangle.
					if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC()))
					{
							//Entangle effect and Web VFX impact
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), iSpellId );
					}
					//Slow down the creature within the Web
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget, 0.0f, iSpellId );
					
				//}
			}
	}
}