/** @file
* @brief Include File for Necromancy Magic
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/

const string NECROTIC_EMPOWERMENT_MARKER = "HAS_NECROTIC_EMPOWER";
const string NECROTIC_CYST_MARKER        = "HAS_NECROTIC_CYST";
const int nNoNecCyst = 16829317;
const int nNoMotherCyst = 16829318;
const int nNecEmpower = 16829319;
const int nGaveCyst = 16829316;



#include "_HkSpell"
#include "_CSLCore_Player"
#include "_CSLCore_NWNx"
#include "_CSLCore_Reputation"
//#include "_SCInclude_AI_c"
/*
void SCApplyDeadlyAbilityDrainEffect( int nDrainAmount, int nDrainedStat, object oTarget, int iDurationType = DURATION_TYPE_PERMANENT, float fDuration=0.0f, object oAttacker = OBJECT_INVALID );
*/



int SCGetLostHPerLevel( object oTarget )
{
	int iClassHitPoints = GetMaxHitPoints(oTarget); // -GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
	
	if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_10, oTarget ) )
	{
		iClassHitPoints -= 300;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_9, oTarget ) )
	{
		iClassHitPoints -= 270;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_8, oTarget ) )
	{
		iClassHitPoints -= 240;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_7, oTarget ) )	
	{
		iClassHitPoints -= 210;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_6, oTarget ) )
	{
		iClassHitPoints -= 180;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_5, oTarget ) )
	{
		iClassHitPoints -= 150;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_4, oTarget ) )
	{
		iClassHitPoints -= 120;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_3, oTarget ) )
	{
		iClassHitPoints -= 90;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_2, oTarget ) )
	{
		iClassHitPoints -= 60;
	}
	else if ( GetHasFeat(FEAT_EPIC_TOUGHNESS_1, oTarget ) )
	{
		iClassHitPoints -= 30;
	}
	
	return iClassHitPoints/GetHitDice(oTarget);
	
}

// applies level drain effect, killing target if the drain takes them below
void SCApplyDeadlyAbilityLevelEffect( int nDrainAmount, object oTarget, int iDurationType = DURATION_TYPE_PERMANENT, float fDuration=0.0f, object oAttacker = OBJECT_INVALID, int iExtraDamage = 0 )
{
	if ( GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL, oTarget ) )
	{
		// don't bother, target is immune, this just gives feedback about the attack
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNegativeLevel(nDrainAmount), oTarget);
		return;
	}
	
	if ( ( HkGetHitDice( oTarget, TRUE ) - nDrainAmount ) > 0 ) // The stat is going to be 1 or higher
	{
		// apply the draining effect, but do it in such a way that it can't be dispelled
		effect eLevelDrain = EffectNegativeLevel(nDrainAmount);
		//eConDam = SetEffectSpellId(eConDam, -1); // replaced by applyeffect to object function triggered by -2.
		eLevelDrain = SupernaturalEffect(eLevelDrain);
		HkApplyEffectToObject(iDurationType, SetEffectSpellId(eLevelDrain,-2), oTarget, fDuration, -2, oAttacker );
		
		int iDamage = ( nDrainAmount * SCGetLostHPerLevel(oTarget) ) + iExtraDamage;
		if ( iDamage > GetCurrentHitPoints(oTarget) ) // don't let this be what kills them regardless
		{
			iDamage = GetCurrentHitPoints(oTarget)-d4();
		}
		
		if ( iDamage > 0 )
		{
			ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE) , oTarget );
		}
	}
	else // The level is going below 1, which means they need to die
	{
		if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oTarget)+10), oTarget);
		}
	}	
}


