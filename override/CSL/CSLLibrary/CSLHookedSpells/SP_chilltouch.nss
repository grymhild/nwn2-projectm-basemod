//::///////////////////////////////////////////////
//:: Chill Touch
//:: SG_S0_ChlTch.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Chill touch causes a blue glow to surround
     caster's hand.  Upon successful melee attack,
     target takes d6 dmg and must make fort save to
     avoid 1 pt Str loss.  Undead do not take any
     damage, but instead flee in fear from caster
     for d4+caster level rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkApplyMetamagicVariableMods( d4(1), 4 * 1 )+iDuration ) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	
	int     iDieType        = 6;
	int     iNumDice        = 1;
	int     iBonus          = 0;
	int     iDamage         = 0;
	float   fDelay;
	int iSave, iAdjustedDamage;
	
	

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_IMP_FROST_S );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eStr         = EffectAbilityDecrease(ABILITY_STRENGTH,1);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	fDelay = CSLRandomBetweenFloat(0.4, 1.1);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHILL_TOUCH));
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if(!HkResistSpell(oCaster, oTarget))
		{
			if(!CSLGetIsUndead(oTarget))
			{
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType, OBJECT_SELF, fDelay);
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, iSaveType, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					iDamage = HkApplyMetamagicVariableMods( d6(1), 6 )+iBonus;
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORFULLDAMAGE, iDamage, oTarget, iDC, iSaveType, oCaster, iSave );
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectVisualEffect(iHitEffect),HkEffectDamage(iDamage,iDamageType)), oTarget));
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
					{
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eDur,eStr), oTarget, HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS)));
					}
				}
            }
            else
            {
                if(!HkSavingThrow(SAVING_THROW_WILL,oTarget,iDC,SAVING_THROW_TYPE_SPELL))
                {
                   DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR), oTarget));
                   DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTurned(), oTarget, fDuration));
                }
            }
        }
    }

    HkPostCast(oCaster);
}


