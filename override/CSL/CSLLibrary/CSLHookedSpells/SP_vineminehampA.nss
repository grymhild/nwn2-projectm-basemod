//::///////////////////////////////////////////////
//:: Vine Mine, Hamper Movement: On Enter
//:: X2_S0_VineMHmpA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of Vine Mine, Hamper
    Movement have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_VINE_MINE_HAMPER_MOVEMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
    effect eSlow = EffectVisualEffect(VFX_IMP_SLOW);
    eSlow = EffectLinkEffects(eSlow, EffectMovementSpeedDecrease(50));
    
    object oTarget = GetEnteringObject();
    //float fDelay = CSLRandomBetweenFloat(1.0, 2.2);
    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        // if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        if( !CSLGetIsIncorporeal( oTarget ) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells
        {
                //Fire cast spell at event for the target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId()));
                //Apply reduced movement effect and VFX_Impact
                HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
        }
    }
}