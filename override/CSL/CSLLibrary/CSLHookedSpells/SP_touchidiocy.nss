//::///////////////////////////////////////////////
//:: [Touch of Idiocy]
//:: [NX_S0_touchidiocy.nss]
//:://////////////////////////////////////////////
//::
//:: Components: V, S
//:: Duration: 10 minutes/level
//:: Saving Throw: None
//:: Spell Resistance: Yes
//::
//:: Touch attack applies 1d6 penalty to INT, WIS,
//:: and CHA, which can affect target's spellcasting.
//:: This penalty cannot reduce any score to below 1.
//::
//:://////////////////////////////////////////////
//:: Created By: Ryan Young (REY - OEI)
//:: Created On: January 12, 2007
//::
//:: Borrowed heavily from [NW_S0_ShkngGrsp.nss]
//:: Jesse Reynolds (JLR - OEI)
//:://////////////////////////////////////////////
//:: AFW-OEI 07/10/2007: NX1 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

 


void main()
{
	//scSpellMetaData = SCMeta_SP_touchidiocy();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TOUCH_OF_IDIOCY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	float fDuration = TurnsToSeconds(10 * HkGetSpellDuration(OBJECT_SELF));
	
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
	//GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from CSLTouchAttackMelee
	
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

				if (!HkResistSpell(OBJECT_SELF, oTarget))
				{
					//Check for metamagic
					int nWisDmg = HkApplyMetamagicVariableMods(d6(), 6);
					int nIntDmg = HkApplyMetamagicVariableMods(d6(), 6);
					int nChaDmg = HkApplyMetamagicVariableMods(d6(), 6);
					
					nWisDmg = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nWisDmg, SC_TOUCH_MELEE, oCaster );
					nIntDmg = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nIntDmg, SC_TOUCH_MELEE, oCaster );
					nChaDmg = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nChaDmg, SC_TOUCH_MELEE, oCaster );
			
					//Set ability damage effect
					effect eWis, eInt, eCha;
					
					int nCurWis = GetAbilityScore(oTarget, ABILITY_WISDOM);
					if ( (nCurWis - nWisDmg) <= 1)
					{
						eWis = EffectAbilityDecrease(ABILITY_WISDOM, (nCurWis -1));
					}
					else
					{
						eWis = EffectAbilityDecrease(ABILITY_WISDOM, nWisDmg);
					}
					
					int nCurInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
					if ( (nCurInt - nIntDmg) <= 1)
					{
						eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, (nCurInt - 1));
					}
					else
					{
						eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nIntDmg);
					}
					
					int nCurCha = GetAbilityScore(oTarget, ABILITY_CHARISMA);
					if ( (nCurCha - nChaDmg) <= 1)
					{
						eCha = EffectAbilityDecrease(ABILITY_CHARISMA, (nCurCha - 1));
					}
					else
					{
						eCha = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDmg);
					}
					
					effect eDur = EffectVisualEffect( VFX_DUR_SPELL_TOUCH_OF_IDIOCY );
					effect eLink = EffectLinkEffects(eWis, eInt);
					eLink = EffectLinkEffects(eLink, eCha);
					eLink = EffectLinkEffects(eLink, eDur);
					
						//Apply the VFX impact and effects
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
					HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
				}
			}
	}
	effect eRay = EffectBeam(VFX_BEAM_ENCHANTMENT, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
	
	HkPostCast(oCaster);
}

