//::///////////////////////////////////////////////
//:: Negative Energy Ray
//:: SOZ UPDATE BTM
//:: NW_S0_NegRay
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a bolt of negative energy at the target
    doing 1d6 damage.  Does an additional 1d6
    damage for 2 levels after level 1 (3,5,7,9) to
    a maximum of 5d6 at level 9.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 13, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_NEGATIVE_ENERGY_RAY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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

	object oTarget = HkGetSpellTarget();
    
    int iSpellPower = HkGetSpellPower( oCaster, 9 );
    
    

    iSpellPower = CSLGetMax( 1, ( iSpellPower + 1 ) / 2 );
    
    int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower);
    
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_EVIL, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_IMP_NEGATIVE_ENERGY );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	

    effect eVis = EffectVisualEffect(iHitEffect);
    effect eDam = HkEffectDamage(iDamage, iDamageType);
    effect eHeal = EffectHeal(iDamage);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eRay;
    if( !CSLGetIsUndead(oTarget) )
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
            eRay = EffectBeam(iShapeEffect, OBJECT_SELF, BODY_NODE_HAND);
            if (!HkResistSpell(OBJECT_SELF, oTarget))
            {
                //Make a saving throw check
                //if( HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), iSaveType))
                //{
                //    iDamage /= 2;
                //}
                iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(oCaster, oTarget), iSaveType, oCaster);
				
                //Apply the VFX impact and effects
                //DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                if ( iDamage > 0)
                {
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
        eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
    
    HkPostCast(oCaster);
}

