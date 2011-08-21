//::///////////////////////////////////////////////
//:: Animate Dead
//:: NW_S0_AnimDead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons a powerful skeleton or zombie depending
	on caster level.
	4TH LEVEL SPELL RECVD AT LEVEL 7
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Necromancy"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ANIMATE_DEAD;
	int iClass = CLASS_TYPE_NONE;
	if (GetSpellId()==SPELLABILITY_PM_ANIMATE_DEAD)
	{
		iSpellId = SPELLABILITY_PM_ANIMATE_DEAD;
		iClass = CLASS_TYPE_NONE;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_ANIMATE, iAttributes ) )
	{
		return;
	}
	
	CSLSpellEvilShift(oCaster);
	 
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	if (GetSpellId()==SPELLABILITY_PM_ANIMATE_DEAD) {
		SummonUndead();
		return;
	}
	
	
	string sResRef = "";
	int iCasterLevel = CSLGetMin(11, HkGetSpellPower(oCaster)) + UndeadLevelBonus(oCaster);
	float fDuration = UndeadDuration(oCaster);
	if      (iCasterLevel<=11) sResRef = "csl_sum_undead_skeleton1"; // CR 7
	else if (iCasterLevel<=14) sResRef = "csl_sum_undead_skeleton2"; // CR 9
	else if (iCasterLevel<=17) sResRef = "csl_sum_undead_skeleton3"; // CR 11
	else                     sResRef = "csl_sum_undead_skeleton4"; // CR 13
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sResRef, VFX_FNF_SUMMON_UNDEAD), HkGetSpellTargetLocation(), fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}
