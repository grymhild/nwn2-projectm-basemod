//::///////////////////////////////////////////////
//:: Grease: Heartbeat
//:: NW_S0_GreaseC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creatures entering the zone of grease must make
	a reflex save or fall down.  Those that make
	their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_grease(); //SPELL_GREASE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_GREASE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget;
	effect eFall = EffectKnockdown();
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	effect eLink = EffectLinkEffects(eFall, eHit);
	eLink = SetEffectSpellId(eLink, SPELL_GREASE);
	float fDelay;
	//Get first target in spell area
	oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
		// if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
		if ( !CSLGetIsIncorporeal( oTarget ) )
		{
			if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
			{
				fDelay = CSLRandomBetweenFloat(0.0, 2.0);
				int iSaveDC = HkGetSpellSaveDC();
				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
				{
					if (DEBUGGING >= 6) { CSLDebug( "GreaseHeartBeat: SaveDC " + IntToString( iSaveDC )); }
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 4.0f ));
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  4.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}
				
				if ( CSLGetIsFireBased( oTarget ) )
				{
					ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_FIRE), GetLocation(oTarget) );
					CSLEnviroIgniteAOE( GetHitDice(oTarget), OBJECT_SELF );
				}
			}
		}
		//Get next target in spell area
		oTarget = GetNextInPersistentObject();
	}
}