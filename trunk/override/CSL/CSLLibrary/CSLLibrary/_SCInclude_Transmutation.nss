/** @file
* @brief Include File for Transmutation Magic
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_HkSpell"
#include "_SCInclude_Class"
#include "_CSLCore_Player"

// * improves an animal companion or summoned creature's attack and damage and the ability to hit
// * magically protected creatures
//void SCDoMagicFang(int nPower, int nDamagePower);
/*
void SCDoMagicFang(int nPower, int nVFX);

void SCDoPetrification(int nPower, object oSource, object oTarget, int iSpellId, int nFortSaveDC);
*/



//::///////////////////////////////////////////////
//:: SCDoMagicFang
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

FEB 19: Made it so only Animal Companions get these bonuses
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SCDoMagicFang(int nPower, int nVFX)
{
	object oTarget  = HkGetSpellTarget();
	object oCaster  = OBJECT_SELF;
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			int bDoVis = FALSE;
			float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds(HkGetSpellDuration(oCaster)) );
			object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
			object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
			object oWeapon3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
			object oWeapon4 = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
			itemproperty iEbonus = ItemPropertyEnhancementBonus(nPower);

			if ( CSLGetIsAnimalOrBeastOrDragon(oTarget)  )
			{
				if (GetIsObjectValid(oWeapon1))
				{
					CSLSafeAddItemProperty(oWeapon1, iEbonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
					bDoVis = TRUE;
				}
				if (GetIsObjectValid(oWeapon2))
				{
					CSLSafeAddItemProperty(oWeapon2, iEbonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
					bDoVis = TRUE;
				}
				if (GetIsObjectValid(oWeapon4))
				{
					CSLSafeAddItemProperty(oWeapon4, iEbonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
					bDoVis = TRUE;
				}
				if (GetIsObjectValid(oWeapon3))
				{
					CSLSafeAddItemProperty(oWeapon3, iEbonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
					bDoVis = TRUE;
				}
				if (bDoVis)
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX), oTarget, fDuration);
				}
			}
			else
			{
				FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget);
			}
		}
	}
}

// *  This is a wrapper for how Petrify will work in Expansion Pack 1
// * Scripts affected: flesh to stone, breath petrification, gaze petrification, touch petrification
// * nPower : This is the Hit Dice of a Monster using Gaze, Breath or Touch OR it is the Caster Spell of
// *   a spellcaster
// * nFortSaveDC: pass in this number from the spell script
void SCDoPetrification(int nPower, object oSource, object oTarget, int iSpellId, int nFortSaveDC)
{

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
			// * exit if creature is immune to petrification
			if (CSLGetIsImmuneToPetrification(oTarget) == TRUE)
			{
				return;
			}
			float fDifficulty = 0.0;
			int bIsPC = GetIsPC(oTarget);
			int bShowPopup = FALSE;

			// * calculate Duration based on difficulty settings
			int nGameDiff = GetGameDifficulty();
			switch (nGameDiff)
			{
				case GAME_DIFFICULTY_VERY_EASY:
				case GAME_DIFFICULTY_EASY:
				case GAME_DIFFICULTY_NORMAL:
							fDifficulty = RoundsToSeconds(nPower); // One Round per hit-die or caster level
					break;
				case GAME_DIFFICULTY_CORE_RULES:
				case GAME_DIFFICULTY_DIFFICULT:
					bShowPopup = TRUE;
				break;
			}

			int iSaveDC = nFortSaveDC;
			effect ePetrify = EffectPetrify();

			effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FLESH_TO_STONE );

			effect eLink = EffectLinkEffects(eDur, ePetrify);

				// Let target know the negative spell has been cast
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ));
				//SpeakString(IntToString(iSpellId));

				// Do a fortitude save check
				if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC))
				{
					// Save failed; apply paralyze effect and VFX impact

					/// * The duration is permanent against NPCs but only temporary against PCs
					if (bIsPC == TRUE)
					{
							if (bShowPopup == TRUE)
							{
								// * under hardcore rules or higher, this is an instant death
								HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
								DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
								// if in hardcore, treat the player as an NPC
								bIsPC = FALSE;
								//fDifficulty = TurnsToSeconds(nPower); // One turn per hit-die
							}
							else
							{
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDifficulty/2);
							}
					}
					else
					{
							HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

							//----------------------------------------------------------
							// GZ: Fix for henchmen statues haunting you when changing
							//     areas. Henchmen are now kicked from the party if
							//     petrified.
							//----------------------------------------------------------
							if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
							{
								CSLFireHenchman(GetMaster(oTarget),oTarget);
							}

					}
					// April 2003: Clearing actions to kick them out of conversation when petrified
					AssignCommand(oTarget, ClearAllActions(TRUE));
				}
	}

}

