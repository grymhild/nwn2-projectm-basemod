//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2005 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Spell summons a Ghoul, Shadow, Ghast, Wight or
	Wraith
	6TH LEVEL SPELL RCVD AT LEVEL 11
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_crundead();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CREATE_UNDEAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_ANIMATE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	string sResRef = "";
	
	int iCasterLevel = CSLGetMin(14, HkGetSpellPower(oCaster)) + UndeadLevelBonus(oCaster);    
	float fDuration = UndeadDuration(oCaster);
	if      (iCasterLevel<=14) sResRef = "csl_sum_undead_ghoul1";   // CR 11
	else if (iCasterLevel<=17) sResRef = "csl_sum_undead_ghoul2";   // CR 13
	else if (iCasterLevel<=20) sResRef = "csl_sum_undead_ghoul3";   // CR 15
	else                     sResRef = "csl_sum_undead_ghoul4";   // CR 17
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sResRef, VFX_HIT_SPELL_SUMMON_CREATURE), HkGetSpellTargetLocation(), fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}

