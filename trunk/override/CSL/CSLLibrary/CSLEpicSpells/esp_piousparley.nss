//:://////////////////////////////////////////////
//:: FileName: "ss_ep_piousparly"
/* 	Purpose: Pious Parley - this spell will look at the Deity field on the
		caster, and will then use that to open the corresponding conversation
		for that god with the caster. If no deity name exists on the caster,
		a default conversation will open, telling them they're faithless.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"
//#include "x0_i0_position"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_PIOUS_P;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PIOUS_P))
	{
		string sDeity = GetDeity(OBJECT_SELF);
		string sDeityConv = "pparl_" + GetStringLeft(sDeity, 10);
		//Debug.
		//SendMessageToPC(OBJECT_SELF, "Deity = " + sDeity);
		//SendMessageToPC(OBJECT_SELF, "DeityConv = " + sDeityConv);

		location lLoc = GetLocation(OBJECT_SELF);
		location lNew;
		float fAngle, fDist, fOrient, fDelay;

		effect eDur = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
		effect eVisG = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
		effect eVisN = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
		effect eVisE = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
		effect eE;
		effect eImp = EffectVisualEffect(VFX_IMP_HEALING_S);
		int nPray = ANIMATION_LOOPING_MEDITATE;
		int nX, nY;

		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD) eE = eVisG;
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL) eE = eVisE;
		else eE = eVisN;

		AssignCommand(OBJECT_SELF, ActionPlayAnimation(nPray, 1.0, 6.0));
		fDelay = 0.2;
		for (nX = 10; nX > 0; nX--)
		{
			for (nY = 20; nY > 0; nY--)
			{
				fAngle = IntToFloat(nY * 18);
				fDist = IntToFloat(nX);
				fOrient = fAngle;
				lNew = CSLGenerateNewLocationFromLocation
				(lLoc, fDist, fAngle, fOrient);
				DelayCommand(fDelay,
				HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lNew));
			}
			fDelay += 0.4;
		}
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, 15.0, -2);
		DelayCommand(4.0,
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eE, lNew));

		//DelayCommand(4.9, AssignCommand(OBJECT_SELF, ClearAllActions()));
		DelayCommand(5.0, AssignCommand(OBJECT_SELF,
			ActionStartConversation(OBJECT_SELF,
			sDeityConv, TRUE, FALSE)));
	}
	HkPostCast(oCaster);
}

