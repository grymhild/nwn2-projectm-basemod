//::///////////////////////////////////////////////
//:: Avasculate
//:: nw_s0_avasculate.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Avasculate
	Necromancy [Death, Evil]
	Level: sorceror/wizard 7
	Components: V,S
	Range: Close
	Duration: Instantaneous
	Saving Throw: Fortitude partial
	Spell Resistance: Yes
	
	You must succeed on a ranged touch attack with
	the ray to strike a target.  If the attack succeeds,
	the subject is reduced to half of its current hit
	points and stunned for 1 round.  On a successful
	Fortitude saving throw, the subject is not stunned.
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
	int iSpellId = SPELL_AVASCULATE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	CSLSpellEvilShift(oCaster);
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget  = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1032, TRUE));     
			if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
			{	
				if (!HkResistSpell(oCaster, oTarget))
				{
					if (GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH, oCaster)) 
					{
						return;
					}
					
					int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, oCaster );
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
					{
						int nDam = CSLGetMin(GetCurrentHitPoints(oTarget)/2, CSLGetMin(150, HkGetSpellPower(oCaster) * 10));
						nDam = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDam, SC_TOUCHSPELL_RAY );
						effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
						if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
						{
							float fDur = HkApplyMetamagicDurationMods(RoundsToSeconds(1));
							effect eLink = EffectVisualEffect(VFX_DUR_STUN);
							eLink = EffectLinkEffects(eLink, EffectStunned());
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
						}
					}
					
				}
			}
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_AVASCULATE), oTarget);
		}
		CSLSpellEvilShift(oCaster);
	}
	HkPostCast(oCaster);
}