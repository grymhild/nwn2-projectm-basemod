/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC =  GetEnteringObject(); // only works if it's in a trigger or an AOE
	//if( !GetIsObjectValid( oPC ) ) // this is to make it runnable via rs command or execute as well
	//{
	//	if ( GetObjectType(OBJECT_SELF)==OBJECT_TYPE_CREATURE )
	//	{
	//		oPC == OBJECT_SELF;
	//	}
	//}
	
	if (  GetIsObjectValid( oPC ) && ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC ) )  )
	{
		
		effect eEffect;	
		
		

	//EffectBABMinimum
	SendMessageToPC( oPC, "Working on EffectBABMinimum "  );
		eEffect = EffectBABMinimum( 30 );
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectBABMinimum" );
	//EffectCutsceneDominated
	SendMessageToPC( oPC, "Working on EffectCutsceneDominated "  );
		eEffect = EffectCutsceneDominated();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectCutsceneDominated" );
	//EffectDamage <-- would not have this because it does not persist
	//EffectDamageShield <-- perhaps this is elemental shield
	SendMessageToPC( oPC, "Working on EffectDamageShield "  );
		eEffect = EffectDamageShield(15, DAMAGE_BONUS_1d6, DAMAGE_TYPE_PIERCING);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectDamageShield" );
	//EffectDarkVision
	SendMessageToPC( oPC, "Working on EffectDarkVision "  );
		eEffect = EffectDarkVision();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectDarkVision" );
	//EffectDeath <-- would not have this because it does not persist
	//EffectDisappear
	SendMessageToPC( oPC, "Working on EffectDisappear "  );
		eEffect = EffectDisappear();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectDisappear" );
	//EffectHeal <-- would not have this because it does not persist
	//EffectLowLightVision
	SendMessageToPC( oPC, "Working on EffectLowLightVision "  );
		eEffect = EffectLowLightVision();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectLowLightVision" );
	//EffectModifyAttacks
	SendMessageToPC( oPC, "Working on EffectModifyAttacks "  );
		eEffect = EffectModifyAttacks(4);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectModifyAttacks" );
	//EffectNWN2ParticleEffect // this seems not to work
	//SendMessageToPC( oPC, "Working on EffectNWN2ParticleEffect "  );
	//	eEffect = EffectNWN2ParticleEffect();
	//	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
	//	CSLRemoveAllEffects( oPC, TRUE, "Removing EffectNWN2ParticleEffect" );
	//EffectNWN2ParticleEffectFile
	SendMessageToPC( oPC, "Working on EffectNWN2ParticleEffectFile "  );
		eEffect = EffectNWN2ParticleEffectFile("body_gift_03.PFX");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectNWN2ParticleEffectFile" );
	//EffectNWN2SpecialEffectFile
	SendMessageToPC( oPC, "Working on EffectNWN2SpecialEffectFile "  );
		eEffect = EffectNWN2SpecialEffectFile("fx_unity_will.sef");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectNWN2SpecialEffectFile" );
		//EffectKnockdown
	SendMessageToPC( oPC, "Working on EffectKnockdown "  );
		eEffect = EffectKnockdown();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing KnockDown" );
	//EffectAppear
	SendMessageToPC( oPC, "Working on EffectAppear "  );
		eEffect = EffectAppear();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0f);
		CSLRemoveAllEffects( oPC, TRUE, "Removing EffectAppear" );
	//EffectSeeInvisible
	//EffectSeeTrueHPs
	//EffectSetScale
	//EffectSummonCopy
	//EffectSummonCreature
		
		
		//int iPrevAppearance = GetAppearanceType(oPC);
		 
		//int iNewAppearance = CSLGetIncrementAppearance( iPrevAppearance );
		
		//if ( iNewAppearance != -1 )
		//{
		//	SetCreatureAppearanceType( oPC, iNewAppearance);
		//	//if ( GetLocalInt( oPC, "APPEARANCECHANGE" ) )
		//	SendMessageToPC( oPC, "Your appearance changes from "+CSLGetStringByAppearance( iPrevAppearance )+"("+IntToString(iPrevAppearance)+") to "+CSLGetStringByAppearance( iNewAppearance )+"("+IntToString(iNewAppearance)+")"  );
		//}
		
		
		//SetLocalInt( oPC, "HKPERM_damagemodtype", DAMAGE_TYPE_SONIC );
	}
}