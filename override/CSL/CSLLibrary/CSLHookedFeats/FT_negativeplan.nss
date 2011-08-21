//::///////////////////////////////////////////////
//:: Summon Shadow
//:: NW_S0_SummShad02.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Spell powerful ally from the shadow plane to
	battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//:: Update creature blueprints

#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_FT_negativeplan();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	int iSpellPower = HkGetSpellPower( oCaster, 60, CLASS_TYPE_CLERIC );
	effect eSummon;
	//effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

	//Set the summoned undead to the appropriate template based on the caster level
	if (iSpellPower <= 7)
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow3",VFX_FNF_SUMMON_UNDEAD);
	}
	else if ((iSpellPower >= 8) && (iSpellPower <= 10))
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_mastiff",VFX_FNF_SUMMON_UNDEAD);
	}
	else if ((iSpellPower >= 11) && (iSpellPower <= 14))
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow7",VFX_FNF_SUMMON_UNDEAD); // change later
	}
	else if ((iSpellPower >= 15))
	{
			eSummon = EffectSummonCreature("csl_sum_shadow_shadow9",VFX_FNF_SUMMON_UNDEAD);
	}

	//Apply VFX impact and summon effect
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	DelayCommand(6.0f, BuffSummons( oCaster ));
	
	HkPostCast(oCaster);
}