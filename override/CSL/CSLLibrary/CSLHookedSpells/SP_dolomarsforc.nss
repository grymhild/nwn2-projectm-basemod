//::///////////////////////////////////////////////
//:: Dolomar's Force Wave
//:: sg_s0_dolowave.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     This spell creates a wave of force eminating
     from the caster, pushing creatures away.
     Creatures in the area of effect may make opposed
     STR checks vs spell DC to not be moved.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
// void main()
// {
//     location lTarget        = GetLocation(oCaster);
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
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	location lTarget = GetLocation(oCaster);
    float   fDist           = 10.0+IntToFloat(iCasterLevel);
    float   fDistBetween;
    float   fDelay;
    int     iTargetDC;
    int     iSTRCheck;
    float   fMoveAmount     = 0.0f;
    location lMoveToLoc;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eKnock   = EffectKnockdown();

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_FORCEWAVE), oCaster);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE);
    while(GetIsObjectValid(oTarget)) {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster) {
            SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_DOLOMAR_WAVE));
            if(!HkResistSpell(oCaster, oTarget)) {
                fDistBetween=GetDistanceBetween(oTarget,oCaster);
                fDelay=fDistBetween/20;
                iTargetDC=12+iCasterLevel/2;
                iSTRCheck=d20()+GetAbilityModifier(ABILITY_STRENGTH,oTarget);
                if(iSTRCheck<iTargetDC)
                {
                    fMoveAmount=IntToFloat(5+iTargetDC-iSTRCheck);
                    if(fDistBetween+fMoveAmount>fDist) {
                        fMoveAmount=fDist-fMoveAmount;
                    }
                    AssignCommand(oTarget,ClearAllActions());
                    lMoveToLoc = CSLGenerateNewLocationFromLocation(GetLocation(oTarget), fMoveAmount, 
                        CSLGetNormalizedDirection(CSLGetAngleBetweenLocations(lTarget, GetLocation(oTarget))),
                        GetFacing(oTarget));
                    AssignCommand(oTarget, JumpToLocation(lMoveToLoc));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 3.0f));
                    if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  3.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE);
    }

    HkPostCast(oCaster);
}


