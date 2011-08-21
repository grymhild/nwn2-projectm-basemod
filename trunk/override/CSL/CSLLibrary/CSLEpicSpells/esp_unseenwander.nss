//:://////////////////////////////////////////////
//:: FileName: "ss_ep_unseenwand"
/* 	Purpose: Unseen Wanderer - grants a player target the "Wander Unseen"
		feat, which allows you to turn invisible/visible at will, permanently.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "x2_inc_spellhook"
//#include "x0_i0_position"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_UNSEENW;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget) && // Is the target valid?
		!GetHasFeat(5028, oTarget) && // Does the target not already have the feat?
		GetIsPC(oTarget)) 			// Is the target a player?
	{
		if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_UNSEENW))
		{
			int nY;
			effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
			float fAngle, fDist, fOrient;
			location lTarget = GetLocation(oTarget);
			location lNew, lNew2;
			float fDelay = 0.2;
			for (nY = 20; nY > 0; nY--) // Where in perimeter.
			{
				fAngle = IntToFloat(nY * 18);
				fDist = 1.1;
				fOrient = fAngle;
				lNew = CSLGenerateNewLocationFromLocation
				(lTarget, fDist, fAngle, fOrient);
				fAngle += 180.0;
				fOrient = fAngle;
				lNew2 = CSLGenerateNewLocationFromLocation
				(lTarget, fDist, fAngle, fOrient);
				DelayCommand(fDelay,
				HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lNew));
				DelayCommand(fDelay,
				HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lNew2));
				fDelay += 0.4;
			}
			DelayCommand(6.0, GiveFeat(oTarget, 428));
			FloatingTextStringOnCreature("You have gained the ability to wander unseen at will!", oTarget, FALSE);
		}
	}
	else
	{
		FloatingTextStringOnCreature("Spell failed - target already has this ability.", OBJECT_SELF, FALSE);
	}
	HkPostCast(oCaster);
}

