/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
// *
//////////////////////////////////////////////


/////////////////////////////////////////////				UPDATES
//
/////////////////////////////////////////////
// VERSION 1.2 - no updates needed
//
// VERSION 1.1 - no updates needed


/////////////////////////////////////////////				INCLUDED FILES
//
/////////////////////////////////////////////
// I need these for Tag Based Scripting.
#include "x2_inc_switches"
// I need the switch to see if damage shields are allowed.
#include "_SCInclude_Loot_c"
// I need the damage bonus constants for length of time and dmg.
//#include "fw_inc_misc"


/////////////////////////////////////////////				GLOBAL VARIABLES
//
/////////////////////////////////////////////

/////////////////////////////////////////////				FUNCTION DECLARATIONS
//
/////////////////////////////////////////////

////////////////////////////////////////////
// * Function that randomly chooses an DAMAGE_BONUS_* constant from min to max.
// * NOTE: This is only used for damage shields. Nothing else.  
// * This is not to be confused with IP_CONST_DAMAGEBONUS_*  
//
int FW_Choose_CONST_DAMAGE_BONUS (int min = FW_MIN_DAMAGE_SHIELD_BONUS, int max = FW_MAX_DAMAGE_SHIELD_BONUS);

////////////////////////////////////////////
// * Function that randomly chooses an DAMAGE_TYPE_* constant 
// * NOTE: This is only used for damage shields. Nothing else.  
// * This is not to be confused with IP_CONST_DAMAGETYPE_*  
//
int FW_Choose_CONST_DAMAGE_TYPE ();

//////////////////////////////////////////////////////////
// * Creates a random damage shield for a PC.
// 
void FW_Random_Reciprocal_Damage (object oItem, object oPC);


/////////////////////////////////////////////				IMPLEMENTATION
//
/////////////////////////////////////////////



