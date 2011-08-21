//::///////////////////////////////////////////////
//:: Companion's Strife
//:: sg_s0_comstr.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	The spell warps the targets ability to discern
	friends from foes and causes them to immediately
	attack nearest allies in attempt to "escape"
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 24, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= HkGetAOEOwner(OBJECT_SELF);
	//location lTarget 		= GetLocation(oTarget);
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	int iDuration = GetLocalInt(oTarget, "SG_L_COMP_STR_DUR");
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	//int 	iDieType 		= 0;
	//int 	iNumDice 		= 0;
	//int 	iBonus 		= 0;
	//int 	iDamage 		= 0;

	object oAttackTarget = GetEnteringObject();

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//effect eAOE = EffectAreaOfEffect(AOE_MOB_COMP_STRIFE);
	//effect eVis = EffectAreaOfEffect(VFX_DUR_MIND_AFFECTING_FEAR);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(GetIsObjectValid(oAttackTarget))
	{
		SetCommandable(TRUE, oTarget);
		SetIsTemporaryEnemy(oAttackTarget, oTarget, TRUE, fDuration);
		AssignCommand(oTarget,ActionEquipMostDamagingMelee(oAttackTarget));
		DelayCommand(0.1f, AssignCommand(oTarget,ActionAttack(oAttackTarget)));
		DelayCommand(0.5f, SetCommandable(FALSE,oTarget));
	}
}
