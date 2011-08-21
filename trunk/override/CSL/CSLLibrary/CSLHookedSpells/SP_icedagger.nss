//::///////////////////////////////////////////////
//:: Ice Dagger
//:: SOZ UPDATE BTM
//:: X2_S0_IceDagg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a dagger shapped piece of ice that
// flies toward the target and deals 1d4 points of
// cold damage per level (maximum od 5d4)
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25 , 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_ICE_DAGGER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;

	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	
	
    object oTarget = HkGetSpellTarget();
    
    int iSpellPower = HkGetSpellPower( oCaster, 5 );
    
    
    int iDamage;
    float fDelay;
    
    
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    
    if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
   	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
        //Get the distance between the explosion and the target to calculate delay
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
        if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
   	    {
           //Roll damage for each target
            iDamage = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
            
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
            //Set the damage effect
            eDam = HkEffectDamage(iDamage, iDamageType);
            if(iDamage > 0)
            {
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
    }
    
    HkPostCast(oCaster);
}