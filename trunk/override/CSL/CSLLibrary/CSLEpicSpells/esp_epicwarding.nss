//::///////////////////////////////////////////////
//:: Epic Ward
//:: X2_S2_EpicWard.
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Makes the caster invulnerable to damage
	(equals damage reduction 50/+20)
	Lasts 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Aug 12, 2003
//:://////////////////////////////////////////////
/*
	Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_EP_WARD;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, iSpellId))
	{
		object oTarget = HkGetSpellTarget();
		int nDuration = HkGetCasterLevel(OBJECT_SELF);
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));
		int nLimit = 50*nDuration;
		effect eDur = EffectVisualEffect(495);
		effect eProt = EffectDamageReduction(50, DAMAGE_POWER_PLUS_TWENTY, nLimit);
		effect eLink = EffectLinkEffects(eDur, eProt);
		eLink = EffectLinkEffects(eLink, eDur);

		// * Brent, Nov 24, making extraodinary so cannot be dispelled
		eLink = ExtraordinaryEffect(eLink);

		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, iSpellId );
		//Apply the armor bonuses and the VFX impact
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration) );
	}
	HkPostCast(oCaster);
}
