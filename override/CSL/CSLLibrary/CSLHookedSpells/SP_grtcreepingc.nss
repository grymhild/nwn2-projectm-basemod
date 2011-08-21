//::///////////////////////////////////////////////
//:: Creeping Cold
//:: NX_s0_creepcold.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
		
	Creeping Cold, Greater
	Transmutation [Cold]
	Level: Druid 4
	Components: V, S
	Range: Close
	Target: One Creature
	Duration: See text
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	
	This spell is the same as creeping cold, but the
	duration increases by 1 round, during which the
	subject takes 4d6 points of cold damage.  If you
	are at least 15th level the spell lasts for 5
	rounds and deals 5d6 points of cold damage.  If
	you are at least 20th level, the spell lasts for
	6 rounds and deals 6d6 points of cold damage.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Evocation"










void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_CREEPING_COLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nNumStage = 4;
	if      (iSpellPower > 19) nNumStage = 6;
	else if (iSpellPower > 14) nNumStage = 5;
	int iSave = 0;
	int nCounter = 0;
	
	//int iSaveType = iSaveType;			
	//if ( GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD, oCaster ) )
	//{
	//	iSaveType = SAVING_THROW_TYPE_ALL;
	//}
	
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
			if (!HkResistSpell(oCaster, oTarget))
			{
				if (HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster)) iSave = 1;
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_SPELL_CREEPING_COLD ), oTarget, RoundsToSeconds(nNumStage));
				int iMetaMagic = GetMetaMagicFeat();
				for (nCounter=0;nCounter<nNumStage;nCounter++)
				{
					DelayCommand(RoundsToSeconds(nCounter), SCDoCreepingCold(oCaster, oTarget, iDamageType, nCounter+1, iSave, iSpellId, iMetaMagic));
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}
