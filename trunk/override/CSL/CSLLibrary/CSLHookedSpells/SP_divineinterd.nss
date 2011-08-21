//::///////////////////////////////////////////////
//:: Divine Interdiction
//:: sg_s0_divinter.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Abjuration
Level: Clr 4
Components: V, S, DF
Casting Time: 1 action
Range: Close (25ft. +5ft./2 levels)
Area: 10-ft.-radius emanation, centered on a creature, object, or point in space
Duration: 1 round/level
Saving Throw: Will negates or none (object)
Spell Resistance: Yes


Divine interdiction interferes with a cleric's connection to his or her divine source of power, resulting in a temporary loss of the ability to turn or rebuke undead (or other creatures). Paladins, blackguards, and other classes capable of rebuking, turning, or otherwise commanding other creatures can also suffer a temporary loss of this ability through divine interdiction.

The spell can be cast on a point in space, but the effect is stationary unless cast on a mobile object. The spell can be centered on a creature, and the effect then radiates from the creature and moves as it moves. An unwilling creature can attempt a Will save to negate the spell and can use SR, if any. Should the save fail, the target’s turning abilities are immediately negated for the spell’s duration.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 12, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     SGSetSpellInfo( );
// 
//
//
//
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
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
    object  oAOE;
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eAOE = EffectAreaOfEffect(AOE_CUSTOM_10FT_RAD,"sg_s0_divinterA","****","sg_s0_divinterB", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(GetIsObjectValid(oTarget))
    {
        if(!CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_ALLALLIES, oCaster) && GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
        {
            if(!HkResistSpell(oCaster,oTarget))
            {
                if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
                {
                    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DIVINE_INTERDICTION));
                }
            }
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DIVINE_INTERDICTION, FALSE));
        }
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    }
    else
    {
        HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
        HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
    }
    

    HkPostCast(oCaster);
}