////////////////////////////////////////////
// * Function that randomly chooses an DAMAGE_BONUS_* constant from min to max.
// * NOTE: This is only used for damage shields. Nothing else.  
// * This is not to be confused with IP_CONST_DAMAGEBONUS_*  
//
// TABLE: DAMAGE_BONUS
//
// INDEX = ITEM_PROPERTY...AVERAGE DAMAGE
//   0   = 1    damage  ...avg = 1
//   1   = 2    damage  ...avg = 2
//   2   = 1d4  damage  ...avg = 2.5
//   3   = 3    damage  ...avg = 3
//   4   = 1d6  damage  ...avg = 3.5
//   5   = 4    damage  ...avg = 4
//   6   = 1d8  damage  ...avg = 4.5
//   7   = 5    damage  ...avg = 5
//   8   = 2d4  damage  ...avg = 5
//   9   = 1d10 damage  ...avg = 5.5
//   10  = 6    damage  ...avg = 6
//   11  = 1d12 damage  ...avg = 6.5
//   12  = 7    damage  ...avg = 7
//   13  = 2d6  damage  ...avg = 7
//   14  = 8    damage  ...avg = 8
//   15  = 9    damage  ...avg = 9
//   16  = 2d8  damage  ...avg = 9
//   17  = 10   damage  ...avg = 10
//   18  = 11   damage  ...avg = 11
//   19  = 2d10 damage  ...avg = 11
//   20  = 12   damage  ...avg = 12
//   21  = 13   damage  ...avg = 13
//   22  = 2d12 damage  ...avg = 13
//   23  = 14   damage  ...avg = 14
//   24  = 15   damage  ...avg = 15
//   25  = 16   damage  ...avg = 16
//   26  = 17   damage  ...avg = 17
//   27  = 18   damage  ...avg = 18
//   28  = 19   damage  ...avg = 19
//   29  = 20   damage  ...avg = 20
//   30  = 21   damage  ...avg = 21
//   31  = 22   damage  ...avg = 22
//   32  = 23   damage  ...avg = 23
//   33  = 24   damage  ...avg = 24
//   34  = 25   damage  ...avg = 25
//   35  = 26   damage  ...avg = 26
//   36  = 27   damage  ...avg = 27
//   37  = 28   damage  ...avg = 28
//   38  = 29   damage  ...avg = 29
//   39  = 30   damage  ...avg = 30
//   40  = 31   damage  ...avg = 31
//   41  = 32   damage  ...avg = 32
//   42  = 33   damage  ...avg = 33
//   43  = 34   damage  ...avg = 34
//   44  = 35   damage  ...avg = 35
//   45  = 36   damage  ...avg = 36
//   46  = 37   damage  ...avg = 37
//   47  = 38   damage  ...avg = 38
//   48  = 39   damage  ...avg = 39
//   49  = 40   damage  ...avg = 40
//
// INDEX = ITEM_PROPERTY...AVERAGE DAMAGE
//
int FW_Choose_CONST_DAMAGE_BONUS (int min = FW_MIN_DAMAGE_SHIELD_BONUS, int max = FW_MAX_DAMAGE_SHIELD_BONUS)
{
   int iRoll = 0;
   int iDamage;
   if (min < 0)
      min = 0;
   if (min > 49)
      min = 49;
   if (max < 0)
      max = 0;
   if (max > 49)
      max = 49;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
   {
      iDamage = DAMAGE_BONUS_1;
   }
   else
   {
      int iValue = max - min + 1;
      iRoll = Random(iValue)+ min;
   }
   
   switch (iRoll)
   {
      case 0: iDamage = DAMAGE_BONUS_1;
         break;
      case 1: iDamage = DAMAGE_BONUS_2;
         break;
      case 2: iDamage = DAMAGE_BONUS_1d4;
         break;
      case 3: iDamage = DAMAGE_BONUS_3;
         break;
      case 4: iDamage = DAMAGE_BONUS_1d6;
         break;
      case 5: iDamage = DAMAGE_BONUS_4;
         break;
      case 6: iDamage = DAMAGE_BONUS_1d8;
         break;
      case 7: iDamage = DAMAGE_BONUS_5;
         break;
      case 8: iDamage = DAMAGE_BONUS_2d4;
         break;
      case 9: iDamage = DAMAGE_BONUS_1d10;
         break;
      case 10: iDamage = DAMAGE_BONUS_6;
         break;
      case 11: iDamage = DAMAGE_BONUS_1d12;
         break;
      case 12: iDamage = DAMAGE_BONUS_7;
         break;
      case 13: iDamage = DAMAGE_BONUS_2d6;
         break;
      case 14: iDamage = DAMAGE_BONUS_8;
         break;
      case 15: iDamage = DAMAGE_BONUS_9;
         break;
      case 16: iDamage = DAMAGE_BONUS_2d8;
         break;
      case 17: iDamage = DAMAGE_BONUS_10;
         break;
      case 18: iDamage = DAMAGE_BONUS_11;
         break;
      case 19: iDamage = DAMAGE_BONUS_2d10;
         break;
	  case 20: iDamage = DAMAGE_BONUS_11;
         break;
      case 21: iDamage = DAMAGE_BONUS_12;
         break;
      case 22: iDamage = DAMAGE_BONUS_2d12;
         break;
      case 23: iDamage = DAMAGE_BONUS_14;
         break;
      case 24: iDamage = DAMAGE_BONUS_15;
         break;
      case 25: iDamage = DAMAGE_BONUS_16;
         break;
      case 26: iDamage = DAMAGE_BONUS_17;
         break;
      case 27: iDamage = DAMAGE_BONUS_18;
         break;
      case 28: iDamage = DAMAGE_BONUS_19;
         break;
      case 29: iDamage = DAMAGE_BONUS_20;
         break;
	  case 30: iDamage = DAMAGE_BONUS_21;
         break;
      case 31: iDamage = DAMAGE_BONUS_22;
         break;
      case 32: iDamage = DAMAGE_BONUS_23;
         break;
      case 33: iDamage = DAMAGE_BONUS_24;
         break;
      case 34: iDamage = DAMAGE_BONUS_25;
         break;
      case 35: iDamage = DAMAGE_BONUS_26;
         break;
      case 36: iDamage = DAMAGE_BONUS_27;
         break;
      case 37: iDamage = DAMAGE_BONUS_28;
         break;
      case 38: iDamage = DAMAGE_BONUS_29;
         break;
      case 39: iDamage = DAMAGE_BONUS_30;
         break;
	  case 40: iDamage = DAMAGE_BONUS_31;
         break;
      case 41: iDamage = DAMAGE_BONUS_32;
         break;
      case 42: iDamage = DAMAGE_BONUS_33;
         break;
      case 43: iDamage = DAMAGE_BONUS_34;
         break;
      case 44: iDamage = DAMAGE_BONUS_35;
         break;
      case 45: iDamage = DAMAGE_BONUS_36;
         break;
      case 46: iDamage = DAMAGE_BONUS_37;
         break;
      case 47: iDamage = DAMAGE_BONUS_38;
         break;
      case 48: iDamage = DAMAGE_BONUS_39;
         break;
      case 49: iDamage = DAMAGE_BONUS_40;
         break;
      default: break;
   }   
   return iDamage;
}

