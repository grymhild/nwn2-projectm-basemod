//::///////////////////////////////////////////////
//:: Summon Shadow
//:: NW_S0_SummShad.nss
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
//:: Change duration to 3 + CL rounds

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADES_SUMMON_SHADOW;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW )
	{
		iSpellId=SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW;
	}
	else if ( GetSpellId() == SPELL_SHADES_SUMMON_SHADOW )
	{
		iSpellId=SPELL_SHADES_SUMMON_SHADOW;
	}
	else if ( GetSpellId() == SPELL_SHADOW_CONJURATION_SUMMON_SHADOW )
	{
		iSpellId=SPELL_SHADOW_CONJURATION_SUMMON_SHADOW;
	}
	else if ( GetSpellId() == SPELL_MINOR_SHAD_CONJ ||  GetSpellId() == SPELL_MSC_SUMM_SHAD )
	{
		iSpellId=SPELL_MSC_SUMM_SHAD;
	}
	
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_SHADOW, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( OBJECT_SELF )+ 3;
	effect eSummon;
	
	//Check for metamagic extend
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Set the summoned undead to the appropriate template based on the caster level
	if ( iSpellId == SPELL_MSC_SUMM_SHAD )
	{
		iSpellPower /= 3; // this is a lower powered version of shadow conjurations
	}
	
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
	HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration );
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, HkGetSpellTargetLocation());
	DelayCommand(6.0f, BuffSummons( oCaster ));
	
	HkPostCast(oCaster);
}

