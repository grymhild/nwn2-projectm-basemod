//::///////////////////////////////////////////////
//:: Elemental Strike
//:: cmi_s2_elemstrike
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: August 11, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
//#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_elemwar_stri();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


	int nVFXHit;
	int iDamageType;
	int iSaveType;
	effect eStatusEffect;
	int bKnock = FALSE;
	
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR))
	{
		iSaveType = SAVING_THROW_TYPE_ALL;
		nVFXHit = VFX_HIT_SPELL_LIGHTNING;
		iDamageType = DAMAGE_TYPE_BLUDGEONING;	
		eStatusEffect = EffectKnockdown();
		bKnock = TRUE;
	}	
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH))
	{	
		iSaveType = SAVING_THROW_TYPE_ALL;	
		iDamageType = DAMAGE_TYPE_BLUDGEONING;	
		nVFXHit = VFX_HIT_SPELL_ACID;
		eStatusEffect = EffectKnockdown();
		bKnock = TRUE;		
	}
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE))
	{
		iSaveType = SAVING_THROW_TYPE_FIRE;	
		iDamageType = DAMAGE_TYPE_FIRE;	
		nVFXHit = VFX_HIT_SPELL_FIRE;
		eStatusEffect = EffectDamage(d6(1), iDamageType);
	}
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER))
	{
		iSaveType = SAVING_THROW_TYPE_COLD;	
		iDamageType = DAMAGE_TYPE_MAGICAL;	
		nVFXHit = VFX_HIT_SPELL_ICE;
		eStatusEffect = EffectAttackDecrease(4);	
	}
		
	//Declare major variables
	object oTarget = HkGetSpellTarget();
			 
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		
			effect eVis = EffectVisualEffect(nVFXHit);
			int iDamage = d6(10);
						
			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE, OBJECT_SELF );
				/*
				if (GetHasFeat(2991,OBJECT_SELF,TRUE))
					iDamage += 2;	
				if (nMeleeTouch == TOUCH_ATTACK_RESULT_CRITICAL)
					iDamage = iDamage * 2;
										
				//include sneak attack damage
				if (UseSneakAttackForSpells())
					iDamage += CSLEvaluateSneakAttack(oTarget, OBJECT_SELF);
				*/					
				effect eDamage = HkEffectDamage(iDamage,iDamageType);
				
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));				

				//Apply the effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				
				int iDC = 15 + GetAbilityModifier(ABILITY_CONSTITUTION);	
                if  (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
				{
					if (iDamageType != DAMAGE_TYPE_FIRE)
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatusEffect, oTarget, 6.0f);
						if ( bKnock && !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
						{
							CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN", 6.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
						}
					}
					else
					{
						DelayCommand(6.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eStatusEffect, oTarget));
					}
				}
			}
		}	
	}			
	HkPostCast(oCaster);
}