////////////////////////////////////////////
// * Function that randomly chooses an DAMAGE_TYPE_* constant 
// * NOTE: This is only used for damage shields. Nothing else.  
// * This is not to be confused with IP_CONST_DAMAGETYPE_*  
//
int FW_Choose_CONST_DAMAGE_TYPE ()
{
   int iDamageType;
   int iRoll = Random (12);
   switch (iRoll)
   {
      case 0: iDamageType = DAMAGE_TYPE_BLUDGEONING;
         break;
      case 1: iDamageType = DAMAGE_TYPE_PIERCING;
         break;
      case 2: iDamageType = DAMAGE_TYPE_SLASHING;
         break;
      case 3: iDamageType = DAMAGE_TYPE_ACID;
         break;
      case 4: iDamageType = DAMAGE_TYPE_COLD;
         break;
      case 5: iDamageType = DAMAGE_TYPE_ELECTRICAL;
         break;
      case 6: iDamageType = DAMAGE_TYPE_FIRE;
         break;
      case 7: iDamageType = DAMAGE_TYPE_SONIC;
         break;
      case 8: iDamageType = DAMAGE_TYPE_NEGATIVE;
         break;
      case 9: iDamageType = DAMAGE_TYPE_POSITIVE;
         break;
      case 10: iDamageType = DAMAGE_TYPE_DIVINE;
         break;
      case 11: iDamageType = DAMAGE_TYPE_MAGICAL;
         break;
      default: break;
   }
   return iDamageType;
}

//////////////////////////////////////////////////////////
// * Creates a random damage shield for a PC.
// 
void FW_Random_Reciprocal_Damage (object oItem, object oPC)
{
	if (FW_ALLOW_DAMAGE_SHIELDS == FALSE)
		return;
	    
	// Determine Static Amount of Damage.
	int nPCLevel = GetHitDice (oPC);	
		
	// Determine Random Amount of Damage.
	int nRandomAmount = FW_Choose_CONST_DAMAGE_BONUS();
	// Determine the Damage Type.
	int iDamageType = FW_Choose_CONST_DAMAGE_TYPE();
	string sDamageType;
	switch(iDamageType)
	{
		case DAMAGE_TYPE_ACID: sDamageType        = " Acid Damage. ";  break;
		case DAMAGE_TYPE_BLUDGEONING: sDamageType = " Bludgeoning Damage. ";  break;
		case DAMAGE_TYPE_COLD: sDamageType        = " Cold Damage. ";  break;
		case DAMAGE_TYPE_DIVINE: sDamageType      = " Divine Damage. ";  break;
		case DAMAGE_TYPE_ELECTRICAL: sDamageType  = " Electrical Damage. ";  break;
		case DAMAGE_TYPE_FIRE: sDamageType        = " Fire Damage. ";  break;
		case DAMAGE_TYPE_MAGICAL: sDamageType     = " Magical Damage. ";  break;
		case DAMAGE_TYPE_NEGATIVE: sDamageType    = " Negative Damage. ";  break;
		case DAMAGE_TYPE_PIERCING: sDamageType    = " Piercing Damage. ";  break;
		case DAMAGE_TYPE_POSITIVE: sDamageType    = " Positive Damage. ";  break;
		case DAMAGE_TYPE_SLASHING: sDamageType    = " Slashing Damage. ";  break;
		case DAMAGE_TYPE_SONIC: sDamageType       = " Sonic Damage. ";  break;	
		
		default: break;
	}
	// Determine Length of Damage Shield.	
	int nLengthTime;
	float fLengthTime;	
	int min = FW_MIN_DAMAGE_SHIELD_LENGTH_TIME;
	int max = FW_MAX_DAMAGE_SHIELD_LENGTH_TIME;
	if (min < 1)
		min = 1;
	if (max < 1)
		max = 1;	
	if (min > max)
    {
    	nLengthTime = max;
    }
    else
    {
     	int iValue = max - min + 1;
      	nLengthTime = Random(iValue)+ min;
    }
	fLengthTime = IntToFloat(nLengthTime);	
	// Create the effect.
    effect eEffect = EffectDamageShield (nPCLevel, nRandomAmount, iDamageType);
	effect eVisEffect = EffectVisualEffect(VFX_DUR_SPELL_PROT_ENERGY);
	// Link the effects so that when one ends, the other does too.
	effect eLink = EffectLinkEffects (eEffect, eVisEffect);
    // Apply the linked effect.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fLengthTime);	
	
	// Set the name on the item to reflect the damage it will do.
	string sDamageAmount = IntToString(nPCLevel);
	string sRandomAmountLabel = Get2DAString ("iprp_damagecost", "Label", nRandomAmount);
	string sLengthTime = IntToString(nLengthTime);
		
	string sDescription;	
	sDescription = "     Long long ago, an ancient scholar named 'cdaulepp' sought knowledge where no one " +
		"had previously sought it.  His research lead him to discover a whole new " +
		"realm of defensive magical powers that he eventually learned to control.  " +
		"The Lesser and Greater Gods, unaware of this power's existence, had " +
		"not claimed it for their own portfolios.  Once mastered, cdaulepp used this power " +
		"to ascend to Godhood several millenia ago.  His magic portfolio, mainly of " +		
		"a defensive nature, was used to surround himself in a sphere of defensive " +
		"magical shields that protected him from the other Gods.  \n     Legend has it that " +
		"artifacts dating from the time of cdaulepp's mortal existence and studies " +
		"still survive today.  Those artifacts, the rarest of all treasure, are " +
		"actually some of his experiments that failed.  These rejected items are " +
		"imbued with lesser versions of the defensive shields that cdaulepp uses " +
		"to protect himself.  If you should be so lucky as to be reading this message " +
		"it means you have found one of those rarest of rare artifacts.  Activate this " +
		"item and surround yourself in the power and protection of cdaulepp, the " +
		"ultimate master.  \n \n";		
	
	// Send a message to the PC telling him what the item does in 
	// case he doesn't inspect the item. 	
	string szMessage =  "     Damage shield activated. Damage dealt is your PC level: " + sDamageAmount +
						" + " + sRandomAmountLabel + sDamageType + "The damage shield will last for: " + 
						IntToString(nLengthTime) + " seconds.";
	
	string szPCMessage = sDescription + szMessage;					
	// In case the PC doesn't examine the item again, send them a message
	// telling them what the damage shield does.						
	SendMessageToPC (oPC, szPCMessage);	
	
	// Get current item description.
	string sOriginalDescription = GetDescription (oItem);	
	string sUpdatedDescription = sOriginalDescription + szMessage;
	SetDescription (oItem, sUpdatedDescription);
	
	// When damage shield effect ends, change description back to normal.
	float fDelayTimer = fLengthTime + 2.0;
	DelayCommand (fDelayTimer, SetDescription (oItem, sOriginalDescription));  
}


