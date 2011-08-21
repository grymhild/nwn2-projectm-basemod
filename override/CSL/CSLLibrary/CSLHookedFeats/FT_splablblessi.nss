//::///////////////////////////////////////////////
//:: Protection from Spirits
//:: nx_s2_protspirits.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	The spirit shaman gains a permanent +2
	deflection bonus to AC and a +2 resistance
	bonus on saves against attacks and effects
	made by spirits. This is essentially a
	permanent Protection From Evil, except it
	protects against spirits and lasts until it
	is dismissed or dispelled.  If this ability
	is dispelled, the spirit shaman can recreate
	it simply by taking a standard action to do so.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/13/2007
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablblessi();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();

	// Does not stack with itself or with Warding of the Spirits
	if (!GetHasSpellEffect(SPELLABILITY_BLESSING_OF_THE_SPIRITS, oTarget) &&
			!GetHasSpellEffect(SPELLABILITY_WARDING_OF_THE_SPIRITS, oTarget) )
	{
			effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL, TRUE);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL, TRUE);
	
			effect eLink = EffectLinkEffects(eAC, eSave);
	
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
	
	HkPostCast(oCaster);
}

