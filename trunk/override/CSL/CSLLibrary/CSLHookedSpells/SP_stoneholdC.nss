//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates an area of effect that will cover the
	creature with a stone shell holding them in
	place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: May 04, 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_stonehold(); //SPELL_STONEHOLD;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_STONEHOLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel,  SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nRounds;
	int iSaveDC = HkGetSpellSaveDC();
	effect eHold = EffectParalyze(iSaveDC, SAVING_THROW_FORT);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);
	effect eParal = EffectVisualEffect( VFX_DUR_PARALYZED );
	eHold = EffectLinkEffects( eHold, eParal );
	effect eFind;
	object oTarget;
	object oCreator;
	float fDelay;

	oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
		{
			if ( !CSLGetIsImmuneToClouds(oTarget) )
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD, TRUE ));
				if (!GetHasSpellEffect(SPELL_STONEHOLD,oTarget))
				{
					//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
					//{
						if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC))
						{
							nRounds = HkApplyMetamagicVariableMods( d6(), 6);
							fDelay = CSLRandomBetweenFloat(0.75, 1.75);
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, RoundsToSeconds(nRounds)));
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
						}
					//}
				}
			}
		}
		oTarget = GetNextInPersistentObject();
	}
}