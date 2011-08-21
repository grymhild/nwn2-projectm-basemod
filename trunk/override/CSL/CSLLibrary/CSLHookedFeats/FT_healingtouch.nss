//::///////////////////////////////////////////////
//:: Healing Touch
//:: cmi_s2_healingtouch
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 1, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
//#include "_SCInclude_Class"

int GetHealingReserveLevel()
{

	if ( GetHasSpell(897) || GetHasSpell(114) )
		return 8;	
					
	if ( GetHasSpell(894) || GetHasSpell(374) || GetHasSpell(70) || GetHasSpell(153) )
		return 7;						
			
	if ( GetHasSpell(891) || GetHasSpell(79) || GetHasSpell(1023) )
		return 6;					
		
	if ( GetHasSpell(80) || GetHasSpell(1030) || GetHasSpell(142) || GetHasSpell(1004) )
		return 5;						

	if ( GetHasSpell(31) || GetHasSpell(152) )
		return 4;																
		
	if ( GetHasSpell(35) || GetHasSpell(126) || GetHasSpell(145) || GetHasSpell(147) || 
		GetHasSpell(1020) || GetHasSpell(1022) )
		return 3;					
																		
		
	if ( GetHasSpell(34) || GetHasSpell(149) || GetHasSpell(97) || GetHasSpell(1169) )
		return 2;																	
									
	return 0;
}

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nHealingLevel = 0;
	// IsModuleSupported(OBJECT_SELF);
	nHealingLevel = GetHealingReserveLevel();
	int nCanHeal = 1;	 
	
	if (nHealingLevel == 0)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	else
	if ( !CSLGetIsUndead( oTarget, TRUE ) )
	{
		
		//int nTouchofHealingUse50PercentCap = GetLocalInt(GetModule(), "TouchofHealingUse50PercentCap");
		//int nTouchofHealingUseAugmentHealing = GetLocalInt(GetModule(), "TouchofHealingUseAugmentHealing");
		
		if ( CSLGetPreferenceSwitch("TouchofHealingUse50PercentCap",FALSE) )
		{
			if ( GetCurrentHitPoints(oTarget) > (GetMaxHitPoints(oTarget)/2) )
			{	
				SendMessageToPC(OBJECT_SELF,"Target's health is greater than 50%, this ability only affects those at half life or below.");
				nCanHeal = 0;
			}
		}
		//		else
		//			if (nTouchofHealingUse50PercentCap == 0)
		//				SendMessageToPC(OBJECT_SELF, "This module does not support Kaedrin's content correctly.  Please see the 'Adding Module Support.txt' readme about how to add the needed module support.");

		
		effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
		int nHeal = 3 * nHealingLevel;
		
		if ( CSLGetPreferenceSwitch("TouchofHealingUseAugmentHealing",FALSE) )
		{
			if (GetHasFeat(FEAT_AUGMENT_HEALING,OBJECT_SELF))
				nHeal += nHealingLevel * 2;
		}
				
		if (nCanHeal)
		{				
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));				
	
			//Apply the effects
	        effect eHeal = EffectHeal(nHeal);
	        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);			
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}

	}			


	HkPostCast(oCaster);
}