/** @file
* @brief Include File for Dex Encounters
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//#include "_SCUtility"
#include "_SCInclude_Treasure"
#include "seed_db_inc"

const int SPAWN_STATE_READY = 0;
const int SPAWN_STATE_ACTIVE = 1;
const int SPAWN_STATE_WAITING = 2;
const float BOSS_SPAWN_DELAY = 10.0; // IN MINUTES

const int GOLD_PER_LEVEL = 250;

/*
int    CheckRandomSpawn(int iChance, object oPC=OBJECT_INVALID, int iMaxLevel = 0);
int    GetSpawnState(object oMinion);
int    GetIsBoss(object oMinion);
object DropEquippedItem(object oMinion, int iPCTChance=25, int iSlot=INVENTORY_SLOT_RIGHTHAND, string sNewTag="VALID");
object MakeCreature(string sWhich, object oLocation, int bFlyIn=TRUE, string sNewTag="");
object SpawnBoss(string sWhich, object oLocation, int iBossEffect=TRUE);
void   Despawn (object oToDespawn);
void   DropInvItem(object oMinion, string sTag);
void   HideWeapons(object oPC); // Puts away object's weapons
void   SetSpawnState(object oMinion, int nIsBoss = TRUE);
void   SetBoss(object oMinion, int nIsBoss = TRUE);
void   voidSpawnBoss(string sWhich, object oLocation, object oPC, int iBossEffect=TRUE);
void   voidMakeCreature(string sWhich, object oLocation, object oEnteredBy = OBJECT_INVALID, int bTreasure=FALSE, int bFlyIn=FALSE);
*/

int GoldValue(object oMinion)
{
	return CSLRandomUpperHalf(GOLD_PER_LEVEL * GetHitDice(oMinion)); // Gold Per Hit Die
}

int GetSpawnCount(object oMinion)
{
	object oArea = GetArea(oMinion);
	return GetLocalInt(oArea, "SPAWNS");
}

int IncSpawnCount(object oMinion)
{
	object oArea = GetArea(oMinion);
	int nCnt = CSLIncrementLocalInt(oArea, "SPAWNS", 1);
	SetLocalObject(oMinion, "SPAWNS", oArea);
	SetLocalLocation(oMinion, "SPAWNS", GetLocation(oMinion));
	return nCnt;
}

int DecSpawnCount(object oMinion)
{
	object oSpawnArea = GetLocalObject(oMinion, "SPAWNS");
	if (oSpawnArea!=OBJECT_INVALID)
	{
		int nCnt = CSLIncrementLocalInt(oSpawnArea, "SPAWNS", -1);
		return nCnt;
	}
	return -1;
}

