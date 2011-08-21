//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: The Dead Walk(!)
//:: nw_s0_ideadwalk.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"


#include "_SCInclude_Necromancy"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_IN_thedeadwalk();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_ANIMATE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	string sResRef;
	
	int iCasterLevel = CSLGetMin(15, GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster)) + UndeadLevelBonus(oCaster);
	float fDuration = UndeadDuration(oCaster);
	if      (iCasterLevel<= 6)  sResRef = "csl_sum_undead_zombie2";    // CR 5
	else if (iCasterLevel<= 9)  sResRef = "csl_sum_undead_zombie3";    // CR 7
	else if (iCasterLevel<=12)  sResRef = "csl_sum_undead_skeleton2";  // CR 9
	else if (iCasterLevel<=15)  sResRef = "csl_sum_undead_skeleton3";  // CR 11
	else if (iCasterLevel<=18)  sResRef = "csl_sum_undead_ghoul2";     // CR 13
	else if (iCasterLevel<=21)  sResRef = "csl_sum_undead_ghoul3";     // CR 15
	else if (iCasterLevel<=24)  sResRef = "csl_sum_undead_vampire4";   // CR 17
	else if (iCasterLevel<=27)  sResRef = "csl_sum_undead_vampire5";   // CR 19
	else                      sResRef = "csl_sum_undead_vampire6";   // CR 21
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sResRef, VFX_FNF_SUMMON_UNDEAD), HkGetSpellTargetLocation(), fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}