//::///////////////////////////////////////////////
//:: Creeping Cold
//:: NX_s0_creepcold.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Creeping Cold
	Transmutation [Cold]
	Level: Druid 2
	Components: V, S
	Range: Close
	Target: One creature
	Duration: 3 rounds
	Saving throw: Fortitude half
	Spell Resistance: Yes
	
	The subject takes 1d6 cumulative points of cold damage per
	round (that is, 1d6 on the 1st round, 2d6 on the
	second, and 3d6 on the third).  Only one save is
	allowed against the spell; if successful it halves
	the damage each round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Evocation"



////#include "_inc_helper_functions"
//#include "_SCUtility"



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CREEPING_COLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
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
	

	
	
	int iSave = 0;
	int nCounter = 0;
	int nNumStage = 3;
	
	//int iSaveType = SAVING_THROW_TYPE_COLD;			
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
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
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELL_CREEPING_COLD), oTarget, RoundsToSeconds(nNumStage));
				int iMetaMagic = HkGetMetaMagicFeat();
				for (nCounter=0;nCounter<nNumStage;nCounter++)
				{
					DelayCommand(RoundsToSeconds(nCounter), SCDoCreepingCold(oCaster, oTarget, iDamageType, nCounter+1, iSave, iSpellId, iMetaMagic));
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}
