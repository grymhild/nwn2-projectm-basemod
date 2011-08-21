//::///////////////////////////////////////////////
//:: Favored of the Spirits
//:: nx_s2_favoredspirits.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
A spirit shaman learns how to perform a special
rite that guards her from death. While under the
protection of this rite, a spirit shaman instantly
heals 10 hit points per shaman level, up to 150 hit
points, if she is reduced to 0 hit points or lower.
The spirit shaman receives the spells effect
immediately, even if reduced to 10 hit points or
lower by an enemy attack, and thus may survive a blow
that otherwise would have killed her. The rites
protection is discharged once it is triggered, and
the spirit shaman must rest to regain the favor of
the spirits.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablfavore();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	// AFW-OEI 07/16/2007: Early-out if no feat uses left.
	if (!GetHasFeat(FEAT_FAVORED_OF_THE_SPIRITS))
	{
		return;
	}
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN);
	
	if (nShamanLvl > 30)
	{   // Cap healing at 15
			nShamanLvl = 30;
	}

	// Does not stack with itself.
	if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
			effect eHP = EffectHealOnZeroHP(oTarget, 10*nShamanLvl);
			eHP = ExtraordinaryEffect(eHP); // Make it not dispellable.
			
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oTarget);
				
		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_FAVORED_OF_THE_SPIRITS);
	}
	
	HkPostCast(oCaster);
}

