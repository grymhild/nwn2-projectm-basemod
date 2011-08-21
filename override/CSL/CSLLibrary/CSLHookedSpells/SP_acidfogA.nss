//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures within the AoE take 2d6 acid damage
	per round and upon entering if they fail a Fort Save
	their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_ACID_FOG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int nIgnoreSR = FALSE;
	//if ( iSpellId == 745 )
    //{
    //    nIgnoreSR = TRUE;
    //}
    //else
    //{
    //	iSpellId == SPELL_ACID_FOG;
    //}
	//Declare major variables
	int iDamage;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	int iDescriptor = HkGetDescriptor(); // This is stored in the AOE tag of the AOE, and after that it's stored in a var on the AOE
	int iSaveType = SAVING_THROW_TYPE_ACID;
	int iHitEffect = VFX_HIT_SPELL_ACID;
	int iDamageType = CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_ACID, iDescriptor );
	if ( iDamageType != DAMAGE_TYPE_ACID )
	{
		iHitEffect = CSLGetHitEffectByDamageType( iDamageType );
		iSaveType = CSLGetSaveTypeByDamageType( iDamageType );
	}
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDam;
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eSlow = EffectMovementSpeedDecrease(50);
	object oTarget = GetEnteringObject();
	float fDelay = CSLRandomBetweenFloat(1.0, 2.2);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		if (!CSLGetIsImmuneToClouds(oTarget) )
		{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), iSpellId ));
			//Spell resistance check
			//if( nIgnoreSR || !HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
			//{
				//Roll Damage
				//Enter Metamagic conditions
				
				iDamage = HkApplyMetamagicVariableMods(d6(4), 24 );
				effect eDam = EffectDamage(iDamage, iDamageType);
				eDam = EffectLinkEffects(eDam, EffectVisualEffect(iHitEffect));
			
				//Make a Fortitude Save to avoid the effects of the movement hit.
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), iSaveType, GetAreaOfEffectCreator(), fDelay))
				{
					//slowing effect
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
					// * BK: Removed this because it reduced damage, didn't make sense iDamage = d6();
				}

				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			//}
		}
	}
}