//::///////////////////////////////////////////////
//:: Planar Ally
//:: X0_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons an outsider dependant on alignment.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Modified from Planar binding
//:: Hold ability removed for cleric version of spell

// cleric level 6

//:: AFW-OEI 06/02/2006:
//:: Update creature blueprint.
//:: Changed duration to minutes per caster level.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_planarally();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PLANAR_ALLY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iDescriptor = SCMETA_DESCRIPTOR_AIR;
	int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
	switch (nAlign)
	{
		case ALIGNMENT_EVIL:
			iDescriptor = SCMETA_DESCRIPTOR_EVIL;
			break;
		case ALIGNMENT_GOOD:
			iDescriptor = SCMETA_DESCRIPTOR_GOOD;
			break;
		case ALIGNMENT_NEUTRAL:
			iDescriptor = SCMETA_DESCRIPTOR_AIR;
			/*int iRoll = d4();
			switch (iRoll)
			{
				case 1: iDescriptor = SCMETA_DESCRIPTOR_FIRE; break;
				case 2: iDescriptor = SCMETA_DESCRIPTOR_EARTH; break;
				case 3: iDescriptor = SCMETA_DESCRIPTOR_WATER; break;
				case 4: iDescriptor = SCMETA_DESCRIPTOR_AIR; break;
			}*/
			break;
	}
	int iImpactSEF = VFX_HIT_SPELL_SUMMON_CREATURE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_INTERNAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CALLING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = HkGetSpellDuration(OBJECT_SELF) * 60.0f;
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eSummon;
	
	//int nRacial = GetRacialType(oTarget);
	//Check for metamagic extend
	
	//Set the summon effect based on the alignment of the caster
	string sSummon = "csl_sum_spirit_sylph";
	int iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
	float fDelay = 1.0f;
	if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )
	{
		sSummon = "csl_sum_tanar_succubus2";
		iVFXEffect = VFX_FNF_SUMMON_GATE;
		fDelay = 3.0f;		
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )
	{
		sSummon = "csl_sum_celest_bear";
		iVFXEffect = VFX_FNF_SUMMON_CELESTIAL;
		fDelay = 3.0f;		
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )
	{
		sSummon = "csl_sum_spirit_sylph";
		iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		fDelay = 1.0f;
	}
	else
	{
		return;
	}
	eSummon = EffectSummonCreature(sSummon, iVFXEffect, fDelay);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	
	//Apply the summon effect and VFX impact
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration);
	DelayCommand(fDelay+1.5f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}

