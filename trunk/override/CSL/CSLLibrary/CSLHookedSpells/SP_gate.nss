//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//::  Update creature blueprint (to Horned Devil).
//:: BDF-OEI 8/02/2006:
//::  Renamed CreateBalor to CreateOutsider and added a DCR to kickstart attack on the summoner

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

#include "_SCInclude_Class"
#include "_SCInclude_Summon"
#include "_CSLCore_Combat"

void CreateOutsider()
{
	object oCaster = OBJECT_SELF;
	//if (SCStoneCasterInTown(oCaster)) return;
	object oOutsider = CreateObject(OBJECT_TYPE_CREATURE, "csl_sum_baat_devilhorn", HkGetSpellTargetLocation());
	// error with function on this line
	
	
	SetIsTemporaryEnemy(oOutsider, oCaster );
	
	CSLDetermineCombatRound( oOutsider, oCaster );
	//AssignCommand(oOutsider, DetermineCombatRound(oCaster));
}

void main()
{
	//scSpellMetaData = SCMeta_SP_gate();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GATE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9; //HkGetSpellLevel( iSpellId, iClass );
	location lTarget = HkGetSpellTargetLocation();
	string sSummonTable = SCSummonGetTable( "Magic", iSpellId, lTarget, HkGetSpellClass(oCaster), oCaster );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION|SPELL_SUBSCHOOL_CALLING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iPower = HkGetSpellPower(oCaster);
	int iDuration = HkGetSpellDuration(oCaster) + 3; //( 5 * nLvl ); // WAS +3, GIVING SMALL GIFT HERE
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	
	// use my 2da based summon system
	int iSpellColumn = 1; // always uses one, normally this is 1, it uses columns greater than 1 to handle multiple summons
	int iSummonLevel = 11; // this is 2 higher than actual level, to keep gated creatures out of range of normal summons
	int iSummonBonus = SCGetSummonBonus( oCaster, sSummonTable ); // increases the summons level based on feats, focus in conjuration, etc.
	
	//string sSummonTable = SCSummonGetTable( "Magic", iSpellId, lTarget, HkGetSpellClass(oCaster), oCaster );
	
	
	SCSummonCreature( oCaster, sSummonTable, iSummonLevel+iSummonBonus, iPower, fDuration, lTarget, iSpellId, iSpellColumn, CSL_SUMMONCONTROL_PROTECTED_SERVITUDE );
	
	
	
	
	// kaedrin is adding some alignment templates
	/*
	string sBlueprint = "c_summ_devilhorn";

	if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)

		sBlueprint = "cmi_summ_gategood";	

	else

	if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)

		sBlueprint = "cmi_summ_gateneut";
	*/

	//Declare major variables
	/*
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration(OBJECT_SELF) + 3;
	effect eSummon;
	effect eVis = EffectVisualEffect( VFX_DUR_GATE );
	effect eVis2 = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
	//Make metamagic extend check
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	location lSpellTargetLOC = HkGetSpellTargetLocation();

	if (GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) || GetHasSpellEffect(SPELL_HOLY_AURA))
	{
			eSummon = EffectSummonCreature( "csl_sum_baat_devilhorn", VFX_INVOCATION_BRIMSTONE_DOOM,  3.0 );

			HkApplyEffectAtLocation( iDurType, eSummon, lSpellTargetLOC, fDuration);
			HkApplyEffectAtLocation ( DURATION_TYPE_TEMPORARY, eVis, lSpellTargetLOC, 5.0);
			
			HkApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
			DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	}
	else
	{
			HkApplyEffectAtLocation ( DURATION_TYPE_TEMPORARY, eVis, lSpellTargetLOC, 5.0);
			DelayCommand(3.0, HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis2, lSpellTargetLOC ));
			DelayCommand(3.0, CreateOutsider());
			
	}
	*/
	HkPostCast(oCaster);
}

