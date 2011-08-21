//::///////////////////////////////////////////////
//:: Create Undead
//:: x2_s0_CrShadow.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell will summon a shadow - 20% of the time,
	the shadow will be hostile to the summoner.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_summshadx2();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SUMMON_SHADOW_X2;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	location lSummonLocation = HkGetSpellTargetLocation();

	//Declare major variables
	int iDuration = HkGetSpellDuration( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	iDuration = 24;
	effect eSummon;

	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Set the summoned undead to the appropriate template based on the caster level
	if (d100() > 20)
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow7",VFX_FNF_SUMMON_UNDEAD);
			//Apply VFX impact and summon effect
			HkApplyEffectAtLocation(iDurType, eSummon, lSummonLocation, fDuration );
			HkApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster), oCaster );
	}
	else
	{
			//need to just create the given creature and set them to attack
			//eSummon = EffectSummonCreature("csl_sum_shadow_shadow7",VFX_FNF_SUMMON_UNDEAD);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD ), lSummonLocation);
			object oSummon = CreateObject(OBJECT_TYPE_CREATURE, "csl_sum_shadow_shadow7", lSummonLocation, FALSE);
			
			SetIsTemporaryEnemy( oCaster, oSummon ); // make sure it's an enemy to the caster and attacks
			DelayCommand( 0.5f, AssignCommand(oSummon, ClearAllActions()) );
			DelayCommand( 2.0f, AssignCommand(oSummon, ActionAttack(oCaster)) );
	}


	
	//
	
	HkPostCast(oCaster);
}