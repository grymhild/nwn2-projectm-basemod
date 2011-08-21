//::///////////////////////////////////////////////
//:: Touch of Fatigue
//:: NX_s0_tfatigue.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Components: V, S
	Duration: 1 round/level
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	
	Touch attack gives target Fatigued status
	effect. If the target is already fatigued,
	nothing happens.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.13.06
//:://////////////////////////////////////////////
// ChazM 1/8/07 Modified includes
// MDiekmann 5/21/07 Changed so that spell only lasts one round per caster level
// AFW-OEI 07/14/2007: NX1 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Evocation"




void main()
{
	//scSpellMetaData = SCMeta_SP_touchfatigue();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TOUCH_OF_FATIGUE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	object oTarget = HkGetSpellTarget();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TOUCH_OF_FATIGUE);
	//effect eFatigue = CSLEffectFatigue();
	//effect eLink = EffectLinkEffects(eVis, eFatigue);
	int nFatigueRds =   HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	
	
//discriminate targets

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
				//spell resistance
				if (!HkResistSpell(oCaster, oTarget))
				{
					//saving throw
					if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oCaster))
					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						CSLApplyFatigue(oTarget, RoundsToSeconds(nFatigueRds) );
					}
				}
			}
		}
	}
	HkPostCast(oCaster);
}

