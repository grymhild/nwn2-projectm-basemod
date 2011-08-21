/*
	sp_pestilence

	Disease effect on target. The disease will spawn an AOE
	that will spread the disease for 24h from infection.

	By: Ornedan
	Created: Dec 25, 2004
	Modified: Jul 2, 2006
*/
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary

#include "_HkSpell"
#include "_CSLCore_Combat"
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PESTILENCE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	float fMaxDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

	effect eDisease = SupernaturalEffect(EffectDisease(DISEASE_PESTILENCE));
	effect eAoE = EffectAreaOfEffect(AOE_MOB_PESTILENCE);

	int iAttackRoll;
	// Check for the disease component
	if(!CSLGetHasEffectType(oCaster,EFFECT_TYPE_DISEASE))
	{
		if(GetIsPC(oCaster))
		{
			SendMessageToPC(oCaster, "You need to to be diseased to cast this spell");
		}// end if - is oCaster a PC
	}// end if - caster isn't diseased
	else
	{
		// Check if the target is valid
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_PESTILENCE));
			//Make touch attack
			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				//Make sure the target is a living one
				if( !CSLGetIsConstruct( oTarget )  &&  !CSLGetIsUndead( oTarget ) )
				{
				//Make SR Check
				if (!HkResistSpell(oCaster, oTarget ))
				{
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_DISEASE))
					{
						HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, SPELL_PESTILENCE, oCaster);
						//SetLocalInt(oTarget, "SPELL_PESTILENCE_DC", nSaveDC);
						//SetLocalInt(oTarget, "SPELL_PESTILENCE_CASTERLVL", nCasterLevel);
						//SetLocalInt(oTarget, "SPELL_PESTILENCE_SPELLPENETRATION", nPenetr);
						//SetLocalObject(oTarget, "SPELL_PESTILENCE_CASTER", oCaster);
						//SetLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE", TRUE);
// 					DelayCommand(4.0f, DeleteLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE"));

						// Delayed a bit. Seems like the presence of the disease effect may
						// not register immediately, resulting in the AoE killing itself
						// right away due to that check failing.
						DelayCommand(0.4f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, HoursToSeconds(24), SPELL_PESTILENCE, oCaster));
					}// end if - fort save
				}// end if - spell resistance
				}//end if - only living targets
			}// end if - touch attack
		}// end if - is the target valid
	}// end else - the caster is diseased
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}