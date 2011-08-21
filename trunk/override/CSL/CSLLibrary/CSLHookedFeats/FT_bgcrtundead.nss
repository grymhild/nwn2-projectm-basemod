//::///////////////////////////////////////////////
//:: x0_s2_blkdead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////


#include "_HkSpell"
void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_BG_CREATEDEAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}



	string sResRef = "";
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster);
	float fDuration = HkApplyMetamagicDurationMods(HoursToSeconds(iCasterLevel * 2));
	
	if      (iCasterLevel <  7) sResRef = "csl_sum_undead_skeleton6"; // CR 9
	else                      sResRef = "csl_sum_undead_ghast2";    // CR 13
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sResRef, VFX_FNF_SUMMON_UNDEAD), HkGetSpellTargetLocation(), fDuration);
	
	
	HkPostCast(oCaster);

}