// applies level drain effect, killing target if the drain takes them below
void SCApplyDeadlyAbilityDrainEffect( int nDrainAmount, int nAbility, object oTarget, int iDurationType = DURATION_TYPE_PERMANENT, float fDuration=0.0f, object oAttacker = OBJECT_INVALID )
{
	if ( GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oTarget ) )
	{
		// don't bother, target is immune
		// don't bother, target is immune, this just gives feedback about the attack
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityDecrease(nAbility, nDrainAmount), oTarget);
		return;
	}
	
	if ( ( GetAbilityScore(oTarget, nAbility, FALSE) - nDrainAmount ) > 0 ) // The stat is going to be 1 or higher
	{
	
		// apply the draining effect, but do it in such a way that it can't be dispelled
		effect eAbilityDam = EffectAbilityDecrease(nAbility, nDrainAmount);
		//eConDam = SetEffectSpellId(eConDam, -1); // replaced by applyeffect to object function triggered by -2.
		eAbilityDam = ExtraordinaryEffect(eAbilityDam);
		HkApplyEffectToObject(iDurationType, SetEffectSpellId(eAbilityDam,-2), oTarget, fDuration, -2, oAttacker );
	}
	else // The stat is going below 1, which means they need to die
	{
		if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oTarget)+10), oTarget);
		}
	}	
}




// applies level drain effect, killing target if the drain takes them below
void SCApplyAbilityDrainEffect(  int nAbility,  int nDrainAmount, object oTarget, int iDurationType = DURATION_TYPE_PERMANENT, float fDuration=0.0f, int bDispellable = FALSE, int nSpellID = -1, object oAttacker = OBJECT_INVALID )
{
	if ( GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oTarget ) )
	{
		// don't bother, target is immune
		// don't bother, target is immune, this just gives feedback about the attack
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityDecrease(nAbility, nDrainAmount), oTarget);
		return;
	}
	
	if ( ( GetAbilityScore(oTarget, nAbility, FALSE) - nDrainAmount ) > 0 ) // The stat is going to be 1 or higher
	{
	
		// apply the draining effect, but do it in such a way that it can't be dispelled
		//effect eConDam = EffectAbilityDecrease(nAbility, nDrainAmount);
		//eConDam = SetEffectSpellId(eConDam, -1); // replaced by applyeffect to object function triggered by -2.
		//eConDam = ExtraordinaryEffect(eConDam);
		//HkApplyEffectToObject(iDurationType, eConDam, oTarget, fDuration, -2 );
		
		// Is the damage temporary and specified to heal at the PnP rate
		if (iDurationType == DURATION_TYPE_TEMPORARY && fDuration == -1.0f)
		{
			int i;
			for(i = 1; i < nDrainAmount; i++)
			{
				DelayCommand(0.01f, ApplyEffectToObject(iDurationType, bDispellable ? EffectAbilityDecrease(nAbility, 1) : SetEffectSpellId(SupernaturalEffect(EffectAbilityDecrease(nAbility, 1)),-1),  oTarget, HoursToSeconds(24) * i));
			}
		}
		else if(!bDispellable)
		{
			DelayCommand(0.01f, ApplyEffectToObject(iDurationType, SetEffectSpellId(SupernaturalEffect(EffectAbilityDecrease(nAbility, nDrainAmount)),-1),  oTarget, fDuration));
		}
		else
		{
			HkApplyEffectToObject(iDurationType, EffectAbilityDecrease(nAbility, nDrainAmount), oTarget, fDuration, nSpellID, oAttacker);
		}
	}
	else // The stat is going below 1, which means they need to die
	{
		if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oTarget)+10), oTarget);
		}
	}	
}

/**
 * Applies the corruption cost for Corrupt spells.
 *
 * @param oCaster  The caster of the Corrupt spell
 * @param oTarget  The target of the spell.
 *                 Not used for anything, should probably remove - Ornedan
 * @param nAbility ABILITY_* of the ability to apply the cost to
 * @param nCost    The amount of stat damage or drain to apply
 * @param bDrain   If this is TRUE, the cost is applied as ability drain.
 *                 If FALSE, as ability damage.
 */
void SCApplyCorruptionCost(object oPC, int nAbility, int nCost, int bDrain)
{
    // Undead redirect all damage & drain to Charisma, sez http://www.wizards.com/dnd/files/BookVileFAQ12102002.zip
    if( GetRacialType( oPC ) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD,oPC) > 0 || GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC) ) == "x2_gauntletlich" )
	{
        nAbility = ABILITY_CHARISMA;
	}
    //Exalted Raiment
    if(GetHasSpellEffect(SPELL_EXALTED_RAIMENT, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)))
    {
        nCost -= 1;
    }

    // Is it ability drain?
    if ( bDrain )
    {
        SCApplyAbilityDrainEffect( nAbility, nCost, oPC, DURATION_TYPE_PERMANENT  );
    // Or damage
    }
    else
    {
        SCApplyAbilityDrainEffect( nAbility, nCost, oPC, DURATION_TYPE_TEMPORARY, -1.0f);
	}
}

