// nx_s2_satiate
/*
	Spirit Eater Satiate Feat
	
Satiate
Alignment: Neutral
Limitations: 1 use/day
This is the spirit-eater affliction panic button. The player is out of uses of Devour Spirit, and his
affliction is in its final stages. The player makes a big, permanent sacrifice to the tune of 25% of
the XP distance to the PC’s next level, and the PC’s spirit energy is fully recharged. Conceptually,
this is something like spirit-eater self-cannibalism - he allows the spirit-eater to feed upon his own spirit.
The player cannot lose a level by using this ability - it caps when the player is reduced to 0 XP
beyond the last level he gained. The 1 use/day limitation prevents exploitation of this cap.
	
*/
// ChazM 2/23/07
// ChazM 4/2/07 added implementation
// ChazM 4/12/07 VFX/string update
// ChazM 6/25/07 apply a level drain for 10 mins instead of taking any more XP

#include "_HkSpell"
#include "_SCInclude_SpiritEater"
#include "_SCInclude_Necromancy"

//#include "ginc_2da"

const int STR_REF_SATIATE_ERROR = 208648;





void main()
{
	//scSpellMetaData = SCMeta_FT_splablsatiat();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	//ability can only be used at spirit-eater stage 4 or worse.
	if(GetSpiritEaterStage() < 4)
	{
		FloatingTextStrRefOnCreature(STR_REF_SATIATE_ERROR,oCaster, FALSE, 4.f, COLOR_WHITE, COLOR_WHITE, 0.3f,Vector(0.f,0.f,1.f));
		IncrementRemainingFeatUses(oCaster,FEAT_SATIATE);
		return;
	}
	
	// Get all Spirit Eater Points back.
	SetSpiritEaterPoints(fSPIRIT_EATER_POINTS_MAX);
	
	float fCraving = GetSpiritEaterCorruption();
	if(fCraving > 1.f)
	{
		SetSpiritEaterCorruption(1.f);
	}
	
	// Reduce XP by 25% of distance to next level.
	int nECL = CSLGetRaceDataECL( GetSubRace(oCaster) );//GetECL(oCaster, FALSE);
	//PrettyDebug("CSLGetECL(oCaster, FALSE) = " + IntToString(nECL));
	
	int nXP = GetXP(oCaster);
	int nNextLevelXP = CSLGetMinXPForLevel(nECL+1);  //StringToInt(Get2DAString("exptable", "XP", iHD));
	int nThisLevelXP = CSLGetMinXPForLevel(nECL);  //StringToInt(Get2DAString("exptable", "XP", iHD-1));
	int nPenalty = (nNextLevelXP - nThisLevelXP)/4;
	int nNewXP = nXP - nPenalty;
	
	// can't go below what's needed for this level.
	if (nNewXP < nThisLevelXP)
	{
		nNewXP = nThisLevelXP;
		// apply a level drain for 10 mins instead of taking any more XP
		// effect eLevelDrain = EffectNegativeLevel(1);
		// HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLevelDrain, oCaster, 600.0f);
		SCApplyDeadlyAbilityLevelEffect( 1, oCaster, DURATION_TYPE_TEMPORARY, 600.0f, oCaster );
	}
	SetXP(oCaster, nNewXP);
	
	// Visual effect on caster
	effect eCasterVis = EffectVisualEffect(VFX_CAST_SPELL_SATIATE);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
	
	//Fire cast spell at event for the specified target
		SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE)); // not harmful
	
	// feat will automatically decrement
	
	HkPostCast(oCaster);
}

