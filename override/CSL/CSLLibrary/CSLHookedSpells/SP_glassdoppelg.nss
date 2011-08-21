//::///////////////////////////////////////////////
//:: Glass Doppelganger
//:: nx_s0_glass_doppelganger.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Caster Level(s): Sorc/wiz 5
	Innate Level: 5
	School: Illusion
	Descriptor(s): Shadow
	Component(s): V, S
	Range: Touch
	Area of Effect / Target: Single creature
	Duration: 1 round / level
	Save: No
	Spell Resistance: No
	
	This spell forms a living glass creation that
	is an exact copy of the target with the following
	exceptions: The creature is made out of glass,
	and thus more brittle, being summoned in at 1/4
	of the current hitpoints of the target. The
	summoned creature has 15 resistance to fire,
	cold, electricity, acid, peircing, and slashing
	damage types. The summoned creature gains
	vulnerability 50% to sonic and bludgeoning damage.
	The glass copy is allied with the caster, but
	not under direct control, acting as a summoned
	animal or a henchman. Creatures copied are must
	have the same or fewer hit dice than the caster
	has caster levels, with a hard cap of 15 HD.
	Copied creatures have no memorized spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/14/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

//#include "_SCInclude_Encounter"
#include "_CSLCore_Config"
#include "_SCInclude_Class"

void main()
{

	//scSpellMetaData = SCMeta_SP_glassdoppelg();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GLASS_DOPPELGANGER;
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
	int iSpellPower = HkGetSpellPower( oCaster, 15 ); // OldGetCasterLevel(OBJECT_SELF);
	
	
	
	if ( CSLGetIsBoss(oTarget) || nTargetHD > iSpellPower )
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
	int nNewHP = GetCurrentHitPoints(oTarget)/4; // Copy has 1/4 the HP of the target.
	effect eSummon = EffectSummonCopy(oTarget, VFX_FNF_SUMMON_UNDEAD, 0.0f, sNewTag, nNewHP, "SP_glassdoppl_buff");
	
	//Apply VFX impact and summon effect
	//location lWaypoint = CalcSafeLocation( OBJECT_SELF, HkGetSpellTargetLocation(), 10.0f, TRUE, TRUE );
	HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration); // HkGetSpellTargetLocation()
	DelayCommand(6.0f, BuffSummons(oCaster));
	
	HkPostCast(oCaster);
}
