//::///////////////////////////////////////////////
//:: Vampiric Feast
//:: X2_S2_HELLBALL
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

	Classes: Cleric, Druid, Spirit Shaman, Wizard, Sorcerer, Warlock
	Spellcraft Required: 24
	Caster Level: Epic
	Innate Level: Epic
	School: Necromancy
	Descriptor(s): Evil
	Components: Verbal, Somatic
	Range: Personal
	Area of Effect / Target: All hostile creatures within 20 ft. of caster.
	Duration: Instant
	Save: Fortitude ½ (DC +5)
	Spell Resistance: Yes
	
	When this spell is cast, you drink in the life force of all enemies in
	the area of effect. Creatures who succeed at a Fortitude save (DC +5)
	lose only half their remaining hit points. Those who fail their saving
	throw are instantly slain. Moreover, the life-force of slain creatures
	coalesces as a Greater Shadow, which will attack any surviving enemies.
	
	You are only able to absorb sufficient hit points to return you to full
	health. Any remaining life force dissipates into the fabric of the Weave.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Player"



//#include "seed_db_inc"

void Degenerate(object oMinion, int nRounds=3)
{
	if (nRounds==0)
	{
		DestroyObject(oMinion);
	}
	else
	{
		effect eDamage = EffectDamage(GetCurrentHitPoints(oMinion) / 2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oMinion);
		--nRounds;
		DelayCommand(6.0, Degenerate(oMinion, nRounds));
	}
	AssignCommand(oMinion, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), oMinion));
}

void MakeVamp(object oCaster, object oPC, int nHPs)
{
	string sTag = "VAMP_"+CSLGetCreatureIdentifier(oPC);
	
	object oMinion = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, sTag);
	oMinion = GetNearestObjectByTag(sTag, oPC);
	ForceRest(oMinion);
	effect eDamage = EffectDamage(GetMaxHitPoints(oMinion) - nHPs, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oMinion);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNWN2SpecialEffectFile("fx_animus.sef"), oMinion);
	ChangeToStandardFaction(oMinion, STANDARD_FACTION_HOSTILE);
	CSLDontDropGear(oMinion);
	SetCreatureScriptsToSet(oMinion, SCRIPTSET_NPC_DEFAULT);
	SetIsTemporaryFriend(oMinion, oCaster);
	DelayCommand(6.0, Degenerate(oMinion));
}

void main()
{
	//scSpellMetaData = SCMeta_SP_vampiricfeas();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_VAMPIRIC_FEAST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE|SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iSaveDC = HkGetSpellSaveDC() + 5;
	int nHealing = 0;
	float fDelay;
	location lCaster = HkGetSpellTargetLocation();
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_VAMPIRIC_FEAST );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eDamage;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (oTarget!=oCaster && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster)) // Only ever effects enemies
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
			fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget))/20; // Create a delay so that all creatures seem to be hit at the same time.
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				int iSave, iAdjustedDamage;
				 
				
				//iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, fDelay);
				//iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, iSave, fDelay );
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, SAVING_THROW_RESULT_ROLL, fDelay );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
					{
						eDamage = EffectDeath();
						DelayCommand(fDelay, MakeVamp(oCaster, oTarget, iSaveDC));
						nHealing += iSaveDC;
					}
					else
					{
						eDamage = EffectDamage( d6(iSaveDC), iDamageType, DAMAGE_POWER_NORMAL, TRUE);   // Last flag is to ignore all resistances & immunities.
					}
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay + 0.1, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				}
				
				
				/*
				if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, fDelay)) // Fail save, lose all your remaining HP
				{ 
					eDamage = EffectDeath();
					DelayCommand(fDelay, MakeVamp(oCaster, oTarget, iSaveDC));
					nHealing += iSaveDC;
				}
				else
				{  
					// Make save, take damage
					eDamage = EffectDamage( d6(iSaveDC), iDamageType, DAMAGE_POWER_NORMAL, TRUE);   // Last flag is to ignore all resistances & immunities.
				}
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay + 0.1, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				*/
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	if (nHealing>0)  // We drained some life.
	{
		DelayCommand(1.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealing), oCaster));
	}
	HkPostCast(oCaster);
}

