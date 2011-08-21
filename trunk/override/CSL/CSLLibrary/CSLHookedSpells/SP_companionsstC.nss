//::///////////////////////////////////////////////
//:: Companion's Strife (b) - hearbeat
//:: sg_s0_comstrb.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	The spell warps the targets ability to discern
	friends from foes and causes them to immediately
	attack nearest allies in attempt to "escape"
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 25, 2003
//:://////////////////////////////////////////////
//#include "NW_I0_PLOT"
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget = HkGetAOEOwner(OBJECT_SELF);
	//location lTarget 		= GetLocation(oTarget);
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	int 	iDuration 		= GetLocalInt(oTarget, "SG_L_COMP_STR_DUR")-1;
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	
	object oAttackTarget;
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//effect eAOE = EffectAreaOfEffect(AOE_MOB_COMP_STRIFE);
	//effect eVis = EffectAreaOfEffect(VFX_DUR_MIND_AFFECTING_FEAR);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(iDuration>0)
	{
		SetLocalInt(oTarget, "SG_L_COMP_STR_DUR", iDuration);
		oAttackTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
		if(GetIsObjectValid(oAttackTarget) && GetDistanceBetween(oTarget, oAttackTarget)<FeetToMeters(6.5)) {
			SetCommandable(TRUE, oTarget);
			SetIsTemporaryEnemy(oAttackTarget, oTarget, TRUE, fDuration);
			AssignCommand(oTarget,ActionEquipMostDamagingMelee(oAttackTarget));
			DelayCommand(0.1f, AssignCommand(oTarget,ActionAttack(oAttackTarget)));
			DelayCommand(0.5f, SetCommandable(FALSE,oTarget));
		} else {
			if(GetIsObjectValid(oCaster)) {
				SetCommandable(TRUE,oTarget);
				AssignCommand(oTarget,ActionMoveAwayFromObject(oCaster,TRUE));
				DelayCommand(0.5f,SetCommandable(FALSE,oTarget));
			}
		}
	} else {
		DestroyObject(OBJECT_SELF);
	}
}