void Despawn (object oMinion)
{
	if (!GetIsObjectValid(oMinion)) return; // DEAD LIKELY, EXIT
	
	if (GetLocalInt(oMinion, "THIEF")) return; // IF THEY STEAL FROM PC, DON'T DESPAWN THEM SO PC HAS A CHANCE OF RECOVERING

	if (GetMaster(oMinion)!=OBJECT_INVALID ||
		GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL, oMinion)     || GetHasSpellEffect(SPELL_DOMINATE_ANIMAL, oMinion)      ||
		GetHasSpellEffect(SPELL_CHARM_MONSTER, oMinion)              || GetHasSpellEffect(SPELL_CHARM_PERSON, oMinion)         ||
		GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oMinion)           || GetHasSpellEffect(SPELL_DOMINATE_PERSON, oMinion)      ||
		GetHasSpellEffect(SPELL_MASS_CHARM, oMinion)                 || GetHasSpellEffect(SPELL_CONFUSION, oMinion)            ||
		GetHasSpellEffect(SPELL_CONTROL_UNDEAD, oMinion)             || GetHasSpellEffect(SPELL_DARKNESS, oMinion)             ||
		GetHasSpellEffect(SPELL_DAZE, oMinion)                       || GetHasSpellEffect(SPELL_FEAR, oMinion)                 ||
		GetHasSpellEffect(SPELL_HOLD_ANIMAL, oMinion)                || GetHasSpellEffect(SPELL_HOLD_MONSTER, oMinion)         ||
		GetHasSpellEffect(SPELL_HOLD_PERSON, oMinion)                || GetHasSpellEffect(SPELL_POWER_WORD_STUN, oMinion)      ||
		GetHasSpellEffect(SPELL_STORM_OF_VENGEANCE, oMinion)         || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oMinion) ||
		GetHasSpellEffect(SPELL_FREEZING_CURSE, oMinion)         || 
		GetLocalInt( oMinion, "CSL_COUNTERSPELLED" )
		)     
	{
		DelayCommand(120.0, Despawn(oMinion)); // CHECK AGAIN LATER, THEY ARE UNDER PC SPELL
		return;
	}
	if ( GetIsInCombat(oMinion) )
	{
		int nCnt = GetSpawnCount(oMinion);
		if (nCnt > 4 && GetIsEncounterCreature(oMinion))
		{
			location lHome = GetLocalLocation(oMinion, "SPAWNS");
			float fDistance = GetDistanceBetweenLocations(lHome, GetLocation(oMinion));
			if (fDistance > 30.0)
			{
				object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oMinion);
				fDistance = GetDistanceBetween(oMinion, oPC);
				if (fDistance > 10.0)
				{
					AssignCommand(oMinion, ClearAllActions(TRUE));
					AssignCommand(oMinion, ActionMoveToLocation(lHome, TRUE));
				}
			}
		}
		DelayCommand(20.0, Despawn(oMinion)); // CHECK AGAIN LATER, THEY ARE IN COMBAT
	return;
	}
	// NOT ENGAGED WITH PC, DESTORY THE SPAWN
	DecSpawnCount(oMinion);
	DestroyObject(oMinion);
}

void SetSpawnState(object oMinion, int nIsBoss = TRUE)
{
	SetLocalInt(oMinion, "SPAWNSTATE", nIsBoss);
}

int GetSpawnState(object oMinion)
{
	return GetLocalInt(oMinion, "SPAWNSTATE");
}

void SetBoss(object oMinion, int nIsBoss = TRUE)
{
	SetLocalInt(oMinion, "BOSS", nIsBoss);
}

int GetIsBoss(object oMinion)
{
	return GetLocalInt(oMinion, "BOSS");
}

void DropInvItem(object oMinion, string sTag)
{
	object oItem;
	int iSlot=0;
	for(iSlot=0;iSlot < INVENTORY_SLOT_CWEAPON_L;iSlot++)   // skip creature items
	{
		oItem = GetItemInSlot(iSlot, oMinion);
		if (GetTag(oItem)==sTag)
		{
			SetDroppableFlag(oItem, TRUE);
			return;
		}
	}
	oItem = GetFirstItemInInventory(oMinion);
	while (GetIsObjectValid(oMinion))
	{
		if (GetTag(oItem)==sTag)
		{
			SetDroppableFlag(oItem, TRUE);
			return;
		}
		oItem = GetNextItemInInventory(oMinion);
	}
}




object MakeCreature(string sWhich, object oLocation, int bFlyIn=TRUE, string sNewTag="")
{
   object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sWhich, GetLocation(oLocation), bFlyIn, sNewTag);
   SetLocalInt(oMinion,"SEEDED",TRUE);
   DelayCommand(300.0, Despawn(oMinion));
   return oMinion;
}

void voidMakeCreature(string sWhich, object oLocation, object oEnteredBy = OBJECT_INVALID, int bTreasure=FALSE, int bFlyIn=FALSE)
{
	object oMinion = MakeCreature(sWhich, oLocation, bFlyIn);
	if (CSLPCIsClose(oMinion, oEnteredBy, 100))
	{
		DelayCommand(1.0, AssignCommand(oMinion, ActionMoveToObject(oEnteredBy, TRUE, 4.0)));
		if (d10()==1) DelayCommand(1.1, AssignCommand(oMinion, ActionAttack(oEnteredBy)));
	}
}