effect SCCreateDoomEffectsLink()
{
	//Declare major variables
	effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eAttack = EffectAttackDecrease(2);
	effect eDamage = EffectDamageDecrease(2);
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_DOOM ); // NWN2 VFX

	effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eSaves);
	eLink = EffectLinkEffects(eLink, eSkill);
	eLink = EffectLinkEffects(eLink, eDur);

	return eLink;
}


int UndeadLevelBonus(object oPC)
{
	int iBonus = 0;
	if (GetHasFeat(FEAT_AUGMENT_SUMMONING, oPC)) iBonus++;
	if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oPC)) iBonus++;
	if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC)) iBonus++;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC)) iBonus++;
	iBonus += GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) / 3;
	return iBonus;
}

float UndeadDuration(object oPC)
{
	return HkApplyMetamagicDurationMods(HoursToSeconds(10 + UndeadLevelBonus(oPC)));
}



int BuffUndeadItem(object oSum, int nSlot, int nEB, int nDamBonus) {
	object oItem = GetItemInSlot(nSlot, oSum); // ENCHANT THE CLAWS
	if (oItem!=OBJECT_INVALID) {
		CSLSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(nEB));
		if (nDamBonus){
			CSLSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, nDamBonus));
		} else {
		}
		return TRUE;
	}
	return FALSE;
}

void BoostUndeadSummon(object oPC, object oSum = OBJECT_INVALID) {
	if (oSum==OBJECT_INVALID) oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
	int iLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC); //GetUndeadLevel(oPC);
	int nNecro = UndeadLevelBonus(oPC);
	if (GetHasFeat(FEAT_AUGMENT_SUMMONING, oPC)) {
		effect eAug = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
		eAug = EffectLinkEffects(eAug, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(eAug), oSum);
	}
	if (nNecro) {
		SendMessageToPC(oPC, "Pale Master Necromancy Boost +" + IntToString(nNecro));
	}
	int iBonus = iLevel / 4 + nNecro; // 10/4 + 4 = max 6
	if (!iBonus) return;
	int nEB = CSLGetMax(5, iBonus);
	int nDamBonus = 0;
	if      (iBonus==1) nDamBonus = DAMAGE_BONUS_1d4;
	else if (iBonus==2) nDamBonus = DAMAGE_BONUS_1d6;
	else if (iBonus==3) nDamBonus = DAMAGE_BONUS_1d8;
	else if (iBonus==4) nDamBonus = DAMAGE_BONUS_1d10;
	else if (iBonus>=5) nDamBonus = DAMAGE_BONUS_2d6;
//   else if (iBonus==6) nDamBonus = DAMAGE_BONUS_2d8;
//   else if (iBonus==7) nDamBonus = DAMAGE_BONUS_2d10;
//   else if (iBonus==8) nDamBonus = DAMAGE_BONUS_2d12;
	SendMessageToPC(oPC, "Pale Master Necromancy Boost applied: +" + IntToString(iBonus) + " AC / +" +IntToString(nEB) + " EB / +" + CSLDamageBonusToString(nDamBonus) + " Negative damage.");
	if (BuffUndeadItem(oSum, INVENTORY_SLOT_RIGHTHAND, nEB, nDamBonus)) BuffUndeadItem(oSum, INVENTORY_SLOT_LEFTHAND, nEB, nDamBonus);
	else if (BuffUndeadItem(oSum, INVENTORY_SLOT_CWEAPON_R, nEB, nDamBonus)) BuffUndeadItem(oSum, INVENTORY_SLOT_CWEAPON_L, nEB, nDamBonus);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(iBonus), oSum);
}

