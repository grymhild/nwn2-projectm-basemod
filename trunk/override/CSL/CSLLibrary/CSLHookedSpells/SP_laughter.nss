//::///////////////////////////////////////////////
//:: Tasha's Hideous Laughter
//:: [x0_s0_laugh.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target is held, laughing for the duration
	of the spell (1d3 rounds)

*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TASHAS_HIDEOUS_LAUGHTER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster ) ;
	object oTarget = HkGetSpellTarget();
	int iModifier = 0;
	if (GetRacialType(oTarget)==GetRacialType(oCaster)) iModifier = 2;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_TASHAS_HIDEOUS_LAUGHTER));
		if (CSLGetIsMindless(oTarget)==FALSE)
		{
			if (!HkResistSpell(oCaster, oTarget) && !HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()+iModifier, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				if (!GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, oCaster))
				{
					float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( iDuration ));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT), oTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELL_TASHA_LAUGHTER), oTarget, fDuration);
					DelayCommand(0.3, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, fDuration));
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDuration, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
					AssignCommand(oTarget, ClearAllActions());
					AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
					AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
					CSLReduceBreathableRounds( oTarget, 3, iDuration, iSpellId );
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

