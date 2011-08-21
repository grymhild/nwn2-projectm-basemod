//::///////////////////////////////////////////////
//:: [Cause Fear]
//:: [NW_S0_CauseFear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Casts "Cause Fear" on multiple critters
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CAUSE_FEAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR|SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iCasterLevel = ( GetSpellId() == SPELL_CAUSE_FEAR ) ? 4 : CSLGetMin(10, HkGetSpellPower(oCaster));
	
	int nDC = HkGetSpellSaveDC();

	//Has same SpellId as Cause Fear, not an item, but returns no valid class -> it's racial ability
	if (GetSpellId() == SPELL_CAUSE_FEAR && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		nDC = 10 + GetSpellLevel(SPELL_CAUSE_FEAR) + GetAbilityModifier(ABILITY_CHARISMA);
	}
	
	object oTarget = HkGetSpellTarget();
	object oOrigTgt = oTarget;
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(iCasterLevel));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eScary = CSLGetFearEffect();
	// First, do the one we explicitly targeted, if any:
	if (GetIsObjectValid(oTarget))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
				if (!HkResistSpell(oCaster, oTarget))
				{
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
					{
						HkApplyEffectToObject(iDurType, eScary, oTarget, fDuration);
					}
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