void SCCamoflage(object oTarget, int nAmount = 10 )
{
	object oCaster = OBJECT_SELF;
	int iCasterLevel = HkGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds( iCasterLevel ) );
	int iDurType = HkApplyMetamagicDurationTypeMods( DURATION_TYPE_TEMPORARY );
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_CAMOFLAGE);
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HIDE, nAmount ));
	SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId(), FALSE));
	
	// make it so camoflage does not stack
	//int bRemovedEffect =
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_VINE_MINE_CAMOUFLAGE, SPELL_MASS_CAMOFLAGE, SPELL_CAMOFLAGE );
	
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
}

void SCApplyHasteEffect(object oTarget, object oCaster, int iSpellId = -1, float fDuration = 1.0f, int iDurType = DURATION_TYPE_TEMPORARY )
{

	effect eLink;
	int iHasHaste = FALSE;
	int nSwiftblade = GetLevelByClass(CLASS_SWIFTBLADE, oCaster);
	
	
	if ( iSpellId == SPELL_EXPEDITIOUS_RETREAT )
	{
		eLink = EffectVisualEffect(VFX_DUR_SPELL_EXPEDITIOUS_RETREAT);
		eLink = EffectLinkEffects(eLink, EffectMovementSpeedIncrease(150) );
	}
	else if ( iSpellId == 647 ) // that is blinding speed
	{
		eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		eLink = EffectLinkEffects(eLink, EffectHaste() );
		iHasHaste = TRUE;
	}
	else if ( iSpellId == SPELLABILITY_IMPROVED_REACTION ) // that is blinding speed
	{
		eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		// this is for haste or slow
		// eVis = EffectVisualEffect(VFX_IMP_HASTE);
		eLink = EffectLinkEffects(eLink, EffectHaste() );
		eLink = ExtraordinaryEffect(eLink);
	}
	else
	{
		eLink = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
		// this is for haste or slow
		// eVis = EffectVisualEffect(VFX_IMP_HASTE);
		eLink = EffectLinkEffects(eLink, EffectHaste() );
		iHasHaste = TRUE;
	}
	eLink = SetEffectSpellId(eLink, iSpellId);
	
	CSLUnstackSpellEffects(oTarget, SPELL_HASTE, "Haste");
	CSLUnstackSpellEffects(oTarget, 647, "Blinding Speed");
	CSLUnstackSpellEffects(oTarget, SPELL_MASS_HASTE, "Mass Haste");
	CSLUnstackSpellEffects(oTarget, SPELL_EXPEDITIOUS_RETREAT, "Expeditious Retreat");
	CSLUnstackSpellEffects(oTarget, BLADESINGER_SONG_CELERITY, "Song of Celerity");
	CSLUnstackSpellEffects(oTarget, SPELLABILITY_IMPROVED_REACTION, "Improved Reaction");
	CSLUnstackSpellEffects(oTarget, LION_TALISID_LIONS_SWIFTNESS, "Lion Talisid Swiftness");
	if ( !CSLGetPreferenceSwitch("PNPFleeTheScene",FALSE) ) // only do this if they don't have my teleport
	{
		CSLUnstackSpellEffects(oTarget, SPELL_I_FLEE_THE_SCENE, "Blinding Speed");
	}
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE) );
	 
	 
	if ( (oTarget == oCaster) && ( nSwiftblade > 0 ) && ( iSpellId == SPELL_HASTE || iSpellId == SPELL_MASS_HASTE))
	{
		float fSwiftbladeDuration = fDuration;
		fSwiftbladeDuration = GetSwiftbladeHasteDuration(nSwiftblade, fSwiftbladeDuration);
		//effect eSwiftbladeLink = eLink;
		eLink = GetSwiftbladeHasteEffect(nSwiftblade, eLink);
		HkApplyEffectToObject(iDurType, eLink, oTarget, fSwiftbladeDuration);
	
	}
	else
	{
		HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId);
	}
		
	if ( iHasHaste && GetHasSpellEffect(BLADESINGER_SONG_FURY, oTarget))
	{
		effect eAtks = EffectModifyAttacks(2);
		eAtks = SetEffectSpellId(eAtks, -BLADESINGER_SONG_FURY);
		if ( (oTarget == OBJECT_SELF) && (nSwiftblade > 0) )
		{
			HkApplyEffectToObject(iDurType, eAtks, oTarget, GetSwiftbladeHasteDuration(nSwiftblade, fDuration ), iSpellId );
		}
		else
		{
			if (!GetHasFeatEffect(FEAT_FRENZY_1))
			{
				if(!GetHasFeatEffect(FEAT_BARBARIAN_RAGE))
				{
					HkApplyEffectToObject(iDurType, eAtks, oTarget, fDuration, iSpellId);
				}
			}
		}
	}
	
	
	//if ( iSpellId == SPELL_EXPEDITIOUS_RETREAT )
	//{
		
	//}

}

