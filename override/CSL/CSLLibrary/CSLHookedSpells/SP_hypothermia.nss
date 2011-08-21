//::///////////////////////////////////////////////
//:: Hypothermia
//:: nx_s0_hypothermia.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
		
	Hypothermia
	Evocation [Cold]
	Level: Cleric 4, druid 3
	Components: V, S
	Range: Close
	Target: One creature
	Saving Throw: Fortitude partial
	Spell Resistance: Yes
	
	The subject takes 1d6 points of cold damage per
	caster level (maximum 10d6) and becomes fatigued.
	A successful Fortitude save halves the damage and
	negates the fatigue.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.06.2006
//:://////////////////////////////////////////////
// MDiekmann 5/21/07 - Modified code to use fatigue effect
// AFW-OEI 07/06/2007: Fatigue must be applied as a permanent effect.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HYPOTHERMIA;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//Major variables
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); // OldGetCasterLevel(oCaster);
	int iDamage;
	effect eFatigue = CSLEffectFatigue();
	effect eDam;
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	//effect eLink;
	
	
	//Cap caster level for purposes of limiting damage
	//if (iSpellPower > 10)
	//{
	// iSpellPower = 10;
	//}

	//int iDamageType = DAMAGE_TYPE_COLD;
	//int iSaveType = SAVING_THROW_TYPE_COLD;	
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
	//{
	//	iDamageType = DAMAGE_TYPE_MAGICAL;
	//	iSaveType = SAVING_THROW_TYPE_ALL;
	//}
	
	//Determine damage


	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iImpactEffect = HkGetShapeEffect( VFXSC_HIT_HYPOTHERMIA, SC_SHAPE_AOE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	int iSave, iAdjustedDamage, iDC;
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	
	iDamage = d6(iSpellPower);
	iDamage = HkApplyMetamagicVariableMods(iDamage, 60);
	eDam = HkEffectDamage(iDamage, iDamageType);
			
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (GetIsObjectValid(oTarget))
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Target is valid, cast spell and then run spell resistance and saving throw before applying effect
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1031, TRUE));
			
			if (!HkResistSpell(oCaster, oTarget))
			{
				
				
				iDC = HkGetSpellSaveDC();
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType, OBJECT_SELF);
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iDC, iSaveType, oCaster, iSave );
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, iSaveType, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, iDamageType), oTarget);
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
					{
						HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eFatigue, oTarget);
					}
				
				}
			}
		}
	}
	HkPostCast(oCaster);
}