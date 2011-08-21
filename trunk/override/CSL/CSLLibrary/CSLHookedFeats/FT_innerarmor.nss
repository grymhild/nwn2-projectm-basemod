//::///////////////////////////////////////////////
//:: Inner Armor
//:: nx_s2_innerarmor.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 10th level, a sacred fist's inner tranquility
	protects him from external threats. He may invoke
	a +4 sacred bonus to AC, a +4 sacred bonus on all saves,
	and spell resistance 25 for a number of rounds equal to his
	Wisdom modifier. He may use inner armor once per day.
	*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/01/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/12/2007: NX1 VFX

#include "_HkSpell"
#include "_CSLCore_Items"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_innerarmor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes =83970;
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
	

	int nWisdomBonus  = GetAbilityModifier(ABILITY_WISDOM);
	if (nWisdomBonus <= 0)
	{
		nWisdomBonus = 1; // Lasts a minimum of one round.
	}
	
	effect eAC = EffectACIncrease(4, AC_DODGE_BONUS);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
	effect eSR = EffectSpellResistanceIncrease(25);
	effect eDur = EffectVisualEffect(VFX_DUR_INNER_ARMOR);
		
	effect eLink = EffectLinkEffects(eAC, eSave);
	eLink = EffectLinkEffects(eLink, eSR);
	eLink = EffectLinkEffects(eLink, eDur);

	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	// Spell does not stack
	if (GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
	{
			//SCRemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	}

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nWisdomBonus));
	
	HkPostCast(oCaster);
}