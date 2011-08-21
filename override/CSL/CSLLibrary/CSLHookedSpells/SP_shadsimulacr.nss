//::///////////////////////////////////////////////
//:: Shadow Simulacrum
//:: nx_s0_shadow_simulacrum.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Illusion (Shadow)
	Level: Sor/Wiz 9
	Components: V, S
	Range: Touch
	Effect: One duplicate creature
	Duration: 1 round / caster level
	Saving Throw: None
	Spell Resistance: No
	
	Shadow Simulacrum reaches into the plane of
	shadow and creates a shadow duplicate of the
	creature touched by the caster. This shadow
	creature retains all the abilities of the
	original, but is created with only 3/4th the
	current hit points of the original and all
	memorized spells are lost.  Moreover, the
	simulacrum gains 20% concealment and immunity
	to negative energy damage.  Creatures with more
	than double the caster's level in hit dice are
	immune to this spell.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

//#include "_SCInclude_Encounter"
#include "_CSLCore_Config"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_shadsimulacr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADOW_SIMULACRUM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	object oTarget = HkGetSpellTarget();
	
	// PC's cannot copy PC's unless they are in single player, or a DM as a PC in a PW, this is to implement features to allow hiding of the character sheet so this can't be used to spy on builds
	if ( CSLGetPreferenceSwitch("PreventPlayersCloningPlayers",FALSE) && GetIsPC(oTarget) && GetIsPC(oCaster) && !CSLGetIsDM( oCaster, TRUE ) )
	{
		SendMessageToPC(OBJECT_SELF, "This creature is too powerful for you to duplicate!");
		return;
	}
	
	
	int nTargetHD = GetHitDice(oTarget);
	int iSpellPower = HkGetSpellPower( oCaster, 30 );
	
	if ( CSLGetIsBoss(oTarget) || nTargetHD > iSpellPower+3 )
	{
		// Targets with greater HD than the caster, or with more than 15 HD are immune.
		SendMessageToPC(OBJECT_SELF, "This creature is too powerful for you to duplicate!");
		return;
	}
	
	int iDuration = HkGetSpellDuration(oCaster);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);	
	
	string sTag = GetTag(oTarget);
	string sNewTag = IntToString(ObjectToInt(oCaster))+"_"+sTag+"_CSLCLONE"; // Create "unique" tag
	if ( FindSubString(sTag, "_CSLCLONE") != -1 || FindSubString(sTag, sNewTag) != -1 )
	{
		SendMessageToPC(OBJECT_SELF, "You may not create a copy of a clone. Spell Failed.");
		return;
	}
	
	int nNewHP = GetCurrentHitPoints(oTarget) * 3 / 4;   // Copy has 3/4 the HP of the target
	// * @todo, need to reimplement the shadowsim buff script if that is not causing a crash
	effect eSummon = EffectSummonCopy(oTarget, VFX_FNF_SUMMON_UNDEAD, 0.0f, sNewTag, nNewHP, ""); // "SP_shadowsim_buff");
	//float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	
	HkPostCast(oCaster);	
}

