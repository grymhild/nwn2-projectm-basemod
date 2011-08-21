//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates an area of effect that will cover the
	creature with a stone shell holding them in
	place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: August  2003
//:: Updated   : October 2003
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
	int iSpellId = SPELL_STONEHOLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel,  SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
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
	//Get the first object in the persistant area
	oTarget = GetEnteringObject();
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		if ( !CSLGetIsImmuneToClouds(oTarget) )
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD, TRUE ));
			//Make a SR check
			//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
			//{
				//Make a Fort Save
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
				{
					nRounds = HkApplyMetamagicVariableMods( d6(), 6);
					fDelay = CSLRandomBetweenFloat(0.45, 1.85);
					//Apply the VFX impact and linked effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, RoundsToSeconds(nRounds)));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				}
			//}
		}
	}
}