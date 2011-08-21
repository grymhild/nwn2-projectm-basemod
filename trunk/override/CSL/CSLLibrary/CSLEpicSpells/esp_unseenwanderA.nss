//:://////////////////////////////////////////////
//:: FileName: "wander_unseen"
/* 	Purpose: Wander Unseen - this is the ability that is granted to a player
		as the result of an Unseen Wanderer epic spell. Using this feat will
		either turn the player invisible, or if already in that state, visible
		again.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_dispel"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_WANDERUNSEEN;
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
	object oPC = OBJECT_SELF;
	effect eX, eRem;
	int nIsInvis;

	eX = GetFirstEffect(oPC);
	while (GetIsEffectValid(eX))
	{
		if (GetEffectType(eX) == EFFECT_TYPE_INVISIBILITY ||
			GetEffectType(eX) == EFFECT_TYPE_GREATERINVISIBILITY)
		{
			// Debug
			SendMessageToPC(oPC, "Invisible");
			nIsInvis = TRUE;
			eRem = eX;
		}
		eX = GetNextEffect(oPC);
	}

	if (nIsInvis == TRUE)
	{
		RemoveEffect(oPC, eRem);
	}
	else
	{
		effect eInv = SupernaturalEffect(EffectInvisibility(INVISIBILITY_TYPE_NORMAL));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oPC);
	}
	HkPostCast(oCaster);
}
