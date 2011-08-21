//::///////////////////////////////////////////////
//:: Moon Bolt
//:: nw_s0_moonbolt.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A moon bolt strikes unerringl against any living or undead creature in range.

	A living creature struck by a moon bolt takes 1d4 points of Strength damage per
	three caster levels (max 5d4).  If the subject makes a sucessful Fort save
	the strength damage is halved.

	An undead creature struck by a moon bolt must make a will save or fall helpless
	for 1d4 rounds, after which time it is no longer helpless and can stand upright,
	but it takes a -2 penalty on sttack rolls and will saving throws for the next minute.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 19, 2006
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_moonbolt();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MOON_BOLT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	object oTarget   = HkGetSpellTarget();
	int    iDice     = HkGetSpellPower(oCaster, 15) / 3;
	effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	int    nKODur    = HkApplyMetamagicVariableMods(d4(), 4);
	float  fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(nKODur));
	int iDC = HkGetSpellSaveDC();
	int iDamage, iAdjustedDamage, iSave;
	
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
			effect eBeam = EffectBeam(VFX_SPELL_BEAM_MOON_BOLT, oCaster, BODY_NODE_HAND);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0);
			if ( CSLGetIsConstruct(oTarget) )
			{
				return;
			}
			else if ( CSLGetIsUndead( oTarget, TRUE ) )
			{
				iDamage = HkApplyMetamagicVariableMods(d4(iDice), 4*(iDice));
				//iSave = HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 0.5);
				//iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, iSave );
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, SAVING_THROW_RESULT_ROLL, 0.5 );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					int nDex = GetAbilityScore(oTarget, ABILITY_DEXTERITY);
					effect eUndeadLink = EffectLinkEffects(eVis, EffectKnockdown());
					eUndeadLink = EffectLinkEffects(eUndeadLink, EffectAbilityDecrease(ABILITY_DEXTERITY, nDex));
					effect eCurseLink  =  EffectSavingThrowDecrease(SAVING_THROW_WILL, 2);
					eCurseLink  =  EffectLinkEffects(eCurseLink, EffectAttackDecrease(2));
					float fDuration2 = HkApplyMetamagicDurationMods(60.0);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUndeadLink, oTarget, fDuration);
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDuration, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
					DelayCommand(fDuration, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurseLink, oTarget, fDuration2));
				}
				
				//
				//if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster))
				//{
				//	
				//	
				//}
			}
			else
			{
				iDamage = HkApplyMetamagicVariableMods(d4(iDice), 4*(iDice));
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 0.5);
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, iSave );
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					effect eLivingLink =  EffectLinkEffects(eVis, EffectAbilityDecrease(ABILITY_STRENGTH, iDamage));
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLivingLink, oTarget);
				}
				//if (HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster))
				//{
				//	nDam /= 2;
				//}
				
			}
		}
	}
	
	HkPostCast(oCaster);
}

