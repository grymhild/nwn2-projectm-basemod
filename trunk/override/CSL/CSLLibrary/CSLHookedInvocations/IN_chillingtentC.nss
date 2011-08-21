//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Chilling Tentacles  HEARTBEAT
//:: nw_s0_chilltent.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Chilling Tentacles
			Complete Arcane, pg. 132
			Spell Level: 5
			Class:           Misc

			This functions identically to the Evard's black tentacles spell
			(4th level wizard) except that each creature in the area of effect
			takes an additional 2d6 of cold damage per round regardless
			if tentacles hit them or not.

		Upon entering the mass of "soul-chilling" rubbery tentacles the
		target is struck by 1d4 tentacles.  Each has a chance to hit of 5 + 1d20.
		If it succeeds then it does 2d6 damage and the target must make
		a Fortitude Save versus paralysis or be paralyzed for 1 round.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"



/*
int RunRollToHit(object oTarget, object oCaster) {
	//roll against the AC of the target bab +6 + caster's wisdom modifier * 2
	int iRoll = d20();
	if (iRoll==20) return TRUE;
	if (iRoll==1)  return FALSE;
	//iRoll += 6 + 2 * GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	iRoll += GetBaseAttackBonus(oCaster) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	return (iRoll>=GetAC(oTarget));
}
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_I_CHILLING_TENTACLES;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eImmoble = EffectCutsceneImmobilize();
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eLink = EffectLinkEffects(eVis, eImmoble);
	eLink = EffectLinkEffects(eLink, EffectAttackDecrease(4));
	eLink = EffectLinkEffects(eLink, EffectSpellFailure());
	effect eDam;
	int iDamage = 0;
	float fDelay;
	
	object oTarget = GetFirstInPersistentObject();
	
	while(GetIsObjectValid(oTarget))
    {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
			// slowing is regardless
			DelayCommand( 0.1,  HkNonStackingSlow( oTarget, oCaster, RoundsToSeconds(1), 3805 )  );

			iDamage = 0;
			if((GetCreatureSize(oTarget)>CREATURE_SIZE_SMALL)&&(GetCreatureSize(oTarget)<=CREATURE_SIZE_HUGE)&&!CSLGetIsIncorporeal( oTarget )&&!GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
            {
                    fDelay = CSLRandomBetweenFloat(0.75, 1.50);
                    if( CSLGrappleCheck( oCaster, oTarget, HkGetSpellPower(oCaster, 30, iClass) ) ) // only cast by warlocks
                    {
                        iDamage = d6() + 4;
                        //Enter Metamagic conditions
                        eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
                        DelayCommand(0.3, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        {
                            DelayCommand(0.1, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
                        }
                    }
               
            }
            // Apply Cold Damage regardless of whether or not any tentacles struck the target.... 
            fDelay  = CSLRandomBetweenFloat(0.4, 0.8);
            iDamage = d6(2);
            ///iDamage = ApplyMetamagicVariableMods( iDamage, 2*6 );
            eDam = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
		oTarget = GetNextInPersistentObject();
	}	
}
	
/*	
	
	
	
	
	int iSaveDC = GetInvocationSaveDC(oCaster); //GetSpellSaveDC();
	effect ePara = EffectVisualEffect(VFX_DUR_PARALYZED);
	ePara = EffectLinkEffects(ePara, EffectParalyze(iSaveDC, SAVING_THROW_FORT));
	int iBonus = HkGetWarlockBonus(oCaster);

	int nHits;
	int iDamage;
	effect eDam;
	float fDelay;
	object oTarget = GetFirstInPersistentObject();
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_I_CHILLING_TENTACLES));
			iDamage = 0;
			for (nHits = d4(); nHits>0; nHits--) {
				if (RunRollToHit(oTarget, oCaster))
				{ //ROLL TO HIT TARGET
					fDelay = CSLRandomBetweenFloat(0.75, 1.5);
					iDamage = d6(2) + iBonus;
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				}
			}
			if (iDamage>0 && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay)) {
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, 6.0));
			}
			// Apply Cold Damage regardless of whether or not any tentacles struck the target....
			fDelay  = CSLRandomBetweenFloat(0.4, 0.8);
			iDamage = d6(2);
			eDam = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
		oTarget = GetNextInPersistentObject();
	}
}
*/