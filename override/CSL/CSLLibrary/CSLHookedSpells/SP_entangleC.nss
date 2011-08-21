//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_EntangleC.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the AOE the target must make
	a reflex save or be entangled by vegitation
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Updated Aug 14, 2003 Georg: removed some artifacts
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
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eHold = EffectEntangle();
	effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
	//Link Entangle and Hold effects
	effect eLink = EffectLinkEffects(eHold, eEntangle);
	effect eSlow = EffectSlow();
	object oCreator;
	int bValid;

	object oTarget = GetFirstInPersistentObject();

	while(GetIsObjectValid(oTarget))
	{  // SpawnScriptDebugger();
		// if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
		if( !CSLGetIsIncorporeal(oTarget) ) // AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE, TRUE));
					//Make SR check
					if(!GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
					{
							//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
							//{
								//Make reflex save
								if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC()))
								{
									//Apply linked effects
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
								}
								else
								{
									//Apply linked effects
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(1));
								}
							//}
					}
				}
			}
			//Get next target in the AOE
			oTarget = GetNextInPersistentObject();
	}
	
	HkPostCast(oCaster);
}