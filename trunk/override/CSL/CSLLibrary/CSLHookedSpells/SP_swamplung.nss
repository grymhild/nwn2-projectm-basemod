//::///////////////////////////////////////////////
//:: Swamp Lung
//:: nw_s0_swamplung.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	The spell attempts to flood the target's lungs with stagnant
	swamp water.  if the subject fails the save, the creature falls
	prone in a coughing fit for 1-6 rounds and is helpless during
	that time.  Furthermore, on a failed save, the subject contracts
	filth fever, which causs 1-3 strength and dexterity damage.
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
	int iSpellId = SPELL_SWAMP_LUNG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_WATER, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();

	if (GetHasSpellEffect(GetSpellId(), oTarget))
	{
		FloatingTextStrRefOnCreature(100775, oCaster, FALSE);
		return;
	}

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if ( !CSLGetIsDrownable(oTarget, TRUE ) ) // why is   in here
			{
				FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
				return;
			}
			if ( CSLGetIsVermin(oTarget) || CSLGetIsOutsider(oTarget) ) // these guys ignore the effect unless they are underwater, in which case they only gulp water
			{
				if ( GetLocalInt(oTarget, "UNDERWATER")  && !FortitudeSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oCaster) )
				{
						FloatingTextStringOnCreature("*gulp*", oTarget, TRUE);
						CSLReduceBreathableRounds( oTarget, 5 );
						return;
				}
				FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
				return;
			}
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId ));
			if (!FortitudeSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oCaster))
			{
				int iDuration = d6();
				float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(iDuration));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_SWAMP_LUNG), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, fDuration);
				if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDuration, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDisease(DISEASE_FILTH_FEVER)), oTarget);
				CSLReduceBreathableRounds( oTarget, 2 );
				CSLReduceBreathableRounds( oTarget, 3, iDuration, iSpellId );
			}
		}
	}
	
	HkPostCast(oCaster);
}

