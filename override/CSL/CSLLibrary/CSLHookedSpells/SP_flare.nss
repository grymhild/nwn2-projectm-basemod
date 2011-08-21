//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature hit by ray loses 1 to attack rolls.
	
	DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
/////////////////////////////////////////////////////

#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_flare();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLARE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NONE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect( iHitEffect );

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 416));
		
		// * Apply the hit effect so player knows something happened
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


		//Make SR Check
		if ((!HkResistSpell(OBJECT_SELF, oTarget))  )
		{
			if ( HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()) == FALSE )
			{
				if( CSLGetIsLightSensitiveCreature(oTarget) )
				{
					// Is a little stronger versus light sensitive creatures
					effect eBad = EffectAttackDecrease( 2 );
					eBad = EffectLinkEffects(eBad, EffectBlindness() );
					//Apply the VFX impact and damage effect
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(10));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
				else
				{
					//Set damage effect
					effect eBad = EffectAttackDecrease(1);
					//Apply the VFX impact and damage effect
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(10));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
			else if( CSLGetIsLightSensitiveCreature(oTarget) )
			{
				//Set damage effect
				effect eBad = EffectAttackDecrease(1);
				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(d4()));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
	}
	HkPostCast(oCaster);
}

