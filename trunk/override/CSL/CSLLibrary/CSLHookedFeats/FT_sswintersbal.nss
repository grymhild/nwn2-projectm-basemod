//::///////////////////////////////////////////////
//:: Stormsingers Winters Ballad
//:: cmi_s2_wntrblld
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 16, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//Based on Call Lightning Storm by OEI

#include "_HkSpell"
//#include "nw_i0_spells" 
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_sswintersbal();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = STORMSINGER_WINTER_BALLAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
    int iCasterLevel = GetStormSongCasterLevel(oCaster);

	if (iCasterLevel < 15) //Short circuit
	{
		SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 15 or more to use this ability.");
		return;
	}
	if (!GetHasFeat(257))
	{
		SpeakString("No uses of the Bard Song ability are available");
		return;
	}
	else
	{
		DecrementRemainingFeatUses(OBJECT_SELF, 257);		
	}	
			
    int iDamage;
    float fDelay;
    
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iImpactEffect = HkGetShapeEffect( VFXSC_HIT_CALLLIGHTNING, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	effect eVis2 = EffectVisualEffect(916); //VFX_SPELL_HIT_CALL_LIGHTNING
	effect eDur = EffectVisualEffect(915); //VFX_SPELL_DUR_CALL_LIGHTNING
	effect eLink = EffectLinkEffects(eVis, eVis2);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (iCasterLevel > 15)
    {
        iCasterLevel = 15;
    }
    
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, 1.75);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
           //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = CSLRandomBetweenFloat(1.4, 2.25);	// AFW-OEI 07/10/2007: Increase delay to synch better with AoE VFX.
            if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                iDamage = d6(iCasterLevel);
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, (GetSpellSaveDC()+4), iSaveType);
                //Set the damage effect
                eDam = HkEffectDamage(iDamage, iDamageType);
                if(iDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    
    HkPostCast(oCaster);
}

