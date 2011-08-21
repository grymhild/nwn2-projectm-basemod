//::///////////////////////////////////////////////
//:: Blast of Flame
//:: SOZ UPDATE BTM
//:: X2_S2_Blastofflame
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Created by Reeron on 3-18-08
//
// Flames fill the area, dealing 1d6 points of fire damage 
// per caster level (maximum 10d6) to any creature in the 
// area that fails its saving throw.
//
// Modified by Reeron on 3-31-08
// No longer damages caster by mistake.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
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
	int iSpellId = SPELL_BLAST_OF_FLAME;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    //int iCasterLevel = GetCasterLevel(OBJECT_SELF);
    int iSpellPower = HkGetSpellPower( oCaster, 10 );
    
    int iDamage;
    float fDelay;
    location lTargetLocation = HkGetSpellTargetLocation();
	float fMaxDelay = 0.0f; // Used to determine duration of fire cone
    object oTarget;
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_FIRE, SC_SHAPE_SPELLCONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget!=OBJECT_SELF))
    	{


                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId ));
                //Get the distance between the target and caster to delay the application of effects
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
				if (fDelay > fMaxDelay)
				{
					fMaxDelay = fDelay;
				}
                //Make SR check, and appropriate saving throw(s).

                   
                    iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
        		   
                    iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);

                    // Apply effects to the currently selected target.
                    effect eFire = HkEffectDamage(iDamage, iDamageType);
                    effect eVis = EffectVisualEffect(iHitEffect);
                    if(iDamage > 0)
                    {
                        //Apply delayed effects
                        DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    }


        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect( iShapeEffect );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
	
	HkPostCast(oCaster);
}

