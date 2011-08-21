//::///////////////////////////////////////////////
//:: Web: Heartbeat
//:: NW_S0_WebC.nss
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
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
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
	eLink = SetEffectSpellId(eLink, iSpellId);
	
	object oTarget;
	//Spell resistance check
	oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
			// if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
			if( !CSLGetIsIncorporeal( oTarget ) ) // AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
			{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
				{
				// *************
				// * Patch Fix
				// * Brent
				// * Moved the two spell cast events down after the reaction check check
					//Fire cast spell at event for the target
					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));

					//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
					//{
							//Make a Fortitude Save to avoid the effects of the entangle.
							//if(!/*Reflex Save*/ HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC()))
							//{
							//	//Entangle effect and Web VFX impact
							//	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, RoundsToSeconds(1));
							//	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
							//}
							if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC()))
							{
								//Entangle effect and Web VFX impact
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), iSpellId );
							}
					//}
				}
			}
			oTarget = GetNextInPersistentObject();
	}
}