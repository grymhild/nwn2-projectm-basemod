//::///////////////////////////////////////////////
//:: Death Touch
//:: cmi_s2_deathtouch
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 28, 2007
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x0_I0_SPELLS"
//#include "x2_inc_spellhook"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
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
	


    object oTarget = HkGetSpellTarget();
	
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		int iCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC,OBJECT_SELF);
		
		int nDeathRoll = d6(iCasterLevel);
		if (iTouch == TOUCH_ATTACK_RESULT_CRITICAL)
		{
			nDeathRoll = nDeathRoll * 2;
		}	
		
		int nCurrentHP = GetCurrentHitPoints(oTarget);
		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	
		
		if (nDeathRoll > nCurrentHP)
		{
			
			effect eDeath = EffectDeath(TRUE,TRUE,FALSE,TRUE);
		
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		    {
		            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath , oTarget);
		    }
		}
		else
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SendMessageToPC(OBJECT_SELF,"Death Touch failed to slay the target.");
		}
	}
	
	HkPostCast(oCaster);
}