int CountUndead(object oPC) {
	int nCnt = 0;
	if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)==OBJECT_INVALID) return 0;
	object oArea = GetArea(oPC);
	object oMinion = GetFirstObjectInArea(oArea);
	while (GetIsObjectValid(oMinion)) {
		if (GetObjectType(oMinion)==OBJECT_TYPE_CREATURE) {
			if (GetMaster(oMinion)==oPC && CSLGetIsUndead( oMinion ) ) {
				nCnt++;
			}
		}
		oMinion = GetNextObjectInArea(oArea);
	}
	return nCnt;
}



void CreateUndead(object oPC, string sResRef, int nMaxDom = 1, int bRedEyes = FALSE) {
	int nCount = CountUndead(oPC) + 1;
	if (nCount > nMaxDom)
	{
		FloatingTextStringOnCreature("There are too many Undead currently at your service...", oPC, FALSE);
		return;
	}
	location lLocation = GetLocation(oPC);
	SetLocalInt(oPC, "UNDEADCOUNT", nCount);
	object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLocation, FALSE);
	FloatingTextStringOnCreature("A " + GetName(oMinion) + " is now at your service.", oPC, FALSE);
	SetLastName(oMinion, "of " + GetName(oPC));//GetName(oMinion)+
	SetLocalObject(oMinion, "DOMINATED", oPC);
	HkApplySummonTag( oMinion, oPC );
	if (bRedEyes) HkApplyEffectToObject(DURATION_TYPE_PERMANENT,  EffectNWN2SpecialEffectFile("aura_legion_g.sef"), oMinion);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectCutsceneDominated()), oMinion, HoursToSeconds(24));
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), lLocation);
	BoostUndeadSummon(oPC, oMinion);
	/*
	//Distance flattened these to avoid x0_i0_assoc
	const int CSL_ASC_DISTANCE_2_METERS =   0x00000001;
	const int CSL_ASC_DISTANCE_4_METERS =   0x00000002;
	const int CSL_ASC_DISTANCE_6_METERS =   0x00000004;
	*/
	int nDistance = 0x00000004;
	if (nCount==1) nDistance = 0x00000001;
	if (nCount==2) nDistance = 0x00000002;
	CSLSetAssociateState(nDistance, TRUE, oMinion);
	int nSpawnInConditions = GetLocalInt(oMinion, "NW_GENERIC_MASTER");
	// error with variable on this line, fixed by including x0_i0_spawncond.NSS
	nSpawnInConditions |= CSL_FLAG_STEALTH | CSL_FLAG_AMBIENT_ANIMATIONS | CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS | CSL_FLAG_FAST_BUFF_ENEMY;
	
	SetLocalInt(oMinion, "NW_GENERIC_MASTER", nSpawnInConditions);
	int nCombatConditions = GetLocalInt(oMinion, "X0_COMBAT_CONDITION");
	if (nCount==1) nCombatConditions |= CSL_COMBAT_FLAG_AMBUSHER;
	else nCombatConditions = nCombatConditions | CSL_COMBAT_FLAG_RANGED;
	SetLocalInt(oMinion, "X0_COMBAT_CONDITION", nCombatConditions);
	if ( GetIsDM(oPC) || GetIsDMPossessed(oPC) )
	{
		ChangeToStandardFaction( oMinion, STANDARD_FACTION_HOSTILE);
		SetCreatureScriptsToSet( oMinion, 9 );
	}
	else if ( !GetIsOwnedByPlayer( oPC ) && !GetIsPC( oPC ) )
	{
		ChangeFaction(oMinion, oPC);
		SetCreatureScriptsToSet( oMinion, 9 );
	}
}

