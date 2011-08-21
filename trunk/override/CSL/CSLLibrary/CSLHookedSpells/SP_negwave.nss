//::///////////////////////////////////////////////
//:: Negative Energy Wave
//:: sg_s0_negwave.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Sor/Wiz 4
     Components: V,S
     Casting Time: 1 action
     Range: 50 ft
     Effect: 50-ft radius burst, centered on you
     Duration: Instantaneous (see text)
     Saving Throw: Will negates (see text)
     Spell Resistance: Yes

     You release a silent burst of negative energy
     from your body.
     You can affect up to 1d6 HD worth of undead
     creatures per level (maximum 15d6).  Those closest
     to you are affected first.  The spell can have one
     of two effects, which you select when you cast it.
     Rebuked: The undead creatures cower as if in awe. (Treat
     them as stunned.) The effect lasts 10 rounds.
     Bolstered: Undead creatures gain turn resistance of 1d4 plus
     your Charisma modifier (minimum +1). The effect lasts 10
     rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 30, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
// 
//
//     object  oTarget;         //= HkGetSpellTarget();
//     location lTarget        = GetLocation(oCaster);
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(10) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int     iDC; 
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = iCasterLevel;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iHDAffected;
    int     iTurnResist;
    int     iCHAMod         = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    float   fRadius         = FeetToMeters(50.0);
    float   fDistBetween;
    int     iCount          = 1;

    if(iCHAMod<1) iCHAMod=1;
    if(iSpellId==SPELL_NEG_ENERGY_WAVE) iSpellId=SPELL_NEG_ENERGY_WAVE_REBUKE;
    if(iNumDice>15) iNumDice=15;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	iHDAffected = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );
	iDamage = HkApplyMetamagicVariableMods( d4(), 4 )+iCHAMod;
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImp         = EffectVisualEffect(VFX_FNF_HOWL_ODD);
    effect eStunVis     = EffectVisualEffect(VFX_IMP_STUN); // 97
    effect eStunDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eStun        = SupernaturalEffect(EffectStunned());
    effect eStunLink    = EffectLinkEffects(eStun, eStunDur);
    effect eTurnVis     = EffectVisualEffect(VFX_IMP_EVIL_HELP); // 144
    effect eTurn        = EffectTurnResistanceIncrease(iTurnResist);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oCaster);
    object oTarget=GetNearestCreature(CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT,iSpellId,oCaster,iCount);
    fDistBetween=GetDistanceBetween(oCaster,oTarget);
    while( GetIsObjectValid(oTarget) && fDistBetween<=fRadius && iHDAffected>0)
    {
        if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && CSLGetIsUndead(oTarget))
        {
            if ( iSpellId == SPELL_NEG_ENERGY_WAVE_BOLSTER )
            {
            	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_NEG_ENERGY_WAVE_BOLSTER, FALSE));
				if(GetHitDice(oTarget)<=iHDAffected)
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eTurnVis,oTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eTurn,oTarget,fDuration);
					iHDAffected -= GetHitDice(oTarget);
				}
            }
            else
            {
				SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_NEG_ENERGY_WAVE_REBUKE));
				if(GetHitDice(oTarget)<=iHDAffected)
				{
					if(!HkResistSpell(oCaster, oTarget, fDistBetween/20.0))
					{
						if(!HkSavingThrow(SAVING_THROW_WILL,oTarget,iDC, SAVING_THROW_TYPE_NEGATIVE))
						{
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eStunVis, oTarget);
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunLink, oTarget, fDuration);
						}
					}
					iHDAffected-=GetHitDice(oTarget);
				}
            }
        }
        iCount++;
        oTarget=GetNearestCreature(CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT,iSpellId,oCaster,iCount);
        fDistBetween=GetDistanceBetween(oCaster,oTarget);
    }

    HkPostCast(oCaster);
}


