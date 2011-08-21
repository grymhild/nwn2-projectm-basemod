//::///////////////////////////////////////////////
//:: Otherworldly Whispers
//:: [nx_s0_otherworldlywhispers]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Invocation Level: Least
//:: Spell Level Equivalent: 2
//::
//:: You hear whispers in your ears, revealing secrets
//:: of the multiverse.  You gain a +6 bonus on all lore
//:: and spellcraft checks for 24 hours.
//:://////////////////////////////////////////////
//:: Created By: ??
//:: Created On: ??
//:://////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"



//#include "_SCInclude_Invocations"

void main()
{
	//scSpellMetaData = SCMeta_IN_otherworldly();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFXSC_HIT_WHISPERS;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iBonus = HkGetWarlockBonus(oCaster);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);  // 24 hours
	effect eLink = EffectSkillIncrease(SKILL_LORE, iBonus);
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPELLCRAFT, iBonus));
	// eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, iBonus));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, iBonus));
	SendMessageToPC(oCaster, "Other worldly bonus +" + IntToString(iBonus) + " granted for 24 hours.");
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	
	HkPostCast(oCaster);
}

