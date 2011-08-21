//::///////////////////////////////////////////////
//:: Wall of Fire: Heartbeat
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Person within the AoE take 4d6 fire damage
	per round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_wallfire(); //SPELL_WALL_OF_FIRE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_WALL_OF_FIRE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_ELEMENTAL;
	if ( GetSpellId() == SPELL_SHADES_WALL_OF_FIRE )
	{
		// iSpellId=SPELL_SHADES_WALL_OF_FIRE;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 20); // AOE's ignore caps since the cap is set when it's cast
	int iSpellSaveDC = HkGetSpellSaveDC();
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iDescriptor = HkGetDescriptor(); // This is stored in the AOE tag of the AOE, and after that it's stored in a var on the AOE
	int iSaveType = SAVING_THROW_TYPE_FIRE;
	int iHitEffect = VFX_HIT_SPELL_FIRE;
	int iDamageType = CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_FIRE, iDescriptor );
	if ( iDamageType != DAMAGE_TYPE_FIRE )
	{
		iHitEffect = CSLGetHitEffectByDamageType( iDamageType );
		iSaveType = CSLGetSaveTypeByDamageType( iDamageType );
	}
	/////////////////////////////////////////////////////////////////////////////////
	
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			if (!HkResistSpell(oCaster, oTarget))
			{
				int iDamage = HkApplyMetamagicVariableMods(d6(2), 12) + iSpellPower;
				if ( CSLGetIsUndead( oTarget, TRUE ) )
				{
					iDamage *= 2;
				}
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORFULLDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
				if (iDamage > 0)
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, iDamageType), oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iHitEffect), oTarget);
				}
			}
		}
		
		if ( iDamageType == DAMAGE_TYPE_FIRE && CSLGetIsBlockedByFire(oTarget)  ) // force a creature who got in, to get out
		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
			AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));		
		}
		
		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	}
	
	
	
	
}