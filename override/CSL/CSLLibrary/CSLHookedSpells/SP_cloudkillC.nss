//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures with 3 or less HD die, those with
	4 to 6 HD must make a save Fortitude Save or die.
	Those with more than 6 HD take 1d4 CON damage per
	round.  Fortitude reduces damage by half.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_cloudkill(); //SPELL_CLOUDKILL;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if ( CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_CLOUDKILL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_POISON|SCMETA_DESCRIPTOR_GAS, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nConDamage;
	
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_POISON);  // NWN2 VFX
	
	int iDC = HkGetSpellSaveDC();
	int iHD;
	float fDelay;
	//Get the first object in the persistant AOE
	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE , oCaster))
		{
			if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) && !CSLGetIsImmuneToClouds(oTarget) )
			{
				iHD = GetHitDice(oTarget);
				fDelay = CSLRandomBetweenFloat();
				
				nConDamage = HkApplyMetamagicVariableMods(d4(), 4);
				if ( iHD > 6 )
				{
					nConDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, nConDamage, oTarget, iDC, SAVING_THROW_TYPE_POISON, oCaster, SAVING_THROW_RESULT_ROLL );
				}
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
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		oTarget = GetNextInPersistentObject();
	}
	
	HkPostCast(oCaster);
}