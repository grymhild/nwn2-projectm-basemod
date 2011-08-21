//::///////////////////////////////////////////////
//:: Storm of Vengeance: Heartbeat
//:: NW_S0_StormVenC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates an AOE that decimates the enemies of
	the cleric over a 30ft radius around the caster
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_STORM_OF_VENGEANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL|SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	// Adjust acid damage if needed
	int iDescriptor = HkGetDescriptor(); // This is stored in the AOE tag of the AOE, and after that it's stored in a var on the AOE
	int iSaveType = SAVING_THROW_TYPE_ACID;
	int iHitEffect = VFX_HIT_SPELL_ACID;
	int iDamageType = CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_ACID, iDescriptor );
	if ( iDamageType != DAMAGE_TYPE_ACID )
	{
		iHitEffect = CSLGetHitEffectByDamageType( iDamageType );
		iSaveType = CSLGetSaveTypeByDamageType( iDamageType );
	}
	
	// Only can adjust one damage type, will do electrical always in addition
	int iSaveTypeAlt = SAVING_THROW_TYPE_ELECTRICITY;
	int iHitEffectAlt = VFX_HIT_SPELL_LIGHTNING;
	int iDamageTypeAlt = DAMAGE_TYPE_ELECTRICAL; //CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_ELECTRICAL, iDescriptor );
	//if ( iDamageTypeAlt != DAMAGE_TYPE_ELECTRICAL )
	//{
	//	iHitEffectAlt = CSLGetHitEffectByDamageType( iDamageTypeAlt );
	//	iSaveTypeAlt = CSLGetSaveTypeByDamageType( iDamageTypeAlt );
	//}
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	effect eAcid;
	effect eElec;
	effect eVisAcid = EffectVisualEffect(iHitEffect);
	effect eVisElec = EffectVisualEffect(iHitEffectAlt);
	
	effect eStun = EffectVisualEffect(VFX_DUR_STUN);
	eStun = EffectLinkEffects(eStun, EffectStunned());
	
	float fDelay;
	//Get first target in spell area
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STORM_OF_VENGEANCE));
			//if (!HkResistSpell(oCaster, oTarget, fDelay))
			//{
				//FIX: roll damage for each target separately
                eAcid = EffectDamage(d6(3), iDamageType);
                eElec = EffectDamage(d6(6), iDamageTypeAlt);
				
				fDelay = CSLRandomBetweenFloat(0.5, 1.0);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(3), iDamageType), oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
				if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC(), iSaveTypeAlt, oCaster, fDelay)==SAVING_THROW_CHECK_FAILED)
				{
					DelayCommand(fDelay, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId ) ); //FIX: will remove stun, if save is passed
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    if (d2()==1)
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    }
				}
				else
				{
                   //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(2)));				
				}	 
				/*	
				if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC(), iSaveTypeAlt, oCaster, fDelay)==SAVING_THROW_CHECK_FAILED)
				{	
					fDelay += 1.0;
					DelayCommand(fDelay, RemoveEffectsFromSpell(oTarget, SPELL_STORM_OF_VENGEANCE));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d3(6), iDamageTypeAlt), oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)));
				}
				*/
			//}
		}
		//Get next target in spell area
		oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
	}
}