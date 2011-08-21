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

//#include "NW_I0_PLOT"
//
//
// 
// void main()
// {
// 
//     location lTarget        = GetLocation(oTarget);
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------

//#include "nw_i0_plot"

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	object  oTarget = HkGetSpellTarget();
	int iCasterLevel = HkGetCasterLevel(oCaster);
	
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag = HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE,  oTarget  );
	
    object  oAttackTarget;

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_MOB_COMP_STRIFE, "", "", "", sAOETag);
    effect eVis = EffectAreaOfEffect(VFX_DUR_MIND_AFFECTING_FEAR);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster, SPELL_COMP_STRIFE));
    if(CSLGetIsHumanoid(oTarget) && !HkResistSpell(oCaster, oTarget))
    {
        if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR))
        {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
            SetLocalInt(oTarget, "SG_L_COMP_STR_DUR", iDuration);
            AssignCommand(oTarget,ClearAllActions());
            DelayCommand(0.5f,SetCommandable(FALSE,oTarget));
            oAttackTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
            if(GetIsObjectValid(oAttackTarget) && GetDistanceBetween(oTarget, oAttackTarget)<FeetToMeters(6.5))
            {
                SetCommandable(TRUE, oTarget);
                SetIsTemporaryEnemy(oAttackTarget, oTarget, TRUE, fDuration);
                AssignCommand(oTarget,ActionEquipMostDamagingMelee(oAttackTarget));
                DelayCommand(0.1f, AssignCommand(oTarget,ActionAttack(oAttackTarget)));
                DelayCommand(0.5f, SetCommandable(FALSE,oTarget));
            }
            else
            {
                SetCommandable(TRUE,oTarget);
                AssignCommand(oTarget,ActionMoveAwayFromObject(oCaster,TRUE,75.0));
                DelayCommand(0.5f,SetCommandable(FALSE,oTarget));
            }
        }
    }

    HkPostCast(oCaster);
}

