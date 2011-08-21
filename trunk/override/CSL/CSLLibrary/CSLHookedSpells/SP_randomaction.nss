//::///////////////////////////////////////////////
//:: Random Action
//:: sg_s0_ranaction.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Spell Description
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 10, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = d8();
    //int     iNumDice        = 0;
    //int     iBonus          = 0;
    //int     iDamage         = 0;

    object oAttackTarget;
    object oItem;




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis      = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eWillSave    = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
    effect eStun        = EffectStunned();
    effect eDaze        = EffectDazed();
    effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RANDOM_ACTION));
    if(!HkResistSpell(oCaster, oTarget)) {
        if(CSLGetIsLiving(oTarget) && !HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS) && 
            GetAbilityScore(oTarget,ABILITY_INTELLIGENCE)>=3) {
                
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
            AssignCommand(oTarget, ClearAllActions());
            switch(iDieType) {
                case 1:
                    AssignCommand(oTarget, ActionAttack(oTarget));
                    break;
                case 2:
                    oAttackTarget=GetNearestCreature(CREATURE_TYPE_RACIAL_TYPE, RACIAL_TYPE_ALL, oTarget);
                    AssignCommand(oTarget, ActionAttack(oAttackTarget));
                    break;
                case 3:
                    AssignCommand(oTarget, ActionMoveAwayFromObject(oCaster, TRUE, 200.0f));
                    break;
                case 4:
                    oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                    if(GetIsObjectValid(oItem)) {
                        AssignCommand(oTarget, ActionUnequipItem(oItem));
                    }
                    oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
                    if(GetIsObjectValid(oItem)) {
                        AssignCommand(oTarget, ActionUnequipItem(oItem));
                    }
                    break;
                case 5:
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDuration);
                    break;
                case 6:
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDuration);
                    break;
                case 7:
                    AssignCommand(oTarget, ActionRandomWalk());
                    DelayCommand(fDuration+1.5f, AssignCommand(oTarget, ClearAllActions()));
                    break;
                case 8:
                    AssignCommand(oTarget, ActionAttack(oCaster));
                    break;
            }
            SetCommandable(FALSE, oTarget);
            DelayCommand(fDuration, SetCommandable(TRUE, oTarget));
        } else {
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eWillSave, oTarget);
        }
    }

    HkPostCast(oCaster);
}


