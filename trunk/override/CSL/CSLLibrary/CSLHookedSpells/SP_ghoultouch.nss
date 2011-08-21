//::///////////////////////////////////////////////
//:: Ghoul Touch
//:: NW_S0_GhoulTch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The caster attempts a touch attack on a target
	creature.  If successful creature must save
	or be paralyzed. Target exudes a stench that
	causes all enemies to save or be stricken with
	-2 Attack, Damage, Saves and Skill Checks for
	1d6+2 rounds.
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
	int iSpellId = SPELL_GHOUL_TOUCH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GHOUL_TOUCH, TRUE));
		int bFeedback = ( !CSLIsItemValid( GetSpellCastItem() ) );
		int iTouch = CSLTouchAttackMelee(oTarget,bFeedback);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			int iSaveDC = HkGetSpellSaveDC();
			if (!HkResistSpell(oCaster, oTarget) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NEGATIVE))
			{
				float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(d6()+2));
				effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZED));
				eLink = EffectLinkEffects(eLink, EffectParalyze(iSaveDC, SAVING_THROW_FORT));
				string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
				eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(AOE_PER_FOGGHOUL, "", "", "", sAOETag));
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_GHOUL_TOUCH );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), oTarget);
			}
		}
	}
	
	HkPostCast(oCaster);
}