//  Creates the linked bad effects for Battletide.
effect SCCreateBadTideEffectsLink()
{
	//Declare major variables
	effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eAttack = EffectAttackDecrease(2);
	effect eDamage = EffectDamageDecrease(2);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BATTLETIDE_VICTIM ); // NWN2 VFX
	//Link the effects
	effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eSaves);
	eLink = EffectLinkEffects(eLink, eDur);

	return eLink;
}


//  Creates the linked good effects for Battletide.
effect SCCreateGoodTideEffectsLink()
{
	 //Declare major variables
	effect eGoodTide = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1);
	eGoodTide = EffectLinkEffects( eGoodTide, EffectAttackIncrease(1) );
	eGoodTide = EffectLinkEffects( eGoodTide, EffectACIncrease(1) );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
	eGoodTide = EffectLinkEffects( eGoodTide, EffectVisualEffect( VFX_DUR_SPELL_BATTLETIDE ) );	// NWN2 VFX
    //Link the effects
   

    return eGoodTide;
	
	/*
	//Declare major variables
	effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2) );
	eGoodTide = EffectLinkEffects( eGoodTide, EffectAttackIncrease(2) );
	eGoodTide = EffectLinkEffects( eGoodTide, EffectDamageIncrease(2, DAMAGE_TYPE_MAGICAL ) );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	eGoodTide = EffectLinkEffects( eGoodTide, EffectVisualEffect( VFX_DUR_SPELL_BATTLETIDE ) ); // NWN2 VFX
	

	return eGoodTide;
	*/
}


//::///////////////////////////////////////////////
//:: SCDoSpikeGrowthEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	1d4 damage, plus a 24 hr slow if take damage.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SCDoSpikeGrowthEffect(object oTarget)
{
	float fDelay = CSLRandomBetweenFloat(1.0, 2.2);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_SPIKE_GROWTH, TRUE ));
			//Spell resistance check
			if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
			{
				int iDamage = HkApplyMetamagicVariableMods(d4(), 4);
				
				float fDuration = HoursToSeconds(24);
				fDuration = HkApplyMetamagicDurationMods(fDuration);
				int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

				effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING);
				//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);  // NWN1 VFX
				//effect eVis = EffectVisualEffect( VFX_COM_BLOOD_REG_RED );   // NWN2 VFX
				//effect eLink = eDam;
				//Apply damage and visuals
				//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam/*eLink*/, oTarget));

				// * only apply a slow effect from this spell once
				if (GetHasSpellEffect(SPELL_SPIKE_GROWTH, oTarget) == FALSE)
				{
					//Make a Reflex Save to avoid the effects of the movement hit.
					if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC(), SAVING_THROW_ALL, GetAreaOfEffectCreator(), fDelay))
					{
						effect eSpeed = EffectMovementSpeedDecrease(30);
						effect eVisSlow = EffectVisualEffect( VFX_DUR_SPELL_SLOW );
						effect eLink = EffectLinkEffects( eSpeed, eVisSlow );
						HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
					}
				}
			}
	}
}