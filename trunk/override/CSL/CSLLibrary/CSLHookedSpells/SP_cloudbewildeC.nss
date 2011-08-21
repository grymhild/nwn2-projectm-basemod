//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewldC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A cone of noxious air goes forth from the caster.
	Enemies in the area of effect are stunned and blinded
	1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCreator = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCreator, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_CLOUD_OF_BEWILDERMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_POISON|SCMETA_DESCRIPTOR_GAS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eStun = EffectVisualEffect(VFX_DUR_STUN);
	eStun = EffectLinkEffects(eStun, EffectStunned());
	eStun = EffectLinkEffects(eStun, EffectBlindness());


	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCreator))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_CLOUD_OF_BEWILDERMENT, TRUE));
			if (!GetHasSpellEffect(SPELL_CLOUD_OF_BEWILDERMENT,oTarget))
			{
				//if (!HkResistSpell(oCreator, oTarget))
				//{
					if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_POISON))
					{
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) && !CSLGetIsImmuneToClouds(oTarget) )
						{
							float fDelay = CSLRandomBetweenFloat(0.75, 1.75);
							int nRounds = HkApplyMetamagicVariableMods(d6(1), 6);
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_BLIND), oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nRounds)));
						}
					}
				//}
			}
		}
		oTarget = GetNextInPersistentObject();
	}
}