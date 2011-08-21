//::///////////////////////////////////////////////
//:: Phantasmal Killer
//:: NW_S0_PhantKill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target of the spell must make 2 saves or die.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_phantkiller();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PHANTASMAL_KILLER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR|SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_PHANTASM, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDC = HkGetSpellSaveDC();
	int iSave, iAdjustedDamage;

	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_PHANTASMAL_KILLER));
		if (!HkResistSpell(oCaster, oTarget))
		{
			if (!GetHasFeat(FEAT_IMMUNITY_PHANTASMS, oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR))
			{
				int bSave = WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster);
				if (bSave==SAVING_THROW_CHECK_FAILED) //if (!SCSavingThrow2(SAVING_THROW_WILL,  oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS)) 
				{
					
					iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF);
					
					iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_ADJUSTED_PARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_DEATH, oCaster, iSave );
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, TRUE, TRUE, TRUE), oTarget);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
					}
					else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
					{
						int iDamage = HkApplyMetamagicVariableMods(d6(3), 18);
						iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_ADJUSTED_PARTIALDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_DEATH, oCaster, iSave );
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ILLUSION), oTarget);
					}
				}
				else if (bSave==SAVING_THROW_CHECK_IMMUNE)
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SPELL_SPELL_RESISTANCE), oTarget);
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

