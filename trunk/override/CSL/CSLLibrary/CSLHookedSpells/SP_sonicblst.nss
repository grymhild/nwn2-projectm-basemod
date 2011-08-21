//::///////////////////////////////////////////////
//:: Sonic Blast
//:: sg_s0_sonicblst.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation [Sonic]
     Level: Sor/Wiz 3
     Components: V, S, M
     Casting Time: 1 action
     Range: Close (25 ft. + 5 ft./2 levels)
     Area: 5 ft. wide to close range (25 ft.+5 ft./2 levels)
     Duration: Instantaneous
     Saving Throw: Reflex half
     Spell Resistance: Yes

     You generate a deadly beam of sonic energy from
     your outstretched hand that deals 1d6 points of
     damage per caster level (maximum 10d6) to each
     creature within its area.

     The sonic blast may shove creatures in the area
     back along the path of the spell. Any creature
     failing its saving throw must make a Strength
     check (DC equal to damage inflicted by the spell);
     those who fail find themselves bull rushed directly
     away from the caster as if by a Large creature with
     a Strength score equal to the damage the spell
     inflicted. The spell moves with the target; see the
     bull rush description in Chapter Eight of the
     Player's Handbook for details on attacks of
     opportunity, stability modifiers, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: February 19, 2004
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
//
//
// 
// void main()
// {
//
//     
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
//
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDC;
	

	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iReflexDamage;
    int     iBullRushDC     = d20()+4; // d20 + 4 mod for Large size
    int     iBullRushSTRMod;    // str mod will be (iDamage-10)/2;
    int     iMissedSave;
    float   fRange = FeetToMeters(25.0 + 5.0*iCasterLevel/2);
    location lMoveToTarget;
    object  oTarget2, oNextTarget;
    
    int     iCnt = 1;
    float   fDelay;


	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iShapeEffect = HkGetShapeEffect( VFXSC_DUR_SPELLCONELONG_SONIC, SC_SHAPE_SPELLCONE ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iBeamEffect = HkGetShapeEffect( VFX_BEAM_SONIC, SC_SHAPE_BEAM );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eBeam        = EffectBeam(iBeamEffect, oCaster, BODY_NODE_HAND);
    effect eDamage;
    effect eVis         = EffectVisualEffect(VFX_IMP_KNOCK);
    effect eVis1        = EffectVisualEffect(iHitEffect);
    effect eLink        = EffectLinkEffects(eVis,eVis1);
    effect eKnockdown   = EffectKnockdown();
	float fMaxDelay = 0.0f;
     //if(CSLEnviroGetIsUnderWater(oCaster) && iDamageType==iDamageType) fRange*=2.0;  	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lImpactLoc);

    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, iCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= fRange)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oCaster));
        while (GetIsObjectValid(oTarget))
        {
               if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster)
               {
                    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SONIC_BLAST));
                    if (!HkResistSpell(oCaster, oTarget))
                    {
                        iDC = HkGetSpellSaveDC(oCaster, oTarget);
                        iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
                        iReflexDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
                        //Determine if target missed saving throw when determining damage above
                        if(iDamage==iReflexDamage || ((iDamage/2==iReflexDamage) && GetHasFeat(FEAT_IMPROVED_EVASION,oTarget)))
                        {
							// if missed save, takes full damage, unless they have improved evasion.
							// Improved evasion grants half damage on a missed save
							iMissedSave=TRUE;
                        }
                        else
                        {
                        	iMissedSave=FALSE;
                        }
                        iDamage=iReflexDamage;
                        iBullRushSTRMod=(iDamage-10)/2;  // get the equivalent STR mod for check
                        iBullRushDC+=iBullRushSTRMod;    // add to Bull Rush DC
                        eDamage==HkEffectDamage(iDamage,iDamageType);
                        eLink=EffectLinkEffects(eDamage,eLink);
                        
                        fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
						fMaxDelay = CSLGetMaxf(fDelay, fMaxDelay);
			
                        if(iDamage>0)
                        {
                            DelayCommand(1.3f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                            if(iMissedSave)
                            {
                                int iTargetSTRCheck=GetAbilityModifier(ABILITY_STRENGTH,oTarget)+d20();
                                switch(GetCreatureSize(oTarget))
                                {
                                    case CREATURE_SIZE_HUGE:
                                        iTargetSTRCheck+=8;
                                        break;
                                    case CREATURE_SIZE_LARGE:
                                        iTargetSTRCheck+=4;
                                        break;
                                    case CREATURE_SIZE_SMALL:
                                        iTargetSTRCheck-=4;
                                        break;
                                    case CREATURE_SIZE_TINY:
                                        iTargetSTRCheck-=8;
                                        break;
                                }
                                if(iTargetSTRCheck<iBullRushDC)
                                {
                                    int iDist=5+iBullRushDC-iTargetSTRCheck;  // 5ft+1 for each point lost check by
                                    float fDistToMove=IntToFloat(iDist);
                                    float fDistBetween=GetDistanceBetween(oTarget,oCaster);
                                    float fRange=IntToFloat(25+5*iCasterLevel);
                                    if(fDistBetween<fRange) //can only push to maximum range of spell
                                    {
                                        if(fDistBetween+fDistToMove>fRange)
                                        {
                                            fDistToMove=fRange-fDistBetween;
                                        }
                                        float fFacing=GetFacing(oTarget);
                                        if(fDistToMove>=SC_DISTANCE_HUGE)
                                        {
                                            fDistToMove=SC_DISTANCE_HUGE;
                                        }
                                        else if(fDistToMove>=SC_DISTANCE_LARGE)
                                        {
                                            fDistToMove=SC_DISTANCE_LARGE;
                                        }
                                        else if(fDistToMove>=SC_DISTANCE_MEDIUM)
                                        {
                                            fDistToMove=SC_DISTANCE_MEDIUM;
                                        }
                                        else if(fDistToMove>=SC_DISTANCE_SHORT)
                                        {
                                            fDistToMove=SC_DISTANCE_SHORT;
                                        }
                                        else
                                        {
                                            fDistToMove=SC_DISTANCE_TINY;
                                        }
                                        lMoveToTarget=CSLGenerateNewLocationFromLocation(GetLocation(oTarget),fDistToMove,CSLGetOppositeDirection(fFacing),fFacing);
                                        AssignCommand(oTarget,ClearAllActions());
                                        DelayCommand(1.0f,AssignCommand(oTarget,JumpToLocation(lMoveToTarget)));
                                        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 4.0f);
                                        if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
										{
											CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  4.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
										}
                                    }
                                }
                            }
                        }
                    }
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
                    oNextTarget = oTarget;
                    eBeam = EffectBeam(iBeamEffect, oNextTarget, BODY_NODE_CHEST);
           }
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        iCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, iCnt);
    }
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( iShapeEffect ), oCaster, fMaxDelay+0.5);
	
    HkPostCast(oCaster);
}