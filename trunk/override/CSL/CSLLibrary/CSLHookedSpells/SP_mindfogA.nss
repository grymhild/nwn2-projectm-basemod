//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a bank of fog that lowers the Will save
	of all creatures within who fail a Will Save by
	-10.  Affect lasts for 2d6 rounds after leaving
	the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
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
	int iSpellId = SPELL_MIND_FOG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_MIND|SCMETA_DESCRIPTOR_GAS, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_MIND_FOG_VIC);
	eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_WILL, 10));
	object oCreator = GetAreaOfEffectCreator();
	int bValid = FALSE;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCreator))
	{
		if ( !CSLGetIsImmuneToClouds(oTarget) )
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
			if (GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
			{
				effect eAOE = GetFirstEffect(oTarget);
				while (GetIsEffectValid(eAOE))
				{
					if (GetEffectSpellId(eAOE)==SPELL_MIND_FOG && oCreator==GetEffectCreator(eAOE) && GetEffectType(eAOE)==EFFECT_TYPE_SAVING_THROW_DECREASE)
					{
						RemoveEffect(oTarget, eAOE);
						bValid = TRUE;
					}
					eAOE = GetNextEffect(oTarget);
				}
			}
			if (!bValid)
			{
				if(!HkResistSpell(oCreator, oTarget))
				{
					if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_ROLL ))
					{
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCreator))
						{
							DelayCommand(CSLRandomBetweenFloat(1.0, 2.2), HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
						}
					}
				}
			}
			else
			{
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			}
		}
	}
}