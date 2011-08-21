//::///////////////////////////////////////////////
//:: Lion's Roar
//:: cmi_s0_lionroar
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


float RADIUS_SIZE_LIONROAR =  36.57f; // 120'

#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Lions_Roar;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	int iSpellPower = HkGetSpellPower(oCaster, 20);
	int nHPBonus = iSpellPower;
	float fDuration = TurnsToSeconds(iSpellPower);
	iSpellPower = iSpellPower/2;
    int nDmgDice;
    int iDamage, nDamage2;
    float fDelay;
    
	//SONIC
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_SONIC, SC_SHAPE_AOE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LIONROAR);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eVisHit = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
    effect eDam;
	effect eStun = EffectStunned();	
	effect eTempHP;
	effect eAB = EffectAttackIncrease(1);
	effect eFearSave = EffectSavingThrowIncrease(SAVING_THROW_TYPE_FEAR,1);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eAB,eFearSave);
	eLink = EffectLinkEffects(eLink,eVis);
		
    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
    //Apply the ice storm VFX at the location captured above.
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster) //Additional target check to make sure that the caster cannot be harmed by this spell
        {
            fDelay = CSLRandomBetweenFloat(0.15, 0.35);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
            if (!HkResistSpell(oCaster, oTarget, fDelay))
            {
				int iSave, iAdjustedDamage, iDC;
				 
				
				iDC = HkGetSpellSaveDC();
				iSave = HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_ALL, OBJECT_SELF);
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_REFLEX, SAVING_THROW_ADJUSTED_PARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					// do full or half damage based on the save
					iDamage = HkApplyMetamagicVariableMods(d8(nDmgDice), nDmgDice * 8);
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_ADJUSTED_PARTIALDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_SONIC, oCaster, iSave );
					if ( iDamage > 0 )
					{
						eDam = HkEffectDamage(iDamage, iDamageType);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHit, oTarget));
						
						if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE ) // only stun if they really failed their save and took damage
						{
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)));
						}
					}
				}				
            }
        }
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) && oTarget != oCaster)	
		{
			//Apply Buff
			eTempHP = EffectTemporaryHitpoints(d8()+nHPBonus);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,fDuration));	
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oTarget, fDuration));	
			
		}
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    
    HkPostCast(oCaster);
}

