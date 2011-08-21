//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures with 3 or less HD die, those with
	4 to 6 HD must make a save Fortitude Save or die.
	Those with more than 6 HD take 1d4 CON damage
	every round. Fortitude saves for half.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 09.18.06: Modified to make closer to the PHB rules

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{
	//scSpellMetaData = SCMeta_SP_cloudkill(); //SPELL_CLOUDKILL;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_CLOUDKILL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_POISON|SCMETA_DESCRIPTOR_GAS, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//Declare major variables
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	int iHD = GetHitDice(oTarget);
	effect eDeath = EffectDeath();
	effect eVis =   EffectVisualEffect(VFX_IMP_DEATH);
	//effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY); // NWN1 VFX
	effect eNeg = EffectVisualEffect( VFX_HIT_SPELL_POISON ); // NWN2 VFX
	//effect eSpeed = EffectMovementSpeedDecrease(50);
	//effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	//effect eVis2 = EffectVisualEffect( VFX_IMP_SLOW ); // NWN2 VFX
	//effect eLink = EffectLinkEffects(eSpeed, eVis2);
	int iDC = HkGetSpellSaveDC();

	float fDelay;
	//effect eConDam;
	int nConDamage;
	
	
    
	if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator()) )
	{
		if( GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) )
		{
			return;
		}
		
		if( CSLGetIsImmuneToClouds(oTarget ) )
		{
			return;
		}
		//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL, TRUE ));
		//Make SR Check
		//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
		//
		//{
			//Determine spell effect based on the targets HD, only do this on entry...
			fDelay= CSLRandomBetweenFloat(0.5, 1.5);
			nConDamage = HkApplyMetamagicVariableMods(d4(), 4);
			if ( iHD <= 3  || ( iHD <= 6 && !HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay) ))
			{
				if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				}
			}
			else if ( iHD > 6 )
			{
				nConDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, nConDamage, oTarget, iDC, SAVING_THROW_TYPE_POISON, oCaster, SAVING_THROW_RESULT_ROLL );
			}

			// going to apply con damage regardless, they might be dead, but if immune to death and not level drain they will be affected
			// They only get a fort save for half if they ar level 7 or higher
			//if ( iHD > 6 && FortitudeSave(oTarget, iDC, SAVING_THROW_TYPE_POISON, OBJECT_SELF) )
			//{
			//	// half damage, minimum of 1
			//	nConDamage =  CSLGetMax(1, HkApplyMetamagicVariableMods(d4(), 4)/2 );
			//}
			//else
			//{
			//	nConDamage = HkApplyMetamagicVariableMods(d4(), 4);
			//}
			
			
			
			if ( nConDamage > 0 )
			{
				DelayCommand(fDelay, SCApplyDeadlyAbilityDrainEffect( nConDamage, ABILITY_CONSTITUTION, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster ) );
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
			}
		//}
	}
	
	HkPostCast(oCaster);
}