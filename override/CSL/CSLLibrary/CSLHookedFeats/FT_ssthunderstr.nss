//::///////////////////////////////////////////////
//:: Thunderstrike
//:: cmi_s2_thundstruck
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


// Based on Polar Ray code by OEI

#include "_HkSpell"
//#include "NW_I0_SPELLS"    
//#include "x2_inc_spellhook" 
//#include "_SCInclude_sneakattack"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_ssthunderstr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = STORMSINGER_THUNDERSTRIKE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


	//int nHasRSS = GetHasFeat(2991);

    //Declare major variables
    object oTarget = HkGetSpellTarget();
	int iTouch = CSLTouchAttackRanged(oTarget);
	
	int iDC = 10 + GetLevelByClass(CLASS_STORMSINGER) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	iDC += CSLGetDCBonusByLevel(OBJECT_SELF);
	
	int iDamage = GetSkillRank(SKILL_PERFORM);
	
	if (iDamage < 11) //Short circuit
	{
		SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 11 or more to use this ability.");
		return;
	}
	if (!GetHasFeat(FEAT_BARD_SONGS))
	{
		SpeakString("No uses of the Bard Song ability are available");
		return;
	}
	else
	{
		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);		
	}	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iBeamEffect = HkGetShapeEffect( VFX_BEAM_SONIC, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	iDamage += d20();
	
		
	//Stormpower
	iDamage += 2;	
	
	iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );

    if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));

		if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		{			
				//include sneak attack damage
				//if (StringToInt(Get2DAString("cmi_switches","SneakAttackSpells",0)))
				iDamage += CSLEvaluateSneakAttack(oTarget, OBJECT_SELF);
								
				if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC))
				{
					//Save Made
					//iDamage = iDamage/2;
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_REFLEX, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, SAVING_THROW_RESULT_SUCCESS );
				
		            effect eDam = EffectDamage(iDamage, iDamageType);
		   	 		effect eVis = EffectVisualEffect(iHitEffect);
		            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);					
				}
				else
				{
					//Save Failed
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_REFLEX, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, SAVING_THROW_RESULT_FAILED );
		            effect eDam = EffectDamage(iDamage, iDamageType);
		   	 		effect eVis = EffectVisualEffect(iHitEffect);
					effect eDeaf = EffectDeaf();
		            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);	
					if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEAFNESS) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(iDamage));		
					}						
				}
	

		}
    }
	
    effect eBeam = EffectBeam(iBeamEffect, OBJECT_SELF, BODY_NODE_HAND);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5);
    
    HkPostCast(oCaster);
}