object SpawnBoss(string sWhich, object oLocation, int bFlyIn=FALSE)
{
	object oMinion = GetObjectByTag(sWhich);
	if (oMinion!=OBJECT_INVALID) return oMinion;
	oMinion = MakeCreature(sWhich, oLocation, bFlyIn);
	int i;
	SetBoss(oMinion, TRUE);
	SetAILevel(oMinion, AI_LEVEL_HIGH);
	if (GetHasSpell(SPELL_SPELL_RESISTANCE,oMinion))
	{
		DelayCommand(0.5f, AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_SPELL_RESISTANCE, oMinion)));
	}
	else if (GetHasSpell(SPELL_FREEDOM_OF_MOVEMENT,oMinion))
	{
		DelayCommand(0.5f, AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_FREEDOM_OF_MOVEMENT, oMinion)));
	}
	int nGoldValue = GoldValue(oMinion); //
	GiveGoldToCreature(oMinion, nGoldValue/2); // HALF AS COINS
	SCTreas_CreateGems(oMinion, nGoldValue/2);         // HALF AS GEMS
	for (i=1;i<=3;i++) SCTreas_CreateRandomPotion(oMinion, 2); // GIVE 3 RANDOM POTIONS (STACK OF 2)
	float fNoKD = IntToFloat(GetHitDice(oMinion)) * 30.0;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oMinion, fNoKD);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSeeInvisible(), oMinion, fNoKD);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN), oMinion, fNoKD); // GIVE IMMUNITY TO KNOCKDOWN FOR SHORT DURATION
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DEATH), oMinion, fNoKD); // GIVE IMMUNITY TO DEATH SPELLS FOR SHORT DURATION
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(GetHitDice(oMinion)/2), oMinion, fNoKD); // GIVE ATTACK BONUS FOR SHORT DURATION
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellImmunity(SPELL_BIGBYS_GRASPING_HAND), oMinion, fNoKD); // GIVE ATTACK BONUS FOR SHORT DURATION
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNWN2SpecialEffectFile("seed_boss_ring.sef"), oMinion);
	return oMinion;
}

void voidSpawnBoss(string sWhich, object oLocation, object oPC, int iBossEffect=TRUE)
{
	object oMinion = SpawnBoss(sWhich, oLocation, iBossEffect);
	//   SRM_RandomTreasure(TREASURE_HIGH, oMinion, oMinion);
	AssignCommand(oMinion, ActionAttack(oPC));
}

object DropEquippedItem(object oMinion, int iPCTChance=25, int iSlot=INVENTORY_SLOT_RIGHTHAND, string sNewTag="VALID")
{
	object oItem = GetItemInSlot(iSlot, oMinion);
	object oCopy = oItem;
	if (Random(100)<=iPCTChance)
	{
		oCopy = CopyObject(oItem, GetLocation(oMinion), oMinion, sNewTag);
		SetDroppableFlag(oCopy, TRUE);
		AssignCommand(oMinion, ActionEquipItem(oCopy, iSlot));
	}
	return oCopy;
}

// Pass in the 1 in iChance to spawn and the max level of the pc entering to spawn
int CheckRandomSpawn(int iChance, object oPC=OBJECT_INVALID, int iMaxLevel = 0)
{
	//if (Random(iChance))
	//{
	//	return FALSE;
	//}
	
	if (oPC!=OBJECT_INVALID && !GetIsPC(oPC))
	{
		return FALSE;
	}
	
	/*
	if (  iChance < 4 )
	{
		return TRUE; // IF NOT 0, EXIT
	}
	
	iChance = iChance / 4;
	
	*/
	if ( Random(iChance) )
	{
		return FALSE; // IF NOT 0, EXIT
	}
	

	// if (iMaxLevel!=0 && oPC!=OBJECT_INVALID) return (GetHitDice(oPC)<=iMaxLevel);
	return TRUE;
}

void HideWeapons(object oPC)// Puts away object's weapons
{
   AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)));
   AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)));
} // HideWeapons

void ResetSpawnState(object oEnc, float fWhen=60.0) // THIS NORMALLY WILL HAPPEN BASED ON BOSS RESPAWN RATE, USE THIS TO OVERRIDE IT
{
   AssignCommand(GetModule(), DelayCommand(fWhen, SetSpawnState(oEnc, SPAWN_STATE_READY)));
}