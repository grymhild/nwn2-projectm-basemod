//::///////////////////////////////////////////////
//:: Hemorrhage
//:: sg_s0_Hemorr.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Clr 1
     Components: V, S, DF
     Casting Time: 1 action
     Range: Touch
     Target: Creature touched
     Duration: 1 round/2 levels (maximum 5 rounds)
     Saving Throw: Will negates
     Spell Resistance: Yes

     Your touch inflicts a deep, painful wound that
     bleeds profusely and refuses to heal. The target
     takes 1d3 points of damage per round from bleeding
     until the spell's duration expires. Nonmagical
     healing neither stops the blood loss nor restores
     hit points lost from such bleeding. A cure spell
     restores hit points normally but does not stop the
     bleeding. A styptic or heal spell both stops the
     bleeding and restores lost hit points as it
     normally would.

     Hemorrhage is countered by styptic.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 30, 2004
//:://////////////////////////////////////////////
#include "_HkSpell"

void BloodHit( object oTarget, int iRoundsLeft, int iMetamagic )
{
	if ( iRoundsLeft > 0 && GetHasSpellEffect(SPELL_HEMORRHAGE, oTarget) )
	{
		int iDamage = HkApplyMetamagicVariableMods( d3(1), 3, iMetamagic );

		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oTarget);
		 
		SpawnBloodHit(  oTarget, TRUE, OBJECT_INVALID );
		iRoundsLeft -= 1;
		DelayCommand( 6.0f, BloodHit( oTarget, iRoundsLeft, iMetamagic) );
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTALLCREATORS, OBJECT_INVALID, oTarget, SPELL_HEMORRHAGE );
	}
	DelayCommand( 6.0f, SpawnBloodHit(  oTarget, FALSE, OBJECT_INVALID ) );
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HEMORRHAGE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_IMP_DUST_EXPLOSION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 3;
    int     iNumDice        = 1;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iNumRounds      = iCasterLevel/2;

    if(iNumRounds<1) iNumRounds=1;
    if(iNumRounds>5) iNumRounds=5;
    float fDuration = HkApplyDurationCategory(iNumRounds);
    fDuration = HkApplyMetamagicDurationMods( fDuration );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

    //iDamage = HkApplyMetamagicVariableMods( d3(iNumDice), 3 * iNumDice );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    //string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
    effect eDurVis  = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_HEMORRHAGE));
    int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
        if(!HkResistSpell(oCaster, oTarget) && CSLGetIsBloodBased(oTarget))
        {
            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
            {
				BloodHit( oTarget, iNumRounds, HkGetMetaMagicFeat() );
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurVis, oTarget, fDuration);
            }
        }
    }
    HkPostCast(oCaster);
}