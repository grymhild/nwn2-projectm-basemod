//::///////////////////////////////////////////////
//:: Sickening Grasp
//:: cmi_s2_sickengrasp
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 11, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"



void main()
{	
	//scSpellMetaData = SCMeta_FT_sickgrasp();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iDuration = 0;
	
	iDuration = GetNecroReserveLevel();
		 
	if (iDuration == 0)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	else
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		
			effect eVis = EffectVisualEffect(VFX_HIT_WEAKEN_SPIRITS);
			effect eDamageDecrease = EffectDamageDecrease(2);
			effect eAB = EffectAttackDecrease(2);
			effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2,SAVING_THROW_TYPE_ALL);
			effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
			
			effect eLink = EffectLinkEffects(eSkill, eSave);
			eLink = EffectLinkEffects(eLink,eAB);
			eLink = EffectLinkEffects(eLink,eDamageDecrease);
			
			//A sickened creature takes a -2 penalty on attack rolls, weapon damage rolls, 
			//saving throws, skill checks, and ability checks.
			
			//Hmm.  Not going to do the ability check part for now as that would be a 
			//-4 to all stats which is huge for an unlimited use feat.
						
			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));				
				int iDC = GetReserveSpellSaveDC(iDuration,OBJECT_SELF);
				//Apply the effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					
                if  (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DISEASE))
                {
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );	
				}
				else
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f);
				}
			}
		}	
	}			
	HkPostCast(oCaster);
}