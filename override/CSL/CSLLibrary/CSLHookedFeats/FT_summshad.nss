//::///////////////////////////////////////////////
//:: Summon Shadow
//:: X0_S2_ShadSum.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	PRESTIGE CLASS VERSION
	Spell powerful ally from the shadow plane to
	battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//:: Update creature blueprints
//:: Change duration to 24 hours
//:: Remove epic stuff
#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_summshadx2();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SUMMON_SHADOW;
	int iClass = CLASS_TYPE_SHADOWDANCER;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	
	
	//Declare major variables
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oCaster);
	//int iDuration = iCasterLevel;
	effect eSummon;

	//Set the summoned undead to the appropriate template based on the caster level
	if (iCasterLevel <= 5)
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow3",VFX_FNF_SUMMON_UNDEAD);
	}
	else if (iCasterLevel <= 8)
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow7",VFX_FNF_SUMMON_UNDEAD);
	}
	else if (iCasterLevel <=10)
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow9",VFX_FNF_SUMMON_UNDEAD);
	}
	/*
	else
	{
		if (GetHasFeat(1002,OBJECT_SELF))// has epic shadowlord feat
		{
		//GZ 2003-07-24: Epic shadow lord
			eSummon = EffectSummonCreature("x2_s_eshadlord",VFX_FNF_SUMMON_UNDEAD);
		}
		else
		{
			eSummon = EffectSummonCreature("X1_S_SHADLORD",VFX_FNF_SUMMON_UNDEAD);
		}
	}
	*/

	//Apply VFX impact and summon effect
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	
	HkPostCast(oCaster);
}