void SummonUndead() {
	object oPC = OBJECT_SELF;
	string sResRef = "";
	int bRedEyes = FALSE;
	int iSpellId = GetSpellId();
	int iLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
	int iBonus = UndeadLevelBonus(oPC);
	if (iBonus) {
		iLevel += iBonus;
		SendMessageToPC(oPC, "Pale Master Conjuration Boost +" + IntToString(iBonus));
	}
	
	if ( !GetIsOwnedByPlayer( oPC ) && !GetIsPC( oPC ) )
	{
		// dealing with an npc
		if (iSpellId==SPELLABILITY_PM_ANIMATE_DEAD)
		{
			if      (iLevel < 3) sResRef = "c_ghast";
			else if (iLevel < 5) sResRef = "c_mummy";
			else                 sResRef = "c_mummylord";
		}
		else if (iSpellId==SPELLABILITY_PM_SUMMON_UNDEAD)
		{
			if      (iLevel < 5) sResRef = "c_ghast";
			else if (iLevel < 7) sResRef = "c_mummy";
			else                 sResRef = "c_mummylord";
		}
		else if (iSpellId==SPELLABILITY_PM_SUMMON_GREATER_UNDEAD)
		{
			if      (iLevel < 10) sResRef = "c_vampiref";
			else if (iLevel < 12) sResRef = "c_vampirem";
			else                  sResRef = "c_vampireelite";
		}
		object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oPC), FALSE);
		return;
	}
	else
	{
	// dealing with a player
		if (iSpellId==SPELLABILITY_PM_ANIMATE_DEAD)
		{
			if      (iLevel < 3) sResRef = "pm_zombie1";
			else if (iLevel < 5) sResRef = "pm_zombie2";
			else                 sResRef = "pm_zombie3";
		}
		else if (iSpellId==SPELLABILITY_PM_SUMMON_UNDEAD)
		{
			if      (iLevel < 5) sResRef = "pm_skeleton1";
			else if (iLevel < 7) sResRef = "pm_skeleton2";
			else                 sResRef = "pm_skeleton3";
		}
		else if (iSpellId==SPELLABILITY_PM_SUMMON_GREATER_UNDEAD)
		{
			if      (iLevel < 10) sResRef = "pm_ghast1";
			else if (iLevel < 12) sResRef = "pm_ghast2";
			else                  sResRef = "pm_ghast3";
		}
	}
	bRedEyes = (GetStringRight(sResRef, 1)=="3");
	CreateUndead(oPC, sResRef, 2, bRedEyes);
}


int GetCanCastNecroticSpells(object oPC)
{	                
	int bReturn = TRUE;
	
	// check for Necrotic Empowerment on caster
	if (GetHasSpellEffect(SPELL_NECROTIC_EMPOWERMENT, oPC))
	{
		// "You cannot cast spells utilizing your Mother Cyst while under the effect of Necrotic Empowerment."

		FloatingTextStrRefOnCreature(nNecEmpower, oPC);
		bReturn = FALSE;
	}
	// check for Mother Cyst
	if(!GetHasFeat(FEAT_MOTHER_CYST, oPC) && (!GetIsObjectValid(GetSpellCastItem())))
	{

		// "You must have a Mother Cyst to cast this spell."
		FloatingTextStrRefOnCreature(nNoMotherCyst, oPC);
		bReturn = FALSE;
	}
	
	if(DEBUGGING) CSLDebug("spinc_necrocyst: GetCanCastNecroticSpells():\n"
	                    + "oPC = '" + GetName(oPC) + "'");
	
	return bReturn;
	
}


int GetHasNecroticCyst(object oCreature)
{
	
	                    
	return CSLGetPersistentInt(oCreature, NECROTIC_CYST_MARKER);
	
	if(DEBUGGING) CSLDebug("spinc_necrocyst: GetHasNecroticCyst():\n"
	                    + "oCreature = '" + GetName(oCreature) + "'");

}

void GiveNecroticCyst(object oCreature)
{
	
	CSLSetPersistentInt(oCreature, NECROTIC_CYST_MARKER, 1);
	FloatingTextStrRefOnCreature(nGaveCyst, OBJECT_SELF);
	itemproperty iCystDam = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
	if (GetIsObjectValid(oArmor))
	{
		//add item prop with DURATION_TYPE_PERMANENT
		CSLSafeAddItemProperty(oArmor, iCystDam, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}

	else
	{
		object oSkin = CSLGetPCSkin(oCreature);
		CSLSafeAddItemProperty(oSkin, iCystDam, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}

	//Keep property on armor or hide
	ExecuteScript ("prc_keep_onhit_a", oCreature);
	
	if(DEBUGGING) CSLDebug("spinc_necrocyst: GiveNecroticCyst():\n"
		                    + "oCreature = '" + GetName(oCreature) + "'");

}

void RemoveCyst(object oCreature)
{
	CSLSetPersistentInt(oCreature, NECROTIC_CYST_MARKER, 0);

}