//::///////////////////////////////////////////////
//:: x0_s2_fiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Summons the 'fiendish' servant for the player.
This is a modified version of Planar Binding


At Level 5 the Blackguard gets a Succubus

At Level 9 the Blackguard will get a Vrock

Will remain for one hour per level of blackguard
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: April 2003
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//:: Update creature blueprints
//:: Change duration to 24 hours
//:: Remove epic stuff

#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_BG_FIENDISH_SERVANT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}

	
	
	int iLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster);
	effect eSummon;
	float fDelay = 3.0;
	//int iDuration = iLevel;
	
	if ( iLevel >= 8 )
    {
		eSummon = EffectSummonCreature("csl_sum_baat_hellhound", VFX_FNF_SUMMON_GATE, fDelay);	
    }
    else
    {
		eSummon = EffectSummonCreature("csl_sum_tanar_nightmare1", VFX_FNF_SUMMON_GATE, fDelay);	
    }
    

	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	DelayCommand(5.0f, BuffSummons(oCaster));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}