/////////////////////////////////////////////				MAIN
//
/////////////////////////////////////////////

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;
	// Debug
    // SendMessageToPC(GetFirstPC(),IntToString(nEvent));
	
	int iResult = X2_EXECUTE_SCRIPT_END;

    // * This code runs when the item has the OnHitCastSpell: Unique power property
    // * and it hits a target(weapon) or is being hit (armor)
    // * Note that this event fires for non PC creatures as well.
    if (nEvent ==X2_ITEM_EVENT_ONHITCAST)
    {
        oItem  =  GetSpellCastItem();                  // The item casting triggering this spellscript
        object oSpellOrigin = OBJECT_SELF ;
        object oSpellTarget = GetSpellTargetObject();
        oPC = OBJECT_SELF;

    }

    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    else if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {

        oPC   = GetItemActivator();
        oItem = GetItemActivated();
		FW_Random_Reciprocal_Damage (oItem, oPC);

    }

    // * This code runs when the item is equipped
    // * Note that this event fires PCs only
    else if (nEvent ==X2_ITEM_EVENT_EQUIP)
    {

        oPC = GetPCItemLastEquippedBy();
        oItem = GetPCItemLastEquipped();
		
    }

    // * This code runs when the item is unequipped
    // * Note that this event fires PCs only
    else if (nEvent ==X2_ITEM_EVENT_UNEQUIP)
    {

        oPC    = GetPCItemLastUnequippedBy();
        oItem  = GetPCItemLastUnequipped();		

    }
    // * This code runs when the item is acquired
    // * Note that this event fires PCs only
    else if (nEvent == X2_ITEM_EVENT_ACQUIRE)
    {

        oPC = GetModuleItemAcquiredBy();
        oItem  = GetModuleItemAcquired();
    }

    // * This code runs when the item is unaquire d
    // * Note that this event fires PCs only
    else if (nEvent == X2_ITEM_EVENT_UNACQUIRE)
    {

        oPC = GetModuleItemLostBy();
        oItem  = GetModuleItemLost();
    }

    //* This code runs when a PC or DM casts a spell from one of the
    //* standard spellbooks on the item
    else if (nEvent == X2_ITEM_EVENT_SPELLCAST_AT)
    {

        oPC = GetModuleItemLostBy();
        oItem  = GetModuleItemLost();
    }
	SetExecutedScriptReturnValue (iResult);
}