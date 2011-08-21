//::///////////////////////////////////////////////
//:: Furious Assault
//:: NW_S2_FurAslt.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	* Attacks do max damage for the next 3 rounds.
	* User takes 10 points of damage at the end of
	each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/18/2006
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_furyassault();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	object oTarget = OBJECT_SELF;

	effect eMaxDamage = EffectMaxDamage();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eDoT = EffectDamage(10);

	effect eLink = EffectLinkEffects(eMaxDamage, eDur);
	eLink = SupernaturalEffect(eLink);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_FURIOUS_ASSAULT, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
	DelayCommand(RoundsToSeconds(2), HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDoT, oTarget));
	DelayCommand(RoundsToSeconds(3), HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDoT, oTarget));
	DelayCommand(RoundsToSeconds(4), HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDoT, oTarget));
	
	HkPostCast(oCaster);
}