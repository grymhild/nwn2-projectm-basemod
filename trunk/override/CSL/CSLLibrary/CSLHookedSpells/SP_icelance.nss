//::///////////////////////////////////////////////
//:: IceLance
//:: SOZ UPDATE BTM
//:: Created by Reeron on 4-1-08
//:://////////////////////////////////////////////
/*
    You must succeed on a ranged touch attack. If 
    you hit, the icelance deals 6d6 points of damage 
    to the target. Half of this damage is piercing 
    damage; the rest is cold damage. In addition, the 
    target must make a Fortitude save or be stunned 
    for 1d4 rounds.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: 
//:: Reeron modifed on 4-1-08
//:: 
//:: Respects immunity to critical hits.
//:: Added sneak attack damage.
//:: Added check for point blank shot feat.
//:: Now does extra damage if you have the (custom) feat 
//:: Ranged Spell Specialization.
//::
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ICELANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
    effect eStun = EffectStunned();
    effect eDur = EffectVisualEffect( VFX_DUR_STUN );
    eStun = EffectLinkEffects( eStun, eDur );

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int iDuration = d4(1);
   	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int iSave, iAdjustedDamage, iDC;

    
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

    effect eVis = EffectVisualEffect(iHitEffect);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
		//int nmodifyattack;
		//int nSpecDamage =0;
		
		// /* need to create a pointblank function() *//
		//nmodifyattack=POINTBLANK(oTarget);
		
		float fDist = GetDistanceToObject(oTarget);
		float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);
		//int touch=TouchAttackRanged(oTarget,TRUE,nmodifyattack);
		
		
		int iTouch = CSLTouchAttackRanged(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				
				
				iDC = HkGetSpellSaveDC();
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_ALL, OBJECT_SELF);
				
				
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_ADJUSTED_PARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					// first a visual
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					
					// then we do full damage of two types, irresepective of save
					int iDamage = HkApplyMetamagicVariableMods( d6(6) , 36 );
					iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORFULLDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
				
					// split the damage into two types...
					int nDamage2 = iDamage/2;
					int nDamage3 = iDamage-nDamage2;
					effect eDam1 = HkEffectDamage(nDamage2, DAMAGE_TYPE_PIERCING);
					effect eDam2 = HkEffectDamage(nDamage3, iDamageType);
					
					
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
					
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
					{
						float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
						int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
						DelayCommand(fDelay, HkApplyEffectToObject(iDurType, EffectStunned(), oTarget, fDuration ) );
					}
				}
			}
		}
	}
	HkPostCast(oCaster);
}