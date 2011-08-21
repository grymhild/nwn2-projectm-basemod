//::///////////////////////////////////////////////
//:: Bloodstorm
//:: sg_s0_bldstm.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//::///////////s///////////////////////////////////
/*
     Evocation [Fear]
     Level: Sor/Wiz 3
     Components: V,S,M
     Casting Time: 1 Full Round
     Range: Medium (100 ft + 10 ft/level
     Area: Column 25 ft wide and 40 ft high
     Duration: 1 round/level
     Saving Throw: See Text
     Spell Resistance: Yes

     Bloodstorm summons a whirlwind of blood that
     envelops the entire area of effect and has
     several effects on those caught within it.
     First, those in the area of effect must make
     Reflex saving throws or be blinded by the
     swirling blood while they remain in the
     whirlwind and for 2d6 rounds thereafter.
     Second, all combatants withing the bloodstorm
     fight at -4 to their attack rolls, and ranged
     attacks that pass through the whirlwind also
     suffer this attack penalty (can't do).  Third,
     the blood is slightly acidic and causes 1d4
     points of damage per round.  Finally, victims
     must make a Will save or become frightened if
     8HD or above and panicked if less than 8HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 15, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//
//     int     iDC;            //= HkGetSpellSaveDC(oCaster, oTarget);
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
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = 1;
    int     iBonus          = 0;
    int     iDamage         = 0;
	int iDC;
    float   fRadius         = FeetToMeters(25.0f/2);
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVisImp = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
    effect eVisDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
    effect eVisImp2 = EffectVisualEffect(VFX_FNF_PWSTUN);
    effect eVisFright = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);

    effect eAOE = EffectAreaOfEffect(AOE_PER_BLOODSTORM, "", "", "", sAOETag);

    effect eBlind = EffectBlindness();
    effect eAttPenalty = EffectAttackDecrease(4);
    effect eRangePenalty = EffectConcealment(75, MISS_CHANCE_TYPE_VS_RANGED);
    eAttPenalty = EffectLinkEffects(eAttPenalty, eRangePenalty);
    effect eBloodDmg;  // damage effect for the acidic blood.  must define after amount is known
    effect eFrightened = EffectFrightened();
    effect eLink = EffectLinkEffects(eFrightened, eVisFright);

    //--------------------------------------------------------------------------
    //Apply effects
    //--------------------------------------------------------------------------
    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisImp, lTarget);
    DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration));
    DelayCommand(1.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVisDur, lTarget, fDuration));
    DelayCommand(1.2f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisImp2, lTarget));
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    if ( GetIsObjectValid(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ) )
	{
        SignalEvent(oTarget, EventSpellCastAt(oCaster,SPELL_BLOODSTORM));
        HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttPenalty, oTarget);
        if(!HkResistSpell(oCaster, oTarget))
        {
            iDC = HkGetSpellSaveDC(oCaster, oTarget);
            if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC) && !GetLocalInt(oTarget, "BSTM_IS_BLIND"))
            {
                HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);
                SetLocalInt(oTarget,"BSTM_IS_BLIND",TRUE);
            }

			iDamage = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice ) + iBonus;
			eBloodDmg = HkEffectDamage(iDamage);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBloodDmg, oTarget);

            if(WillSave(oTarget,iDC,SAVING_THROW_TYPE_FEAR)==0)
            {
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFrightened, oTarget, fDuration);
                SetLocalInt(oTarget,"BSTM_IS_FRIGHT",TRUE);
                if(GetHitDice(oTarget)<=8)
                {
                    AssignCommand(oTarget, ClearAllActions(TRUE));
                    AssignCommand(oTarget, ActionMoveAwayFromLocation(lTarget, TRUE, FeetToMeters(400.0f)));
                    SetLocalInt(oTarget,"BSTM_IS_PANIC",TRUE);
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }

    HkPostCast(oCaster);
}


