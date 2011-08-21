/** @file
* @brief Spell Function Wrappers and Hooks to replace the engines spell casting functions
*
* 
* 
*
* @ingroup hkspell
* @author Brian T. Meyer and others
*/


//search for nDamage = nDamage / 2;
/*
int SAVING_THROW_ALL                    = 0;
int SAVING_THROW_FORT                   = 1;
int SAVING_THROW_REFLEX                 = 2;
int SAVING_THROW_WILL                   = 3;

int SAVING_THROW_CHECK_FAILED           = 0;
int SAVING_THROW_CHECK_SUCCEEDED        = 1;
int SAVING_THROW_CHECK_IMMUNE           = 2;
*/
/*
int SAVING_THROW_CHECK_FAILED           = 0;
int SAVING_THROW_CHECK_SUCCEEDED        = 1;
int SAVING_THROW_CHECK_IMMUNE           = 2;
*/
const int SAVING_THROW_RESULT_FAILED = 0;
const int SAVING_THROW_RESULT_SUCCESS = 1;
const int SAVING_THROW_RESULT_IMMUNE = 2;
const int SAVING_THROW_RESULT_ROLL = 3; // use this to test for success, this can be used to get the correct result if the saving throw was done earlier in the script
const int SAVING_THROW_RESULT_REMEMBER = 4; // use this to make the saving throw against this spell casting or AOE unique, whatever is rolled the first time is maintained on a per target basis


const int SAVING_THROW_ADJUSTED_NODAMAGE = 0;
const int SAVING_THROW_ADJUSTED_PARTIALDAMAGE = 1;
const int SAVING_THROW_ADJUSTED_FULLDAMAGE = 2;

/*
int SAVING_THROW_TYPE_ALL               = 0;
int SAVING_THROW_TYPE_NONE              = 0;
int SAVING_THROW_TYPE_MIND_SPELLS       = 1;
int SAVING_THROW_TYPE_POISON            = 2;
int SAVING_THROW_TYPE_DISEASE           = 3;
int SAVING_THROW_TYPE_FEAR              = 4;
int SAVING_THROW_TYPE_SONIC             = 5;
int SAVING_THROW_TYPE_ACID              = 6;
int SAVING_THROW_TYPE_FIRE              = 7;
int SAVING_THROW_TYPE_ELECTRICITY       = 8;
int SAVING_THROW_TYPE_POSITIVE          = 9;
int SAVING_THROW_TYPE_NEGATIVE          = 10;
int SAVING_THROW_TYPE_DEATH             = 11;
int SAVING_THROW_TYPE_COLD              = 12;
int SAVING_THROW_TYPE_DIVINE            = 13;
int SAVING_THROW_TYPE_TRAP              = 14;
int SAVING_THROW_TYPE_SPELL             = 15;
int SAVING_THROW_TYPE_GOOD              = 16;
int SAVING_THROW_TYPE_EVIL              = 17;
int SAVING_THROW_TYPE_LAW               = 18;
int SAVING_THROW_TYPE_CHAOS             = 19;
*/

// keep these in order of ascending damage so >  and <  type operators can be used
int SAVING_THROW_METHOD_FORNODAMAGE = 1;
int SAVING_THROW_METHOD_FORQUARTERDAMAGE = 2;
int SAVING_THROW_METHOD_FORHALFDAMAGE = 3;
int SAVING_THROW_METHOD_FORPARTIALDAMAGE = 4;
int SAVING_THROW_METHOD_FORTHREEQUARTERDAMAGE = 5;
int SAVING_THROW_METHOD_FORFULLDAMAGE = 6;


//#include "_SCMessages"
#include "_CSLCore_Strings"
#include "_CSLCore_Time"
#include "_CSLCore_Messages"
#include "_CSLCore_Visuals"

#include "_CSLCore_Info"
#include "_CSLCore_Magic"
#include "_CSLCore_Feats"
#include "_CSLCore_Class"
#include "_CSLCore_Appearance"

#include "_CSLCore_Magic_c"
#include "_CSLCore_Descriptor"
#include "_CSLCore_Combat"
#include "_CSLCore_Position"
#include "_CSLCore_Environment"
#include "_CSLCore_Player"


//#include "x2_inc_spellhook"
#include "_SCInclude_CacheStats"


void HkPreCast( object oCaster = OBJECT_SELF, int iSpellId = -1, int iDescriptor = -1, int iClass = 255, int iSpellLevel = -1, int iSpellSchool = -1, int iSpellSubSchool = -1, int iAttributes = -1 );
void HkPostCast( object oCaster = OBJECT_SELF);
int HkCounterSpellHookCasting( object oCaster, int iSpellId, int iSpellLevel = 1, int iClass = 255, int iSpellSchool = -1, int iAttributes = -1 );
int HkGetSpellId( object oCaster = OBJECT_SELF, int iForce = FALSE );
int HkGetSpellLevel(int iSpellId = -1, int iClass = 255, object oCaster = OBJECT_SELF );
int HkGetSpellClass( object oCaster = OBJECT_SELF );
int HkPrepGetClassRowFromCache( object oChar, int iClass );
int HkGetSpellPower( object oChar = OBJECT_SELF, int iMaxPower = 60, int iClass = 255 );
int HkDispelDC( object oCreator, int iClass  = 255 );
int HkDispelCheck( object oCaster, int iDispelSpellID = -1, int iClass  = 255 );
void HkApplyEffectToObject( int iDurationType, effect eEffect, object oTarget, float fDuration=0.0f, int iSpellId = -1, object oCaster = OBJECT_SELF, int iClass = 255 );
int HkCheckSpellResistance( object oCaster, object oTarget );
int HkCheckSpellMantle( object oCaster, object oTarget );
int HkCheckSpellImmunity( object oCaster, object oTarget );
int HkCheckSpellTurning( object oCaster, object oTarget );
void HkTransferCasterModifiersToTarget( object oTarget, object oCaster );
int HkHasSpellAbsorption( object oTarget );
int HkGetSpellResistance( object oTarget );
void HkResetMetaModifierVars( object oCaster );
int HkGetItemCasterLevel( object oItem, object oChar = OBJECT_SELF );
int HkGetScrollLevel( object oItem, object oChar = OBJECT_SELF );
int HkApplyTouchAttackDamage( object oTarget, int iTouch, int iDamage, int iAttackType = SC_TOUCH_UNKNOWN, object oAttacker = OBJECT_SELF );
void HkApplyTargetTag( object oTarget, object oCaster = OBJECT_SELF, int iSpellId = -1, int iClass = 255 , float fDuration = -1.0f );
int HkGetCreatorLevelSkew( int iLevel = -1 );

// placeholder for when i do mana
//Decrements the number of spell charges
//  object oPC, the subject losing a charge
void HkDecrementSpellCharges(object oPC)
{
    //int nCharges= GetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
   // SetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT, nCharges - 1);
   // FloatingTextStringOnCreature("Charges Remaining: " + IntToString(nCharges - 1), oPC);
}


void HkSetTotalSpellCharges(object oPC)
{
    //int nCharges= GetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
   // SetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT, nCharges - 1);
   // FloatingTextStringOnCreature("Charges Remaining: " + IntToString(nCharges - 1), oPC);
}


/**  
* Runs the spell Hook and Prepares the spell data such as the spellid, class, descriptor, school, and other attributes for later functions as well as determining if the given spell can be cast.
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iDescriptor The SCMETA_DESCRIPTOR_* constants ( stored bitwise ) for the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param iSpellLevel The level of the current spell from 0 ( Cantrip ) to 10 ( Epic )
* @param iSpellSchool The SPELL_SCHOOL_* constant with the school for the current spell
* @param iSpellSubSchool The SPELL_SUBSCHOOL_* constant with the subschool for the current spell
* @param iAttributes The SCMETA_ATTRIBUTES_* constants ( stored bitwise ) for the current spell
* @see HkPreCast
* @return Boolean, True indicates the spell can run, False that the script should exit 
*/
int HkPreCastHook( object oCaster = OBJECT_SELF, int iSpellId = -1, int iDescriptor = -1, int iClass = 255, int iSpellLevel = -1, int iSpellSchool = -1, int iSpellSubSchool = -1, int iAttributes = -1 )
{
	HkPreCast( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes );
	
	if ( CSLReadIntModifier( oCaster, "Blocked" ) == TRUE) // HKTEMP_Blocked
	{
		HkPostCast( oCaster );
		return FALSE;
	}	
	
	
	if ( HkCounterSpellHookCasting( oCaster, iSpellId, iSpellLevel, iClass, iSpellSchool, iAttributes ) )
	{
		SendMessageToPC( oCaster, "Counterspelled" );
		
		HkPostCast( oCaster );
		return FALSE;
	}
	
	/// pre cast from the OEI version
	
	object oTarget = GetSpellTargetObject();
   int nContinue = TRUE;
   
   //---------------------------------------------------------------------------
   // This stuff is only interesting for player characters we assume that use
   // magic device always works and NPCs don't use the crafting feats or
   // sequencers anyway. Thus, any NON PC spellcaster always exits this script
   // with TRUE (unless they are DM possessed or in the Wild Magic Area in
   // Chapter 2 of Hordes of the Underdark.
   //---------------------------------------------------------------------------
   if (!GetIsPC(OBJECT_SELF))
   {
       if( !GetIsDMPossessed(OBJECT_SELF) && !GetLocalInt(GetArea(OBJECT_SELF), "X2_L_WILD_MAGIC"))
       {
            return TRUE;
       }
   }

   //---------------------------------------------------------------------------
   // Break any spell require maintaining concentration (only black blade of
   // disaster)
   // /*REM*/ X2BreakConcentrationSpells();
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // Run use magic device skill check
   //---------------------------------------------------------------------------
   nContinue = ExecuteScriptAndReturnInt("x2_pc_umdcheck",OBJECT_SELF); // X2UseMagicDeviceCheck();

   if (nContinue)
   {
       //-----------------------------------------------------------------------
       // run any user defined spellscript here
       //-----------------------------------------------------------------------
       string sScript = GetModuleOverrideSpellscript();
		if (sScript != "")
		{
			ExecuteScript(sScript,OBJECT_SELF);
			if ( GetModuleOverrideSpellScriptFinished() == TRUE )
			{
			 	nContinue = FALSE;
				if (DEBUGGING >= 5) { CSLDebug("Module override script  "+IntToString(nContinue) ); }
			}
		}
   }

   //---------------------------------------------------------------------------
   // The following code is only of interest if an item was targeted
   //---------------------------------------------------------------------------
   if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
   {

       //-----------------------------------------------------------------------
       // Check if spell was used to trigger item creation feat
       //-----------------------------------------------------------------------
       if (nContinue) 
       {
           nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft",OBJECT_SELF);
           if (DEBUGGING >= 5) { CSLDebug("xp craft  "+IntToString(nContinue) ); }
       }

       //-----------------------------------------------------------------------
       // Check if spell was used for on a sequencer item
       //-----------------------------------------------------------------------
       if (nContinue)
       {
            nContinue = (!CSLGetSpellCastOnSequencerItem(oTarget));
            if (DEBUGGING >= 5) { CSLDebug("Sequencer  "+IntToString(nContinue) ); }
       }

       //-----------------------------------------------------------------------
       // * Execute item OnSpellCast At routing script if activated
       //-----------------------------------------------------------------------
       if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
       {
             SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
             int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget),OBJECT_SELF);
             if (nRet == X2_EXECUTE_SCRIPT_END)
             {
                HkPostCast( oCaster );
				if (DEBUGGING >= 5) { CSLDebug("Tagged Based end" ); }
				return FALSE;
             }
       }

	   /* Brock H. - OEI 07/05/06 - Removed for NWN2
	   
       //-----------------------------------------------------------------------
       // Prevent any spell that has no special coding to handle targetting of items
       // from being cast on items. We do this because we can not predict how
       // all the hundreds spells in NWN will react when cast on items
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = X2CastOnItemWasAllowed(oTarget);
       }
	   */
   }

	//---------------------------------------------------------------------------
	// The following code is only of interest if a placeable was targeted
	//---------------------------------------------------------------------------
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{	// spells going off on crafting workbenches causes to much carnage.  
		// Maybe we should have the spells actually fire in hard core mode... 
		// Although death by labratory experiment might be too much even for the hard core... ;)
		// We turn off effects for all workbenches just to avoid any confusion.
		// since the spell won't fire or signal the cast event, we do so here.
		if ( CSLIsWorkbench(oTarget) )
		{
			
			
			
			nContinue = FALSE;
			if (DEBUGGING >= 5) { CSLDebug("Work Bench" ); }
		    //Fire "cast spell at" event on a workbench. (only needed for magical workbenches currently)
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
		}
	}
   
	
	
	if ( !nContinue )
	{
		HkPostCast( oCaster );
		if (DEBUGGING >= 5) { CSLDebug("No Continue on precast" ); }
		return FALSE;
	}
	return TRUE;
}



/**  
* Prepares the spell data such as the spellid, class, descriptor, school, and other attributes for later functions as well as determining if the given spell can be cast. Generally HkPreCastHook is used instead, but this is useful if you need to call it in a function. This being used should be paired with HkPostCast at the end of the script.
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iDescriptor The Descriptor for the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param iSpellLevel = -1
* @param iSpellSchool = -1
* @param iSpellSubSchool = -1
* @param iAttributes = -1
* @see HkPreCastHook
*/ 
void HkPreCast( object oCaster = OBJECT_SELF, int iSpellId = -1, int iDescriptor = -1, int iClass = 255, int iSpellLevel = -1, int iSpellSchool = -1, int iSpellSubSchool = -1, int iAttributes = -1 )
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	if (DEBUGGING >= 8) { CSLDebug("HkPreCast 1", oCaster ); }
	
	// set the unique identifier for this spell casting script being run, used to identify the spell and to 
	CSL_SPELLCAST_SERIALID = CSLGetRandomSerialNumber( CSL_SPELLCAST_SERIALID );
	
	// if ( GetIsSinglePlayer() ) {DEBUGGING = 9;}
	// These are to make sure this information is figured out already, just double checking things really
	if ( iSpellId == -1 )
	{
		iSpellId = HkGetSpellId();
	}
	
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCaster );
	}
	
	if ( iDescriptor == -1 )
	{
		iDescriptor = 0;
	}
	
	if ( iSpellSchool == -1 )
	{
		iSpellSchool = 0;
	}
	
	if ( iSpellLevel == -1 )
	{
		iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	}
	
	if (DEBUGGING >= 8) { CSLDebug("HkPreCast 2", oCaster ); }
	
	
	// AOE's are mostly hardcoded, so this should not be a factor
	if ( GetObjectType( OBJECT_SELF ) != OBJECT_TYPE_AREA_OF_EFFECT )
	{
		string sDeity = "";
		if ( CSLGetBaseCasterType( iClass ) == SC_SPELLTYPE_DIVINE )
		{
			sDeity = GetDeity( oCaster );
		}
		
		
		SetLocalInt( oCaster, "HKTEMP_SpellId", iSpellId+1 );
		SetLocalInt( oCaster, "HKTEMP_SpellLevel", iSpellLevel+1 );
		SetLocalInt( oCaster, "HKTEMP_Class", iClass+1 );
		SetLocalInt( oCaster, "HKTEMP_Descriptor", iDescriptor );
		SetLocalInt( oCaster, "HKTEMP_School", iSpellSchool );
		SetLocalInt( oCaster, "HKTEMP_SubSchool", iSpellSubSchool );//HkGetReflexAdjustedDamage 
		SetLocalInt( oCaster, "HKTEMP_Attributes", iAttributes );//HkGetReflexAdjustedDamage 
		
		string sModifierScript;
		string sLastScript; // this does some to prevent the same script from running more than once, i am assuming that triggers are going to be simple and this is to handle exceptional cases only
		
		// Adjust for Class Modifiers
		ExecuteScript("_SCDexClassHooks", oCaster);
		//SendMessageToPC(oCaster, "Running Class Script _SCDexClassHooks");
		
		
		
		int iCasterState = CSLEnviroObjectGetStatus( oCaster );
		int iCasterCharState = GetLocalInt( oCaster, "CSL_CHARSTATE" );
		int iTargetState = 0;
		int iTargetCharState = -1;
		location lTargetLocation;
		
		object oTarget = GetSpellTargetObject();
		if (  GetIsObjectValid(oTarget)  )
		{
			if ( oTarget == oCaster )
			{
				iTargetState = iCasterState;
				iTargetCharState = iCasterCharState;
			}
			else
			{
				iTargetState = CSLEnviroObjectGetStatus( oTarget );
				iTargetCharState = GetLocalInt( oTarget, "CSL_CHARSTATE" );
			}
		}
		else
		{
			lTargetLocation = GetSpellTargetLocation();
			iTargetState = CSLEnviroLocationGetStatus( lTargetLocation );
			
			if ( iTargetState & CSL_ENVIRO_WATER )
			{
				float fWaterHeight = CSLEnviroGetWaterHeightAtLocation( lTargetLocation );
				if ( fWaterHeight == 0.0f )
				{
					iTargetState &= ~CSL_ENVIRO_WATER;
				}
				else
				{
					vector vPosition = GetPositionFromLocation( lTargetLocation );
					if (  fWaterHeight < vPosition.z )
					{
						iTargetState &= ~CSL_ENVIRO_WATER;
					}
				}
			}
			//
		}
		
		SetLocalInt( oCaster, "HKTEMP_TargetState", iTargetState );
		
		if ( !CSLEnviroSpellHookCasterCheck( iCasterState, iCasterCharState, oCaster, iSpellId, iDescriptor,iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes  ) )
		{
			SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
			return;
		}
		
		if ( !CSLEnviroSpellHookTargetCheck( iTargetState, iTargetCharState, oCaster, iSpellId, iDescriptor,iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
		{
			SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
			return;
		}
		
		
		
		// this runs up to 4, not really needed anymore but might be useful to some
		sModifierScript = GetLocalString( oCaster, "MODIFIERSCRIPT");
		if ( sModifierScript != "" && sLastScript != sModifierScript )
		{
			//SendMessageToPC(oCaster, "Running Script "+sModifierScript);
			if (  sLastScript != sModifierScript ) { ExecuteScript( sModifierScript , oCaster); sLastScript = sModifierScript; }
			sModifierScript = GetLocalString( oCaster, "MODIFIERSCRIPT2");
			if ( sModifierScript != "" )
			{
				//SendMessageToPC(oCaster, "Running Script "+sModifierScript);
				if (  sLastScript != sModifierScript ) { ExecuteScript( sModifierScript , oCaster); sLastScript = sModifierScript; }
				
				sModifierScript = GetLocalString( oCaster, "MODIFIERSCRIPT3");
				if ( sModifierScript != "" && sLastScript != sModifierScript )
				{
					//SendMessageToPC(oCaster, "Running Script "+sModifierScript);
					if (  sLastScript != sModifierScript ) { ExecuteScript( sModifierScript , oCaster); sLastScript = sModifierScript; }
					sModifierScript = GetLocalString( oCaster, "MODIFIERSCRIPT4");
					if ( sModifierScript != "" && sLastScript != sModifierScript )
					{
						//SendMessageToPC(oCaster, "Running Script "+sModifierScript);
						if (  sLastScript != sModifierScript ) { ExecuteScript( sModifierScript , oCaster); sLastScript = sModifierScript; }
					}
				}
			}
			
		}
		if (DEBUGGING >= 8) { CSLDebug("HkPreCast 3", oCaster ); }
		
		sModifierScript = GetLocalString( GetArea(oCaster), "MODIFIERSCRIPT");
		if ( sModifierScript != "" && sLastScript != sModifierScript )
		{
			//SendMessageToPC(oCaster, "Running Area Script "+sModifierScript);
			if (  sLastScript != sModifierScript ) { ExecuteScript( sModifierScript , oCaster); sLastScript = sModifierScript; }
		}
		
		
		/*
		
		if ( GetLocalInt(oCaster, "SCMOD_VARSACTIVE") == TRUE )
		{
			iDescriptor = CSLReadSpellModifierVars( oCaster, oCaster, iDescriptor, iSpellId, iClass, iSpellSchool, iSpellSubSchool, sDeity   );
		}
		
		if ( GetLocalInt( GetArea(oCaster), "SCMOD_VARSACTIVE") == TRUE )
		{
			iDescriptor = CSLReadSpellModifierVars( GetArea(oCaster), oCaster, iDescriptor,  iSpellId, iClass, iSpellSchool, iSpellSubSchool, sDeity  );
		}
		*/
		
		// lets deal with classes first
		
		//iDescriptor = CSLApplyClassSpellModifiers( oCaster, iDescriptor,  iSpellId, iClass, iSpellSchool, iSpellSubSchool, sDeity  );

		
		
		
	}
	if (DEBUGGING >= 8) { CSLDebug("HkPreCast 4", oCaster ); }
	// it might be wiser to just set temporary vars on the caster, which i remove after casting 
	
	
	if (DEBUGGING >= 8) { CSLDebug("Spell Sub School is "+CSLSubSchoolToString( iSpellSubSchool )+" Class: "+IntToString(iClass)+" SpellId: "+IntToString(iSpellId), oCaster ); }
}


/**  
* Manages area modifier spellhooks, which are smaller special purpose spellhooks that come into play in specific areas and can be stacked
* You can have multiple spellhooks, up to 4 of them in place at once This
* function manages what is active at any given time, adding more than 4
* will remove the oldest from the stack, 5th var is used to preserve this
* If more than 4 then it is likely implemented wrong, it's really should
* only have 2 at the same time at most, make a new Hook which combines the
* 2 effects
* This is something which allows some complexity to be added, but keep it simple, 
* it's not really designed for complicated triggers, but to deal with simpler issues.
* @param oCaster The caster of the current spell
* @param sHookName = ""
* @param bAddScript TRUE makes the modifier spellhook active while FALSE deletes the modifier spellhook
*/
void HkSetModifierHook( object oCaster = OBJECT_SELF, string sHookName = "", int bAddScript = TRUE)
{
	string sModifierScript1 = GetLocalString( oCaster, "MODIFIERSCRIPT");
	string sModifierScript2 = GetLocalString( oCaster, "MODIFIERSCRIPT2");
	string sModifierScript3 = GetLocalString( oCaster, "MODIFIERSCRIPT3");
	string sModifierScript4 = GetLocalString( oCaster, "MODIFIERSCRIPT4");
	string sModifierScriptB = GetLocalString( oCaster, "MODIFIERSCRIPTB");
	
	//if ( bAddOrRemove == FALSE )
	//{
	// prevents duplicates
	if ( sHookName != "")
	{
		if ( sModifierScript1 == sHookName )
		{
			sModifierScript1 = "";
		}
		else if ( sModifierScript2 == sHookName )
		{
			sModifierScript2 = "";
		}
		else if ( sModifierScript3 == sHookName )
		{
			sModifierScript3 = "";
		}
		else if ( sModifierScript4 == sHookName )
		{
			sModifierScript4 = "";
		}
		else if ( sModifierScriptB == sHookName )
		{
			sModifierScriptB = "";
		}
	}
	//}
	//else 
	if ( bAddScript && sHookName != "" )
	{
		sModifierScriptB = sModifierScript4;
		sModifierScript4 = sModifierScript3;
		sModifierScript3 = sModifierScript2;
		sModifierScript2 = sModifierScript1;
		sModifierScript1 = sHookName;
	}
	
	
	// Now compact the variables so that they are in order
	// need to figure a better way to do this
	// might be better to just work on it all as a larger single string and split
	// Only one should be removed at a time, so this should be enough
	
	// i dont want to deal with duplicates they will just run and that would cause an issue if  a trigger is inside another trigger and it removes the outer triggers script
	// some duplicate handling would be nice in the execution phase perhaps.
	if ( sModifierScript1 == "" )
	{
		sModifierScript1 = sModifierScript2;
		sModifierScript2 = "";
	}
	
	if ( sModifierScript2 == "" )
	{
		sModifierScript2 = sModifierScript3;
		sModifierScript3 = "";
	}
	
	if ( sModifierScript3 == "" )
	{
		sModifierScript3 = sModifierScript4;
		sModifierScript4 = "";
	}
	
	if ( sModifierScript4 == "" )
	{
		sModifierScript4 = sModifierScriptB;
		sModifierScriptB = "";
	}
	SetLocalString( oCaster, "MODIFIERSCRIPT", sModifierScript1);
	SetLocalString( oCaster, "MODIFIERSCRIPT2", sModifierScript2);
	SetLocalString( oCaster, "MODIFIERSCRIPT3", sModifierScript3);
	SetLocalString( oCaster, "MODIFIERSCRIPT4", sModifierScript4);
	SetLocalString( oCaster, "MODIFIERSCRIPTB", sModifierScriptB);
	
	if ( sModifierScriptB != "" )
	{
		SendMessageToPC( oCaster, "Modifier Hook Script Overflow, please inform your the maker of the module that "+sModifierScriptB+" is not going to work correctly" );
	}
}

/**
* Cleans up after a spell has been cast
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces SCPostCast
*/
void HkPostCast( object oCaster = OBJECT_SELF)
{
	HkResetMetaModifierVars(  oCaster  ); // make sure nothing is polluting things here
	return;
}


/*
Counterspells ( players handbook page 170 )
It is possible to cast any spell as a counterspell. By doing so, you are using the spell's energy to
disrupt the casting of the same spell by another character. Counterspelling works even if one spell
is divine and the other arcane.

How Counterspells Work: To use a counterspell, you must select an opponent as the target of the
counterspell. You do this by choosing the ready action (page 160). In doing so, you elect to wait to
complete your action until your opponent tries to cast a spell. (You may still move your speed,
since ready is a standard action.)

If the target of your counterspell tries to cast a spell, make a Spellcraft check (DC 15 + the
spell's level). This check is a free action. If the check succeeds, you correctly identify the
opponent's spell and can attempt to counter it. If the check fails, you can't do either of these
things.

To complete the action, you must then cast the correct spell. As a general rule, a spell can only
counter itself. For example, a fireball spell is effective as a counter to another fireball spell,
but not to any other spell, no matter how similar. Fireball cannot counter delayed blast fireball or
vice versa. If you are able to cast the same spell and you have it prepared (if you prepare spells),
you cast it, altering it slightly to create a counterspell effect. If the target is within range,
both spells automatically negate each other with no other results.

Counterspelling Metamagic Spells: Metamagic feats are not taken into account when determining
whether a spell can be countered. For example, a normal fireball can counter a maximized fireball
(that is, a fireball that has been enhanced by the metamagic feat Maximize Spell) and vice versa.

Specific Exceptions: Some spells specifically counter each other, especially when they have
diametrically opposed effects. For example, you can counter a haste spell with a slow spell as well
as with another haste spell, or you can counter reduce person with enlarge person.

Dispel Magic as a Counterspell: You can use dispel magic to counterspell another spellcaster, and
you don't need to identify the spell he or she is casting. However, dispel magic doesn't always work
as a counterspell. The spell targets a spellcaster and is cast as a counterspell (page 170). Unlike
a true counterspell, however, dispel magic may not work; you must make a dispel check to counter the
other spellcaster's spell.

Reaving Dispel being used will allow you to redirect the cast spell, if
damaging the caster will attack himself, and if beneficial it will be applied to the countering
mage. ( need to research this )
*/


/**
* Makes a caster stop counterspelling
* Run after action, action cancel, death, rest, anything really to clean up
* @param oCounterSpeller The spellcaster who is currently counterspelling
* @param bShowCancel If false will hide any messages
* @see
* @replaces
*/
void HkCounterSpellTargetingEnd( object oCounterSpeller, int bShowCancel = TRUE )
{
	int iSlotNumber = GetLocalInt( oCounterSpeller, "CSL_COUNTERSPELLING" );
	if ( iSlotNumber )
	{
		object oTarget = GetLocalObject( oCounterSpeller, "CSL_COUNTERSPELLTARGET" );
		if ( GetIsObjectValid( oTarget ) )
		{
			DeleteLocalObject( oTarget, "CSL_COUNTERSPELLER"+IntToString(iSlotNumber) );
			CSLDecrementLocalInt( oTarget, "CSL_COUNTERSPELLED", 1, TRUE );
			if ( bShowCancel )
			{
				SetGUIObjectHidden( oCounterSpeller, "SCREEN_HOTBAR", "counterspellOn-btn", FALSE ); // shows
				SetGUIObjectHidden( oCounterSpeller, "SCREEN_HOTBAR", "counterspellOff-btn", TRUE ); // hides
				SendMessageToPC( oCounterSpeller, "You End Counterspelling "+GetName( oTarget ) );
			}
		}
		
	}
	// clear off any variables on the counterspeller
	DeleteLocalObject( oCounterSpeller, "CSL_COUNTERTARGET" );
	DeleteLocalInt( oCounterSpeller, "CSL_COUNTERSPELLING" );
}

/**
* Removes the countering action from a given target, interupting the caster who is countering, and used to clean up things upon death and rest or at the end of combat.
* This is applied to the target of the spell being countered, generally in the on death events, and it is used to remove all those who might be countering them
* @param oTarget The target to remove the effect from
* @see
* @replaces
*/
void HkCounterSpellRemoveEffect( object oTarget  )
{
	if ( GetLocalInt( oTarget, "CSL_COUNTERSPELLED" ) ) // if true someone is counter spelling the caster
	{
		object oCounterSpeller;
		int iSlotNumber;
		for (iSlotNumber = 1; iSlotNumber <= 5; iSlotNumber++) 
		{
			oCounterSpeller = GetLocalObject( oTarget, "CSL_COUNTERSPELLER"+IntToString(iSlotNumber) );
			
			if ( GetIsObjectValid( oCounterSpeller ) )
			{
				HkCounterSpellTargetingEnd( oCounterSpeller );
			}
		}
	}
}

/**
* Heartbeat to support counterspelling actions, it manages animations, keeping the counterspeller in medium range, and ends it gracefully after combat or when it no longer makes sense
* @param oCounterSpeller The caster who is doing the counterspell action
* @param iRemainingRounds Time in rounds remaining to keep countering
* @param iSerial A serial used internally to prevent duplicate heartbeats doing the same job
* @see
*/
void HkSpellCounterHeartbeat( object oCounterSpeller, int iRemainingRounds, int iSerial = -1 )
{
	if ( !GetIsObjectValid( oCounterSpeller ) || !CSLSerialRepeatCheck( oCounterSpeller, "COUNTERSPELLSERIAL", iSerial ) )
	{
		// duplicate, there is a new heartbeat replacing this one, no need to continue
		return;
	}
	
	if ( iRemainingRounds < 1 || CSLGetIsIncapacitated( oCounterSpeller ) )
	{
		HkCounterSpellTargetingEnd( oCounterSpeller );
		return;
	}
	
	
	object oTarget = GetLocalObject( oCounterSpeller, "CSL_COUNTERSPELLTARGET" );
	if ( !GetIsObjectValid( oTarget ) || GetIsDead( oTarget ) || !GetObjectSeen(oTarget, oCounterSpeller) || !CSLIsClose(oTarget, oCounterSpeller, 40.0f ) )
	{
		HkCounterSpellTargetingEnd( oCounterSpeller );
		return;
	}
	
	
	
	//;
	//GetDistanceBetween(oCaster, oCounterSpeller);
	
	// this is not forced on the player, they can still move and cast, but will start doing it if they are not doing anything
	PlayCustomAnimation(oCounterSpeller, "def_conjureloop", FALSE, 1.0f);
	
	iRemainingRounds--;
	
	
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oCounterSpeller, "COUNTERSPELLSERIAL" );
	}
	DelayCommand( 3.0f, HkSpellCounterHeartbeat( oCounterSpeller, iRemainingRounds, iSerial ) );
}

/**
* Starts the counterspelling of a given target
* Called from a gui script called from the contextual menu or from AI coding
* @param oTarget The caster whose spells are going to be blocked, usually GetPlayerCurrentTarget()
* @param oCounterSpeller The counterspeller
* @see
* @replaces
*/
void HkCounterSpellTargetingStart( object oTarget, object oCounterSpeller = OBJECT_SELF )
{
	if ( oTarget == oCounterSpeller )
	{
		return;
	}
	
	
	HkCounterSpellTargetingEnd( oCounterSpeller ); // end spells for other targets
	
	
	if ( !GetHasFeat( FEAT_COUNTERSPELL, oCounterSpeller ) )
	{
		return;
	}
	
	// check distance and line of sight
	if ( !GetIsObjectValid( oTarget ) || GetIsDead( oTarget ) || !GetObjectSeen(oTarget, oCounterSpeller) || !CSLIsClose(oTarget, oCounterSpeller, 40.0f ) )
	{
		return;
	}
	
	if ( CSLGetIsIncapacitated( oCounterSpeller ) )
	{
		return;
	}
	
	if ( !CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCounterSpeller) )
	{
		return;
	}	
	
	// look for open slots, only start counter spelling
	int iSlotNumber;
	for (iSlotNumber = 1; iSlotNumber <= 5; iSlotNumber++) 
	{
		if ( !GetIsObjectValid( GetLocalObject( oTarget, "CSL_COUNTERTARGET"+IntToString(iSlotNumber) ) ) )
		{
			AssignCommand( oCounterSpeller, ClearAllActions() );
			SendMessageToPC( oCounterSpeller, "You begin Counterspelling "+GetName( oTarget ) );
			
			SetLocalObject( oTarget, "CSL_COUNTERSPELLER"+IntToString(iSlotNumber), oCounterSpeller );
			SetLocalInt( oCounterSpeller, "CSL_COUNTERSPELLING", iSlotNumber ); // used to determine if counter spelling
			SetLocalObject( oCounterSpeller, "CSL_COUNTERSPELLTARGET", oTarget );
			
			CSLIncrementLocalInt( oTarget, "CSL_COUNTERSPELLED", 1 );
			
			SetGUIObjectHidden( oCounterSpeller, "SCREEN_HOTBAR", "counterspellOn-btn", TRUE ); // hides
			SetGUIObjectHidden( oCounterSpeller, "SCREEN_HOTBAR", "counterspellOff-btn", FALSE ); // shows
			
			DelayCommand( 6.0f, HkSpellCounterHeartbeat( oCounterSpeller, 6 ) );
			
			return; // only need to do one
			// do the counterspelling dance, pseudo heart beat check to end it when they move as well here
		}
	}
	
	// It hit the max and it failed
}


/**
* This is placed in the spellhook to capture any spellcasting events and indicate when they get blocked
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iSpellLevel = 1
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param iSpellSchool = -1
* @param iAttributes = -1
* @return TRUE indicates the spell was blocked and false that it can ignore any counterspelling
* @see
* @replaces
*/
int HkCounterSpellHookCasting( object oCaster, int iSpellId, int iSpellLevel = 1, int iClass = 255, int iSpellSchool = -1, int iAttributes = -1 )
{
	// if they are casting a spell or feat this ends the counter spelling
	HkCounterSpellTargetingEnd( oCaster );
	
	
	//SendMessageToPC( GetFirstPC(), "Counterspelling is running!" );
	
	if ( GetLocalInt( oCaster, "CSL_COUNTERSPELLED" ) ) // if true someone is counter spelling the caster
	{	
		//SendMessageToPC( GetFirstPC(), "Counterspelling actively countered!" );
		// is the spell blockable? Arcane or divine and not quickened, does autoquicken 1-4 make the first cast spell have quicken metamagic?
		
		if ( GetLastSpellCastClass() == 255 )
		{
			return FALSE; // must be a feat, this should only block actual spells and not feats
		}
		
		// if quickened, return, also if stilled and silenced at the same time but that can come later.
		int iMetaMagic = GetMetaMagicFeat(  ); // oCaster might need to just get the regular engine GetMetaMagicFeat(), this includes the auto and other features
		if ( iMetaMagic & METAMAGIC_QUICKEN ) 
		{
			//SendMessageToPC( GetFirstPC(), "Counterspelling ignored, quickened spell" );
			return FALSE;
		}
		
		
		int bCounterSpellerHears;
		int bCounterSpellerSees;
		int iDistance;
				
		
		int iSpellCounter = -1;
		//string sCounter1 = "****";
		//string sCounter2 = "****";
		string sCounter1 = Get2DAString("spells", "Counter1", iSpellId); // need to do more validation, soas to make sure the counter is not spell 0 or other strings it returns
		string sCounter2 = Get2DAString("spells", "Counter2", iSpellId); // needs to have **** in spells.2da or it will get wonky


		
		int iSpellKnown = FALSE; // prep it prior to the loop
		int iSpellDispel = FALSE; // prep it prior to the loop
		string sSpellName = CSLGetSpellDataName(iSpellId);
		string sSpellKnownName;
		string sCounterSpellName;
		
		int iRoll;
		int iDispelCheck;
		int iCounteringClass;
		int iDC;
		int iCounterScore;
		int iSpellCraftRanks;
		int iSkillCheckRoll;
		string sSkillRollSummary;
		string sDispelRollSummary;
		
		object oCounterSpeller;
		int iSlotNumber;
		for (iSlotNumber = 1; iSlotNumber <= 5; iSlotNumber++) 
		{
			
			oCounterSpeller = GetLocalObject( oCaster, "CSL_COUNTERSPELLER"+IntToString(iSlotNumber) );
			
			if ( GetIsObjectValid( oCounterSpeller ) )
			{
				//SendMessageToPC( GetFirstPC(), "Counterspellor found "+GetName( oCounterSpeller )+" Valid="+IntToString(GetIsObjectValid( oCounterSpeller ) )+" Incapacitated="+IntToString(!CSLGetIsIncapacitated( oCounterSpeller ) )+" CSLIsClose="+IntToString(CSLIsClose(oCaster, oCounterSpeller, 40.0f ))  );
				if (  !CSLGetIsIncapacitated( oCounterSpeller ) )
				{
					if ( CSLIsClose(oCaster, oCounterSpeller, 40.0f ) ) // this is long range
					{
						iDistance = FloatToInt( GetDistanceBetween(oCaster, oCounterSpeller)*1.524f ); // distance meters to feet then divided by 5
						
						
						//1 meter = 3.2808399 feet
						//1 foot = 0.3048
						
						bCounterSpellerSees = GetObjectSeen(oCaster, oCounterSpeller);
						bCounterSpellerHears = GetObjectHeard(oCaster, oCounterSpeller);
						
						//SendMessageToPC( GetFirstPC(), "1 Sees="+IntToString( bCounterSpellerSees )+" Hears="+IntToString( bCounterSpellerHears ) );
						if ( iMetaMagic & METAMAGIC_STILL || !(iAttributes & SCMETA_ATTRIBUTES_SOMANTICCOMP && iAttributes != 0 ) ) 
						{
							bCounterSpellerSees = FALSE;
						}
						
						if ( iMetaMagic & METAMAGIC_SILENT || !(iAttributes & SCMETA_ATTRIBUTES_VOCALCOMP && iAttributes != 0) ) 
						{
							bCounterSpellerHears = FALSE;
						}
						
						// 150.36  
						
						
						// SendMessageToPC( GetFirstPC(), "2 Sees="+IntToString( bCounterSpellerSees )+" Hears="+IntToString( bCounterSpellerHears ) );
						if ( bCounterSpellerHears && bCounterSpellerSees)
						{
							//SendMessageToPC( GetFirstPC(), "Have a valid Counterspeller!" );
							// do a spell craft check, if failed
							AssignCommand( oCounterSpeller, SetFacingPoint( GetPosition(oCaster) ) );
							
							int iSpellcraftDC = 15 + iSpellLevel + CSLGetMax( 0, iDistance-8); // need to vary this by spell school, feats, prohibited school and the like
						
							if ( !bCounterSpellerHears )
							{
								iSpellcraftDC + 5+ CSLGetMax( 0, iDistance-3);
							}
							else if ( !bCounterSpellerSees)
							{
								iSpellcraftDC + 5+CSLGetMax( 0, iDistance-3);
							}
							
							iSpellCraftRanks = GetSkillRank(SKILL_SPELLCRAFT, oCounterSpeller);
							iSkillCheckRoll = d20();
							sSkillRollSummary = " [ Spellcraft:" + IntToString(iSpellCraftRanks) + "+Roll:" + IntToString(iSkillCheckRoll)+"] = " +IntToString( iSpellCraftRanks+iSkillCheckRoll )+" vs DC " + IntToString(iSpellcraftDC);
						
							if ( ( iSpellCraftRanks + iSkillCheckRoll ) > iSpellcraftDC ) // need to put in the dc check here, this forces it to fail for the time being
							{
								iSpellKnown = TRUE;
								sSpellKnownName = sSpellName;
								SendMessageToPC( oCounterSpeller, "You recognize your opponenet is casting "+sSpellName+" and prepare a counterspell"+sSkillRollSummary);
							}
							else
							{
								sSpellKnownName = "Unknown Spell";
								SendMessageToPC( oCounterSpeller, "You fail recognize the spell your opponenet is casting"+sSkillRollSummary);
							}
							
							if ( iSpellKnown && GetHasSpell( iSpellId, oCounterSpeller )  )
							{
								iSpellCounter = iSpellId;
								sCounterSpellName = sSpellName;
							}
							else if ( iSpellKnown && sCounter1 != "" && GetHasSpell( StringToInt(sCounter1), oCounterSpeller )  )
							{
								iSpellCounter = StringToInt(sCounter1);
								sCounterSpellName = CSLGetSpellDataName( StringToInt(sCounter1) );
							}
							else if ( iSpellKnown && sCounter2 != "" && GetHasSpell( StringToInt(sCounter2), oCounterSpeller ) )
							{
								iSpellCounter = StringToInt(sCounter2);
								sCounterSpellName = CSLGetSpellDataName( StringToInt(sCounter1) );
							}
							else if ( GetHasSpell( SPELL_LESSER_DISPEL, oCounterSpeller ) ) // are there other dispels and feats that can be used here.  ??? he does not have lesser dispel?
							{
								iSpellCounter = SPELL_LESSER_DISPEL; // 94
								sCounterSpellName = "Lesser Dispel Magic";
								iSpellDispel = TRUE;
							}
							else if ( GetHasSpell( SPELL_DISPEL_MAGIC, oCounterSpeller ) )
							{
								iSpellCounter = SPELL_DISPEL_MAGIC; // 41
								sCounterSpellName = "Dispel Magic";
								iSpellDispel = TRUE;
							}
							else if ( GetHasSpell( SPELL_GREATER_DISPELLING, oCounterSpeller ) )
							{
								iSpellCounter = SPELL_GREATER_DISPELLING;
								sCounterSpellName = "Greater Dispel Magic";
								iSpellDispel = TRUE;
							}
							else if ( GetHasSpell( SPELLABILITY_PILFER_MAGIC, oCounterSpeller ) )
							{
								iSpellCounter = SPELLABILITY_PILFER_MAGIC;
								sCounterSpellName = "Pilfer Magic";
								iSpellDispel = TRUE;
							}
							else if ( GetHasSpell( SPELL_CHAIN_DISPEL, oCounterSpeller ) )
							{
								iSpellCounter = SPELL_CHAIN_DISPEL;
								sCounterSpellName = "Chain Dispel";
								iSpellDispel = TRUE;
							}
							else if ( GetHasSpell( SPELL_REAVING_DISPEL, oCounterSpeller ) )
							{
								iSpellCounter = SPELL_REAVING_DISPEL;
								sCounterSpellName = "Reaving Dispel";
								iSpellDispel = TRUE;
							}
							else if ( GetHasSpell( SPELL_MORDENKAINENS_DISJUNCTION, oCounterSpeller ) )
							{
								iSpellCounter = SPELL_MORDENKAINENS_DISJUNCTION;
								sCounterSpellName = "Mordenkainens Disjunction";
								iSpellDispel = TRUE;
							}
							
							if ( iSpellCounter != -1 ) // if there is a counter, then go ahead and cause spell to break up
							{
								AssignCommand( oCounterSpeller, ClearAllActions() );
								//AssignCommand( oCounterSpeller, ActionCastFakeSpellAtObject(iSpellCounter, oCaster, PROJECTILE_PATH_TYPE_HOMING) );
								SpawnSpellProjectile( oCounterSpeller, oCaster, GetLocation(oCounterSpeller), GetLocation(oCaster), iSpellCounter, PROJECTILE_PATH_TYPE_DEFAULT ); // 
								//AssignCommand(oCounterSpeller, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1));
								
								 PlayCustomAnimation(oCounterSpeller, "sp_turnundead", FALSE, 1.0f);
								// player stands up
								//DelayCommand(5.0f, PlayCustomAnimation(oPC, "standupb", FALSE, 1.0f));
								// now, play idle animation (otherwise the player would lay down again)
								//DelayCommand(7.66f, PlayCustomAnimation(oPC, "idle", TRUE, 1.0f));
								/*	Wording to use
										to the counter speller
										You countered {SPELLNAME} by dispelling it with {COUNTERSPELL} [10+20]= 30 vs DC 25
										You failed to counter {SPELLNAME} with {COUNTERSPELL} [10+10]= 20 vs DC 25
										You countered {SPELLNAME} with {COUNTERSPELL}
										No Counter for the given spell
										
										
										To the actual caster
										Your spell {SPELLNAME} was counterspelled by {COUNTERSPELLERNAME} using {COUNTERSPELL} 
										
										{COUNTERSPELLERNAME} counterspelled your casting of {SPELLNAME} with {COUNTERSPELL}   
										{COUNTERSPELLERNAME} failed to counterspell your casting of {SPELLNAME} with {COUNTERSPELL} 
									
								*/
								
								// need to do a range check as well for the specific counterspell comparing it to the range i just captured
								
								if ( iSpellDispel )
								{
									// need to do a dispel check
									iDC = HkDispelDC( oCaster, iClass );
									iCounteringClass = GetLocalInt(oCounterSpeller, "SC_iBestCasterClass" );
									iDispelCheck = HkDispelCheck( oCounterSpeller, iSpellCounter, iCounteringClass );
									
									
									iRoll = d20();
									
									
									iCounterScore = iDispelCheck + iRoll;
									sDispelRollSummary = " [" + IntToString(iDispelCheck) + "+Roll:" + IntToString(iRoll)+"] = " +IntToString( iCounterScore )+" vs DC " + IntToString(iDC);
									
									
									DecrementRemainingSpellUses(oCounterSpeller, iSpellCounter);
									SignalEvent(oCaster, EventSpellCastAt(oCounterSpeller, SPELLABILITY_COUNTERSPELL, TRUE ));
									
									if ( ( iCounterScore ) > iDC )
									{
										SendMessageToPC( oCounterSpeller, "You countered  "+sSpellKnownName+" by dispelling it with "+sCounterSpellName+sDispelRollSummary  );
										if ( ( GetSkillRank(SKILL_SPELLCRAFT, oCaster) + d20() ) > 15 + StringToInt( CSLGetSpellDataLevel(iSpellCounter) ) )
										{
											SendMessageToPC( oCaster, GetName(oCounterSpeller)+" counterspelled your casting of "+sSpellName+" with "+sCounterSpellName+sDispelRollSummary  );
										}
										else
										{
											SendMessageToPC( oCaster, GetName(oCounterSpeller)+" counterspelled your casting of "+sSpellName+" with Unknown Spell"+sDispelRollSummary  );
										}
										SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
										return TRUE;
									}
									else
									{
										SendMessageToPC( oCounterSpeller, "You failed to counter "+sSpellKnownName+" with "+sCounterSpellName+sDispelRollSummary  );
										if ( ( GetSkillRank(SKILL_SPELLCRAFT, oCaster) + d20() ) > 15 + StringToInt( CSLGetSpellDataLevel( iSpellCounter ) ) )
										{
											SendMessageToPC( oCaster, GetName(oCounterSpeller)+" failed to counterspell your casting of "+sSpellName+" with "+sCounterSpellName+sDispelRollSummary  );
										}
										else
										{
											SendMessageToPC( oCaster, GetName(oCounterSpeller)+" failed to counterspell your casting of "+sSpellName+" with Unknown Spell"+sDispelRollSummary  );
										}
										return FALSE;
									}
			
									//sMessage  = "\n   --> " + sSpellName + " [" + IntToString(iDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( iDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC);
									
								}
								
								// now do the counter spell block since they can block the spell
								// does the counterspell know what spell the caster is casting.
								SendMessageToPC( oCounterSpeller, "You countered "+sSpellKnownName+" with "+sCounterSpellName  );
								if ( ( GetSkillRank(SKILL_SPELLCRAFT, oCaster) + d20() ) > 15 + StringToInt( CSLGetSpellDataLevel( iSpellCounter ) ) )
								{
									SendMessageToPC( oCaster, "Your spell "+sSpellName+" was counterspelled by "+GetName(oCounterSpeller)+" using "+sCounterSpellName  );
								}
								else
								{
									SendMessageToPC( oCaster, "Your spell "+sSpellName+" was counterspelled by "+GetName(oCounterSpeller)+" using an unknown spell"  );
								}
								// block the spell and reduce the casting, do visuals and countering animations
								DecrementRemainingSpellUses(oCounterSpeller, iSpellCounter);
								SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
								return TRUE; // perhaps i don't want to return, the countering group might all lose a spell
							}
							else
							{
								// send message, has no counter for the given spell
								SendMessageToPC( oCounterSpeller, "No Counter available for "+sSpellKnownName  );
							}
						}
					}
					else
					{
						FloatingTextStringOnCreature("You are out of range and cannot Counterspell", oCounterSpeller, FALSE);
						HkCounterSpellTargetingEnd( oCounterSpeller, TRUE );
					}
				}
				else
				{
					FloatingTextStringOnCreature("You are incapacitated and cannot Counterspell", oCounterSpeller, FALSE);
					HkCounterSpellTargetingEnd( oCounterSpeller, TRUE );
				}
			}
		}
	
	}
	return FALSE;
}

/**
* Returns the school of the spell currently being cast
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces SCGetSpellSchool
*/
int HkGetSpellSchool( object oCaster = OBJECT_SELF )
{
	//int iSpellSchool = sCurrentSpell.iSchool;
	
	
	int iSpellSchool = CSLReadIntModifier( oCaster, "School" );
	//if ( iEffectiveSpellLevel > 0 ) // Barbarian is not a real class
	//{
	//	return iEffectiveSpellLevel;
	//}
	
	
	//if ( iSpellSchool == -1 )
	//{
	//	return -1;
	//}
	
	if (DEBUGGING >= 5) { CSLDebug("Spell School is "+CSLSchoolToString( iSpellSchool ) ); }
	
	return iSpellSchool;
}



/**
* Returns the subschool of the spell currently being cast
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
int HkGetSpellSubSchool( object oCaster = OBJECT_SELF )
{
	///int iSpellSubSchool = sCurrentSpell.iSubSchool;
	
	int iSpellSubSchool = CSLReadIntModifier( oCaster, "SubSchool" );
	
	if (DEBUGGING >= 5) { CSLDebug("Spell Sub School is "+CSLSubSchoolToString( iSpellSubSchool ) ); }
	
	return iSpellSubSchool;
}

/**
* Returns the descriptor of the spell currently being cast
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
int HkGetDescriptor( object oCaster = OBJECT_SELF )
{
	int iDescriptor;
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		iDescriptor = CSLGetAOETagInt( SCSPELLTAG_DESCRIPTOR );
		if (DEBUGGING >= 5 ) { CSLDebug("Descriptor is "+CSLDescriptorsToString( iDescriptor ) ); }
		if ( iDescriptor > -1 )
		{
			return iDescriptor;
		}
	}
	// add in a var check here for scripter overrides
	
	iDescriptor = CSLReadIntModifier( oCaster, "Descriptor", 0 );
	iDescriptor = CSLReadIntModifier( oCaster, "descriptormodtype", iDescriptor) ;
	
	if (DEBUGGING >= 6) { CSLDebug("Descriptor is "+CSLDescriptorsToString( iDescriptor ) ); }
	return iDescriptor;
}

/**
* Returns the correct spellid of the spell currently being cast
* This is used to ensure that it returns the base spellid for the spell and not the row in spells.2da
* @param oCaster The caster of the current spell
* @param iForce = FALSE
* @return
* @see
* @replaces SCGetSpellId XXXPRCGetSpellId
*/
int HkGetSpellId( object oCaster = OBJECT_SELF, int iForce = FALSE )
{
	if (DEBUGGING >= 8) { CSLDebug("HkGetSpellId 1", oCaster ); }
	int iSpellId;	
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		//SendMessageToPC(  GetAreaOfEffectCreator(), "AOE Firing" );
		int iSpellId = CSLGetAOETagInt( SCSPELLTAG_SPELLID );
		if ( iSpellId != -1  )
		{
			if (DEBUGGING >= 5) { CSLDebug("SpellID is "+IntToString( iSpellId ) ); }
			return iSpellId;
		}
		else
		{
			return GetAreaOfEffectSpellId( OBJECT_SELF );
		}

	}
	
	
	if ( iForce ) // this makes it prefer the stored spellid and not the true spellid
	{
		int iTempSpellId = CSLReadIntModifier( oCaster, "SpellId" );
		if ( iTempSpellId != 0 ) 
		{
			iSpellId = iTempSpellId-1;
		}
	}
	else
	{
		iSpellId = GetSpellId();
	}
	
	
	
	
	if ( iSpellId == -1 )
	{
		if ( iForce ) // this makes it go for the remaining method for the spell id
		{
			iSpellId = GetSpellId();
		}
		else
		{
			int iTempSpellId = CSLReadIntModifier( oCaster, "SpellId" );
			if ( iTempSpellId != 0 ) 
			{
				iSpellId = iTempSpellId-1;
			}
		}
	
	//	iSpellId = sCurrentSpell.iSpellId;
	//}
	//else if ( iForce )
	//{
	//	iSpellId = GetSpellId();
	}
	if (DEBUGGING >= 5 ) { CSLDebug("SpellID is "+IntToString( iSpellId ) ); }
	return iSpellId;
}


/**
* Gets the metamagic feat for the currently cast spell
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces SCGetMetaMagicFeat
*/
int HkGetMetaMagicFeat( object oCaster = OBJECT_SELF )
{

	if (DEBUGGING >= 8) { CSLDebug("HkGetMetaMagicFeat for "+GetName( oCaster ), oCaster ); }
	int iMetaMagic = 0;
	if ( GetObjectType( oCaster ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		iMetaMagic = CSLGetAOETagInt( SCSPELLTAG_METAMAGIC );
		if ( iMetaMagic > -1 )
		{
			return iMetaMagic;
		}
	}
	// add in a var check here for scripter overrides
	iMetaMagic = GetMetaMagicFeat();
	//if (DEBUGGING >= 8) { CSLDebug("HkGetMetaMagicFeat 1 now "+IntToString( iMetaMagic ), oCaster ); }	
	iMetaMagic = CSLGetAutomaticMetamagic( iMetaMagic );
	//if (DEBUGGING >= 8) { CSLDebug("HkGetMetaMagicFeat 2 now "+IntToString( iMetaMagic ), oCaster ); }
	iMetaMagic = CSLReadBitModifier( oCaster, "Spell_MetaMagic", iMetaMagic );
	//if (DEBUGGING >= 8) { CSLDebug("HkGetMetaMagicFeat 3 now "+IntToString( iMetaMagic ), oCaster ); }
	//if (DEBUGGING >= 4) { CSLDebug("Metamagic is "+CSLGetMetaMagicName( iMetaMagic ) ); }
	return iMetaMagic;
}

/* PRC Version
int PRCGetMetaMagicFeat()
{
    int nFeat = GetMetaMagicFeat();
    if(GetIsObjectValid(GetSpellCastItem()))
        nFeat = 0;//biobug, this isn't reset to zero by casting from an item

    int nOverride = GetLocalInt(OBJECT_SELF, PRC_METAMAGIC_OVERRIDE);
    if(nOverride)
        return nOverride;
    int nSSFeat = GetLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT);
    int nNewSpellMetamagic = GetLocalInt(OBJECT_SELF, "NewSpellMetamagic");
    if(nNewSpellMetamagic)
        nFeat = nNewSpellMetamagic-1;
    if(nSSFeat)
        nFeat = nSSFeat;

    // Suel Archanamach's Extend spells they cast on themselves.
    // Only works for Suel Spells, and not any other caster type they might have
    // Since this is a spellscript, it assumes OBJECT_SELF is the caster
    if (GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH) >= 3 && HkGetSpellClass() == CLASS_TYPE_SUEL_ARCHANAMACH)
    {
        // Check that they cast on themselves
        if (OBJECT_SELF == HkGetSpellTarget())
        {
            // Add extend to the metamagic feat using bitwise math
            nFeat |= METAMAGIC_EXTEND;
        }
    }
    // Magical Contraction, Truenaming Utterance
    if (GetLocalInt(OBJECT_SELF, "TrueMagicalContraction"))
    {
        nFeat |= METAMAGIC_EXTEND;
    }

    if(GetIsObjectValid(GetSpellCastItem()))
    {
        object oItem = GetSpellCastItem();
        int iSpellId = HkGetSpellId();
        //check item for metamagic
        int nItemMetaMagic;
        itemproperty ipTest = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_METAMAGIC)
            {
                int nSubType = GetItemPropertySubType(ipTest);
                nSubType = StringToInt(Get2DAString("iprp_spells", "SpellIndex", nSubType));
                if(nSubType == iSpellId)
                {
                    int nCostValue = GetItemPropertyCostTableValue(ipTest);
                    if(nCostValue == -1 && DEBUGGING)
                        CSLDebug("Problem examining itemproperty");
                    switch(nCostValue)
                    {
                        //bitwise "addition" equivalent to nFeat = (nFeat | nSSFeat)
                        case 0:
                            nItemMetaMagic |= METAMAGIC_NONE;
                            break;
                        case 1:
                            nItemMetaMagic |= METAMAGIC_QUICKEN;
                            break;
                        case 2:
                            nItemMetaMagic |= METAMAGIC_EMPOWER;
                            break;
                        case 3:
                            nItemMetaMagic |= METAMAGIC_EXTEND;
                            break;
                        case 4:
                            nItemMetaMagic |= METAMAGIC_MAXIMIZE;
                            break;
                        case 5:
                            nItemMetaMagic |= METAMAGIC_SILENT;
                            break;
                        case 6:
                            nItemMetaMagic |= METAMAGIC_STILL;
                            break;
                    }
                }
            }
            ipTest = GetNextItemProperty(oItem);
        }
        nFeat = nItemMetaMagic;
    }
    return nFeat;
}


*/


/**
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param oCaster The caster of the current spell
* @return The spell level of the spell being cast
* @see
* @replaces
*/
int HkGetSpellLevel(int iSpellId = -1, int iClass = 255, object oCaster = OBJECT_SELF )
{
	if (DEBUGGING >= 8) { CSLDebug("HkGetSpellLevel 1", oCaster ); }
	if (iSpellId == -1) { iSpellId = GetSpellId(); }
	
	
	//return GetSpellLevel(iSpellId);
	
	int iEffectiveSpellLevel = -1; // using iEffectiveSpellLevel since this returns both spell level and effective spell level

	
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		//SendMessageToPC(  GetAreaOfEffectCreator(), "AOE Firing" );
		iEffectiveSpellLevel = CSLGetAOETagInt( SCSPELLTAG_SPELLLEVEL );
		
		if ( iEffectiveSpellLevel != -1 )
		{
			if (DEBUGGING >= 6) { CSLDebug("AOE Spell Level is "+IntToString( iEffectiveSpellLevel ) ); }
			return iEffectiveSpellLevel;
		} 
	}
	
	
	
	int iTempEffectiveSpellLevel = CSLReadIntModifier( oCaster, "SpellLevel" );
	if ( iTempEffectiveSpellLevel > 0 ) // Barbarian is not a real class
	{
		iEffectiveSpellLevel = iTempEffectiveSpellLevel-1;
		if (DEBUGGING >= 6) { CSLDebug("iEffectiveSpellLevel is "+IntToString( iEffectiveSpellLevel ) ); }
	}
	//else if ( sCurrentSpell.iSpellLevel != -1 )
	//{
	//	if (DEBUGGING >= 6) { CSLDebug("sCurrentSpell.iSpellLevel is "+IntToString( sCurrentSpell.iSpellLevel ) ); }
	//	return sCurrentSpell.iSpellLevel;
	//}
	
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCaster );
	}
	
	if ( iEffectiveSpellLevel == -1 )
	{
		string sSpellLevel = CSLGetSpellDataLevel( iSpellId, iClass );
		if ( sSpellLevel == "" ) // if we don't get something default to engine function
		{
			iEffectiveSpellLevel = GetSpellLevel( iSpellId );
		}
		else
		{
			iEffectiveSpellLevel = StringToInt( sSpellLevel );
		}
	}
	
	if ( iClass == CLASS_TYPE_WARLOCK )
	{
		// Warlocks are a bit different and will be handled on their own
		int iMetaMagic = HkGetMetaMagicFeat();
		if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 7 ); }
		
		else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST)     { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	
		//int ixxx = SPELLABILITY_DREAD_SEIZURE;
		if ( iSpellId == SPELLABILITY_DREAD_SEIZURE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELLABILITY_HIDEOUS_BLOW_IMPACT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 1 ); }
		else if ( iSpellId == SPELLABILITY_HINDERING_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELLABILITY_OTHERWORLDLY_WHISPERS ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_BEGUILING_INFLUENCE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_BREATH_OF_NIGHT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 0 ); }
		else if ( iSpellId == SPELL_I_CHARM ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_CHILLING_TENTACLES ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
		else if ( iSpellId == SPELL_I_CURSE_OF_DESPAIR ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_DARKNESS ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_DARK_PREMONITION ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 9 ); }
		else if ( iSpellId == SPELL_I_DARK_ONES_OWN_LUCK ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_DEVILS_SIGHT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_DEVOUR_MAGIC ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if ( iSpellId == SPELL_I_ELDRITCH_CHAIN ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_ELDRITCH_CONE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
		else if ( iSpellId == SPELL_I_ELDRITCH_DOOM ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
		else if ( iSpellId == SPELL_I_ELDRITCH_SPEAR ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_ENTROPIC_WARDING ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_FLEE_THE_SCENE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_HIDEOUS_BLOW ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 1 ); }
		else if ( iSpellId == SPELL_I_LEAPS_AND_BOUNDS ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_PATH_OF_SHADOW ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if ( iSpellId == SPELL_I_RETRIBUTIVE_INVISIBILITY ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if ( iSpellId == SPELL_I_SEE_THE_UNSEEN ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_TENACIOUS_PLAGUE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if ( iSpellId == SPELL_I_THE_DEAD_WALK ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_UTTERDARK_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
		else if ( iSpellId == SPELL_I_VOIDSENSE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_VORACIOUS_DISPELLING ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_WALK_UNSEEN ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		else if ( iSpellId == SPELL_I_WALL_OF_PERILOUS_FLAME ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
		else if ( iSpellId == SPELL_I_WORD_OF_CHANGING ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
		
		else if ( iSpellId == SPELL_I_DARKFORESIGHT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 9 ); }
		else if ( iSpellId == SPELL_I_CASTERS_LAMENT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
		else if ( iSpellId == SPELL_I_CAUSTIC_MIRE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_FRIGHTFUL_PRESENCE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
		else if ( iSpellId == SPELL_I_HELLSPAWNGRACE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if ( iSpellId == SPELL_I_IGNOREPYRE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == Instill_Vulnerability ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 7 ); }
		else if ( iSpellId == SPELL_I_REPELL_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
		else if ( iSpellId == SPELL_I_TEMPEST_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
		else if ( iSpellId == SPELL_I_UNDEADBANEBLST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
		else if ( iSpellId == SPELL_Eldritch_Glaive ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
		
	}

	if (DEBUGGING >= 6) { CSLDebug("Spell Level is "+IntToString( iEffectiveSpellLevel ) ); }
	
	return iEffectiveSpellLevel;
}

/**
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
int HkGetSpellClass( object oCaster = OBJECT_SELF )
{
	if (DEBUGGING >= 8) { CSLDebug("HkGetSpellClass 1", oCaster ); }
	int iClass;
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		//SendMessageToPC(  GetAreaOfEffectCreator(), "AOE Firing" );
		iClass = CSLGetAOETagInt( SCSPELLTAG_CASTERCLASS );
		if ( iClass != 255  )
		{
			if (DEBUGGING >= 5) { CSLDebug("AOE Casting Class is "+CSLGetClassesDataName( iClass ) ); }
			return iClass;
		}
	}
	
	int iTempClass = CSLReadIntModifier( oCaster, "Class" )-1; // already stored and cached the class, so don't need to get it again.
	if ( iTempClass < 254 && iTempClass > -1 ) // Barbarian is not a real class
	{
		return iTempClass;
	}
	
	
	/*
	const int CLASS_TYPE_NONE = 255;
const int CLASS_TYPE_RACIAL = -256; // use this soas to get the total hit dice involved instead of the actual class
const int CLASS_TYPE_BESTDIVINE = -257;
const int CLASS_TYPE_BESTARCANE = -258;
const int CLASS_TYPE_BESTELDRITCH = -259;
const int CLASS_TYPE_BESTCASTER = -260; 888 457 8378
	*/
	
	
	// return GetLastSpellCastClass();
	if ( !GetIsObjectValid(oCaster) ) { return 255;} // make sure it's only run on a valid object


	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oCaster = GetMaster( oCaster ); // familiars are always arcane related
		return GetLocalInt(oCaster, "SC_iBestArcaneClass" );
	}
	
	//!GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID
	
	
	if ( iClass == CLASS_TYPE_BESTDIVINE )
	{
		iClass = GetLocalInt(oCaster, "SC_iBestDivineClass" );
	}
	else if ( iClass == CLASS_TYPE_BESTARCANE )
	{
		iClass = GetLocalInt(oCaster, "SC_iBestArcaneClass" );
	}
	else if ( iClass == CLASS_TYPE_BESTELDRITCH )
	{
		iClass = GetLocalInt(oCaster, "SC_iBestEldritchClass" );
	}
	else if ( iClass == CLASS_TYPE_BESTPSIONIC )
	{
		iClass = GetLocalInt(oCaster, "SC_iBestPsionicClass" );
	}
	else if ( iClass == CLASS_TYPE_BESTCASTER )
	{
		iClass = GetLocalInt(oCaster, "SC_iBestCasterClass" );
	}
	
	iClass = GetLastSpellCastClass();
	if ( iClass == 255 )
	{
		// we got an issue, lets get the best caster class
		//return GetLocalInt(oCaster, "SC_iBestCasterClass" );
		iClass = CSLGetClassBySpellId( oCaster,  HkGetSpellId() );
	}
	
	if ( iClass == 255 || iClass == -1  )
	{
		iClass = CLASS_TYPE_RACIAL;
	}
	
	// HkGetBestCasterClass( oTarget ); // HkGetBestDivineClass HkGetBestArcaneClass
	
	if (DEBUGGING >= 5) { CSLDebug("Casting Class is "+CSLGetClassesDataName( iClass ) ); }
	return iClass;
	// need to figure out the class now, must be calling this from a feat
	// need to probably just replace getlastspellcastclass with something smarter, perhaps some sort of lookup feature or looking at caster levels
}


/**
* @param oChar The character to get information from
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces XXXGetCasterLvl
*/
int HkGetCasterLevel( object oChar = OBJECT_SELF, int iClass  = 255)
{
	if (DEBUGGING >= 8) { CSLDebug("HkGetCasterLevel 1", oChar ); }
	int iCasterLevel = 0;
	
	if ( CSLIsItemValid( GetSpellCastItem() ) )
	{
		return HkGetItemCasterLevel( GetSpellCastItem(), oChar );
	}
	
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	// Now AOE's don't have a level, so lets get the creator of the AOE
	if (GetObjectType(oChar) == OBJECT_TYPE_AREA_OF_EFFECT)
	{
		oChar = GetAreaOfEffectCreator();
	}
	
	// Check Metamodifer Vars
	iCasterLevel = CSLReadIntModifier( oChar, "CasterLevel" );
	if ( iCasterLevel == 0 )
	{
		SCCacheStats( oChar );
		
		int iClassRow = 0;
		
		
		
		// empower the dm's
		if (GetIsDM(oChar) && GetLocalInt(oChar, "CSL_UseTrueDMCasterLevel") != TRUE ) 
		{
			return 60;
		}
		
		if ( iClass == 255 )
		{
			iClass = HkGetSpellClass( oChar);
		}
		
		// Would like to make sure i handle things like wands, staves, and wands as well
		// Wand will have it's level embedded in the item
		// Scrolls wil
		
		// potions, scrolls, and wands, the creator can set the caster level of an
		// item at any number high enough to cast the stored spell and not higher than her own caster level.
		
		//Staffs use the wielder's ability score and relevant feats to set the DC for saves against their spells.
		// Unlike with other sorts of magic items, the wielder can use his caster level when activating the power
		//  of a staff if it's higher than the caster level of the staff. Minimum is 8th level.
		
		
		iClassRow = HkPrepGetClassRowFromCache( oChar, iClass );
		iCasterLevel = GetLocalInt(oChar, "SC_iCasterLevel"+IntToString(iClassRow) );
	}
	
	// Check Metamodifer Vars
	iCasterLevel += CSLReadIntModifier( oChar, "CasterLevelAdj" );
	
	iCasterLevel = CSLGetMax( 1, iCasterLevel );
	//int row = 0;
	//return GetLocalInt(oChar, "SC_Row"+IntToString(iClass) );
	
	//return GetCasterLevel(oChar);
	if (DEBUGGING >= 4) { CSLDebug("Caster Level is "+IntToString( iCasterLevel ) ); }
	return iCasterLevel;
}

/**
* @param oChar The character to get information from
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces SCPrep_GetClassRow
* @replaces SCPrep_GetClassRowFromCache
* @replaces HkGetClassRowFromCache
*/
int HkPrepGetClassRowFromCache( object oChar, int iClass )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	//if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	//{
	//	oChar = GetMaster( oChar );
	//}
	
	//SendMessageToPC( OBJECT_SELF, GetName(oChar)+" with Class: "+IntToString( iClass )+ " with stored class row of " +IntToString( GetLocalInt(oChar, "SC_Row"+IntToString(iClass) ) ) );
	// assuming we alread have the vars set up on the character
	// this should not be called by inside functions
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass();
	}
	return GetLocalInt(oChar, "SC_Row"+IntToString(iClass) );
}

/**
* Uses some complicated logic to guess the correct casting stat. Used in epic spells and feats where the correct class cannot be determined. Setting the arcane and divine parameters can give further hints as to the correct stat.
* @param oChar The character to get information from
* @param bArcane If set to FALSE will ignore arcane magic stats as an option
* @param bDivine  If set to FALSE will ignore divine magic stats as an option
* @return
* @see
* @replaces SCGetCasterModifier
*/
int HkGetBestCasterModifier(object oChar, int bArcane=TRUE, int bDivine=TRUE)
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	SCCacheStats( oChar );
	
	// Simplified this to use the primary caster class as predetermined,
	// Assuming this is used when the class of the caster is unknown, or when only the character is known but the class used to cast the spell is not.
	// Need to look and see if there is a way around this, even though for the most part it shold provide the correct class
	// This returns the primary modifier for the given caster, but will return intelligence if class is unknown( or wisdom if we are sure it's divine )
	
	int iScore = 0;
	int iClass = 255;
	int iAbility = -1;
	if (bArcane  == TRUE && bDivine == TRUE )
	{
		iClass = GetLocalInt(oChar, "SC_iBestCasterClass" );
		if ( iClass == 255 )
		{
			iAbility = ABILITY_INTELLIGENCE; // default if not class returns
		}
		else
		{
			iAbility = CSLGetMainStatByClass( iClass, "DC" );
		}
	}
	else if (bArcane == TRUE)
	{
		iClass = GetLocalInt(oChar, "SC_iBestArcaneClass" );
		if ( iClass == 255 )
		{
			iAbility = ABILITY_INTELLIGENCE; // default if not class returns
		}
		else
		{
			iAbility = CSLGetMainStatByClass( iClass, "DC" );
		}
	}
	else if (bDivine == TRUE)
	{
		iClass = GetLocalInt(oChar, "SC_iBestDivineClass" );
		if ( iClass == 255 )
		{
			iAbility = ABILITY_WISDOM; // default if not class returns
		}
		else
		{
			iAbility = CSLGetMainStatByClass( iClass, "DC" );
		}
	}
	
	//if ( iClass < 255 ) // 255 is an invalid class
	//{
	
	//}
	
	//if (iAbility > 0) nCha = GetAbilityModifier(iAbility, oChar);
	//if (iAbility > 0) nCha = GetAbilityModifier(iAbility, oChar);
	int bProdigy = GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oChar);
	return GetAbilityModifier(iAbility, oChar)+bProdigy;
}

/**
* Returns the cached value for the Highest caster level the caster can cast spells at, accounting for PRC's and practiced caster feats.
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetBestCasterMaxSpellLevel( object oChar = OBJECT_SELF )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iBestCasterMaxSpellLevel" );
}


/**
* Returns the cached value for the Highest caster level the caster can cast spells at, accounting for PRC's and practiced caster feats.
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetBestCasterLevel( object oChar = OBJECT_SELF )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iCasterLevels" );
}


/**
* Returns the Best Divine class the caster is a member of, accounting for PRC's and practiced caster feats.
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetBestDivineClass( object oChar = OBJECT_SELF )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iBestDivineClass" );
}

/**
* Returns the Best casting class the caster is a member of, accounting for PRC's and practiced caster feats.
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetBestCasterClass( object oChar = OBJECT_SELF )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iBestCasterClass" );
}

/**
* Returns the Best Arcane class the caster is a member of, accounting for PRC's and practiced caster feats.
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetBestArcaneClass( object oChar = OBJECT_SELF )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	//if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	//{
	//	oChar = GetMaster( oChar );
	//}
	
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iBestArcaneClass" );
}

/**
* Returns the base duration for a given spell which relates to the casters level. Separated as a function soas to allow custom changes just affecting this in relation to Duration. Note this is later translated into different duration types by the rules of the spell, rounds, turns, seconds, etc.
* @param oChar The character to get information from
* @param iMaxDuration The maximum duration cap for the given spell, this limits the spell to follow the rules but also allows exceptions to be made to exceed this.
* @param iClass The class of the caster, used to give a hint inside scripts where only one class can be using the spell.
* @return The duration integer which generally equates to the caster level of the spell caster.
* @see
* @replaces
*/
// HkGetSpellDuration
int HkGetSpellDuration( object oChar = OBJECT_SELF, int iMaxDuration = 60, int iClass  = 255 )
{
	if (DEBUGGING >= 9) { CSLDebug( "Starting HkGetSpellDuration iMaxDuration="+IntToString(iMaxDuration), oChar ); }
	
	iMaxDuration += CSLReadIntModifier( oChar, "Spell_CapAdj" );
	
	if (DEBUGGING >= 9) { CSLDebug( "Starting HkGetSpellDuration2 iMaxDuration="+IntToString(iMaxDuration), oChar ); }

	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	int iSpellDuration = 1;
	// int iCasterLevel;
	
	if ( CSLIsItemValid( GetSpellCastItem() )  )
	{	
		
		iSpellDuration = CSLGetMax( 5, HkGetItemCasterLevel( GetSpellCastItem(), oChar ) );
		
		//iCasterLevel = HkGetSpellPower( oChar, iMaxDuration, iClass);
		
		iSpellDuration = CSLGetMax( iSpellDuration, FloatToInt( GetLocalInt( oChar, "SC_iCasterLevels" )*0.75f ) );
		iSpellDuration = CSLGetMax( iSpellDuration, FloatToInt( CSLGetRogueLevel( oChar )*0.50f ) );
		if (DEBUGGING >= 8) { CSLDebug( "Item Duration Firing "+IntToString(iSpellDuration), oChar ); }

	}
	else if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		
		iSpellDuration = CSLGetAOETagInt( SCSPELLTAG_SPELLPOWER );
		if ( iSpellDuration != -1  )
		{
			if (DEBUGGING >= 8) { CSLDebug( "AOE Spell Duration Firing "+IntToString(iSpellDuration), GetAreaOfEffectCreator() ); }
			//return iSpellDuration;
		}
		else
		{
			if (DEBUGGING >= 8) { CSLDebug( "AOE Spell Duration Firing Invalid Power", GetAreaOfEffectCreator() ); }
		}

	}
	else if ( GetIsObjectValid(oChar) )
	{
		// Check Metamodifer Vars
		iSpellDuration = CSLReadIntModifier( oChar, "Spell_Duration" );
		if ( iSpellDuration == 0 ) 
		{
			iSpellDuration = HkGetSpellPower( oChar, iMaxDuration, iClass); // pass thru the to the power function, basically the same but without the max
			if (DEBUGGING >= 8) { CSLDebug(  "Doing Character : Raw Duration is " + IntToString( iSpellDuration ), oChar ); }
		}
	}
	else
	{
		iSpellDuration = 1;
		if (DEBUGGING >= 8) { CSLDebug(  "Invalid Object : Duration is " + IntToString( iSpellDuration ), oChar ); }
		return iSpellDuration;
	} // make sure it's only run on a valid object

	// Check Metamodifer Vars	
	iSpellDuration += CSLReadIntModifier( oChar, "Spell_DurationAdj" );
	
	if (DEBUGGING >= 6) { CSLDebug(  "HkGetSpellDuration1: Class " + CSLGetClassesDataName( iClass ) + " Duration is " + IntToString( iSpellDuration ), oChar ); }
	
	
	iSpellDuration =  ( iSpellDuration < iMaxDuration) ? iSpellDuration : iMaxDuration; // never more than the max provided.
	if (DEBUGGING >= 6) { CSLDebug(  "HkGetSpellDuration2: Class " + CSLGetClassesDataName( iClass ) + " Duration is " + IntToString( iSpellDuration ), oChar ); }
	
	iSpellDuration =  ( iSpellDuration < 1 ) ? 1 : iSpellDuration; // Minimum of 1 always
	if (DEBUGGING >= 6) { CSLDebug(  "HkGetSpellDuration3: Class " + CSLGetClassesDataName( iClass ) + " Duration is " + IntToString( iSpellDuration ), oChar ); }
	
	
	// possible hooks could be red wizard empowerments ( move from getting level to here )
	
	//int iMetaMagic = GetMetaMagicFeat();
	//if (nMeta Magic == METAMAGIC_EXTEND)
	//{
	//   iSpellDuration = iSpellDuration *2; //Duration is +100%
	//}
	if (DEBUGGING >= 4) { CSLDebug(  "HkGetSpellDuration: Class " + CSLGetClassesDataName( iClass ) + " Duration is " + IntToString( iSpellDuration ), oChar ); }
	//	int iSpellDuration = GetCasterLevel(oChar);	
	//	iSpellDuration =  ( iSpellDuration > iMaxPower) ? iMaxPower : iSpellDuration;	
	//	iSpellDuration =  ( iSpellDuration < 1 ) ? 1 : iSpellDuration;	
	//	return iSpellPower;
	return iSpellDuration;
}	


/**
* Gets the practiced caster bonus, note this is FYI information, it's already adde into the spell power, duration and other cached levels
* @param oCaster The caster of the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkGetPracticedBonus( object oCaster = OBJECT_SELF, int iClass = 255 )
{
	if ( iClass == 255 )
	{
		iClass = GetLocalInt( oCaster, "HKTEMP_Class" )-1;
	}
	
	return GetLocalInt(oCaster, "SC_sPracticedLevels"+IntToString(iClass) );
}


/**
* Gets the Red Wizard bonus for the currently cast spell accounting for class and school
* @param oCaster The caster of the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param iCurrentSchool = -1
* @return
* @see
* @replaces
*/
int HkGetRedWizardBonus( object oCaster = OBJECT_SELF, int iClass = -1, int iCurrentSchool = -1 )
{
	if ( iClass == -1 )
	{
		iClass = GetLocalInt( oCaster, "HKTEMP_Class" )-1;
	}
	if (iClass == CLASS_TYPE_WIZARD && GetHasFeat( FEAT_RED_WIZARD_SPELLCASTING_WIZARD, oCaster ) )
	{
		// now check for the school of the spell
		if ( iCurrentSchool == -1 )
		{
			iCurrentSchool = GetLocalInt( oCaster, "HKTEMP_School" );
		}
		int iCasterSchool = GetLocalInt( oCaster, "SC_iSpellSchool");
		//int iClassPosition = CSLGetPositionByClass( CLASS_TYPE_WIZARD,  oCaster );
		//int iCasterSchool = GetCasterClassSpellSchool(oCaster, iClassPosition );
		
		if ( iCurrentSchool == iCasterSchool )
		{
			return GetLevelByClass( CLASS_TYPE_RED_WIZARD, oCaster )/2;
		}
	}
	return 0;

}

int HkGetHitDice( object oChar = OBJECT_SELF, int bIncludeNegativeLevels = TRUE )
{
	int iHD = GetHitDice(oChar);
	if ( bIncludeNegativeLevels )
	{
		iHD -= CSLGetNegativeLevels( oChar );
	}
	return iHD;
}


/**
* Returns the base spell power for a given spell which relates to the casters level. Separated as a function soas to allow custom changes just affecting the amount of damage done. Note this is later translated into different hit dice, fixed amounts or other amounts based on the specific spell.
* @param oChar The character to get information from
* @param iMaxPower = 60
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkGetSpellPower( object oChar = OBJECT_SELF, int iMaxPower = 60, int iClass = 255 )
{
	if (DEBUGGING >= 9) { CSLDebug( "Starting HkGetSpellPower: iMaxPower="+IntToString( iMaxPower ), oChar ); }
	// Check Metamodifer Vars
	
	iMaxPower += CSLReadIntModifier( oChar, "Spell_CapAdj" );
		
	int iCasterLevel = 0;
	int iClassRow = 0;
	int iSpellPower = 0;
	
	if ( CSLIsItemValid( GetSpellCastItem() ) )
	{
		return HkGetItemCasterLevel( GetSpellCastItem(), oChar );
	}
	
		
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		
		iSpellPower = CSLGetAOETagInt( SCSPELLTAG_SPELLPOWER, OBJECT_SELF );
		if ( iSpellPower != -1  )
		{
			if (DEBUGGING >= 6) { CSLDebug(  "AOE Spell Power Firing "+IntToString(iSpellPower), GetAreaOfEffectCreator() ); }
			
			return iSpellPower;
		}
		else
		{
			if (DEBUGGING >= 6) { CSLDebug(  "AOE Spell Power Firing Invalid Power", GetAreaOfEffectCreator() ); }
		}

	}

	if ( !GetIsObjectValid(oChar) )
	{
		if (DEBUGGING >= 6) { CSLDebug( "HkGetSpellPower: oChar is not Valid, defaulting to 1", oChar ); }
		return 1;
	} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	
	// empower the dm's
	if (GetIsDM(oChar) && GetLocalInt(oChar, "CSL_UseTrueDMCasterLevel") != TRUE )
	{
		return 60;
	}
	
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oChar);
	}
	
	
	iSpellPower = CSLReadIntModifier( oChar, "Spell_Power" );
	
	// Check Metamodifer Vars
	if ( iSpellPower != 0 )
	{
		// we dont do anything then
		if (DEBUGGING >= 6) { CSLDebug( "HkGetSpellPower: Spellpower Overridden to "+IntToString(iSpellPower), oChar ); }
	}
	else if ( iClass == CLASS_TYPE_RACIAL || iClass == 255 )
	{
		iSpellPower = GetHitDice(oChar);
		
	}
	else
	{
		SCCacheStats( oChar );		
		
		if (DEBUGGING >= 6) { CSLDebug(  "Class = "+IntToString(iClass), oChar ); }
		// include any special modifiers here, this is prior to empowers or maximize
		
		// possible hooks could be red wizard empowerments ( move from getting level to here )
		// area empowerments, casting fireballs on the plane of fire
		// area nerfs, fireballs on plane of water
	
		// feat that raises the cap, nMaxPower is the
		//int iCasterLevel = HkGetCasterLevel( oCaster );
		//1
		
		iClassRow = HkPrepGetClassRowFromCache( oChar, iClass );
		iSpellPower = GetLocalInt(oChar, "SC_iSpellPower"+IntToString( iClassRow ) );
	}
	
	
	// Check Metamodifer Vars
	iSpellPower += CSLReadIntModifier( oChar, "Spell_PowerAdj");
	
		
	// cap it, might have the cap raised via feats
	iSpellPower =  ( iSpellPower > iMaxPower) ? iMaxPower : iSpellPower;
	
	if ( GetHasFeat( FEAT_FEY_POWER,  oChar ) && ( HkGetSpellSchool(oChar) == SPELL_SCHOOL_ENCHANTMENT || HkGetSpellSchool(oChar) == SPELL_SCHOOL_ELDRITCH ) ) { iSpellPower += 1; }
	if ( GetHasFeat( FEAT_FIENDISH_POWER,  oChar ) && ( HkGetDescriptor() == SCMETA_DESCRIPTOR_EVIL || HkGetSpellSchool(oChar) == SPELL_SCHOOL_ELDRITCH || HkGetSpellSchool() == SPELL_SCHOOL_EVOCATION ) ) { iSpellPower += 1; }
	
	
	if (iClass == CLASS_TYPE_WIZARD )
	{
		iCasterLevel += HkGetRedWizardBonus( oChar, iClass );
	}
	
	
	
	// check for negative levels
	iSpellPower = iSpellPower - CSLGetNegativeLevels( oChar );
	
	iSpellPower =  ( iSpellPower < 1 ) ? 1 : iSpellPower; // Minimum of 1 always
	if (DEBUGGING >= 4) { CSLDebug(  "HkGetSpellPower: Class " + CSLGetClassesDataName( iClass ) + " Power is " + IntToString( iSpellPower ), oChar ); }
	
	return iSpellPower;
}

/**
* The score used in Dispels for Difficulty (DC) the dispeller needs to beat
* @param oCreator
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkDispelDC( object oCreator, int iClass  = 255 )
{
	int iDC;
	int iAbjFeat;
	int iCreatorLevel;
	int iCreatorStatBonus = 0;
	
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCreator );
	}
	
	if ( SC_DISPELRULES == 0 )
	{
		// PNP rules Dispel DC: 11 + Caster level of effect
		iDC = 11;
		iAbjFeat = 0;
		iCreatorLevel = HkGetSpellPower( oCreator, 60,  iClass );
		
		// Check Metamodifer Vars
		iDC += CSLReadIntModifier( oCreator, "Save_DCadj");
	
		iDC = iDC + iAbjFeat + iCreatorStatBonus + iCreatorLevel;
		
		if (DEBUGGING >= 6) { CSLDebug(  "Your DC is set to ( iCreatorLevel + BaseDC + iAbjFeat + AbilModifier  ) "+IntToString( iDC + iAbjFeat + iCreatorStatBonus + iCreatorLevel ), oCreator  ); }
	}
	else if ( SC_DISPELRULES == 2 )
	{
		// PNP rules Dispel DC: 11 + Caster level of effect
		iDC = 11;
		iAbjFeat = 0;
		//iAbjFeat = GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oCreator ) ? SC_DISPEL_DISPELLER_ABJFEATWEIGHT : 0;
		if ( GetHasFeat( FEAT_ARCANE_DEFENSE_ABJURATION,  oCreator ) ) { iDC += 2; }
		if ( GetHasFeat( FEAT_SPELLCASTING_PRODIGY,  oCreator ) ) { iDC += 1; }
		iCreatorLevel = HkGetSpellPower( oCreator, 60,  iClass );
		
		// Check Metamodifer Vars
		iDC += CSLReadIntModifier( oCreator, "Save_DCadj");

		if ( GetHasFeat( FEAT_FEY_POWER,  oCreator ) && ( HkGetSpellSchool() == SPELL_SCHOOL_ENCHANTMENT || HkGetSpellSchool() == SPELL_SCHOOL_ELDRITCH ) ) { iDC += 1; }
		if ( GetHasFeat( FEAT_FIENDISH_POWER,  oCreator ) && ( HkGetDescriptor() == SCMETA_DESCRIPTOR_EVIL || HkGetSpellSchool() == SPELL_SCHOOL_ELDRITCH || HkGetSpellSchool() == SPELL_SCHOOL_EVOCATION  ) ) { iDC += 1; }
		// iCreatorStatBonus is 0
		iDC = iDC + iAbjFeat + iCreatorStatBonus + iCreatorLevel;
		
		
		if (DEBUGGING >= 6) { CSLDebug(  "Your DC is set to ( iCreatorLevel + BaseDC + iAbjFeat + AbilModifier  ) "+IntToString( iDC + iAbjFeat + iCreatorStatBonus + iCreatorLevel ), oCreator  ); }
	
	
	}
	else if ( SC_DISPELRULES == 3 ) // Seed DC: 70+CreatorLvl*2+StatBonus+AdjDefenseBonus
	{
		iDC = SC_DISPEL_RANGECONSTANT;
		if (DEBUGGING >= 6) { CSLDebug(  "BaseDC = "+IntToString( iDC ), oCreator  ); }
		
		int iAbility = CSLGetMainStatByClass( iClass, "DC" );	
		int bProdigy = GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCreator);
		iCreatorStatBonus =  GetAbilityModifier(iAbility, oCreator)+bProdigy;
		iCreatorStatBonus = iCreatorStatBonus * SC_DISPEL_STATSIGNIFIGANCE;
		if (DEBUGGING >= 6) { CSLDebug(  "Creator Stat Bonus = "+IntToString( iCreatorStatBonus ), oCreator  ); }
		
		iAbjFeat = GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oCreator ) ? SC_DISPEL_DISPELLER_ABJFEATWEIGHT : 0;
	
		if (DEBUGGING >= 6) { CSLDebug(  "iAbjFeat = "+IntToString( iAbjFeat ), oCreator  ); }
		
		iCreatorLevel = HkGetSpellPower( oCreator, 60, iClass );
		iCreatorLevel = HkGetCreatorLevelSkew( iCreatorLevel );
		if (DEBUGGING >= 6) { CSLDebug(  "Skewed CasterLevel = "+IntToString( iCreatorLevel ), oCreator  ); }
		
		// Check Metamodifer Vars
		iDC += CSLReadIntModifier( oCreator, "Save_DCadj");
		
		iDC = iDC + iAbjFeat + iCreatorStatBonus + iCreatorLevel;
		
		if (DEBUGGING >= 4) { CSLDebug(  "Your DC is set to ( iCreatorLevel + BaseDC + iAbjFeat + AbilModifier  ) "+IntToString( iDC + iAbjFeat + iCreatorStatBonus + iCreatorLevel ), oCreator  ); }
	}
	
	return iDC;
}


/**
* The score used in Dispels to see if they can remove an effect. This is added to d20 and if larger than the DC the spell is removed.
* @param oCaster The caster of the current spell
* @param iDispelSpellID = -1
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkDispelCheck( object oCaster, int iDispelSpellID = -1, int iClass  = 255 )
{
	int iResult;
	
	int iPrCBonus;
	int iCasterLevel;
	int iRollBonus;
	
	int iCasterStatBonus;
	int iAbjurationBonus;
	int iLevelAdjust;
	int bProdigy;
	int iAbility;
	int iBonuses;
	
	int iDispelSpellLevel;
	
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCaster );
	}
	
	// PNP rules this is just the casters caster level
	
	// Note each of these is a different rules set
	// Note that seeker arrow is treated as a dispel, but that is an option
	if ( SC_DISPELRULES == 0 ) // Vanilla Rules
	{
		iCasterLevel = HkGetSpellPower( oCaster, CSLGetDispelPowerCap( iDispelSpellID ), iClass );
		if (DEBUGGING >= 6) { CSLDebug(  "iCasterLevel 1:"+IntToString( iCasterLevel ), oCaster  ); }
		iResult = 11 + iCasterLevel;
		if (DEBUGGING >= 6) { CSLDebug(  "DC is 11 + "+IntToString( iCasterLevel )+" = "+IntToString( iResult ), oCaster  ); }
	
	}
	else if ( SC_DISPELRULES == 2 ) // Hybrid Rules - as vanilla but abjuration feats help some
	{
		int iDispelPowerCap = CSLGetDispelPowerCap( iDispelSpellID );
		
		iBonuses = GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster );
		if      (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))    { iBonuses += 3; }
		else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster)) { iBonuses += 2; }
		else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))         { iBonuses += 1; }
		
		if ( GetHasFeat( FEAT_FEY_POWER,  oCaster ) && ( HkGetSpellSchool() == SPELL_SCHOOL_ENCHANTMENT || HkGetSpellSchool() == SPELL_SCHOOL_ELDRITCH ) ) { iBonuses += 1; }
		if ( GetHasFeat( FEAT_FIENDISH_POWER,  oCaster ) && ( HkGetDescriptor() == SCMETA_DESCRIPTOR_EVIL || HkGetSpellSchool() == SPELL_SCHOOL_ELDRITCH || HkGetSpellSchool() == SPELL_SCHOOL_EVOCATION ) ) { iBonuses += 1; }
		
		// else { iAbjurationBonus = 0; }
		
		// this gives + 1-4
		iCasterLevel = HkGetSpellPower( oCaster, iDispelPowerCap, iClass );
		
		if (iDispelSpellID==SPELLABILITY_AA_SEEKER_ARROW_1 || iDispelSpellID==SPELLABILITY_AA_SEEKER_ARROW_2)
		{
			//nPrC = CLASS_TYPE_ARCANE_ARCHER;
			iCasterLevel += GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER, oCaster ); // ( 1-10)
		}
		
		if (iDispelSpellID==SPELLABILITY_PILFER_MAGIC)
		{
			// Might need to remove this
			//nPrC = CLASS_TYPE_ARCANETRICKSTER;
			iCasterLevel = CSLGetMin( iCasterLevel+GetLevelByClass( CLASS_TYPE_ARCANETRICKSTER, oCaster ), iDispelPowerCap);
		}
		
		//15+11 = 26
		
		//13 +11 = 
		//if (DEBUGGING >= 6) { CSLDebug(  "iCasterLevel 1:"+IntToString( iCasterLevel ), oCaster  ); }
		
		// iCasterLevel = CSLGetDispelPowerCap( iDispelSpellID )
		
		iResult = iCasterLevel + iBonuses; // why 11
		if (DEBUGGING >= 6) { CSLDebug(  "Check is "+IntToString( iCasterLevel )+" + Bonuses"+IntToString( iBonuses )+" = "+IntToString( iResult ), oCaster  ); }
	}
	else if ( SC_DISPELRULES == 3 ) // Seed Dispel Check: CasterLvl*2+StatBonus+AdjFocusBonus-SpellAdjust
	{
		// This is designed for PVP really, is 1d100 based, it does work but it does skew things towards max level players
		iCasterLevel = HkGetSpellPower( oCaster, 60, iClass ); // , CSLGetDispelPowerCap( iDispelSpellID ) <-- should it be capped perhaps
		if (DEBUGGING >= 6) { CSLDebug(  "Base Caster Level ="+IntToString( iCasterLevel ), oCaster  ); }
		
		// Get the caster level
		if (iDispelSpellID==SPELLABILITY_PILFER_MAGIC)
		{
			// Might need to remove this
			//nPrC = CLASS_TYPE_ARCANETRICKSTER;
			iPrCBonus = GetLevelByClass( CLASS_TYPE_ARCANETRICKSTER, oCaster );
		}
		else if (iDispelSpellID==SPELLABILITY_AA_SEEKER_ARROW_1 || iDispelSpellID==SPELLABILITY_AA_SEEKER_ARROW_2)
		{
			//nPrC = CLASS_TYPE_ARCANE_ARCHER;
			iPrCBonus = GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER, oCaster );
		}
		//if (DEBUGGING >= 6) { CSLDebug(  "PRC Bonus = "+IntToString( iPrCBonus ), oCaster  ); }
		iCasterLevel = CSLGetMax( CSLGetMin( iCasterLevel + iPrCBonus, GetHitDice( oCaster) ), iCasterLevel );
		iCasterLevel = HkGetCreatorLevelSkew( iCasterLevel );
		//if (DEBUGGING >= 6) { CSLDebug(  "Skewed CasterLevel = "+IntToString( iCasterLevel ), oCaster  ); }
		
		// The level of the dispel spell being used
		iDispelSpellLevel = CSLGetDispellLevel(iDispelSpellID);
		//if (DEBUGGING >= 6) { CSLDebug(  "Level of Dispel Being Used = "+IntToString( iDispelSpellLevel ), oCaster  ); }
		
		// Stat Attribute Bonus	
		iAbility = CSLGetMainStatByClass( iClass, "DC" );	
		bProdigy = GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster );
		iCasterStatBonus =  GetAbilityModifier(iAbility, oCaster )+bProdigy;
		iCasterStatBonus = iCasterStatBonus * SC_DISPEL_STATSIGNIFIGANCE;
		//if (DEBUGGING >= 6) { CSLDebug(  "Caster Stat Bonus = "+IntToString( iCasterStatBonus ), oCaster  ); }
		
		// Abjuration Bonus Feats
		if      (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))    { iAbjurationBonus = 3; }
		else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster)) { iAbjurationBonus = 2; }
		else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))         { iAbjurationBonus = 1; }
		else { iAbjurationBonus = 0; }
		iAbjurationBonus = iAbjurationBonus * SC_DISPEL_DISPELLER_ABJFEATWEIGHT;
		//if (DEBUGGING >= 6) { CSLDebug(  "Bonus Feats = "+IntToString( iAbjurationBonus ), oCaster  ); }
		// 
		//if (DEBUGGING >= 6) { CSLDebug(  "Double Check = "+IntToString( ( SC_DISPEL_DISPELLER_SPELLPOWERINCREMENT * ( 9 - iDispelSpellLevel) ) ), oCaster  ); }
		
		iResult = iCasterLevel + ( iAbjurationBonus ) + iCasterStatBonus - ( SC_DISPEL_DISPELLER_SPELLPOWERINCREMENT * ( 9 - iDispelSpellLevel) ) ;																											
		if (DEBUGGING >= 6) { CSLDebug(  "Dispel Check: Skewed iCasterLevel + ( iAbjurationBonus ) + iCasterStatBonus - ( SpellPowerIncrement*(9-DispelSpellLevel) ) = "+IntToString( iResult ), oCaster  ); }
		//iLevelAdjust    = 5 * (9 - CSLGetDispellLevel(iDispelSpellID) );
		//iRollBonus      = 0;
		//iCasterLevel  *= 2; // doubles the level for the check
		//iCasterLevel  += iRollBonus; // the roll bonus
		//iCasterLevel  -= iLevelAdjust;
	}
	return iResult;
}

/**
* Gets the Feat Based DC Bonus the caster receives. Does not includes the bonuses based on epic levels.
* @param oCaster The caster of the current spell
* @param iCurrentSchool = -1
* @param iCurrentSubSchool = -1
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param iCurrentDescriptor = -1
* @return The DC Bonus the caster receives due to feats and other effects
* @see
* @replaces
*/
int HkGetSpellDCBonus( object oCaster = OBJECT_SELF, int iCurrentSchool = -1, int iCurrentSubSchool = -1, int iClass = -1, int iCurrentDescriptor = -1 )
{
	if ( iClass == -1 )
	{
		iClass = GetLocalInt( oCaster, "HKTEMP_Class" )-1;
	}
	if ( iCurrentSchool == -1 )
	{
		iCurrentSchool = GetLocalInt( oCaster, "HKTEMP_School" );
	}
	if ( iCurrentSubSchool == -1 )
	{
		iCurrentSubSchool = GetLocalInt( oCaster, "HKTEMP_SubSchool" );
	}
	if ( iCurrentDescriptor == -1 )
	{
		iCurrentDescriptor = GetLocalInt( oCaster, "HKTEMP_Descriptor" );
	}
	
	int iBonus = CSLGetDCSchoolFocusAdjustment(oCaster, iCurrentSchool );
	
	
	
	return iBonus;
}


/**
* Gets the Feat Based Bonus the defender receives to DC. Also used to boost some summons.
* @param oCaster The caster of the current spell
* @param iCurrentSchool = -1
* @param iCurrentSubSchool = -1
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param iCurrentDescriptor = -1 )
* @return
* @see
* @replaces
*/
int HkGetSpellDefenseBonus( object oCaster = OBJECT_SELF,  int iCurrentSchool = -1, int iCurrentSubSchool = -1, int iClass = -1, int iCurrentDescriptor = -1 )
{
	if ( iClass == -1 )
	{
		iClass = GetLocalInt( oCaster, "HKTEMP_Class" )-1;
	}
	if ( iCurrentSchool == -1 )
	{
		iCurrentSchool = GetLocalInt( oCaster, "HKTEMP_School" );
	}
	if ( iCurrentSubSchool == -1 )
	{
		iCurrentSubSchool = GetLocalInt( oCaster, "HKTEMP_SubSchool" );
	}
	if ( iCurrentDescriptor == -1 )
	{
		iCurrentDescriptor = GetLocalInt( oCaster, "HKTEMP_Descriptor" );
	}
	
	int iBonus = 0;
	
	
	if ( iCurrentSchool == SPELL_SCHOOL_ABJURATION )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_CONJURATION  )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_CONJURATION, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_DIVINATION )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_DIVINATION, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_ENCHANTMENT )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_ENCHANTMENT, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_EVOCATION )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_EVOCATION, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_ILLUSION )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_ILLUSION, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_NECROMANCY )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_NECROMANCY, oCaster))         { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_TRANSMUTATION )
	{
		if (GetHasFeat(FEAT_ARCANE_DEFENSE_TRANSMUTATION, oCaster))         { iBonus++; }
	}
	return iBonus;
}


//* note - PRC has spell penetration as well pulled, perhaps add this in as well.

//void
/* DC = (a constant, I think its 10) + spell level + ability modifier + 1 (if spellcasting prodigy) + spell focus feat + greater spell focus feat + epic spell focus feat + spell unique modifier (for example, implosion +3, epic spell +5) */
/*
Also, +RW bonus, +Spellcasting Prodigy, and + Epic DC.
Red Wizards get a +1 to their saves in their specialized school.
Spellcasting Prodigy's a +1 to saves, as the description suggests.
Every 3 levels past 20 get you another point on DCs.
Oh, and gnomes get a +1 on illusions.
*/




// Private function - Get the save DC bonus for the specified spell
// JXPrivateGetSpellDCBonusFromSpell <- Jailiax
// This is changed soas to use the spell attributes of the currently being cast spell
/*
int HkGetSpellDCBonus( object oCreature )
{
	int iSpellSaveDC = 0;

	int iSpellSchool = HkGetSpellSchool();
	switch (iSpellSchool)
	{
		case SPELL_SCHOOL_EVOCATION:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCreature))			{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCreature))		{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oCreature))				{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_TRANSMUTATION:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCreature))		{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCreature))	{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oCreature))			{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_NECROMANCY:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCreature))		{ iSpellSaveDC += 3; break; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCreature))		{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCreature))				{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_ILLUSION:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCreature))			{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCreature))		{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oCreature))				{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_ABJURATION:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCreature))		{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCreature))		{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCreature))				{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_CONJURATION:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCreature))		{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCreature))	{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCreature))			{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_DIVINATION:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oCreature))		{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oCreature))	{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oCreature))				{ iSpellSaveDC += 1; }
			break;
		case SPELL_SCHOOL_ENCHANTMENT:
			if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCreature))		{ iSpellSaveDC += 3; }
			else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCreature))	{ iSpellSaveDC += 2; }
			else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oCreature))			{ iSpellSaveDC += 1; }
			break;
	}
	return iSpellSaveDC;
}
*/

// return GetSpellSaveDC();




/**
* Initiates a swift action
* @author drammel - Tome of Battle
* @param oPC = OBJECT_SELF
* @param iManeuver = 0
* @see HkSwiftActionIsActive, HkTrackSave
* @todo Fully implement HkSwiftActionStart so it is working
* @replaces
*/
void HkSwiftActionStart( object oPC = OBJECT_SELF, int iManeuver = 0 )
{
	SetLocalInt(oPC, "Swift", 1);
	// DelayCommand(6.0f, SetLocalInt(oToB, "Swift", 0));
	DelayCommand(6.0f, SetLocalInt(oPC, "Swift", 0));
	
	string sTga = Get2DAString("maneuvers", "ICON", iManeuver );
	
	// support for the tome of battle
	SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", sTga);
	DelayCommand(6.0f, SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", "b_empty.tga"));
}

/**
* Checks to see if a swift action is active
* @author drammel - Tome of Battle
* @param oPC = OBJECT_SELF
* @return
* @see HkSwiftActionStart, HkTrackSave
* @replaces
*/
int HkSwiftActionIsActive( object oPC = OBJECT_SELF )
{
	if (GetLocalInt(oPC, "Swift") == 0)
	{
		return FALSE;
	}
	return TRUE;
}

// character can have 2 stances
void hkSetStance1( int iStance, object oCaster = OBJECT_SELF )
{
	SetLocalInt(oCaster, "Stance", iStance);
}

int hkGetStance1( object oCaster = OBJECT_SELF  )
{
	return GetLocalInt(oCaster, "Stance" );
}

void hkSetStance2( int iStance, object oCaster = OBJECT_SELF )
{
	SetLocalInt(oCaster, "Stance2", iStance);
}

int hkGetStance2( object oCaster = OBJECT_SELF  )
{
	return GetLocalInt(oCaster, "Stance2" );
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int hkStanceGetHasActive( object oTarget, int iStance0 = -1, int iStance1 = -1, int iStance2 = -1, int iStance3 = -1, int iStance4 = -1, int iStance5 = -1, int iStance6 = -1, int iStance7 = -1, int iStance8 = -1, int iStance9 = -1 )
{
	if (GetCurrentHitPoints(oTarget) < 1)
	{
		return FALSE;
	}
	
	int nCurStance = GetLocalInt(oTarget, "Stance");
	int nCurStance2 = GetLocalInt(oTarget, "Stance2");
	
	if ( nCurStance == 0 || nCurStance2 == 0 )
	{
		return FALSE;
	}
	
	if ( iStance0 == -1 )
	{
		return FALSE;
	}
	else if ( iStance0 == nCurStance || iStance0 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance1 == -1 )
	{
		return FALSE;
	}
	else if ( iStance1 == nCurStance || iStance1 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance2 == -1 )
	{
		return FALSE;
	}
	else if ( iStance2 == nCurStance || iStance2 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance3 == -1 )
	{
		return FALSE;
	}
	else if ( iStance3 == nCurStance || iStance3 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance4 == -1 )
	{
		return FALSE;
	}
	else if ( iStance4 == nCurStance || iStance4 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance5 == -1 )
	{
		return FALSE;
	}
	else if ( iStance5 == nCurStance || iStance5 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance6 == -1 )
	{
		return FALSE;
	}
	else if ( iStance6 == nCurStance || iStance6 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance7 == -1 )
	{
		return FALSE;
	}
	else if ( iStance7 == nCurStance || iStance7 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance8 == -1 )
	{
		return FALSE;
	}
	else if ( iStance8 == nCurStance || iStance8 == nCurStance2 )
	{
		return TRUE;
	}
	
	if ( iStance9 == -1 )
	{
		return FALSE;
	}
	else if ( iStance9 == nCurStance || iStance9 == nCurStance2 )
	{
		return TRUE;
	}
	
	return FALSE;
}

void hkSetCounter( int iCounter, object oCaster = OBJECT_SELF )
{
	SetLocalInt(oCaster, "Counter", iCounter);
}

int hkGetCounter( object oCaster = OBJECT_SELF  )
{
	return GetLocalInt(oCaster, "Counter" );
}

int hkCounterGetHasActive( object oTarget, int iCounter0 = -1, int iCounter1 = -1, int iCounter2 = -1, int iCounter3 = -1, int iCounter4 = -1, int iCounter5 = -1, int iCounter6 = -1, int iCounter7 = -1, int iCounter8 = -1, int iCounter9 = -1 )
{
	if (GetCurrentHitPoints(oTarget) < 1)
	{
		return FALSE;
	}
	
	int iCurCounter = GetLocalInt(oTarget, "Counter");
	
	if ( iCurCounter == 0 )
	{
		return FALSE;
	}
	
	if ( iCounter0 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter0 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter1 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter1 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter2 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter2 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter3 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter3 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter4 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter4 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter5 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter5 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter6 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter6 == iCurCounter )
	{
		return TRUE;
	}
	
	if ( iCounter7 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter7 == iCurCounter  )
	{
		return TRUE;
	}
	
	if ( iCounter8 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter8 == iCurCounter  )
	{
		return TRUE;
	}
	
	if ( iCounter9 == -1 )
	{
		return FALSE;
	}
	else if ( iCounter9 == iCurCounter  )
	{
		return TRUE;
	}
	
	return FALSE;
}

/**
* The score used in Spell Resist to see if they can beat a creatures spell resistance. This is added to d20 and if larger than the Spell resistance, then the resistance can be ignored.
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
int HkGetSpellPenetration( object oCaster, int iClass  = 255 )
{
	// this is the base score prior to the 1d20 roll which is needed to beat a targets spell resistance
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCaster );
	}

	int iCasterLevel = HkGetCasterLevel( oCaster, iClass );

	// Increase the caster level if the caster has a spell penetration feature
	if ( GetHasFeat(FEAT_SPELL_PENETRATION, oCaster) )
	{
		iCasterLevel += 2;
		if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
		{
			iCasterLevel += 4;
		}
		else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))
		{
			iCasterLevel += 2;
		}
	}
	
	// Check Metamodifer Vars
	iCasterLevel += CSLReadIntModifier( oCaster, "Save_ResistCheckAdj");
	
	return iCasterLevel;
}

/**
* The DC used for targets to save against the given spell.
* @param oCaster The caster of the current spell
* @param oTarget The Target of the current spell
* @return
* @see
* @replaces
*/
int HkGetSpellSaveDC( object oCaster = OBJECT_SELF, object oTarget = OBJECT_INVALID, int iSpellid = -1, int iClass = 255 )
{
	/* Syrus Version ( for reference )
	 int iSpellSaveDC = GetSpellSaveDC();

    if(GetLastSpellCastClass()==CLASS_TYPE_INVALID) {
        iSpellSaveDC = 10 + HkGetSpellPower(oCaster)/3;  // creature spellability save
    } else if(
        // Tyranny Domain - Compulsion Spells Granted Power
        (SGGetHasDomain(DOMAIN_TYRANNY, oCaster) && SGGetSpellSubSchool(oCaster)==SPELL_SUBSCHOOL_COMPULSION) || 

        // Horrid Wilting vs Water Elementals and Plant Creatures
        (GetSpellId()==SPELL_HORRID_WILTING &&CSLGetIsElemental(oTarget) && FindSubString(GetStringLowerCase(GetName(oTarget)),"water")>-1)

    ) {
        iSpellSaveDC += 2;  // technically it's -2 to targets roll, but this is the same thing
    } else if(GetLocalInt(oCaster, "SG_L_SPELLTURN_CASTER_LEVEL")>0) {
        iSpellSaveDC = 10 + GetLocalInt(oCaster, "SG_L_SPELLTURN_CASTER_LEVEL");
    */
    
    
	
	if ( iSpellid == -1 )
	{
		iSpellid = HkGetSpellId( oCaster );
	}
	
	
	// first look for a stored save dc on the caster and just use this
	int iDC = CSLReadIntModifier( oCaster, "Save_DC", -1 );
	if ( iDC > -1 )
	{
		//if (DEBUGGING >= 4) { CSLDebug(  " Using stored SaveDC of = "+IntToString( iDC ), oCaster  ); }
		return iDC;
	}
	
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		//SendMessageToPC(  GetAreaOfEffectCreator(), "AOE Firing" );
		iDC = CSLGetAOETagInt( SCSPELLTAG_SPELLSAVEDC );
		if ( iDC > -1 )
		{
			//if (DEBUGGING >= 6) { CSLDebug(  "AOE Save = "+IntToString( iDC ), oCaster  ); }
			return iDC;
			
			
		}
	}
	else if ( GetObjectType(oCaster) == OBJECT_TYPE_PLACEABLE )
	{
		return GetWillSavingThrow(oCaster); // Placeables use their will save field for this
	}
	
	iDC = 10;
	//if (DEBUGGING >= 4) { CSLDebug(  " Starting with = "+IntToString( iDC ), oCaster  ); }
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCaster );
	}
	
	int iCurrentSchool = GetLocalInt( oCaster, "HKTEMP_School" );
	int iCurrentSubSchool = GetLocalInt( oCaster, "HKTEMP_SubSchool" );
	int iCurrentDescriptor = GetLocalInt( oCaster, "HKTEMP_Descriptor" );
	int iSpellLevel = HkGetSpellLevel( GetSpellId() );
	//if ( iSpellLevel == 10 )
	//{
	//	iDC = 20;	
	//}
	
	// Add in the spell level, with epic spells this makes it 20
	iDC += iSpellLevel;
	//if (DEBUGGING >= 4) { CSLDebug(  " Spell Level += "+IntToString( iSpellLevel ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	
	//Bonus is +1DC every 3 levels after 20, note that folks get this on epic spells
	iDC += CSLGetMax(0,( HkGetCasterLevel( oCaster, iClass)-20 )/3 ); 
	//if (DEBUGGING >= 4) { CSLDebug(  " Epic bonus += "+IntToString( CSLGetMax(0,( HkGetCasterLevel( oCaster, iClass)-20 )/3 ) ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	
	//iDC += iBonus;
	iDC += HkGetSpellDCBonus( oCaster, iCurrentSchool, iCurrentSubSchool, iClass, iCurrentDescriptor );
	//if (DEBUGGING >= 4) { CSLDebug(  " DC Bonus += "+IntToString( HkGetSpellDCBonus( oCaster, iCurrentSchool, iCurrentSubSchool, iClass, iCurrentDescriptor ) ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	
	iDC += HkGetRedWizardBonus(oCaster, iClass, iCurrentSchool );
	//if (DEBUGGING >= 4) { CSLDebug(  " red wizard += "+IntToString( HkGetRedWizardBonus(oCaster, iClass, iCurrentSchool ) ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	
	// this be a warlock
	if ( iClass == CLASS_TYPE_WARLOCK ) // HkGetSpellSchool(oCaster) == SPELL_SCHOOL_ELDRITCH
	{
		if ( iSpellid == SPELLABILITY_I_ELDRITCH_BLAST )
		{
			if ( GetHasFeat(FEAT_ABILITY_FOCUS_ELDRITCH_BLAST, oCaster) )
			{
				iDC += 2;
			}
		}
		
		// be generous and let this stack ( do an else if otherwise )
		if ( GetHasFeat(FEAT_ABILITY_FOCUS_INVOCATIONS, oCaster) )
		{
			iDC += 2;
		}
		
	}
	
	
	int iAbility = CSLGetMainStatByClass( iClass, "DC" );
	if ( iAbility < 0 || iAbility > 5 ) // safety check
	{
		iAbility = ABILITY_CHARISMA;
	}
	iDC += GetAbilityModifier(iAbility);
	//if (DEBUGGING >= 4) { CSLDebug(  " stat bonus += "+IntToString(  GetAbilityModifier(iAbility) ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	//this is the engine version here GetSpellSaveDC();
	
	
	
	
	
	//if ( iDC > 120 )
	//{
	//	return 10;
	//}
	
	// 
	
	
	// Check Metamodifer Vars
	iDC += CSLReadIntModifier( oCaster, "Save_DCadj");
	//if (DEBUGGING >= 4) { CSLDebug(  " Save DC Adjust += "+IntToString( CSLReadIntModifier( oCaster, "Save_DCadj") ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	
	// add in the prodigy feat
	iDC += GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster);
	//if (DEBUGGING >= 4) { CSLDebug(  " Save DC Prodigy += "+IntToString( GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster) ), oCaster  ); }
	//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	
	
	
	
	if ( GetHasFeat( FEAT_FEY_POWER,  oCaster ) && ( HkGetSpellSchool(oCaster) == SPELL_SCHOOL_ENCHANTMENT || HkGetSpellSchool(oCaster) == SPELL_SCHOOL_ELDRITCH ) )
	{ 
		iDC += 1; 
		//if (DEBUGGING >= 4) { CSLDebug(  " fey power += "+IntToString( 1 ), oCaster  ); }
		//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	}
	if ( GetHasFeat( FEAT_FIENDISH_POWER,  oCaster ) && ( HkGetDescriptor() == SCMETA_DESCRIPTOR_EVIL || HkGetSpellSchool() == SPELL_SCHOOL_ELDRITCH || HkGetSpellSchool() == SPELL_SCHOOL_EVOCATION ) )
	{ 
		iDC += 1;
		//if (DEBUGGING >= 4) { CSLDebug(  " Fiendish power += "+IntToString( 1 ), oCaster  ); }
		//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	}
	
	if ( GetHasFeat( FEAT_SHADOW_TRICKSTER,  oCaster ) && HkGetSpellSchool( oCaster ) == SPELL_SCHOOL_ILLUSION && hkStanceGetHasActive( oCaster, STANCE_ASSNS_STANCE, STANCE_BALANCE_SKY, STANCE_CHILD_SHADOW, STANCE_DANCE_SPIDER, STANCE_ISLAND_OF_BLADES, STANCE_DANCING_MOTH ) )
	{
		iDC += 2;
		//if (DEBUGGING >= 4) { CSLDebug(  " shadow trickster += "+IntToString( 2 ), oCaster  ); }
		//if (DEBUGGING >= 4) { CSLDebug(  "Save = "+IntToString( iDC ), oCaster  ); }
	}
	
	
	//if (DEBUGGING >= 4) { CSLDebug(  "Final Save = "+IntToString( iDC ), oCaster  ); }
	return iDC;
}


/*
// Jailiax version of the spellsave DC Function, here for reference and to make sure what i have does all the same work this does

// Get the save DC for the specified spell cast by a creature
// - iSpellId SPELL_* constant
// - oCreature Creature from which to get the spell save DC
// - iClass CLASS_TYPE_* constant (CLASS_TYPE_INVALID to use the best caster class able to cast the spell)
// * Returns the creature's spell save DC
int JXImplGetCreatureSpellSaveDC(int iSpellId, object oCreature = OBJECT_SELF, int iClass = CLASS_TYPE_INVALID)
{
	if (iSpellId < 0) return 0;

	// Get the class used to cast the current spell
	if (iClass == CLASS_TYPE_INVALID)
		iClass = GetLastSpellCastClass();

	// Get the best creature's class able to cast the spell
	if (iClass == CLASS_TYPE_INVALID)
		iClass = JXGetClassForSpell(iSpellId, oCreature);

	// Still no caster class found ? Then no caster level...
	if (iClass == CLASS_TYPE_INVALID) return 0;

	// Set the base spell save DC 
	int iSpellSaveDC = 10;
	// Add the spell save DC bonus based on the spell level
	if (iClass == CLASS_TYPE_ASSASSIN)
		iSpellSaveDC += JXPrivateGetAssassinSpellLevel(iSpellId);
	else if (iClass == CLASS_TYPE_BLACKGUARD)
		iSpellSaveDC += JXPrivateGetBlackguardSpellLevel(iSpellId);
	else
		iSpellSaveDC += JXGetBaseSpellLevel(iSpellId, iClass);
	// Add the spell save DC bonus that depends on the spell
	iSpellSaveDC += JXPrivateGetSpellDCBonusFromSpell(iSpellId, oCreature);
	// Add the caster ability modifier
	int iAbility = -1;
	if (iClass == CLASS_TYPE_ASSASSIN)
		iAbility = ABILITY_INTELLIGENCE;
	else if (iClass == CLASS_TYPE_BLACKGUARD)
		iAbility = ABILITY_WISDOM;
	else
	{
		iAbility = JXClassGetCasterAbility(iClass);
	}
	iSpellSaveDC += GetAbilityModifier(iAbility, oCreature);

	return iSpellSaveDC;
}


*/





int HkSaveAllowReroll( object oTarget ) // int iSavingThrow, object oTarget, int iDC, int iSaveType=SAVING_THROW_TYPE_NONE, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL
{
	object oToB = CSLGetDataStore(oTarget);
	if (!GetIsObjectValid(oToB))
	{
		return FALSE;
	}
	
	// we do a swift action to allow a reroll
	if ( hkGetCounter(oTarget) == COUNTER_IRON_HEART_FOCUS && HkSwiftActionIsActive(oTarget) == FALSE )
	{ //Priotity is given to Iron Heart Focus over Zealous Surge because Zealous Surge has a once per day use.
		SetLocalInt(oToB, "IronHeartFocus", 1);

		return TRUE;
	}

	if ( GetHasFeat(6815, oTarget) ) //Zealous Surge
	{// Assuemed that oToB is valid if you have this feat.
		if ((GetLocalInt(oToB, "ZealousSurge") == 1) && (GetLocalInt(oToB, "ZealousSurgeUse") == 1))
		{
			FloatingTextStringOnCreature("<color=cyan>*Zealous Surge Reroll!*</color>", oTarget, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			SetLocalInt(oToB, "ZealousSurgeUse", 0);

			return TRUE;
		}
	}
	
	return FALSE;
}



int HkAuraOfPerfectOrderSaveCheck( int iSavingThrow, object oTarget, int iDC, int iSaveType=SAVING_THROW_TYPE_NONE, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL )
{
	if (GetLocalInt(oTarget, "AuraOfPerfectOrder") == 1) //Assumed that the Target has the Tome of Battle if this is set to 1.
	{
		if ( hkStanceGetHasActive( oTarget, STANCE_AURA_OF_PERFECT_ORDER ) )
		{// From here we're attempting to rebuild the Saving Throw functions.
		
			object oToB = CSLGetDataStore(oTarget);
			SetLocalInt(oTarget, "AuraOfPerfectOrder", 0); // Used only once per round, it's a swift action.
			SetLocalInt(oToB, "SaveType", iSavingThrow);
			SetLocalInt(oToB, "SaveTarget", ObjectToInt(oTarget));
			DelayCommand(1.0f, SetLocalInt(oToB, "SaveType", 0));
			DelayCommand(1.0f, SetLocalInt(oToB, "SaveTarget", 0));
		
			int nBaseSave;
			if (iSavingThrow == SAVING_THROW_FORT)
			{
				nBaseSave = GetFortitudeSavingThrow(oTarget);// Tested to confirm it does add effect bonuses.
			}
			else if (iSavingThrow == SAVING_THROW_REFLEX)
			{
				nBaseSave = GetReflexSavingThrow(oTarget);
			}
			else if (iSavingThrow == SAVING_THROW_WILL)
			{
				nBaseSave = GetWillSavingThrow(oTarget);
			}

			if ((11 + nBaseSave) < iDC)
			{
				nPriorCheckSucces = SAVING_THROW_CHECK_SUCCEEDED;
			}
			else if (( nBaseSave - 11 ) > iDC)
			{
				nPriorCheckSucces = SAVING_THROW_CHECK_FAILED;
			}

			if (iSaveType == SAVING_THROW_TYPE_CHAOS)
			{
				nPriorCheckSucces = SAVING_THROW_CHECK_SUCCEEDED; // It is an Aura of Perfect Order after all.
			}
		
		}
	}
	return nPriorCheckSucces;
}
/**
* does a saving throw check with the given parameters
* @param iSavingThrow
* @param oTarget The Target of the current spell
* @param iDC The DC the target has to beat
* @param iSaveType The required type of saving throw, defaults to SAVING_THROW_TYPE_NONE, but can be SAVING_THROW_FORT, SAVING_THROW_REFLEX, SAVING_THROW_WILL
* @param oSaveVersus = OBJECT_SELF
* @param fDelay Amount of time to delay feedback from the given saving throw, used to make things like cones of cold look like they actually radiate outward instead of happening instantly
* @return constants SAVING_THROW_RESULT_FAILED, SAVING_THROW_RESULT_SUCCESS or SAVING_THROW_RESULT_IMMUNE
* @see
* @todo use constants from nwscript.nss instead of my homebrew ones
* @replaces XXXMySavingThrow
*/
int HkSavingThrow(int iSavingThrow, object oTarget, int iDC, int iSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay=0.0f, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL )
{
	if ( !GetIsObjectValid(oTarget) ) { return 1;} // make sure it's only run on a valid object
	
	if ( GetIsDM(oTarget) ) { return SAVING_THROW_CHECK_IMMUNE;} // make sure it ignores dm's

	// -------------------------------------------------------------------------
	// GZ: sanity checks to prevent wrapping around
	// -------------------------------------------------------------------------
	if (iDC<1)
	{
		iDC = 1;
	}
	else if (iDC > 125)
	{
		iDC = 15; // go ahead and reduce this on the sanity check
	}
	else if (iDC > 255)
	{
		iDC = 255;
	}
	
	
	if ( nPriorCheckSucces == SAVING_THROW_RESULT_ROLL )
	{
		nPriorCheckSucces = HkAuraOfPerfectOrderSaveCheck( iSavingThrow, oTarget, iDC, iSaveType, nPriorCheckSucces );
	}
	
	int bResult = SAVING_THROW_RESULT_FAILED;
	effect eVis;
	
	if ( nPriorCheckSucces == SAVING_THROW_RESULT_REMEMBER )
	{
		//nPriorCheckSucces = SAVING_THROW_CHECK_IMMUNE; // , int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL
		// check for stored var for the given spell
		if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT ) // use OBJECT_SELF instead of oAttacker, since oAttacker could be the caster
		{ // this is an AOE
			bResult = GetLocalInt(OBJECT_SELF, "CSL_LASTSAVE_"+ObjectToString(oTarget))-1;
			if ( nPriorCheckSucces != -1 )
			{
				nPriorCheckSucces = SAVING_THROW_RESULT_ROLL;
			}
		}
		else
		{
			CSL_SPELLCAST_SERIALID = CSLGetRandomSerialNumber( CSL_SPELLCAST_SERIALID );
			bResult = GetLocalInt( oTarget, "CSL_LASTSAVE_"+IntToString(CSL_SPELLCAST_SERIALID))-1;
			if ( nPriorCheckSucces != -1 )
			{
				nPriorCheckSucces = SAVING_THROW_RESULT_ROLL;
			}
		}
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_FAILED )
	{
		bResult = SAVING_THROW_CHECK_FAILED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_SUCCEEDED )
	{
		bResult = SAVING_THROW_CHECK_SUCCEEDED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE )
	{
		bResult = SAVING_THROW_CHECK_IMMUNE;
	}
	else
	{
		bResult = SAVING_THROW_RESULT_ROLL;
	}
	
		
	if ( nPriorCheckSucces == SAVING_THROW_RESULT_ROLL )
	{
		if(iSavingThrow == SAVING_THROW_FORT)
		{
			bResult = FortitudeSave( oTarget, iDC, iSaveType, oSaveVersus );
		}
		else if( iSavingThrow == SAVING_THROW_REFLEX)
		{
			bResult = ReflexSave(oTarget, iDC, iSaveType, oSaveVersus );
		}
		else if(iSavingThrow == SAVING_THROW_WILL)
		{
			bResult = WillSave( oTarget, iDC, iSaveType, oSaveVersus );
		}
		
		if( bResult == SAVING_THROW_RESULT_FAILED && HkSaveAllowReroll( oTarget ) )
		{
			if(iSavingThrow == SAVING_THROW_FORT)
			{
				bResult = FortitudeSave( oTarget, iDC, iSaveType, oSaveVersus );
			}
			else if( iSavingThrow == SAVING_THROW_REFLEX)
			{
				bResult = ReflexSave(oTarget, iDC, iSaveType, oSaveVersus );
			}
			else if(iSavingThrow == SAVING_THROW_WILL)
			{
				bResult = WillSave( oTarget, iDC, iSaveType, oSaveVersus );
			}
		}
		
		
	}
	
	
	
	
	int iSpellId = HkGetSpellId();

	/*
			return 0 = FAILED SAVE
			return 1 = SAVE SUCCESSFUL
			return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
	*/
	
	
	
	
	
	if(bResult == SAVING_THROW_RESULT_FAILED)
	{
		if((iSaveType == SAVING_THROW_TYPE_DEATH || iSpellId == SPELL_WEIRD || iSpellId == SPELL_FINGER_OF_DEATH) && iSpellId != SPELL_HORRID_WILTING)
		{
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget));
		}
	}
	//redundant comparison on bValid, let's move the eVis line down below
	/*    if(bValid == 2)
	{
			eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
	}*/
	if(bResult == SAVING_THROW_RESULT_SUCCESS || bResult == SAVING_THROW_RESULT_IMMUNE )
	{
		if(bResult == SAVING_THROW_RESULT_IMMUNE)
		{
			//eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);  // no longer using NWN1 VFX
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE ), oTarget));
			/*
			If the spell is save immune then the link must be applied in order to get the true immunity
			to be resisted.  That is the reason for returing false and not true.  True blocks the
			application of effects.
			*/
			bResult = FALSE;
		}
		
	}
	
	if ( nPriorCheckSucces == SAVING_THROW_RESULT_REMEMBER )
	{
		//nPriorCheckSucces = SAVING_THROW_CHECK_IMMUNE; // , int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL
		// check for stored var for the given spell
		if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT ) // use OBJECT_SELF instead of oAttacker, since oAttacker should be the caster
		{ // this is an AOE
			SetLocalInt(OBJECT_SELF, "CSL_LASTSAVE_"+ObjectToString(oTarget), bResult+1); // this should be tracked for the life of the AOE, or 24 hours, just assume the AOE won't last as long for now
		}
		else
		{
			SetLocalInt( oTarget, "CSL_LASTSAVE_"+IntToString(CSL_SPELLCAST_SERIALID), bResult+1);
			DelayCommand(6.0f, DeleteLocalInt(oTarget,"CSL_LASTSAVE_"+IntToString(CSL_SPELLCAST_SERIALID)) );// won't need it very long if it's an not an AOE
		}
	}
	
	
	
	
	
	
	// tracking saves, as per tome of battle code, mainly to support things its doing in it's track save function
	SetLocalInt(oSaveVersus, "HKTEMP_SaveType", iSavingThrow);
	SetLocalInt(oSaveVersus, "HKTEMP_SaveTarget", ObjectToInt(oTarget));
	DelayCommand(1.0f, DeleteLocalInt(oSaveVersus, "HKTEMP_SaveType" ));
	DelayCommand(1.0f, DeleteLocalInt(oSaveVersus, "HKTEMP_SaveTarget" ));
	
	return bResult;
}

/* PRC version
int PRCSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    int nSpell = HkGetSpellId();

    // Iron Mind's Mind Over Body, allows them to treat other saves as will saves up to 3/day.
    // No point in having it trigger when its a will save.
    if (GetLocalInt(oTarget, "IronMind_MindOverBody") && nSavingThrow != SAVING_THROW_WILL)
    {
        nSavingThrow = SAVING_THROW_WILL;
        DeleteLocalInt(oTarget, "IronMind_MindOverBody");
    }

    // Handle the target having Force of Will and being targeted by a psionic power
    if(nSavingThrow != SAVING_THROW_WILL        &&
       ((nSpell > 14000 && nSpell < 14360) ||
        (nSpell > 15350 && nSpell < 15470)
        )                                       &&
       GetHasFeat(FEAT_FORCE_OF_WILL, oTarget)  &&
       !GetLocalInt(oTarget, "ForceOfWillUsed") &&
       // Only use will save if it's better
       ((nSavingThrow == SAVING_THROW_FORT ? GetFortitudeSavingThrow(oTarget) : GetReflexSavingThrow(oTarget)) > GetWillSavingThrow(oTarget))
       )
    {
        nSavingThrow = SAVING_THROW_WILL;
        SetLocalInt(oTarget, "ForceOfWillUsed", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "ForceOfWillUsed"));
        // "Force of Will used for this round."
        FloatingTextStrRefOnCreature(16826670, oTarget, FALSE);
    }

    int iRW = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oSaveVersus);
    int iTK = GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT, oTarget);
    //Thayan Knights auto-fail mind spells cast by red wizards
    if(iRW > 0 && iTK > 0 && nSaveType == SAVING_THROW_TYPE_MIND_SPELLS)
    {
        return 0;
    }

    // Hexblade gets a bonus against spells equal to his Charisma (Min +1)
    int nHex = GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget);
    if (nHex > 0)
    {
        int nHexCha = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
        if (nHexCha < 1) nHexCha = 1;
        nDC -= nHexCha;
    }

    // This is done here because it is possible to tell the saving throw type here
    // Tyranny Domain increases the DC of mind spells by +2.
    if(GetHasFeat(FEAT_DOMAIN_POWER_TYRANNY, oSaveVersus) && nSaveType == SAVING_THROW_TYPE_MIND_SPELLS)
        nDC += 2;

    //racial pack code
    //this works by lowering the DC rather than adding to the save
    //same net effect but slightly different numbers
    if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY)
    {
        if(GetHasFeat(FEAT_HARD_AIR, oTarget))
            nDC -= 1 + (GetHitDice(oTarget) / 5);
        else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
            nDC -= 2;
    }
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget))
        nDC -= 3;
    else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);

    // Necrotic Cyst penalty on Necromancy spells
    if(CSLGetPersistentInt(oTarget, NECROTIC_CYST_MARKER) && (GetSpellSchool(nSpell) == SPELL_SCHOOL_NECROMANCY))
        nDC += 2;

    int nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);

    // Second Chance power reroll
    if(nSaveRoll == 0                                        &&     // Failed the save
       GetLocalInt(oTarget, "PRC_Power_SecondChance_Active") &&     // Second chance is active
       !GetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound") // And hasn't yet been used for this round
       )
    {
        // Reroll
        nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);

        // Can't use this ability again for a round
        SetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound"));
    }

    // Iron Mind Barbed Mind ability
    if(GetLevelByClass(CLASS_TYPE_IRONMIND, oTarget) >= 10)
    {
        // Only works on Mind Spells and in Heavy Armour
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
        if(nSaveType == SAVING_THROW_TYPE_MIND_SPELLS && GetBaseAC(oItem) >= 6)
        {
            // Spell/Power caster takes 1d6 damage and 1 Wisdom damage
            effect eDam = HkEffectDamage(d6(), DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSaveVersus);
            SCApplyAbilityDrainEffect( ABILITY_WISDOM, 1, oSaveVersus, DURATION_TYPE_TEMPORARY, -1.0);
        }
    }

    return nSaveRoll;
}

*/


/*
// Get the saving throw (fortitude, reflex or will) of a creature, door, or placeable.
// Contrary to GetFortitudeSavingThrow() function and the like, this function
// take into account active effects and item properties' increased and decreased
// saving throws versus specific effects.
// - oTarget Creature, door, or placeable from which the saving throw is get
// - iSave SAVING_THROW_FORT, SAVING_THROW_REFLEX or SAVING_THROW_WILL
// - iSaveVsType SAVING_THROW_TYPE_* constant
// * Returns the specified saving throw
int JXGetSavingThrow(object oTarget, int iSave, int iSaveVsType = SAVING_THROW_ALL)
{
	// Test if the target is a valid creature
	if (!GetIsObjectValid(oTarget))
		return 0;

	// Get the base saving throw
	int iBaseSave;
	switch (iSave)
	{
		case SAVING_THROW_FORT :
			iBaseSave = GetFortitudeSavingThrow(oTarget);
			break;
		case SAVING_THROW_REFLEX :
			iBaseSave = GetReflexSavingThrow(oTarget);
			break;
		case SAVING_THROW_WILL :
			iBaseSave = GetWillSavingThrow(oTarget);
			break;
	}

	if ((GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
	 || (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE))
	 	return iBaseSave;

	// Get the effect modifier
	int iEffectModifier = 0;
	int iSaveTemp;
	int iSaveVsTypeTemp;
	effect eLoop = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eLoop))
	{
		if (GetEffectType(eLoop) == EFFECT_TYPE_SAVING_THROW_INCREASE)
		{
			// Get the saving throw type (SAVING_THROW_* constant)
			iSaveTemp = GetEffectInteger(eLoop, 1);
			// Get the type of decreased saving throw (SAVING_THROW_TYPE_* constant)
			iSaveVsTypeTemp = GetEffectInteger(eLoop, 2);
			
			if (((iSaveTemp == iSave) || (iSaveTemp == SAVING_THROW_ALL))
			 && (iSaveVsTypeTemp == iSaveVsType))
			{
				iEffectModifier += GetEffectInteger(eLoop, 0);
			}
		}
		else if (GetEffectType(eLoop) == EFFECT_TYPE_SAVING_THROW_DECREASE)
		{
			// Get the saving throw type (SAVING_THROW_* constant)
			iSaveTemp = GetEffectInteger(eLoop, 1);
			// Get the type of decreased saving throw (SAVING_THROW_TYPE_* constant)
			iSaveVsTypeTemp = GetEffectInteger(eLoop, 2);
			
			if (((iSaveTemp == iSave) || (iSaveTemp == SAVING_THROW_ALL))
			 && (iSaveVsTypeTemp == iSaveVsType))
			{
				// Get the saving throw decreased value
				iEffectModifier -= GetEffectInteger(eLoop, 0);
			}
		}
		eLoop = GetNextEffect(oTarget);
	}

	// Get the item properties' saving throws vs type
	int iIPSaveVsType = -1;
	switch (iSaveVsType)
	{
		case SAVING_THROW_TYPE_ALL :			iIPSaveVsType = IP_CONST_SAVEVS_UNIVERSAL; break;
		case SAVING_THROW_TYPE_ACID :			iIPSaveVsType = IP_CONST_SAVEVS_ACID; break;
		case SAVING_THROW_TYPE_COLD :			iIPSaveVsType = IP_CONST_SAVEVS_COLD; break;
		case SAVING_THROW_TYPE_DEATH :			iIPSaveVsType = IP_CONST_SAVEVS_DEATH; break;
		case SAVING_THROW_TYPE_DISEASE :		iIPSaveVsType = IP_CONST_SAVEVS_DISEASE; break;
		case SAVING_THROW_TYPE_DIVINE :			iIPSaveVsType = IP_CONST_SAVEVS_DIVINE; break;
		case SAVING_THROW_TYPE_ELECTRICITY :	iIPSaveVsType = IP_CONST_SAVEVS_ELECTRICAL; break;
		case SAVING_THROW_TYPE_FEAR	:			iIPSaveVsType = IP_CONST_SAVEVS_FEAR; break;
		case SAVING_THROW_TYPE_FIRE :			iIPSaveVsType = IP_CONST_SAVEVS_FIRE; break;
		case SAVING_THROW_TYPE_MIND_SPELLS :	iIPSaveVsType = IP_CONST_SAVEVS_MINDAFFECTING; break;
		case SAVING_THROW_TYPE_NEGATIVE :		iIPSaveVsType = IP_CONST_SAVEVS_NEGATIVE; break;
		case SAVING_THROW_TYPE_POISON :			iIPSaveVsType = IP_CONST_SAVEVS_POISON; break;
		case SAVING_THROW_TYPE_POSITIVE :		iIPSaveVsType = IP_CONST_SAVEVS_POSITIVE; break;
		case SAVING_THROW_TYPE_SONIC :			iIPSaveVsType = IP_CONST_SAVEVS_SONIC; break;
	}

	// Get the item property modifier
	int iItemPropModifier = 0;
	if (iIPSaveVsType != -1)
	{
		// Loop all all items held by the creature
		itemproperty ipLoop;
		object oItemHeld; int iLoop;
		for (iLoop = 0; iLoop < 17; iLoop++)
		{
			oItemHeld = GetItemInSlot(iLoop, oTarget);
			if (GetIsObjectValid(oItemHeld)
			 && (GetItemHasItemProperty(oItemHeld, ITEM_PROPERTY_SAVING_THROW_BONUS)
			  || GetItemHasItemProperty(oItemHeld, ITEM_PROPERTY_DECREASED_SAVING_THROWS)))
			{
				// Loop all item propeties of an item
				ipLoop = GetFirstItemProperty(oItemHeld);
				while (GetIsItemPropertyValid(ipLoop))
				{
					// Item property that increases saving throws vs type found
					if ((GetItemPropertyType(ipLoop) == ITEM_PROPERTY_SAVING_THROW_BONUS)
					 && ((GetItemPropertySubType(ipLoop) == iIPSaveVsType)
					  || (GetItemPropertySubType(ipLoop) == IP_CONST_SAVEVS_UNIVERSAL)))
						iItemPropModifier += GetItemPropertyCostTableValue(ipLoop);
					// Item property that decreases saving throws vs type found
					else if ((GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DECREASED_SAVING_THROWS)
					 && ((GetItemPropertySubType(ipLoop) == iIPSaveVsType)
					  || (GetItemPropertySubType(ipLoop) == IP_CONST_SAVEVS_UNIVERSAL)))
						iItemPropModifier -= GetItemPropertyCostTableValue(ipLoop);
					ipLoop = GetNextItemProperty(oItemHeld);
				}
			}
		}
	}

	return iBaseSave + iEffectModifier + iItemPropModifier;
}



*/



/**
* Tracks save events for integration with swift actions
* @param iSaveType
* @param oTarget The Target of the current spell
* @param oCaster The caster of the current spell
* @see
* @replaces
*/
/*
void HkTrackSave( int iSaveType, object oTarget, object oCaster = OBJECT_SELF)
{
	SetLocalInt(oCaster, "HKTEMP_SaveType", iSaveType);
	SetLocalInt(oCaster, "HKTEMP_SaveTarget", ObjectToInt(oTarget));
	DelayCommand(1.0f, DeleteLocalInt(oCaster, "HKTEMP_SaveType" ));
	DelayCommand(1.0f, DeleteLocalInt(oCaster, "HKTEMP_SaveTarget" ));
}
*/


/**
* Gets damage adjustments based on reflex save/evasion/ improved evasion
* @author Syrus Greycloak for currently commented out armor rules and Drammel for Tome of battle integration
* @param nDamage The Damage amount involved
* @param oTarget The Target of the current spell or effect
* @param nDC The DC the target has to save against
* @param nSaveType default is SAVING_THROW_TYPE_NONE, use a SAVING_THROW_TYPE_* constant for this
* @param oSaveVersus The caster of the current spell or effect
* @todo Tome of Battle checks which basically only should be effective if a TOB class is involved
* @todo redo so this is entirely bypassing the engine, add parameter to account for when we already know it failed or succeeded with a default for it to roll success
* @replaces XXXHkBot9sReflexAdjustedDamage XXXPRCGetReflexAdjustedDamage
* @return
*/

//int HkGetSaveAdjustedDamage( int iSaveAgainst, int iSaveMethod,  
//                              int nDamage, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_ALL, object oAttacker = OBJECT_SELF, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL, float fDelay=0.0f )
/* don't need this anymore
int HkGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL)
{
	if ( GetIsDM(oTarget) ) { return 0;}
	
	
	// @todo need to make this feature optional
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
	int iArmorRank = GetArmorRank(oArmor);
		
	//://///////////////////////////////////////////////
	//: Armor check - wearing Medium or Heavy armor does 
	//: not allow use of evasion or improved evasion feats
	//: note that this ignores the Tome of Battle features related to this
	//://///////////////////////////////////////////////
	if( iArmorRank > ARMOR_RANK_LIGHT )
	{
		if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, nSaveType, oSaveVersus))
		{
			return nDamage/2;
		} 
		
		
			
		return nDamage;
	}
	//://///////////////////////////////////////////////
	//: Weight check - carrying Medium or Heavy load does 
	//: not allow use of evasion or improved evasion feats
	//://///////////////////////////////////////////////
	if( GetEncumbranceState(oTarget) >= ENCUMBRANCE_STATE_HEAVY )
	{
		if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, nSaveType, oSaveVersus))
		{
			return nDamage/2;
		} 
		return nDamage;
	}
	
	// CSLGetHasEffectSpellIdGroup( oTarget,  SPELLABILITY_AS_GHOSTLY_VISAGE, SPELL_GHOSTLY_VISAGE )
	int nReturn, nMod, bValid;
	object oToB = OBJECT_INVALID;// CSLGetDataStore(oTarget); // // basically always invalid until i get this stuff integrated
	
	if (GetIsObjectValid(oToB)) 
	{
		//SetLocalInt(oPC, "HKTEMP_SaveType", SAVING_THROW_REFLEX);
		//SetLocalInt(oPC, "HKTEMP_SaveTarget", ObjectToInt(oTarget));
		//DelayCommand(1.0f, DeleteLocalInt(oPC, "HKTEMP_SaveType" ));
		//DelayCommand(1.0f, DeleteLocalInt(oPC, "HKTEMP_SaveTarget" ));

		if ((GetLocalInt(oToB, "Stance") == STANCE_AURA_OF_PERFECT_ORDER) || (GetLocalInt(oToB, "Stance") == STANCE_AURA_OF_PERFECT_ORDER))
		{
			nMod = 1;
		}
		else if (GetLocalInt(oToB, "Counter") == COUNTER_IRON_HEART_FOCUS)
		{
			nMod = 1;
		}
		else if ((GetLocalInt(oToB, "ZealousSurge") == 1) && (GetLocalInt(oToB, "ZealousSurgeUse") == 1))
		{
			nMod = 1;
		}

		if (nMod == 1)
		{
			int nBaseSave = GetReflexSavingThrow(oTarget);
			int nSave;

			// From here we're attempting to rebuild the Saving Throw functions.
			if (GetLocalInt(oTarget, "AuraOfPerfectOrder") == 1) //Assumed that the Target has the Tome of Battle if this is set to 1.
			{
				nSave = 11 + nBaseSave;
			}
			else nSave = d20(1) + nBaseSave;
			
			if (nSave < nDC)
			{
				bValid = 0;
			}
			else bValid = 1;

			if (nSaveType == SAVING_THROW_TYPE_CHAOS)
			{
				bValid = 2; // It is an Aura of Perfect Order after all.
			}
			else if ((nSaveType == SAVING_THROW_TYPE_DEATH) && (GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH)))
			{
				bValid = 2;
			}
			else if ((nSaveType == SAVING_THROW_TYPE_DISEASE) && (GetIsImmune(oTarget, IMMUNITY_TYPE_DISEASE)))
			{
				bValid = 2;
			}
			else if ((nSaveType == SAVING_THROW_TYPE_FEAR) && (GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR)))
			{
				bValid = 2;
			}
			else if ((nSaveType == SAVING_THROW_TYPE_MIND_SPELLS) && (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)))
			{
				bValid = 2;
			}
			else if ((nSaveType == SAVING_THROW_TYPE_POISON) && (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)))
			{
				bValid = 2;
			}
			else if ((nSaveType == SAVING_THROW_TYPE_TRAP) && (GetIsImmune(oTarget, IMMUNITY_TYPE_TRAP)))
			{
				bValid = 2;
			}

			if ((bValid == 0) && (GetLocalInt(oToB, "Counter") == COUNTER_IRON_HEART_FOCUS) && HkSwiftActionIsActive(oTarget) == FALSE)
			{
				SetLocalInt(oToB, "IronHeartFocus", 1);

				nSave = d20(1) + nBaseSave;

				if (nSave < nDC)
				{
					bValid = 0;
				}
				else
				{
					bValid = 1;
				}
			}

			if ((bValid == 0) && (GetLocalInt(oToB, "ZealousSurge") == 1) && (GetLocalInt(oToB, "ZealousSurgeUse") == 1))
			{
				FloatingTextStringOnCreature("<color=cyan>*Zealous Surge!*</color>", oTarget, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
				SetLocalInt(oToB, "ZealousSurgeUse", 0);

				nSave = d20(1) + nBaseSave;

				if (nSave < nDC)
				{
					bValid = 0;
				}
				else
				{
					bValid = 1;
				}
			}
		}
		
		if (nMod == 1)
		{
			if (bValid == 0)
			{
				return GetReflexAdjustedDamage(nDamage, oTarget, 255, nSaveType, oSaveVersus);
			}
			else
			{
				return GetReflexAdjustedDamage(nDamage, oTarget, 1, nSaveType, oSaveVersus);
			}
		}
		else
		{
			return GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);
		}
		
	}
	
	return GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);
}
*/
/* PRC version
int PRCGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF)
{
    int nSpell = HkGetSpellId();
    int nOriginalDamage = nDamage;

     // Iron Mind's Mind Over Body, allows them to treat other saves as will saves up to 3/day.
     // For this, it lowers the DC by the difference between the Iron Mind's will save and its reflex save.
     if (GetLocalInt(oTarget, "IronMind_MindOverBody"))
     {
        int nWill = GetWillSavingThrow(oTarget);
        int nRef = GetReflexSavingThrow(oTarget);
        int nSaveBoost = nWill - nRef;
        // Makes sure it does nothing if bonus would be less than 0
        if (nSaveBoost < 0) nSaveBoost = 0;
        // Lower the save the appropriate amount.
        nDC -= nSaveBoost;
        DeleteLocalInt(oTarget, "IronMind_MindOverBody");
     }

    // Racial ability adjustments
    if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_SONIC && GetHasFeat(FEAT_HARD_AIR, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY)
    {
        if(GetHasFeat(FEAT_HARD_AIR, oTarget))
            nDC -= 1 + (GetHitDice(oTarget) / 5);
        else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
            nDC -= 2;
    }
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_4, oTarget))
        nDC -= 4;
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget))
        nDC -= 3;
    else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget))
        nDC -= 1+(GetHitDice(oTarget)/5);

    // This ability removes evasion from the target
    if (GetLocalInt(oTarget, "TrueConfoundingResistance"))
    {
        // return the damage cut in half
        if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, nSaveType, oSaveVersus))
        {
            return nDamage / 2;
        }

        return nDamage;
    }

    // Do save
    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

    // Second Chance power reroll
    if(nDamage == nOriginalDamage                            &&     // Failed the save
       GetLocalInt(oTarget, "PRC_Power_SecondChance_Active") &&     // Second chance is active
       !GetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound") // And hasn't yet been used for this round
       )
    {
        // Reroll
        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

        // Can't use this ability again for a round
        SetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound"));
    }

    return nDamage;
}

*/


/**
* Gets fortitude adjusted damage, used to support the mettle feat
* @author drammel - Tome of Battle
* @param iDamage
* @param oTarget The Target of the current spell
* @param iDC
* @param nSaveType = SAVING_THROW_TYPE_NONE
* @param oSaveVersus = OBJECT_SELF
* @todo This needs to be put in wherever a fortitude save is allowed for half damage, to support the mettle feat
* @return
* @replaces
*/
/*
int HkGetFortitudeAdjustedDamage(int iDamage, object oTarget, int iDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL)
{
	int iRollResult;
	if ( nPriorCheckSucces == SAVING_THROW_CHECK_FAILED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_FAILED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_SUCCEEDED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_SUCCEEDED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_IMMUNE;
	}
	else // if ( nPriorCheckSucces == SAVING_THROW_RESULT_ROLL ) // on any other result, go ahead and assume it's asking for a roll, soas to make sure everything coming in is valid
	{
		nPriorCheckSucces = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, nSaveType, oSaveVersus );
	}
	
	if( nPriorCheckSucces )
	{
		if (GetHasFeat(FEAT_METTLE, oTarget)) //Mettle
		{
			return 0;
		}
		
		return iDamage/2;
	}
	return iDamage;
}

int HkGetWillAdjustedDamage(int iDamage, object oTarget, int iDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL)
{
	int iRollResult;
	if ( nPriorCheckSucces == SAVING_THROW_CHECK_FAILED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_FAILED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_SUCCEEDED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_SUCCEEDED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_IMMUNE;
	}
	else // if ( nPriorCheckSucces == SAVING_THROW_RESULT_ROLL ) // on any other result, go ahead and assume it's asking for a roll, soas to make sure everything coming in is valid
	{
		nPriorCheckSucces = HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, nSaveType, oSaveVersus );
	}
	
	if( nPriorCheckSucces )
	{	
		return 0;
	}
	return iDamage;
}
*/


/*
int GetHasMettle(object oTarget, int nSavingThrow)
{
    int nMettle = FALSE;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST);

    if (nSavingThrow = SAVING_THROW_WILL)
    {
        // Iron Mind's ability only functions in Heavy Armour
        if (GetLevelByClass(CLASS_TYPE_IRONMIND, oTarget) >= 5 && GetBaseAC(oArmour) >= 6) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget) >= 3) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_SOHEI, oTarget) >= 9) nMettle = TRUE;
        // Fill out the line below to add another class with Will mettle
        // else if (GetLevelByClass(CLASS_TYPE_X, oTarget) >= X) nMettle = TRUE;
    }
    if (nSavingThrow = SAVING_THROW_FORT)
    {
        // Add Classes with Fort mettle here
        if (GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget) >= 3) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_SOHEI, oTarget) >= 9) nMettle = TRUE;
    }

    return nMettle;
}
*/


// need to work on the feat id's for these
// FEAT_METTLE - evasion for both will AND fortitude saves
// FEAT_IMPROVEDMETTLE -  improved evasion for both will AND fortitude saves
// FEAT_METTLE_OF_FORTITUDE - evasion for fortitude
// FEAT_METTLE_OF_WILL - evasion for will
// FEAT_IMPROVED_METTLE_OF_FORTITUDE - improved evasion for fortitude
// FEAT_IMPROVED_METTLE_OF_WILL - improved evasion for will
// FEAT_METTLE_OF_IRONED_WILL - as FEAT_METTLE_OF_WILL but requires wearing heavy armor, for class iron mind from races of stone, only works when in heavy armor



/**
* Gets the adjusted damage for a given spell, has parameters which allow you to specify if this is used in a logical area after a failed or successful saving throw
* @param iSaveAgainst SAVING_THROW_FORT, SAVING_THROW_REFLEX, SAVING_THROW_WILL
* @param iSaveMethod SAVING_THROW_METHOD_* How much damage will be taken if they save
* @param nDamage The Damage amount involved
* @param oTarget The Target of the current spell or effect
* @param nDC The DC the target has to save against
* @param nSaveType default is SAVING_THROW_TYPE_NONE, use a SAVING_THROW_TYPE_* constant for this
* @param oAttacker The caster of the current spell or effect
* @param iPriorCheckSucces SAVING_THROW_RESULT_ROLL, SAVING_THROW_CHECK_FAILED, SAVING_THROW_CHECK_SUCCEEDED, SAVING_THROW_CHECK_IMMUNE
* @todo look at adding , int iDamageType = DAMAGE_TYPE_ALL as last parameter
* @todo integrate into all the spell scripts and replace the previous HkGetReflexAdjustedDamage
*
*/
int HkGetSaveAdjustedDamage( int iSaveAgainst, int iSaveMethod, int nDamage, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_ALL, object oAttacker = OBJECT_SELF, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL, float fDelay=0.0f )
{
	if ( nDamage == 0 )
	{
		return 0; // no damage so just it really does not matter if it fails or not
	}
	
	
	if ( GetIsDM(oTarget) ) { return 0;}
	
	// this is just a placeholder for now, replace the called functions with this for all damage adjustments
	
	// toggle the iSaveAgainst type now, some feats allow you to make a 
	// will, fortitude or other reflex save if a given save is another
	// type and you meet requirements, place holder for now for rules which allow swapping the save type
	// if ( class == XXX )
	// {
	//iSaveAgainst = iSaveAgainst; //  SAVING_THROW_FORT, SAVING_THROW_REFLEX, SAVING_THROW_WILL
	// }
	
	
	// make the saving throw now, i am also validating the passed in constant to ensure it's always a known value
	//int nPriorCheckSucces;
	if ( nPriorCheckSucces == SAVING_THROW_CHECK_FAILED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_FAILED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_SUCCEEDED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_SUCCEEDED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_IMMUNE;
	}
	else // if ( nPriorCheckSucces == SAVING_THROW_RESULT_ROLL ) // on any other result, go ahead and assume it's asking for a roll, soas to make sure everything coming in is valid
	{
		nPriorCheckSucces = HkSavingThrow(iSaveAgainst, oTarget, nDC, nSaveType, oAttacker, fDelay, nPriorCheckSucces );
	}
	
	// need  to review the logic on this, since in quite a few cases even if immune it should do some damage to trigger proper feedback
	if( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE)
	{
		return 0;
	}
	
	// this handles custom feats and abilities which might modify the saving throw
	if ( iSaveAgainst == SAVING_THROW_REFLEX )
	{
		//return HkGetReflexAdjustedDamage( nDamage, oTarget, nDC, nSaveType, oAttacker, nPriorCheckSucces);
		if ( iSaveMethod <= SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
			int iArmorRank = GetArmorRank(oArmor);
			
			int bTestBlindness = !GetHasFeat( FEAT_BLIND_FIGHT, oTarget); // if has blind fight, should be false so it ignores blindness effects
			if ( GetHasFeat( FEAT_IMPROVED_EVASION, oTarget) && ( iArmorRank <= ARMOR_RANK_LIGHT || ( iArmorRank <= ARMOR_RANK_MEDIUM && GetHasFeat( FEAT_EVASION_CHAINED, oTarget) ) || GetHasFeat( FEAT_EVASION_IRONED, oTarget) ) && GetEncumbranceState(oTarget) < ENCUMBRANCE_STATE_HEAVY )
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, bTestBlindness, TRUE, TRUE, TRUE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage/2;
				}
			}
			else if ( GetHasFeat( FEAT_EVASION, oTarget) && ( iArmorRank <= ARMOR_RANK_LIGHT || ( iArmorRank <= ARMOR_RANK_MEDIUM && GetHasFeat( FEAT_EVASION_CHAINED, oTarget) ) || GetHasFeat( FEAT_EVASION_IRONED, oTarget) ) && GetEncumbranceState(oTarget) < ENCUMBRANCE_STATE_HEAVY ) 
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, bTestBlindness, TRUE, TRUE, TRUE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage;
				}
			}
		}
		
	}
	else if ( iSaveAgainst == SAVING_THROW_WILL )
	{
		if ( iSaveMethod <= SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			if ( GetHasFeat( FEAT_IMPROVEDMETTLE, oTarget) || GetHasFeat( FEAT_IMPROVED_METTLE_OF_WILL, oTarget) ) 
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE, oTarget) || GetHasFeat( FEAT_METTLE_OF_WILL, oTarget)  )
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage/2;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE_OF_IRONED_WILL, oTarget) &&  GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) == ARMOR_RANK_HEAVY ) // supports iron mind class from races of stone
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage/2;
				}
			}
		}
	}
	else if ( iSaveAgainst == SAVING_THROW_FORT )
	{
		if ( iSaveMethod <= SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			
			if ( GetHasFeat( FEAT_IMPROVEDMETTLE, oTarget) || GetHasFeat( FEAT_IMPROVED_METTLE_OF_FORTITUDE, oTarget) ) 
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE, oTarget) || GetHasFeat( FEAT_METTLE_OF_FORTITUDE, oTarget)  )
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage/2;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE_OF_IRONED_FORTITUDE, oTarget) &&  GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) == ARMOR_RANK_HEAVY ) // supports iron mind class from races of stone
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return 0;
					}
					return nDamage/2;
				}
			}
		}
		
	}

	
	// now adjust damage based on the provided rules input into this function
	if( nPriorCheckSucces )
	{
		if ( iSaveMethod == SAVING_THROW_METHOD_FORNODAMAGE )
		{
			return 0;
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORQUARTERDAMAGE )
		{
			return nDamage/4;
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORHALFDAMAGE || iSaveMethod == SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			return nDamage/2;
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORTHREEQUARTERDAMAGE )
		{
			return nDamage - (nDamage/4); // flip flop the logic 
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORFULLDAMAGE )
		{
			return nDamage;
		}
	}
	return nDamage;
}

// handles whether mettle or evasion also prevent application of special 
// returns SAVING_THROW_ADJUSTED_FULLDAMAGE if they affect the player, SAVING_THROW_ADJUSTED_NODAMAGE if they dont, and SAVING_THROW_ADJUSTED_PARTIALDAMAGE if it's a partial effect
// SAVING_THROW_ADJUSTED_NODAMAGE = 0;
// SAVING_THROW_ADJUSTED_PARTIALDAMAGE = 1;
// SAVING_THROW_ADJUSTED_FULLDAMAGE = 2;
int HkIsDamageSaveAdjusted( int iSaveAgainst, int iSaveMethod, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_ALL, object oAttacker = OBJECT_SELF, int nPriorCheckSucces = SAVING_THROW_RESULT_ROLL, float fDelay=0.0f )
{
	if ( GetIsDM(oTarget) ) { return SAVING_THROW_ADJUSTED_NODAMAGE;} // make sure it ignores dm's, should still affect those the dm is possessing
	
	// this is just a placeholder for now, replace the called functions with this for all damage adjustments
	
	// toggle the iSaveAgainst type now, some feats allow you to make a 
	// will, fortitude or other reflex save if a given save is another
	// type and you meet requirements, place holder for now
	//iSaveAgainst = iSaveAgainst; //  SAVING_THROW_FORT, SAVING_THROW_REFLEX, SAVING_THROW_WILL
	
	// make the saving throw now, i am also validating the passed in constant to ensure it's always a known value
	///int nPriorCheckSucces;
	if ( nPriorCheckSucces == SAVING_THROW_CHECK_FAILED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_FAILED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_SUCCEEDED )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_SUCCEEDED;
	}
	else if ( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE )
	{
		nPriorCheckSucces = SAVING_THROW_CHECK_IMMUNE;
	}
	else // if ( nPriorCheckSucces == SAVING_THROW_RESULT_ROLL ) // on any other result, go ahead and assume it's asking for a roll, soas to make sure everything coming in is valid
	{
		nPriorCheckSucces = HkSavingThrow(iSaveAgainst, oTarget, nDC, nSaveType, oAttacker, fDelay, nPriorCheckSucces );
	}
	
	// need  to review the logic on this, since in quite a few cases even if immune it should do some damage to trigger proper feedback
	if( nPriorCheckSucces == SAVING_THROW_CHECK_IMMUNE)
	{
		return 0;
	}
	
	// this handles custom feats and abilities which might modify the saving throw
	if ( iSaveAgainst == SAVING_THROW_REFLEX )
	{
		if ( iSaveMethod <= SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
			int iArmorRank = GetArmorRank(oArmor);
			
			int bTestBlindness = !GetHasFeat( FEAT_BLIND_FIGHT, oTarget); // if has blind fight, should be false so it ignores blindness effects
			if ( GetHasFeat( FEAT_IMPROVED_EVASION, oTarget) && ( iArmorRank <= ARMOR_RANK_LIGHT || ( iArmorRank <= ARMOR_RANK_MEDIUM && GetHasFeat( FEAT_EVASION_CHAINED, oTarget) ) || GetHasFeat( FEAT_EVASION_IRONED, oTarget) ) && GetEncumbranceState(oTarget) < ENCUMBRANCE_STATE_HEAVY )
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, bTestBlindness, TRUE, TRUE, TRUE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
				}
			}
			else if ( GetHasFeat( FEAT_EVASION, oTarget) && ( iArmorRank <= ARMOR_RANK_LIGHT || ( iArmorRank <= ARMOR_RANK_MEDIUM && GetHasFeat( FEAT_EVASION_CHAINED, oTarget) ) || GetHasFeat( FEAT_EVASION_IRONED, oTarget) ) && GetEncumbranceState(oTarget) < ENCUMBRANCE_STATE_HEAVY ) 
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, bTestBlindness, TRUE, TRUE, TRUE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_FULLDAMAGE;
				}
			}
		}
		
	}
	else if ( iSaveAgainst == SAVING_THROW_WILL )
	{
		if ( iSaveMethod <= SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			if ( GetHasFeat( FEAT_IMPROVEDMETTLE, oTarget) || GetHasFeat( FEAT_IMPROVED_METTLE_OF_WILL, oTarget) ) 
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_FULLDAMAGE;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE, oTarget) || GetHasFeat( FEAT_METTLE_OF_WILL, oTarget)  )
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE_OF_IRONED_WILL, oTarget) &&  GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) == ARMOR_RANK_HEAVY ) // supports iron mind class from races of stone
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
				}
			}
		}
	}
	else if ( iSaveAgainst == SAVING_THROW_FORT )
	{
		if ( iSaveMethod <= SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			
			if ( GetHasFeat( FEAT_IMPROVEDMETTLE, oTarget) || GetHasFeat( FEAT_IMPROVED_METTLE_OF_FORTITUDE, oTarget) ) 
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_FULLDAMAGE;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE, oTarget) || GetHasFeat( FEAT_METTLE_OF_FORTITUDE, oTarget)  )
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
				}
			}
			else if ( GetHasFeat( FEAT_METTLE_OF_IRONED_FORTITUDE, oTarget) &&  GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) == ARMOR_RANK_HEAVY ) // supports iron mind class from races of stone
			{
				if ( !CSLGetIsIncapacitated( oTarget, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE  ) ) // this is in the middle since it has to iterate the effects, most expensive to run
				{
					if( nPriorCheckSucces )
					{
						return SAVING_THROW_ADJUSTED_NODAMAGE;
					}
					return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
				}
			}
		}
		
	}
	
	
	if( nPriorCheckSucces )
	{
		if ( iSaveMethod == SAVING_THROW_METHOD_FORNODAMAGE )
		{
			return SAVING_THROW_ADJUSTED_NODAMAGE;
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORQUARTERDAMAGE )
		{
			return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORHALFDAMAGE || iSaveMethod == SAVING_THROW_METHOD_FORPARTIALDAMAGE )
		{
			return SAVING_THROW_ADJUSTED_PARTIALDAMAGE;
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORTHREEQUARTERDAMAGE )
		{
			return SAVING_THROW_ADJUSTED_PARTIALDAMAGE; // flip flop the logic 
		}
		else if ( iSaveMethod == SAVING_THROW_METHOD_FORFULLDAMAGE )
		{
			return SAVING_THROW_ADJUSTED_FULLDAMAGE;
		}
	}
	return SAVING_THROW_ADJUSTED_FULLDAMAGE;
}






/*
int SAVING_THROW_TYPE_ALL               = 0;
int SAVING_THROW_TYPE_NONE              = 0;
int SAVING_THROW_TYPE_MIND_SPELLS       = 1;
int SAVING_THROW_TYPE_POISON            = 2;
int SAVING_THROW_TYPE_DISEASE           = 3;
int SAVING_THROW_TYPE_FEAR              = 4;
int SAVING_THROW_TYPE_SONIC             = 5;
int SAVING_THROW_TYPE_ACID              = 6;
int SAVING_THROW_TYPE_FIRE              = 7;
int SAVING_THROW_TYPE_ELECTRICITY       = 8;
int SAVING_THROW_TYPE_POSITIVE          = 9;
int SAVING_THROW_TYPE_NEGATIVE          = 10;
int SAVING_THROW_TYPE_DEATH             = 11;
int SAVING_THROW_TYPE_COLD              = 12;
int SAVING_THROW_TYPE_DIVINE            = 13;
int SAVING_THROW_TYPE_TRAP              = 14;
int SAVING_THROW_TYPE_SPELL             = 15;
int SAVING_THROW_TYPE_GOOD              = 16;
int SAVING_THROW_TYPE_EVIL              = 17;
int SAVING_THROW_TYPE_LAW               = 18;
int SAVING_THROW_TYPE_CHAOS             = 19;

int IMMUNITY_TYPE_NONE              = 0;
int IMMUNITY_TYPE_MIND_SPELLS       = 1;
int IMMUNITY_TYPE_POISON            = 2;
int IMMUNITY_TYPE_DISEASE           = 3;
int IMMUNITY_TYPE_FEAR              = 4;
int IMMUNITY_TYPE_TRAP              = 5;
int IMMUNITY_TYPE_PARALYSIS         = 6;
int IMMUNITY_TYPE_BLINDNESS         = 7;
int IMMUNITY_TYPE_DEAFNESS          = 8;
int IMMUNITY_TYPE_SLOW              = 9;
int IMMUNITY_TYPE_ENTANGLE          = 10;
int IMMUNITY_TYPE_SILENCE           = 11;
int IMMUNITY_TYPE_STUN              = 12;
int IMMUNITY_TYPE_SLEEP             = 13;
int IMMUNITY_TYPE_CHARM             = 14;
int IMMUNITY_TYPE_DOMINATE          = 15;
int IMMUNITY_TYPE_CONFUSED          = 16;
int IMMUNITY_TYPE_CURSED            = 17;
int IMMUNITY_TYPE_DAZED             = 18;
int IMMUNITY_TYPE_ABILITY_DECREASE  = 19;
int IMMUNITY_TYPE_ATTACK_DECREASE   = 20;
int IMMUNITY_TYPE_DAMAGE_DECREASE   = 21;
int IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE = 22;
int IMMUNITY_TYPE_AC_DECREASE       = 23;
int IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE = 24;
int IMMUNITY_TYPE_SAVING_THROW_DECREASE = 25;
int IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE = 26;
int IMMUNITY_TYPE_SKILL_DECREASE    = 27;
int IMMUNITY_TYPE_KNOCKDOWN         = 28;
int IMMUNITY_TYPE_NEGATIVE_LEVEL    = 29;
int IMMUNITY_TYPE_SNEAK_ATTACK      = 30;
int IMMUNITY_TYPE_CRITICAL_HIT      = 31;
int IMMUNITY_TYPE_DEATH             = 32;
*/






/**
* Returns the time in seconds a given duration will last based on the casters hitdice. Allows the entire duration cateogory to be adjusted from one type to the next. This lets a feat or an adjuster to take a spell with a duration of minutes and make it instead last rounds.
* Example to have a spell last 1 round per level, but if the caster is over level 15 it only lasts 15 rounds:
* object oCaster = OBJECT_SELF;
* int iDuration = HkGetSpellDuration( oCaster, 15 );
* float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
* 
* which replaces code like 
* float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds(iDuration) );
* @author Largely Based on Syrus Greycloaks similar system with Modifers implemented
* @param iNumber The caster level value that determines how long a given spell is going to last
* @param iDurationType can be any of the following constants SC_DURCATEGORY_SECONDS, SC_DURCATEGORY_ROUNDS, SC_DURCATEGORY_MINUTES, SC_DURCATEGORY_MINUTES, SC_DURCATEGORY_HOURS, SC_DURCATEGORY_DAYS and defaults to rounds.
* @param iElementalType = DAMAGE_TYPE_MAGICAL
* @param iFogSpell = FALSE
* @return Duration in seconds
* @see HkGetSpellDuration, HkApplyMetamagicDurationMods      
* @replaces SGGetDuration, RoundsToSeconds, HoursToSeconds
*/
float HkApplyDurationCategory(int iNumber, int iDurationType = SC_DURCATEGORY_ROUNDS, int iElementalType = DAMAGE_TYPE_MAGICAL, int iFogSpell = FALSE)
{
    float fDuration;
    
    // reduce if underwater or fog, or if reduction or increase is added
    /*
    if(CSLEnviroGetIsUnderWater(OBJECT_SELF) && (iElementalType==DAMAGE_TYPE_ACID || iFogSpell==TRUE))
    {
        if(iDurationType!=SC_DURCATEGORY_ROUNDS)
        {
            iDurationType--;
        }
        else
        {
            iNumber = 1;
        }
    }
    */
    
    // Check Metamodifer Vars
	iDurationType += CSLReadIntModifier( OBJECT_SELF, "Spell_DurationCatAdj");
    
    if ( iDurationType < SC_DURCATEGORY_ROUNDS )
    {
    	iDurationType = SC_DURCATEGORY_ROUNDS;
    	iNumber = 1;
    }
    else if ( iDurationType > SC_DURCATEGORY_DAYS )
    {
    	iDurationType = SC_DURCATEGORY_DAYS;
    	iNumber++; // over the toup, give a bonus day
    }
    
    switch(iDurationType)
    {
        case SC_DURCATEGORY_ROUNDS:
            fDuration = RoundsToSeconds(iNumber);
            break;
        case SC_DURCATEGORY_MINUTES:
            fDuration = TurnsToSeconds(iNumber);
            break;
		case SC_DURCATEGORY_TENMINUTES:
            fDuration = TurnsToSeconds(iNumber)*10;
            break;
        case SC_DURCATEGORY_HOURS:
            fDuration = HoursToSeconds(iNumber);
            break;
        case SC_DURCATEGORY_DAYS:
            fDuration = HoursToSeconds(24*iNumber);
            break;
		default:
			fDuration = RoundsToSeconds(iNumber);
    }
    if (DEBUGGING >= 6) { CSLDebug( "Category modded Duration is "+CSLFormatFloat( fDuration, 1 )+" Seconds", OBJECT_SELF ); }

    return fDuration;

}


/**
* Determines metamagic effects on duration
* @param fDuration
* @param iMetaMagic Metamagic Constant, if -1 or unused, will determine the constant for the current spell
* @return
* @see
* @replaces
*/
float HkApplyMetamagicDurationMods(float fDuration, int iMetaMagic=-1)
{
	if ( CSLIsItemValid( GetSpellCastItem() ) ) return fDuration;
	if (iMetaMagic==-1) iMetaMagic = HkGetMetaMagicFeat( OBJECT_SELF );

	if (iMetaMagic & METAMAGIC_PERMANENT)       fDuration = 0.0;
	else if (iMetaMagic & METAMAGIC_PERSISTENT) fDuration = CSLGetMaxf(HoursToSeconds(24),fDuration);
	else if (iMetaMagic & METAMAGIC_EXTEND)     fDuration *= 2;
	
	if (DEBUGGING >= 3) { CSLDebug( "Metamagic Modified Duration is "+CSLFormatFloat( fDuration, 1 )+" Seconds", OBJECT_SELF ); }

	//if (DEBUGGING >= 6) { CSLDebug( "Duration Category is "+FloatToString( fDuration ), OBJECT_SELF ); }
	
	return fDuration;
}

/**
* Determines metamagic effects on the duration type, mainly used to handle permamency
* @param iDurType
* @param iMetaMagic Metamagic Constant, if -1 or unused, will determine the constant for the current spell
* @return
* @see
* @replaces
*/
// HkApplyMetamagicDurationTypeMods
int HkApplyMetamagicDurationTypeMods(int iDurType, int iMetaMagic=-1)
{
	if (iMetaMagic==-1) iMetaMagic = HkGetMetaMagicFeat( OBJECT_SELF );
	if (iMetaMagic & METAMAGIC_PERMANENT) iDurType = DURATION_TYPE_PERMANENT;
	return iDurType;
}



int FEAT_ENERGY_ABSORB_COLD = 999999991; // whatever, just a place holder until someone does the feats and then these numbers will be those feats
int FEAT_ENERGY_ABSORB_ACID = 999999992;
int FEAT_ENERGY_ABSORB_FIRE = 999999993;
int FEAT_ENERGY_ABSORB_SONIC = 99999994;
int FEAT_ENERGY_ABSORB_ELECTRICAL = 999999995;
int FEAT_ENERGY_ABSORB_NEGATIVE = 999999996;
int FEAT_ENERGY_ABSORB_POSITIVE = 999999997;
int FEAT_ENERGY_ABSORB_MAGIC = 999999998;
int FEAT_ENERGY_ABSORB_DIVINE = 999999999;

/**
* Modifies damage to a target to allow a given damage to type to heal instead of harm a given target.
* @param nDamageTotal
* @param iDamageType
* @param oTarget The Target of the current spell
* @param iHitEffect = VFX_IMP_HEALING_M
* @param fDelay = 0.0f
* @param oCaster The caster of the current spell
* @return
* @see
* @todo implement the feats to support this      
* @replaces
*/
int HkApplyTargetModifiers( int nDamageTotal, int iDamageType, object oTarget, int iHitEffect = VFX_IMP_HEALING_M, float fDelay = 0.0f, object oCaster = OBJECT_SELF )
{
	if (
	( iDamageType == DAMAGE_TYPE_COLD ) && GetHasFeat(FEAT_ENERGY_ABSORB_COLD, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_FIRE ) && GetHasFeat(FEAT_ENERGY_ABSORB_FIRE, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_ACID ) && GetHasFeat(FEAT_ENERGY_ABSORB_ACID, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_ACID ) && GetHasFeat(FEAT_ENERGY_ABSORB_ACID, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_SONIC ) && GetHasFeat(FEAT_ENERGY_ABSORB_SONIC, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_ELECTRICAL ) && GetHasFeat(FEAT_ENERGY_ABSORB_ELECTRICAL, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_NEGATIVE ) && GetHasFeat(FEAT_ENERGY_ABSORB_NEGATIVE, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_POSITIVE ) && GetHasFeat(FEAT_ENERGY_ABSORB_POSITIVE, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_MAGICAL ) && GetHasFeat(FEAT_ENERGY_ABSORB_MAGIC, oTarget)  ||
	( iDamageType == DAMAGE_TYPE_DIVINE ) && GetHasFeat(FEAT_ENERGY_ABSORB_DIVINE, oTarget)
	)
	{
		effect eHeal = EffectHeal( CSLGetMax(nDamageTotal/2, 1) );
		CSLRemoveEffectByType(oTarget, EFFECT_TYPE_WOUNDING);
		//Apply heal effect and VFX impact
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
		
		
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( iHitEffect ), oTarget));
					
					
		return 0;
	}
	return nDamageTotal;
}

/**
* Resolves Metamagic based adjustments to damage
* @param iVal
* @param iValMax
* @param iMetaMagic Metamagic Constant, if -1 or unused, will determine the constant for the current spell
* @param iDescriptor The Descriptor for the current spell, if unused or set as -1 it will use the descriptor set in the pre cast 
* @return
* @see
* @replaces
*/
// HkApplyMetamagicVariableMods, SCApplyDescriptorMetaVariableMods
int HkApplyMetamagicVariableMods(int iVal, int iValMax, int iMetaMagic=-1, int iDescriptor=-1 )
{
	if (iMetaMagic==-1) { iMetaMagic = HkGetMetaMagicFeat( OBJECT_SELF ); }
	//if (iDescriptor==-1) { iDescriptor = HkGetDescriptor(); } // Don't need this yet
	
	// Need to handle Multiple Metamagics properly here, in case that gets supported in the GUI...
	if (iMetaMagic & METAMAGIC_MAXIMIZE) iVal = iValMax;     // Ignore the rolled value, we are MAXED!
	if (iMetaMagic & METAMAGIC_EMPOWER)  iVal += iVal/2; // Add in 50%
	return iVal;
}
// int nDamage = PRCMaximizeOrEmpower(nDieSize, nDice, nMetaMagic, (nBonusPerDie * nDice) + nBonus);
//int nDamage = HkApplyMetamagicVariableMods(CSLDieX(nDieSize,nDice)+(nBonusPerDie * nDice)+nBonus, (nDieSize*nDice)+(nBonusPerDie*nDice)+nBonus, nMetaMagic )

/* PRC version - rewrite each to use HkApplyMetamagicVariableMods

//Wrapper for The MaximizeOrEmpower function that checks for metamagic feats
//in channeled spells as well
int PRCMaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0)
{
    int i = 0;
    int nDamage = 0;
    int nChannel = GetLocalInt(OBJECT_SELF,"spellswd_aoe");
    int nFeat = GetLocalInt(OBJECT_SELF,"spell_metamagic");
    int nDiceDamage;
    for (i=1; i<=nNumberOfDice; i++)
    {
        nDiceDamage = nDiceDamage + Random(nDice) + 1;
    }
    nDamage = nDiceDamage;
    //Resolve metamagic
    if (nMeta & METAMAGIC_MAXIMIZE || nFeat & METAMAGIC_MAXIMIZE)
//    if ((nMeta & METAMAGIC_MAXIMIZE))
    {
        nDamage = nDice * nNumberOfDice;
    }
    if (nMeta & METAMAGIC_EMPOWER || nFeat & METAMAGIC_EMPOWER)
//    else if ((nMeta & METAMAGIC_EMPOWER))
    {
       nDamage = nDamage + nDamage / 2;
    }
    return nDamage + nBonus;
}

*/



/**
* resolves Metamagic based adjustments to constants used for item properties being applied in spells.
* @param iDamageConstant
* @param iMetaMagic Metamagic Constant, if -1 or unused, will determine the constant for the current spell
* @param iDescriptor The Descriptor for the current spell, if unused or set as -1 it will use the descriptor set in the pre cast
* @return
* @see
* @replaces
*/
int HkApplyMetamagicConstDamageBonusMods(int iDamageConstant, int iMetaMagic=-1, int iDescriptor=-1 )
{
	if (iMetaMagic==-1) { iMetaMagic = HkGetMetaMagicFeat( OBJECT_SELF ); }
	
	if (iMetaMagic & METAMAGIC_EMPOWER)
	{
		switch ( iDamageConstant )
		{
			case DAMAGE_BONUS_1d4: // 4 goes to 6
				iDamageConstant = DAMAGE_BONUS_1d6;
				break;
			case DAMAGE_BONUS_1d6: // 6 goes to 9
				iDamageConstant = DAMAGE_BONUS_1d8;
				break;
			case DAMAGE_BONUS_1d8: // 8 goes to 12
				iDamageConstant = DAMAGE_BONUS_1d12;
				break;
			case DAMAGE_BONUS_1d10: // 10 goes to 15
				iDamageConstant = DAMAGE_BONUS_1d12; // maxxed out
				break;
			case DAMAGE_BONUS_1d12: // 12 goes to 18
				iDamageConstant = DAMAGE_BONUS_1d12; // maxxed out
				break;
			case DAMAGE_BONUS_2d4: // 4 goes to 6
				iDamageConstant = DAMAGE_BONUS_2d6;
				break;
			case DAMAGE_BONUS_2d6: // 6 goes to 9
				iDamageConstant = DAMAGE_BONUS_2d8;
				break;
			case DAMAGE_BONUS_2d8: // 8 goes to 12
				iDamageConstant = DAMAGE_BONUS_2d12;
				break;
			case DAMAGE_BONUS_2d10: // 10 goes to 15
				iDamageConstant = DAMAGE_BONUS_2d12;
				break;
			case DAMAGE_BONUS_2d12: // 12 goes to 18
				iDamageConstant = DAMAGE_BONUS_2d12; // maxxed out
				break;
		}
	
	}

	if (iMetaMagic & METAMAGIC_MAXIMIZE)
	{
		switch ( iDamageConstant )
		{
			case DAMAGE_BONUS_1d4: // 4
				iDamageConstant = DAMAGE_BONUS_4;
				break;
			case DAMAGE_BONUS_1d6: // 6
				iDamageConstant = DAMAGE_BONUS_6;
				break;
			case DAMAGE_BONUS_1d8: // 8
				iDamageConstant = DAMAGE_BONUS_8;
				break;
			case DAMAGE_BONUS_1d10: // 10
				iDamageConstant = DAMAGE_BONUS_10;
				break;
			case DAMAGE_BONUS_1d12: // 12
				iDamageConstant = DAMAGE_BONUS_12;
				break;
			case DAMAGE_BONUS_2d4: // 8
				iDamageConstant = DAMAGE_BONUS_8;
				break;
			case DAMAGE_BONUS_2d6: // 12
				iDamageConstant = DAMAGE_BONUS_12;
				break;
			case DAMAGE_BONUS_2d8: // 16
				iDamageConstant = DAMAGE_BONUS_16;
				break;
			case DAMAGE_BONUS_2d10: // 20
				iDamageConstant = DAMAGE_BONUS_20;
				break;
			case DAMAGE_BONUS_2d12: // 24
				iDamageConstant = DAMAGE_BONUS_24;
				break;
		}
	
	}
	return iDamageConstant;
}



/*
Merging this with the above 
// * This does metamagic variable mods, and if it's sonic adds in damage for Sonic Might, since that is going to get a bonus whenever it's shifted to sonic
int SCApplyDescriptorMetaVariableMods( int iDescriptor, int iVal, int iValMax, int iMetaMagic=-1 )
{
	// Passed Thru
	iVal = HkApplyMetamagicVariableMods(iVal, iValMax, iMetaMagic );
	
	if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )
	{
		if (GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,OBJECT_SELF))
		{
			iVal += HkApplyMetamagicVariableMods( d6(2), 12, iMetaMagic );
		}
	}
	return iVal;
}
*/


// CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_SANCTIFY_STRIKES );

/**
* Modifies damage which involves a ray or similar which can deal a critical hit
* @param oTarget The Target of the current spell
* @param iTouch Result of the touch attack, TOUCH_ATTACK_RESULT_CRITICAL
* @param iDamage
* @param iAttackType = SC_TOUCH_UNKNOWN
* @param oAttacker = OBJECT_SELF
* @return
* @see
* @replaces
*/
int HkApplyTouchAttackCriticalDamage(object oTarget, int iTouch, int iDamage, int iAttackType = SC_TOUCH_UNKNOWN, object oAttacker = OBJECT_SELF )
{
	iDamage = HkApplyTouchAttackDamage(oTarget, iTouch, iDamage, iAttackType, oAttacker );
		
	// drop out if target is immune to criticals, or if the roll to hit was not a critical
	if ( iTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) )
	{
		iDamage = iDamage * 2;
	}
		
	if ( CSLGetPreferenceSwitch("SpellsRaysCanSneakDamage",FALSE) && ( iAttackType == SC_TOUCHSPELL_MELEE || iAttackType == SC_TOUCHSPELL_RANGED ||  iAttackType == SC_TOUCHSPELL_RAY  ) )
	{
		iDamage += CSLEvaluateSneakAttack(oTarget, OBJECT_SELF); // does sneak damage, basically kaedrins code, too long to really deal with here
	}
	
	// the specialization damage is doubled here
	return iDamage;
}

/**
* Applies effects to targets as well as tracking values to help dispels, spell resistance and other features have correct data.
* @param iDurationType
* @param effect eEffect
* @param oTarget The Target of the current spell
* @param fDuration=0.0f
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param oCaster The caster of the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @see
* @replaces XXXSPApplyEffectToObject
*/
void HkApplyEffectToObject( int iDurationType, effect eEffect, object oTarget, float fDuration=0.0f, int iSpellId = -1, object oCaster = OBJECT_SELF, int iClass = 255 )
{
	if ( !GetIsObjectValid(oTarget) ) { return;} // Make sure it valid	
	if (DEBUGGING >= 9) { CSLDebug(  "HkApplyEffectToObject: Running", OBJECT_SELF, oTarget ); }
	
	if ( iDurationType != DURATION_TYPE_INSTANT || fDuration > 1.5f ) // only store metadata when it's actually going to be needed later
	{
		if ( iSpellId == -1 )
		{
			// try to make sure we have a spell id, will pull from the metadata associated with the spell if invalid...
			iSpellId = HkGetSpellId();
		}
		
		HkApplyTargetTag( oTarget, oCaster, iSpellId, iClass, fDuration );
		
		if ( iSpellId == -2 )
		{
			eEffect = SetEffectSpellId(eEffect, -1 );
		}
		else if ( iSpellId != -1 )
		{
			eEffect = SetEffectSpellId(eEffect, iSpellId );
		}
		
		if ( iSpellId < 0 )
		{
			eEffect = SupernaturalEffect( eEffect );
		}
		
	}
	
	if ( iSpellId > -1 )
	{
		//SendMessageToPC( GetFirstPC(),"Not Minus 1");
		if ( oTarget == oCaster)
		{
			int iAttributes = CSLGetSpellAttributes( oCaster );
			//SendMessageToPC( GetFirstPC(),"TargetisCaster");
			if (GetSpellTargetObject() == oCaster )
			{
				//SendMessageToPC( GetFirstPC(),"Casting on Self");
				if ( GetHasFeat( FEAT_SUMMON_FAMILIAR, oCaster, TRUE ) )
				{
					//SendMessageToPC( GetFirstPC(),"Has Familiar Feat");
					object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster );
					if ( GetIsObjectValid(oFamiliar) )
					{
						//SendMessageToPC( GetFirstPC(),"Familiar Is Valid");
						
						if ( iAttributes & ( SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_RESTORATIVE ) )
						{
							//SendMessageToPC( GetFirstPC(),"Applying Effect");
							CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oFamiliar, iSpellId );
							ApplyEffectToObject( iDurationType, eEffect, oFamiliar, fDuration );
							HkApplyTargetTag( oFamiliar, oCaster, iSpellId, iClass, fDuration );
						}
					}
				}
				
				
				if ( GetHasFeat( FEAT_ANIMAL_COMPANION, oCaster, TRUE ) )
				{
					//SendMessageToPC( GetFirstPC(),"Has Companion Feat");
					object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster );
					if ( GetIsObjectValid(oCompanion) )
					{
						if ( iAttributes & ( SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_RESTORATIVE ) )
						{
							CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oCompanion, iSpellId );
							ApplyEffectToObject( iDurationType, eEffect, oCompanion, fDuration );
							HkApplyTargetTag( oCompanion, oCaster, iSpellId, iClass, fDuration  );
						}
					}
				}
			}
		}
	}
	ApplyEffectToObject( iDurationType, eEffect, oTarget, fDuration );
}



/**
* Stores variables on Caster and Summon for proper tracking of the data involved
* @param oSummon
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @see
* @replaces
*/
void HkApplySummonTag( object oSummon, object oCaster = OBJECT_SELF, int iSpellId = -1, int iClass = 255 )
{
	if ( !GetIsObjectValid(oSummon) ) { return;} // Make sure it valid	
	
	if ( iSpellId == -1 )
	{
		iSpellId = HkGetSpellId();
	}
	
	if ( iSpellId == -1 )
	{
		// don't bother without a spellid of some sort, probably should put a debug message here since it indicates a bigger issue
		return;
	}	
	HkApplyTargetTag( oSummon, oCaster, iSpellId, iClass, -1.0f  );
	SetLocalInt( oSummon, "SCSummon",  iSpellId );
	SetLocalObject(oSummon, "MASTER", oCaster);
	
	SetLocalInt( oCaster, "SCLastSummonSpell",  iSpellId ); // just used to check if a summon has been created, the spellid realy does not matter too much but might as well use it since more data is always better
}

/**
* Handles the caps to AC via spells in a way to allow these rules to match the cap implemented for items.
* @param iNum1 = 0
* @param iMaxAdjust = 0
* @return
* @see
* @replaces
*/
int HkCapAC(int iNum1 = 0, int iMaxAdjust = 0 )
{
	if (iNum1 < 1 )
	{
		return 1;
	}
	
	int iMaxACBonus = CSLGetPreferenceInteger( "MaxACBonus", 5 );
	if (DEBUGGING >= 8) { CSLDebug(  "Max AC given "+IntToString( iNum1 )+"is capped with "+IntToString( iMaxACBonus+iMaxAdjust ), OBJECT_SELF ); }
	if (iNum1 < ( iMaxACBonus+iMaxAdjust) )
	{
		return iNum1;
	}
	else
	{
		return iMaxACBonus + iMaxAdjust;
	}
}

/**
* Handles the caps to AB via spells in a way to allow these rules to match the cap implemented for items.
* @param iNum1 = 0
* @param iMaxAdjust = 0
* @return
* @see
* @replaces
*/
int HkCapAB(int iNum1 = 0, int iMaxAdjust = 0 )
{
	if (iNum1 < 1 )
	{
		return 1;
	}
	
	int iMaxABBonus = CSLGetPreferenceInteger( "MaxABBonus", 5 );
	
	if (iNum1 < ( iMaxABBonus+iMaxAdjust) )
	{
		return iNum1;
	}
	else
	{
		return iMaxABBonus + iMaxAdjust;
	}
}

/**
* Handles the caps to save bonuses via spells in a way to allow these rules to match the cap implemented for items.
* @param iNum1 = 0
* @param iMaxAdjust = 0
* @return
* @see
* @replaces
*/
int HkCapSaves(int iNum1 = 0, int iMaxAdjust = 0 )
{
	if (iNum1 < 1 )
	{
		return 1;
	}
	
	int iMaxSaveBonus = CSLGetPreferenceInteger( "MaxSaveBonus", 5 );
	
	if (iNum1 > ( iMaxSaveBonus+iMaxAdjust) )
	{
		return iNum1;
	}
	else
	{
		return iMaxSaveBonus + iMaxAdjust;
	}
}

/**
* wrapper of HkApplyEffectToObject which only applies the effect if it's not already in place for use in delay commands.
* @param iDurationType
* @param effect eEffect
* @param oTarget The Target of the current spell
* @param fDuration=0.0f
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param oCaster The caster of the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @see HkApplyEffectToObject
* @replaces
*/
void HkSafeApplyEffectToObject(int iDurationType, effect eEffect, object oTarget, float fDuration=0.0f, int iSpellId = -1, object oCaster = OBJECT_SELF, int iClass = 255)
{
	if ( iSpellId == -1 || !GetHasSpellEffect( iSpellId, oTarget ) )
	{
		HkApplyEffectToObject( iDurationType, eEffect, oTarget, fDuration, iSpellId, oCaster, iClass );
	}
}


/**
* wrapper of HkApplyEffectToObject which removes the effect if it's already in place for use in delay commands.
* @param iDurationType
* @param effect eEffect
* @param oTarget The Target of the current spell
* @param fDuration=0.0f
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param oCaster The caster of the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @see HkApplyEffectToObject
* @replaces
*/
// HkUnstackApplyEffectToObject
void HkUnstackApplyEffectToObject(int iDurationType, effect eEffect, object oTarget, float fDuration=0.0f, int iSpellId = -1, object oCaster = OBJECT_SELF, int iClass = 255)
{
	if ( iSpellId != -1 && GetHasSpellEffect( iSpellId, oTarget ) )
	{
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	}
	
	HkApplyEffectToObject( iDurationType, eEffect, oTarget, fDuration, iSpellId, oCaster, iClass );
}

/**
* Wrapper of ApplyEffectAtLocation to allow modification of the target location
* @param iDurationType
* @param effect eEffect
* @param location lLocation
* @param fDuration=0.0f
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param oCaster The caster of the current spell
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @see
* @replaces XXApplyEffectAtLocation
*/
// HkApplyEffectAtLocation
void HkApplyEffectAtLocation(int iDurationType, effect eEffect, location lLocation, float fDuration=0.0f, int iSpellId = -1, object oCaster = OBJECT_SELF, int iClass = 255)
{
	ApplyEffectAtLocation( iDurationType, eEffect, lLocation, fDuration );
	/*	
	int iCasterLevel;
	if ( iSpellId == -1 ) { iSpellId = HkGetSpellId(); }
	if ( iClass == 255 ) { iClass = HkGetSpellClass( oCaster ); }
	if ( iClass == 255 )
	{
		if ( CSLIsItemValid( GetSpellCastItem() ) )
		{
			iCasterLevel =  HkGetItemCasterLevel( GetSpellCastItem(), oCaster ); // no class, so must be a feat, default to hit dice
		}
		else
		{
			iCasterLevel =  GetHitDice( oCaster ) ; // no class, so must be a feat, default to hit dice
		}
	}
	else
	{
		iCasterLevel = HkGetCasterLevel( oCaster, iClass );
	}
	
*/
	/*
	string sAOETag = GetLocalString( oCaster, "SC_AOECurrentSpell" );
	object oAOE = GetObjectByTag(sAOETag);
	if ( GetIsObjectValid( oAOE ) )
	{ 
	
		//SetLocalInt(oAOE, "SaveDC", iSaveDC);
		
						
		SetLocalInt(oAOE, "SC_SPELLID", iSpellId);			
		SetLocalInt(oAOE, "SC_SPELLLEVEL", HkGetSpellLevel( HkGetSpellId() ));
		SetLocalInt(oAOE, "SC_CASTERLEVEL", iCasterLevel );
		SetLocalInt(oAOE, "SC_SAVEDC", HkGetSpellSaveDC());	
		SetLocalInt(oAOE, "SC_RESISTDC", HkGetSpellPenetration(oCaster));
		// SetLocalInt(oAOE, "SC_SPELLPOWER", iSpellPower);	
		SetLocalInt(oAOE, "SC_CASTERCLASS", iClass);
		SetLocalInt(oAOE, "SC_SPELLTYPE", CSLGetBaseCasterType(iClass) );
		SetLocalInt(oAOE, "SC_CASTERPOINTER", ObjectToInt(oCaster));
		SetLocalString(oAOE, "SC_CASTERTAG", GetName( oCaster ) );
	}
	*/
}


/**
* Handles a variety of checks related to mantles, spell resistance and immunity to see if a given spell worked
* This should only be called once per casting of a spell per target or it will quickly eat up mantles
* The individual functions for spell resistance can be used on spells like magic missle
* @param oCaster The caster of the current spell
* @param oTarget The Target of the current spell
* @param fDelay = 0.0
* @return
* @see
* @replaces XXMyResistSpell
*/
int HkResistSpell( object oCaster, object oTarget, float fDelay = 0.0 )
{
	/* If caster is not valid, then we might have a problem
	
	int iResist = TRUE;

    if(GetIsObjectValid(oCaster))
        iResist = MyResistSpell(oCaster, oTarget, fDelay);

    return iResist;
    */
	
	
	if (fDelay > 0.5)
	{
		fDelay = fDelay - 0.1;
	}

	
	if ( !GetIsObjectValid(oCaster) ) { return SC_SR_SPELL_WORKED; } // make sure it's only run on a valid object
	
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oCaster = GetMaster( oCaster );
	}
	
	int iResistCheckResult;
	
	// Test spell protection
	
	iResistCheckResult = HkCheckSpellImmunity( oCaster, oTarget );
	if ( iResistCheckResult == SC_SR_SPELL_IMMUNITY)
	{
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_GLOBE_INV_LESS ), oTarget));
		return SC_SR_SPELL_IMMUNITY;
	}
	
	iResistCheckResult = HkCheckSpellMantle(oCaster, oTarget); // this runs old resistspell function
	
	if ( iResistCheckResult == SC_SR_SPELL_IMMUNITY )
	{
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_GLOBE_INV_LESS ), oTarget));
		return SC_SR_SPELL_IMMUNITY;
	}
	if ( iResistCheckResult == SC_SR_SPELL_ABSORBED )
	{
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_SPELL_MANTLE ), oTarget));
		return SC_SR_SPELL_ABSORBED;
	}
	if ( iResistCheckResult == SC_SR_SPELL_COUNTERSONGED )
	{
		return SC_SR_SPELL_COUNTERSONGED;
	}
	// for future usage
	iResistCheckResult = HkCheckSpellTurning( oCaster, oTarget );
	if (iResistCheckResult > 0 )
	{
		return SC_SR_SPELL_TURNED;
	}
	iResistCheckResult = HkCheckSpellResistance( oCaster, oTarget );
	if ( iResistCheckResult == SC_SR_SPELL_RESISTED )
	{
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE ), oTarget));
		return iResistCheckResult;
	}
	return SC_SR_SPELL_WORKED;
}


/*
PRC version
//
//  This function overrides the BioWare MyResistSpell.
//  TODO: Change name to HkResistSpell.
//
int PRCResistSpell(object oCaster, object oTarget, int nEffCasterLvl=0, float fDelay = 0.0)
{
    int nResist;

    // Check if the archmage shape mastery applies to this target
    if (CheckSpellfire(oCaster, oTarget) || CheckMasteryOfShapes(oCaster, oTarget))
        nResist = SPELL_RESIST_MANTLE;
    else {
        // Check immunities and mantles, otherwise ignore the result completely
        nResist = PRCResistSpell(oCaster, oTarget);
        
        //Resonating Resistance
        if((nResist <= SPELL_RESIST_PASS) && (GetHasSpellEffect(SPELL_RESONATING_RESISTANCE, oTarget)))
        {
		nResist = PRCResistSpell(oCaster, oTarget);
	}
	       
        if (nResist <= SPELL_RESIST_PASS)
        {
		nResist = SPELL_RESIST_FAIL;

            // Because the version of this function was recently changed to
            // optionally allow the caster level, we must calculate it here.
            // The result will be cached for a period of time.
            if (!nEffCasterLvl) {
                nEffCasterLvl = GetLocalInt(oCaster, CASTER_LEVEL_TAG);
                if (!nEffCasterLvl) {
                    nEffCasterLvl = PRCGetCasterLevel(oCaster) + SPGetPenetr();
                    SetLocalInt(oCaster, CASTER_LEVEL_TAG, nEffCasterLvl);
                    DelayCommand(CACHE_TIMEOUT_CAST,
                        DeleteLocalInt(oCaster, CASTER_LEVEL_TAG));
                }
            }
            
            // Pernicious Magic
            // +4 caster level vs SR Weave user (not Evoc & Trans spells)
            int iWeav;
            if (GetHasFeat(FEAT_PERNICIOUSMAGIC,oCaster))
            {
                    if (!GetHasFeat(FEAT_SHADOWWEAVE,oTarget))
                    {
                            int nSchool = GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
                            if ( nSchool != SPELL_SCHOOL_EVOCATION && nSchool != SPELL_SCHOOL_TRANSMUTATION )
                            iWeav=4;
                    }

            }


            // A tie favors the caster.
            if ((nEffCasterLvl + d20(1)+iWeav) < PRCGetSpellResistance(oTarget, oCaster))
                nResist = SPELL_RESIST_PASS;
        }
    }

    PRCShowSpellResist(oCaster, oTarget, nResist, fDelay);

    return nResist;
}
*/

/**
* Checks to see if Spell Resistance will block a given spell
* @param oCaster The caster of the current spell
* @param oTarget The Target of the current spell
* @return
* @see
* @replaces
*/
int HkCheckSpellResistance( object oCaster, object oTarget )
{
	if ( !GetIsObjectValid(oCaster) ) { return SC_SR_SPELL_WORKED;} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oCaster = GetMaster( oCaster );
	}
	
	int iCLCheck;
	
		// Get the caster level used for the spell
	int iSpellResistDC = HkGetSpellPenetration(oCaster);


	// Get the spell resistance of the target
	int iSpellResistance = HkGetSpellResistance( oTarget );
	
	// Test if the caster bypasses the target's spell resistance
	int iRoll = d20();
	iCLCheck = iSpellResistDC + iRoll;
	if (DEBUGGING >= 6) { CSLDebug(  "SCSpellResistance:  Roll is " + IntToString( iCLCheck ) + " vs SR of " + IntToString( iSpellResistance ), oCaster, oTarget  ); } 
// CasterLevel=" + IntToString( iCasterLevel )+ "
	if (iCLCheck < iSpellResistance)
	{
			if (DEBUGGING >= 6) { CSLDebug(  "SCSpellResistance: Resisted CasterLevel=" + IntToString( iSpellResistDC )+ " Roll is " + IntToString( iRoll ) + " + " + IntToString( iSpellResistDC ) + " = " + IntToString( iCLCheck ) + " vs SR of " + IntToString( iSpellResistance ), oCaster,  oTarget ); }
			return SC_SR_SPELL_RESISTED;
	}
	else
	{
			if (DEBUGGING >= 6) { CSLDebug(  "SCSpellResistance: Passed CasterLevel=" + IntToString( iSpellResistDC )+ " Roll is " + IntToString( iRoll ) + " + " + IntToString( iSpellResistDC ) + " = " + IntToString( iCLCheck ) + " vs SR of " + IntToString( iSpellResistance ), oCaster,  oTarget ); }
			return SC_SR_SPELL_WORKED;
	}
}

/**
* Checks to see if a mantle will block a given spell
* @param oCaster The caster of the current spell
* @param oTarget The Target of the current spell
* @return
* @see
* @replaces
*/
int HkCheckSpellMantle( object oCaster, object oTarget )
{
	if ( !GetIsObjectValid(oTarget) ) { return SC_SR_SPELL_WORKED;} // make sure it's only run on a valid object
	if ( !HkHasSpellAbsorption(oTarget) ) { return SC_SR_SPELL_WORKED;} // does not have a mantle, so don't bother checking to see if it will work
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oCaster = GetMaster( oCaster );
	}																						// note that some spellresistance will get destroyed by the first spell that hits it, so just don't use it
														
																							// now run the globe check first, so it prevents eating up the globe, and protects any SR
	// must use resist spell for all mantle checks
	//int iSpellResistance1 = HkGetSpellResistance(oTarget);
	
	int iReturn;
	string sResult;
	
	int iSpellLevelsLeft = GetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS" );
	
	if ( iSpellLevelsLeft  <= 0 ) { return SC_SR_SPELL_WORKED;} // ALREADY REMOVED
	
	
	
	
	// Decrease the number of spell absorption levels
	int iSpellLevel = CSLGetMax( HkGetSpellLevel( HkGetSpellId()), 0 );
		
	if (iSpellLevelsLeft - iSpellLevel > 0) // spell was absorbed but mantle remains up
	{
		if (GetIsPC(oTarget))
		{
			SendMessageToPC(oTarget, "<color=mediumorchid>Mantle absorbed "+IntToString(iSpellLevel)+" levels of magic, and has "+IntToString(iSpellLevelsLeft - iSpellLevel)+" Levels Remaining</color>" );
		}
		SendMessageToPC(oCaster, "<color=mediumorchid>Spell cast on "+GetFirstName(oTarget) + " " + GetLastName(oTarget)+" was blocked by a mantle</color>" );

		SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", iSpellLevelsLeft - iSpellLevel);
		return SC_SR_SPELL_ABSORBED;
	}
	
	// Remove the Spell Turning effect if no spell absorption levels are left
	if ( iSpellLevelsLeft > 0 && iSpellLevelsLeft - iSpellLevel <= 0)
	{
		if ( GetIsPC(oTarget) )
		{
			SendMessageToPC(oTarget, "<color=mediumorchid>Mantle absorbed "+IntToString(iSpellLevel)+" levels of magic, and has Fallen</color>" );
		}
		SendMessageToPC(oCaster, "<color=mediumorchid>Spell cast on "+GetFirstName(oTarget) + " " + GetLastName(oTarget)+" was blocked by a mantle</color>" );
		
		SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", 0);
		DeleteLocalInt(oTarget, "SC_SPELLMANTLE_LVLS");
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LEAST_SPELL_MANTLE, SPELL_LESSER_SPELL_MANTLE, SPELL_SPELL_MANTLE, SPELL_GREATER_SPELL_MANTLE, SPELL_SPELL_TURNING );


		//effect eLoop = GetFirstEffect(oTarget);
		//while (GetIsEffectValid(eLoop))
		//{
		//	if (GetEffectSpellId(eLoop) == SPELL_SPELL_TURNING)
		//		RemoveEffect(oTarget, eLoop);
		//	effect eLoop = GetNextEffect(oTarget);
		//}
		return SC_SR_SPELL_ABSORBED;
	}

	//int iSpellResistance2 = HkGetSpellResistance(oTarget);
	
	// now return the results normall provided by this function from OEI
	// need to evalutate whether i should increase spell resistance by a given amount if it is decreased by this script
	
	// what sort of spell resistance is affected
	
	//if (iProtection == SC_SR_SPELL_IMMUNITY) { iReturn = SC_SR_SPELL_IMMUNITY; sResult = "Blocked by Immunity"; }
	//else if (iProtection == SC_SR_SPELL_ABSORBED) { iReturn = SC_SR_SPELL_ABSORBED; sResult = "Blocked by Absorbtion";}
	//else if (iProtection == SC_SR_SPELL_COUNTERSONGED) { iReturn = SC_SR_SPELL_COUNTERSONGED; sResult = "Blocked by CounterSong";}
	//else { iReturn = SC_SR_SPELL_WORKED; sResult = "Passed";}
	
	//if (DEBUGGING >= 9) { CSLDebug(  "HkCheckSpellMantle: Result=" + sResult + " Pre SR " + IntToString( iSpellResistance1 ) + " Post SR " + IntToString( iSpellResistance2 ), oCaster, oTarget  ); }

	return iReturn;
}

/**
* Checks to see if the target is immune to the given spell
* @param oCaster The caster of the current spell
* @param oTarget The Target of the current spell
* @return
* @see
* @replaces
*/
int HkCheckSpellImmunity( object oCaster, object oTarget )
{
	int iSpellLevel = HkGetSpellLevel( HkGetSpellId() ); // get the level of the current spell, will replace with custom function most likely when errors are determined
	int iReturn = SC_SR_SPELL_WORKED;
	string sResult = "Passed Immunity Check";
	
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oCaster = GetMaster( oCaster );
	}
	
	if ( iSpellLevel <= 1 && CSLGetHasEffectSpellIdGroup( oTarget,  SPELLABILITY_AS_GHOSTLY_VISAGE, SPELL_GHOSTLY_VISAGE ) )
	{
		iReturn = SC_SR_SPELL_IMMUNITY;
		sResult = "Blocked by Ghostly Visage";
	}
	else if ( iSpellLevel <= 1 && GetHasSpellEffect( SPELL_ETHEREAL_VISAGE, oTarget) ) //  && SCGetHasSpellEffectSingle( oTarget, SPELL_ETHEREAL_VISAGE )
	{
		iReturn = SC_SR_SPELL_IMMUNITY;
		sResult = "Blocked by Ethereal Visage";
	}
	else if ( iSpellLevel <= 3 && GetHasSpellEffect( SPELL_LESSER_GLOBE_OF_INVULNERABILITY, oTarget) ) // ) // && SCGetHasSpellEffectSingle( oTarget,  SPELL_LESSER_GLOBE_OF_INVULNERABILITY ) )
	{
		iReturn = SC_SR_SPELL_IMMUNITY;
		sResult = "Blocked by Lesser Globe";
	} // iSpellLevel <= 4 &&
	else if ( iSpellLevel <= 4 && GetHasSpellEffect( SPELL_GLOBE_OF_INVULNERABILITY, oTarget) ) // SCGetHasSpellEffectSingle( oTarget, SPELL_GLOBE_OF_INVULNERABILITY ) == TRUE )
	{
		iReturn = SC_SR_SPELL_IMMUNITY;
		sResult = "Blocked by Globe";
	}
	else if ( GetHasSpellEffect( SPELLABILITY_SONG_COUNTERSONG, oTarget) )
	{
		iReturn = SC_SR_SPELL_COUNTERSONGED;
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELLABILITY_SONG_COUNTERSONG );
		sResult = "Blocked by Countersong";
	}
	else
	{
		// Gets the properties on a creatures items so they don't get missed
		// and sets up the proper values
		// note that equip, unequip affect this
		CSLCacheCreatureItemInformation( oTarget ); 
		
		int iSpellImmunityByLevel = GetLocalInt( oTarget , "SC_ITEM_SPELLIMMUNITY_BY_LEVEL"  );
		if ( iSpellImmunityByLevel > 0 && iSpellLevel <= iSpellImmunityByLevel ) // SCGetHasSpellEffectSingle( oTarget, SPELL_GLOBE_OF_INVULNERABILITY ) == TRUE )
		{
			iReturn = SC_SR_SPELL_IMMUNITY;
			sResult = "Blocked by Spell Level Immunity of "+IntToString(iSpellImmunityByLevel);
		}
	}
	
	if ( GetLocalInt( oTarget , "SC_ITEM_SR" ) == 0 )
	{
		int iProtection = ResistSpell(oCaster, oTarget);
		if (iProtection == SC_SR_SPELL_IMMUNITY) { iReturn = SC_SR_SPELL_IMMUNITY; sResult = "Blocked by Misc Immunity"; }
		// need to put this into resist spell where it belongs and remove the spell
		//else if (iProtection == SC_SR_SPELL_COUNTERSONGED) { iReturn = SC_SR_SPELL_COUNTERSONGED; sResult = "Blocked by CounterSong";}
	}
	if (DEBUGGING >= 6) { CSLDebug(  "HkCheckSpellImmunity: Level " + IntToString( iSpellLevel ) + " Spell " +CSLGetSpellDataName( HkGetSpellId() ) + " " + sResult, oCaster, oTarget ); }
	
	return iReturn;
}

/**
* Checks for if the spell can be turned and reflected back on the caster
* @param oCaster The caster of the current spell
* @param oTarget The Target of the current spell
* @return
* @see
* @replaces
*/
int HkCheckSpellTurning( object oCaster, object oTarget )
{
	if ( !GetIsObjectValid(oCaster) ) { return SC_SR_SPELL_WORKED;} // make sure it's only run on a valid object
	
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oCaster = GetMaster( oCaster );
	}
	
	// block this completely
	//return SC_SR_SPELL_WORKED;
	
	if (DEBUGGING >= 6) { CSLDebug(  "Spell Turning ", oCaster, oTarget ); }

	if ( !GetHasSpellEffect(SPELL_SPELL_TURNING, oTarget) )
	{
		return SC_SR_SPELL_WORKED;
	}
	
	if (DEBUGGING >= 10) { CSLDebug(  "Is Direct Target ", oCaster, oTarget ); }
	
		// must use resist spell for all mantle checks
	//int iSpellResistance1 = HkGetSpellResistance(oTarget);
	
	int iReturn;
	int iTurnThisSpell = FALSE;
	string sResult;
	
	int iSpellLevelsLeft = GetLocalInt(oTarget, "SC_SPELLTURN_LVLS" );
	
	if ( iSpellLevelsLeft  <= 0 ) { return SC_SR_SPELL_WORKED;} // ALREADY REMOVED
	
	
	
	
	// Decrease the number of spell absorption levels
	int iSpellLevel = CSLGetMax( HkGetSpellLevel( HkGetSpellId()), 0 );
		
	if (iSpellLevelsLeft - iSpellLevel > 0) // spell was absorbed but mantle remains up
	{
		if (GetIsPC(oTarget))
		{
			SendMessageToPC(oTarget, "<color=mediumorchid>Turning absorbed "+IntToString(iSpellLevel)+" levels of magic, and has "+IntToString(iSpellLevelsLeft - iSpellLevel)+" Levels Remaining</color>" );
		}
		SendMessageToPC(oCaster, "<color=mediumorchid>Spell cast on "+GetFirstName(oTarget) + " " + GetLastName(oTarget)+" was reflected by turning</color>" );

		SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", iSpellLevelsLeft - iSpellLevel);
		
		iTurnThisSpell = TRUE;
		
		iReturn = SC_SR_SPELL_ABSORBED;
	}
	
	// Remove the Spell Turning effect if no spell absorption levels are left
	if ( iSpellLevelsLeft > 0 && iSpellLevelsLeft - iSpellLevel <= 0)
	{
		if ( GetIsPC(oTarget) )
		{
			SendMessageToPC(oTarget, "<color=mediumorchid>Turning absorbed "+IntToString(iSpellLevel)+" levels of magic, and has Fallen</color>" );
		}
		SendMessageToPC(oCaster, "<color=mediumorchid>Spell cast on "+GetFirstName(oTarget) + " " + GetLastName(oTarget)+" was reflected by turning</color>" );
		
		SetLocalInt(oTarget, "SC_SPELLTURN_LVLS", 0);
		DeleteLocalInt(oTarget, "SC_SPELLTURN_LVLS");
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LEAST_SPELL_MANTLE, SPELL_LESSER_SPELL_MANTLE, SPELL_SPELL_MANTLE, SPELL_GREATER_SPELL_MANTLE, SPELL_SPELL_TURNING );


		//effect eLoop = GetFirstEffect(oTarget);
		//while (GetIsEffectValid(eLoop))
		//{
		//	if (GetEffectSpellId(eLoop) == SPELL_SPELL_TURNING)
		//		RemoveEffect(oTarget, eLoop);
		//	effect eLoop = GetNextEffect(oTarget);
		//}
		iTurnThisSpell = TRUE;
		
		iReturn = SC_SR_SPELL_ABSORBED;
	}
	
	if ( iTurnThisSpell == TRUE )
	{
		// void ActionCastSpellAtObject(int iSpellId, object oTarget, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iDomainLevel=0, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
		HkTransferCasterModifiersToTarget( oTarget, oCaster );
		AssignCommand(oTarget, ActionCastSpellAtObject( HkGetSpellId(), oCaster, HkGetMetaMagicFeat(), TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
		HkResetMetaModifierVars( oTarget );
	}
	
	return iReturn;
}

/**
* Hard codes the target of the given spell soas to use the attributes of the caster, supports spell turning but has other uses.
* @param oTarget The Target of the current spell
* @param oCaster The caster of the current spell
* @see
* @replaces
*/
void HkTransferCasterModifiersToTarget( object oTarget, object oCaster )
{
	//SendMessageToPC(oCaster, "Resetting Vars");
	// HKPERM_ Vars are not touched
	
	int iClass = GetLocalInt( oCaster, "HKTEMP_Class" );
	
	SetLocalInt( oTarget, "HKTEMP_Class", iClass );
	SetLocalInt( oTarget, "HKTEMP_SpellId", GetLocalInt( oCaster, "HKTEMP_SpellId" ) );
	SetLocalInt( oTarget, "HKTEMP_SpellLevel", GetLocalInt( oCaster, "HKTEMP_SpellLevel" ) );
	SetLocalInt( oTarget, "HKTEMP_Descriptor", GetLocalInt( oCaster, "HKTEMP_Descriptor" ) );
	SetLocalInt( oTarget, "HKTEMP_School", GetLocalInt( oCaster, "HKTEMP_School" ) );
	SetLocalInt( oTarget, "HKTEMP_SubSchool", GetLocalInt( oCaster, "HKTEMP_SubSchool" ) );
	SetLocalInt( oTarget, "HKTEMP_Attributes", GetLocalInt( oCaster, "HKTEMP_Attributes" ) );
	
	SetLocalInt( oTarget, "HKTEMP_CasterLevel", HkGetCasterLevel( oCaster, iClass ) );
	
	//SetLocalInt( oTarget, "HKTEMP_Spell_Power", GetLocalInt( oCaster, "HKTEMP_Spell_Power" ) );
	
	
	//SetLocalInt( oTarget, "HKTEMP_Spell_Duration", GetLocalInt( oCaster, "HKTEMP_Spell_Duration" ) );
	
	SetLocalInt( oTarget, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic" ) | GetMetaMagicFeat() );

// HkGetSpellSaveDC()
}


/**
* Checks to see if the target has a spell absorbtion effect like a mantle
* @param oTarget The Target of the current spell
* @return TRUE if spell absorbtion  is in effect for the target
* @see
* @replaces
*/
int HkHasSpellAbsorption( object oTarget )
{
	if ( CSLGetHasEffectSpellIdGroup( oTarget,  SPELL_LEAST_SPELL_MANTLE, SPELL_SPELL_MANTLE, SPELL_LESSER_SPELL_MANTLE, SPELL_GREATER_SPELL_MANTLE ) )
	{
		return TRUE;
	}
	
	if ( CSLGetHasEffectType( oTarget, EFFECT_TYPE_SPELLLEVELABSORPTION ) )
	{
		return TRUE;
	}
	
	return FALSE;
	// returns true if the target has some sort of spell absorbtion effect
	//CSLGetHasEffectSpellIdGroup( oPC,  SPELL_INVISIBILITY,  SPELL_GREATER_INVISIBILITY,
	//CSLGetHasEffectType( oPC, EFFECT_TYPE_GREATERINVISIBILITY )
	// case SPELL_LEAST_SPELL_MANTLE:
	// case SPELL_SPELL_MANTLE:
	// case SPELL_LESSER_SPELL_MANTLE:
	// case SPELL_GREATER_SPELL_MANTLE:
	
	// effects
	// EFFECT_TYPE_SPELLLEVELABSORPTION
	// EFFECT_TYPE_SPELL_IMMUNITY
}

/**
* @param oTarget The Target of the current spell
* @return The spell resistance of the target, based on race, feats, classes, and items
* @see
* @replaces
*/
int HkGetSpellResistance( object oTarget )
{
	// first do the vanilla functions, make this an if/then in config
	//return GetSpellResistance(oChar);
	//if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	//{
	//	oCaster = GetMaster( oCaster );
	//}
	// do the complicated "manual" version
	int iSpellResistance = 0;
	
	// get SR set by a variable
	iSpellResistance = CSLGetMax( iSpellResistance, GetLocalInt( OBJECT_SELF , "SC_SPELLRESISTANCE" )   );

	
	int iEffectResistance = 0;
	int iRaceResistance = 0;
	int iClassResistance = 0;
	int iItemResistance = 0;
	int iResistanceAdjustments = 0;
	
	// Get racial Resistance, start off by assuming the proper feat is giving the characters resistance
	// Might throw in a restriction on this if it's a PC
	if ( GetHasFeat( 1075, oTarget ) && ( !CSLGetPreferenceSwitch("UnderdarkSRFadesinSunlight",FALSE) || !CSLGetIsInDayLight( oTarget ) ) ) //FEAT_DROW_RESISTANCE ) )
	{
		iRaceResistance = GetHitDice(oTarget) + 11;// Spell resistance of 11 + character level.
	}
	else if ( GetHasFeat( 1078, oTarget ) && ( !CSLGetPreferenceSwitch("UnderdarkSRFadesinSunlight",FALSE) || !CSLGetIsInDayLight( oTarget ) ) ) //FEAT_SVIRFNEBLIN_RESISTANCE ) )
	{
		iRaceResistance = GetHitDice(oTarget) + 11; //11 + character level.
	}
	else if ( GetHasFeat( 1833, oTarget)) // FEAT_GITH_RESISTANCE ) )
	{
		iRaceResistance = GetHitDice(oTarget) + 5;// 5 + character level
	}
	else if ( GetHasFeat( 2091,oTarget )) // FEAT_HAGSPAWN_RESISTANCE ) )
	{
		iRaceResistance = GetHitDice(oTarget) + 11; // 11 + character level
	}
	else if ( GetHasFeat( 2118, oTarget )) // FEAT_RACIAL_SPELL_RESISTANCE_10 ) )
	{
		iRaceResistance = GetHitDice(oTarget) + 10;
	}
	else if ( GetHasFeat( 2171, oTarget )) // FEAT_SPELL_RESISTANCE ) ) // this is forthe yuan-ti
	{
		iRaceResistance = GetHitDice(oTarget) + 11;
	}
	iSpellResistance = CSLGetMax( iRaceResistance, iSpellResistance );
	
	// Get monk resistance
	if ( GetHasFeat( FEAT_DIAMOND_SOUL, oTarget )  )
	{
		iClassResistance = 10 + GetLevelByClass( CLASS_TYPE_MONK, oTarget );
	
		if ( GetHasFeat( FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_10, oTarget ) )
		{
			iClassResistance = iClassResistance + 20;
		}
		else if ( GetHasFeat( FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_9, oTarget ) )
		{
			iClassResistance = iClassResistance + 18;
		}
		else if ( GetHasFeat( FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_8, oTarget ) )
		{
			iClassResistance = iClassResistance + 16;
		}
		else if ( GetHasFeat( FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_7, oTarget ) )
		{
			iClassResistance = iClassResistance + 14;
		}
		else if ( GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_6, oTarget ) )
		{
			iClassResistance = iClassResistance + 12;
		}
		else if ( GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_5, oTarget ) )
		{
			iClassResistance = iClassResistance + 10;
		}
		else if ( GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_4, oTarget ) )
		{
			iClassResistance = iClassResistance + 8;
		}
		else if ( GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_3, oTarget ) )
		{
			iClassResistance = iClassResistance + 6;
		}
		else if ( GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_2, oTarget ) )
		{
			iClassResistance = iClassResistance + 4;
		}
		else if ( GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1, oTarget ) )
		{
			iClassResistance = iClassResistance + 2;
		}
		
		iSpellResistance = CSLGetMax( iClassResistance, iSpellResistance );
	}
	
	// NWN9 Magus, does not exist in the game
	//else if ( GetHasFeat( 1495 )) //FEAT_GROUP_SPELL_RESISTANCE_10 ) )
	//{
	//   // This is the NWN9 Magus class which is not implemented
	//}
	
	
	// temporary SR modifiers
	//Sacred Fist Inner Armor
	if ( GetHasSpellEffect(SPELLABILITY_INNER_ARMOR, oTarget) )
	{
		iSpellResistance = CSLGetMax( 25, iSpellResistance );
	}
	
	
	
	// get SR coming from items
	CSLCacheCreatureItemInformation( oTarget ); // make sure we have item SR cached
	// GetLocalInt( oChar , "SC_ITEM_SPELLIMMUNITY_BY_LEVEL" )
	iSpellResistance = CSLGetMax( GetLocalInt( oTarget , "SC_ITEM_SR" ), iSpellResistance );
		
	
	
	
	
	
	// get the effects of spells that increase it
	if ( GetHasSpellEffect( SPELL_SPELL_RESISTANCE, oTarget) )
	{
		iSpellResistance = CSLGetMax( iSpellResistance, 12 + GetLocalInt( oTarget , "SC_"+IntToString( SPELL_SPELL_RESISTANCE )+"_CASTERLEVEL" )   ); // put in a failover on this as well
	}
	
	//effect eEffect;
	// these stack, so need to see how many we got of each
	if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE ) ) // only bother if target can be affected by these things
	{
		effect eEffect = GetFirstEffect(oTarget);
		while ( GetIsEffectValid( eEffect ) )
		{
			if (GetEffectType( eEffect ) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ) // or EFFECT_TYPE_SPELL_RESISTANCE_INCREASE
			{
				if(GetEffectSpellId( eEffect ) == SPELL_GREATER_SPELL_BREACH )
				{
					iResistanceAdjustments = iResistanceAdjustments - 5;
				}
				else if(GetEffectSpellId( eEffect ) == SPELL_LESSER_SPELL_BREACH )
				{
					iResistanceAdjustments = iResistanceAdjustments - 3;
				}
				else if(GetEffectSpellId( eEffect ) == SPELL_MORDENKAINENS_DISJUNCTION )
				{
					iResistanceAdjustments = iResistanceAdjustments - 10;
				}
			}
			eEffect = GetNextEffect(oTarget);
		}
		
		// Check for natures balance, unimplemented spell it looks like
		// need to have it drop vars on it's targets if it is going to affect them
		//if ( GetHasSpellEffect( SPELL_NATURES_BALANCE, oChar) )
		//{
		//
		//}

	}
	// Assay is checked in the actual function, since it compares the caster and target
	
	//iSpellResistance = GetSpellResistance(oChar);
	// add in some things to use localints as well, just to double check things
	return CSLGetMax( 0, iSpellResistance + iResistanceAdjustments );
}


/* PRC Version
//
//  This function is a wrapper should someone wish to rewrite the Bioware
//  version. This is where it should be done.
//
int PRCGetSpellResistance(object oTarget, object oCaster)
{
        int iSpellRes = GetSpellResistance(oTarget);

        //racial pack SR
        int iRacialSpellRes = 0;
        if(GetHasFeat(FEAT_SPELL27, oTarget))
            iRacialSpellRes += 27+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL25, oTarget))
            iRacialSpellRes += 25+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL18, oTarget))
            iRacialSpellRes += 18+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL15, oTarget))
            iRacialSpellRes += 15+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL14, oTarget))
            iRacialSpellRes += 14+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL13, oTarget))
            iRacialSpellRes += 13+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL11, oTarget))
            iRacialSpellRes += 11+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL10, oTarget))
            iRacialSpellRes += 10+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL5, oTarget))
            iRacialSpellRes += 5+GetHitDice(oTarget);
        if(iRacialSpellRes > iSpellRes)
            iSpellRes = iRacialSpellRes;

        // Exalted Companion, can also be used for Celestial Template
        if (GetLocalInt(oTarget, "CelestialTemplate"))
        {
            int nHD = GetHitDice(oTarget);
            int nSR = nHD * 2;
            if (nSR > 25) nSR = 25;
            if (nSR > iSpellRes) iSpellRes = nSR;
        }

        // Foe Hunter SR stacks with normal SR
        // when a spell is cast by their hated enemy
        if(GetHasFeat(FEAT_HATED_ENEMY_SR, oTarget) && GetLocalInt(oTarget, "HatedFoe") == MyPRCGetRacialType(oCaster) )
        {
             iSpellRes += 15 + GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oTarget);
        }

    return iSpellRes;
}
*/



/**
* Applies any modifiers to the shape of the given spell
* @param iShape
* @param oCaster The caster of the current spell
* @return
* @see
* @todo add in metamagic features that support this      
* @replaces
*/
int HkApplyShapeMods( int iShape, object oCaster = OBJECT_SELF )
{
	return iShape;
}

/**
* Gets the correct shape effect for the given spell, based on modified shape, size, and element or color
* @param iShapeEffect
* @param iShapeType = SC_SHAPE_NONE
* @param oCaster The caster of the current spell
* @param fRadius = RADIUS_SIZE_HUGE
* @return Visual Effect Constant
* @see
* @replaces
*/
int HkGetShapeEffect( int iShapeEffect, int iShapeType = SC_SHAPE_NONE, object oCaster = OBJECT_SELF, float fRadius = RADIUS_SIZE_HUGE )
{
	int iDescriptorModType = CSLReadIntModifier( oCaster, "descriptormodtype" );
	// allows making beams to change to different appearances besides elemental
	if ( iDescriptorModType != 0 && iShapeType != 0 )
	{
		// overridden by the elemental modification
		// Do stuff here
	}
	
	int iDamageModType = CSLReadIntModifier( oCaster, "damagemodtype" ); 
	
	if ( iDamageModType != 0 && iShapeType != 0 )
	{
		switch ( iShapeType )
		{
			case SC_SHAPE_SPELLCYLINDER:
				iShapeEffect = iShapeEffect;
				break;
			case SC_SHAPE_AOE:
				iShapeEffect = CSLGetAOEEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_AOEEXPLODE:
				iShapeEffect = CSLGetAOEExplodeByDamageType( iDamageModType, fRadius );
				break;
			case SC_SHAPE_BREATHCONE:
				iShapeEffect = CSLGetBreathConeEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_SPELLCONE:
				iShapeEffect = CSLGetSpellConeEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_SHORTCONE:
				iShapeEffect = CSLGetShortConeShortEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_BEAM:
				iShapeEffect = CSLGetBeamEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_CUBE:
				iShapeEffect = iShapeEffect;
				break;
			case SC_SHAPE_WALL:
				iShapeEffect = CSLGetAOEWallByDamageType( iDamageModType );
				break;
			case SC_SHAPE_CLOUD:
				iShapeEffect = iShapeEffect;
				break;
			case SC_SHAPE_AURA:
				iShapeEffect = CSLGetFlameAuraByDamageType( iDamageModType );
				break;
			case SC_SHAPE_FAERYAURA:
				iShapeEffect = CSLGetFaeryAuraByDamageType( iDamageModType );
				break;
			case SC_SHAPE_SHIELD:
				iShapeEffect = CSLGetShieldEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_CONTDAMAGE:
				iShapeEffect = CSLGetContinuousDamageEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_IMPACT:
				iShapeEffect = CSLGetImpactEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_MIRV:
				iShapeEffect = CSLGetMIRVEffectByDamageType( iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_SPEAR:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_SPEAR, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_SWORD:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_SWORD, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_HAMMER:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_HAMMER, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_DAGGER:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_DAGGER, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_MACE:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_MACE, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_TRIDENT:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_TRIDENT, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_GLAIVE:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_GLAIVE, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_PITCHFORK:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_PITCHFORK, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_SCYTHE:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_SCYTHE, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_BATTLEAXE:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_BATTLEAXE, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_BOW:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_BOW, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_SHIELD:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_SHIELD, iDamageModType );
				break;
			case SC_SHAPE_SPELLWEAP_ARMOR:
				iShapeEffect = CSLGetWeaponEffectByDamageType( SC_SHAPE_SPELLWEAP_ARMOR, iDamageModType );
				break;
		}
	}
	
	if (DEBUGGING >= 6) { CSLDebug( "Shape Set to "+IntToString( iShapeEffect ) ); }
	return iShapeEffect;
}


/**
* Gets the correct hit effect based on damage type and modifiers
* @param iHitEffect
* @param oCaster The caster of the current spell
* @return Visual Effect Constant
* @see
* @replaces
*/
int HkGetHitEffect( int iHitEffect, object oCaster = OBJECT_SELF )
{
	int iDamageModType = CSLReadIntModifier( oCaster, "damagemodtype" );
	if ( iDamageModType )
	{
		iHitEffect = CSLGetHitEffectByDamageType( iDamageModType );
	}
	return iHitEffect;
}

/**
* Gets the correct saving throw type based on damage type and modifiers
* @param iSaveType
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
int HkGetSaveType( int iSaveType, object oCaster = OBJECT_SELF )
{
	int iDamageModType = CSLReadIntModifier( oCaster, "damagemodtype" );
		
	//if ( CSLReadIntModifier( oCaster, "damagepiercing" ) )
	//{
	//	return DAMAGE_TYPE_ALL;
	//}
	
	if ( iDamageModType )
	{
		iSaveType = CSLGetSaveTypeByDamageType( iDamageModType );
	}
	
	iSaveType = CSLReadIntModifier( oCaster, "savetype", iSaveType );
	
	return iSaveType;
}

/**
* Gets the correct Damage type based on any modifiers
* @param iDamageType
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces XXXSPGetElementalDamageType
*/
int HkGetDamageType( int iDamageType, object oCaster = OBJECT_SELF )
{
	iDamageType = CSLReadIntModifier( oCaster, "damagemodtype", iDamageType );
	
	// CSLDamagetypeToString
	return iDamageType;
}
/* PRC Version
int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF)
{
    // Only apply change to elemental damages.
    int nOldDamageType = nDamageType;
    switch (nDamageType)
    {
    case DAMAGE_TYPE_ACID:
    case DAMAGE_TYPE_COLD:
    case DAMAGE_TYPE_ELECTRICAL:
    case DAMAGE_TYPE_FIRE:
    case DAMAGE_TYPE_SONIC:
        nDamageType = ChangedElementalDamage(oCaster, nDamageType);
    }

    return nDamageType;
}

*/


/**
* Gets the modified target size based on any modifiers
* @param fTargetSize
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
float HkApplySizeMods( float fTargetSize, object oCaster = OBJECT_SELF )
{
	int iSizeModPercent = CSLReadIntModifier( oCaster, "sizemodpercent" );
	
	if ( iSizeModPercent != 0 )
	{
		fTargetSize = ( ( fTargetSize * iSizeModPercent ) / 100 );
	}
	return fTargetSize;
}




/*
GetLocalInt(OBJECT_SELF, "HKTEMP_damagemodtype" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagepiercing" )

GetLocalInt(OBJECT_SELF, "HKTEMP_damagesplit" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagesplitdamagetype" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagesplitpercent" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagesplitinteger" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagesplitpiercing" )

GetLocalInt(OBJECT_SELF, "HKTEMP_damagebonus" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagebonustype" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagebonuspercent" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagebonusdiesize" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagebonusnumdie" )
GetLocalInt(OBJECT_SELF, "HKTEMP_damagebonusint" )

*/



/**
* Creates a damage effect for use on the given target that handles certain modifiers
* @param iDamageAmount
* @param nDamageType=DAMAGE_TYPE_MAGICAL
* @param nDamagePower=DAMAGE_POWER_NORMAL
* @param nIgnoreResistances=FALSE
* @return
* @see
* @replaces
*/
effect HkEffectDamage(int iDamageAmount, int nDamageType=DAMAGE_TYPE_MAGICAL, int nDamagePower=DAMAGE_POWER_NORMAL, int nIgnoreResistances=FALSE, object oTarget = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// initalize the vars
	effect eDamage;
	object oCaster = OBJECT_SELF;
	
	
	int iBaseDamage = iDamageAmount;
	int iBaseDamagePower = nDamagePower;
	
	nDamageType = CSLReadIntModifier( oCaster, "damagemodtype", nDamageType );
	
	int nDamageModPercent = CSLReadIntModifier( oCaster, "damagemodpercent", 100 );
	if ( nDamageModPercent != 100 )
	{
		iBaseDamage = ( ( iBaseDamage * nDamageModPercent )/100 );
		iDamageAmount = iBaseDamage;
	}
	
	int nDamageModInteger = CSLReadIntModifier( oCaster, "damagemodint", 0 );
	if ( nDamageModInteger != 0 )
	{
		iBaseDamage = iBaseDamage + nDamageModInteger;
		iDamageAmount = iBaseDamage;
	}
	
	int iBaseDamageType = nDamageType;
		
	if ( CSLReadIntModifier( oCaster, "damagepiercing" ) )
	{
		nIgnoreResistances = TRUE;
		iDamageAmount = CSLAdjustPiercingDamage(iDamageAmount, nDamageType, oTarget);
	}
	int iBaseDamagePiercing = nIgnoreResistances;
	
	
	
	// this takes the base damage and splits off some, usually to make it have a different damage type or piercing
	int iSplitDamage = 0;
	int iSplitDamageType = nDamageType;
	int iSplitDamagePower = nDamagePower;
	int iSplitDamagePiercing = nIgnoreResistances;
		
	if ( CSLReadIntModifier( oCaster, "damagesplit" ) )
	{
	
		// get the percentage amount increase
		int iDamageSplitPercentage = CSLReadIntModifier( oCaster, "damagesplitpercent" ); // integer between 1 and 100 representing percentage, note that 200 will increase it to do double damage which is biting
		
		iSplitDamage = ( iBaseDamage * iDamageSplitPercentage ) / 100 ; // Half of bonus (rounded down) is divine damage.
		iBaseDamage = CSLGetMax( iDamageAmount-iSplitDamage, 0 ) ; // The rest (half rounded up) is fire damage.

		// get any integer increase
	
		int iSplitInt = CSLReadIntModifier( oCaster, "damagesplitinteger" ); // integer repesenting a fixed amount of extra damage		
		if ( iSplitInt > iBaseDamage )
		{
			iSplitDamage += iSplitInt;
			iBaseDamage = iBaseDamage - iSplitDamage;
		}
		else
		{
			iSplitDamage += iBaseDamage;
			iBaseDamage = 0;
		}
		if ( iSplitDamage )
		{
			if ( CSLReadIntModifier( oCaster, "damagesplitdamagetype" ) )
			{
				iSplitDamageType = CSLReadIntModifier( oCaster, "damagesplitdamagetype" );
			}
			int iBaseDamageType = nDamageType;
			
			if ( CSLReadIntModifier( oCaster, "damagesplitpiercing" ) )
			{
				iSplitDamagePiercing = TRUE;
			}
		}
	}
	
	
	int iBonusDamage = 0;
	int iBonusDamageType = nDamageType;
	int iBonusDamagePower = nDamagePower;
	int iBonusDamagePiercing = nIgnoreResistances;
	if ( CSLReadIntModifier( oCaster, "damagebonus" ) )
	{
		int iDamageBonusPercentage = GetLocalInt(oCaster, "HKTEMP_damagebonuspercent" ); 
		if ( iDamageBonusPercentage )
		{
			iBonusDamage = ( (iBaseDamage+iSplitDamage) * iDamageBonusPercentage ) / 100 ;
		}
		else
		{
			int iDamageBonusDieSize = CSLReadIntModifier( oCaster, "damagebonusdiesize" ); 
			int iDamageBonusNumDie = CSLReadIntModifier( oCaster, "damagebonusnumdie" );
			int iDamageBonusInt = CSLReadIntModifier( oCaster, "damagebonusint" );
			iBonusDamage = CSLDieX( iDamageBonusDieSize, iDamageBonusNumDie ) + iDamageBonusInt;
			
		}
				
		if ( iBonusDamage )
		{
			iSplitDamageType = CSLReadIntModifier( oCaster, "damagebonustype", iSplitDamageType );
			int iBaseDamageType = nDamageType;
			
			if ( CSLReadIntModifier( oCaster, "damagebonuspiercing" ) )
			{
				iSplitDamagePiercing = TRUE;
			}
		}
	
	}
		
	if ( iBaseDamage )
	{
		eDamage = EffectDamage( iBaseDamage, iBaseDamageType, iBaseDamagePower, iBaseDamagePiercing );
	}
	else
	{
		// eDamage = empty effect here???
	}
	
	if ( iSplitDamage )
	{
		eDamage = EffectLinkEffects( eDamage, EffectDamage( iSplitDamage, iSplitDamageType, iSplitDamagePower, iSplitDamagePiercing ) );
	}
	
	if ( iBonusDamage )
	{
		eDamage = EffectLinkEffects( eDamage, EffectDamage( iBonusDamage, iBonusDamageType, iBonusDamagePower, iBonusDamagePiercing ) );
	}
	
	return eDamage;
}




/**
* Resets any modifier vars on a character after each spell casting
* @param oCaster The caster of the current spell
* @see
* @replaces
*/
// Resets the MetaModifiers
void HkResetMetaModifierVars( object oCaster )
{
	//SendMessageToPC(oCaster, "Resetting Vars");
	// HKPERM_ Vars are not touched
	DeleteLocalInt( oCaster, "HKTEMP_Class" );
	DeleteLocalInt( oCaster, "HKTEMP_SpellId" );
	DeleteLocalInt( oCaster, "HKTEMP_SpellLevel" );
	DeleteLocalInt( oCaster, "HKTEMP_Descriptor" );
	DeleteLocalInt( oCaster, "HKTEMP_School" );
	DeleteLocalInt( oCaster, "HKTEMP_SubSchool" );
	DeleteLocalInt( oCaster, "HKTEMP_Attributes" );
	
	DeleteLocalInt( oCaster, "HKTEMP_MaxLevel" );
	DeleteLocalInt( oCaster, "HKTEMP_MinLevel" );
	
	DeleteLocalInt( oCaster, "HKTEMP_TargetState" ); // stores the target state
	
	DeleteLocalInt( oCaster, "HKTEMP_Blocked" );
	SetLocalString( oCaster, "HKTEMP_Reason", "");
	DeleteLocalInt( oCaster, "HKTEMP_Wild" );
	DeleteLocalInt( oCaster, "HKTEMP_CasterLevel" );
	DeleteLocalInt( oCaster, "HKTEMP_CasterLevelAdj" );
	
	DeleteLocalInt( oCaster, "HKTEMP_shapemod" );
	DeleteLocalInt( oCaster, "HKTEMP_sizemodpercent" );
	
	DeleteLocalInt( oCaster, "HKTEMP_Spell_Power" );
	DeleteLocalInt( oCaster, "HKTEMP_Spell_PowerAdj" );
	DeleteLocalInt( oCaster, "HKTEMP_Spell_Duration" );
	DeleteLocalInt( oCaster, "HKTEMP_Spell_DurationAdj" );
	DeleteLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj" );
	
	DeleteLocalInt( oCaster, "HKTEMP_TurnAdj" );
	
	DeleteLocalInt( oCaster, "HKTEMP_Spell_CapAdj" );
	
	DeleteLocalInt( oCaster, "HKTEMP_Spell_MetaMagic" );
	DeleteLocalInt( oCaster, "HKTEMP_Savetype" );
	DeleteLocalInt( oCaster, "HKTEMP_SaveTarget" );
	
	DeleteLocalInt( oCaster, "HKTEMP_Save_DC" );
	DeleteLocalInt( oCaster, "HKTEMP_Save_ResistCheckAdj" );
	DeleteLocalInt( oCaster, "HKTEMP_Save_DispelDCAdj" );
	DeleteLocalInt( oCaster, "HKTEMP_Save_DCadj" );
	
	DeleteLocalInt( oCaster, "HKTEMP_descriptormodtype" );
	DeleteLocalInt( oCaster, "HKTEMP_damagemodtype" );
	DeleteLocalInt( oCaster, "HKTEMP_damagemodpercent" );
	DeleteLocalInt( oCaster, "HKTEMP_damagemodint" );
	DeleteLocalInt( oCaster, "HKTEMP_damagepiercing" );
	DeleteLocalInt( oCaster, "HKTEMP_damagesplit" );
	DeleteLocalInt( oCaster, "HKTEMP_damagesplitdamagetype" );
	DeleteLocalInt( oCaster, "HKTEMP_damagesplitpercent" );
	DeleteLocalInt( oCaster, "HKTEMP_damagesplitinteger" );
	DeleteLocalInt( oCaster, "HKTEMP_damagesplitpiercing" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonus" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonustype" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonuspiercing" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonuspercent" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonusdiesize" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonusnumdie" );
	DeleteLocalInt( oCaster, "HKTEMP_damagebonusint" );

	

	//DeleteLocalInt(oCaster, "HKTEMP_SaveTarget");
	//SetLocalInt(oToB, "SaveTarget", ObjectToInt(oTarget));
	//DelayCommand(1.0f, SetLocalInt(oPC, "HKTEMP_SaveTarget", 0));
	//DelayCommand(1.0f, SetLocalInt(oToB, "SaveTarget", 0));
	

}


/**
* Applies a mantle absorbtian effect to target 
* @param oTarget The Target of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param fDuration
* @param iAbsorb = 0
* @param iNumberLevels = -1
* @see
* @replaces
*/
void HkApplySpellMantleEffect( object oTarget, int iSpellId, float fDuration, int iAbsorb = 0, int iNumberLevels = -1 )
{
	
	int iMantleVFX = VFX_DUR_SPELL_SPELL_MANTLE;
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LEAST_SPELL_MANTLE, SPELL_LESSER_SPELL_MANTLE, SPELL_SPELL_MANTLE, SPELL_GREATER_SPELL_MANTLE, SPELL_SPELL_TURNING );
	

	DeleteLocalInt(oTarget, "SC_SPELLTURN_LVLS");
	DeleteLocalInt(oTarget, "SC_SPELLMANTLE_LVLS");
	int iVFXeffect;
	switch ( iSpellId )
	{
			case SPELL_LEAST_SPELL_MANTLE:	
				iVFXeffect = VFX_DUR_SPELL_LESSER_SPELL_MANTLE;
				SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", iAbsorb);
				break;
			case SPELL_LESSER_SPELL_MANTLE:
				iVFXeffect = VFX_DUR_SPELL_LESSER_SPELL_MANTLE;
				SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", iAbsorb);
				break;
			case SPELL_SPELL_MANTLE:
				iVFXeffect = VFX_DUR_SPELL_SPELL_MANTLE;
				SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", iAbsorb);
				break;
			case SPELL_GREATER_SPELL_MANTLE:
				iVFXeffect = VFX_DUR_SPELL_GREATER_SPELL_MANTLE;
				SetLocalInt(oTarget, "SC_SPELLMANTLE_LVLS", iAbsorb);
				break;
			case SPELL_SPELL_TURNING:
				SetLocalInt(oTarget, "SC_SPELLTURN_LVLS", iAbsorb);
				break;
	}
	
	

	// Create the effect
	
	effect eLink = EffectSpellLevelAbsorption( -1, iAbsorb );  // iNumberLevels would go where -1 is
	// effect eLink = EffectSpellLevelAbsorption(9, iAbsorb);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(iVFXeffect));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	

	
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );

	// Set the number of spell absorption levels
	
	
	
	//  i am going to leave the variable on after expiration, but detect if there is a mantle
	//  if there is no variable, perhaps due to logging it should protect against first spell and then expire
	// DelayCommand(fDuration, DeleteLocalInt(oTarget, "SC_SPELLTURN_LVLS"));
	
	

}

/**
* @return The current Target of the spell.
* @replaces XXGetSpellTargetObject
*/
object HkGetSpellTarget()
{
	return GetSpellTargetObject();
}

/* PRC version
//wrapper for HkGetSpellTarget()
object HkGetSpellTarget()
{
    object oCaster   = OBJECT_SELF; // We hope this is only ever called from the spellscript
    object oItem     = GetSpellCastItem();
    object oBWTarget = HkGetSpellTarget();
    int nSpellID     = HkGetSpellId();


    if(GetLocalInt(oCaster, "PRC_EF_ARCANE_FIST"))
        return oCaster;

    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE))
        return GetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);

    int bTouch = GetStringUpperCase(Get2DAString("spells", "Range", nSpellID)) == "T";
    // Reddopsi power causes spells and powers to rebound onto the caster.
    if(GetLocalInt(oBWTarget, "PRC_Power_Reddopsi_Active")                 &&  // Reddopsi is active on the target
       !GetLocalInt(oCaster, "PRC_Power_Reddopsi_Active")                  &&  // And not on the manifester
       !(nSpellID == SPELL_LESSER_DISPEL             ||                        // And the spell/power is not a dispelling one
         nSpellID == SPELL_DISPEL_MAGIC              ||
         nSpellID == SPELL_GREATER_DISPELLING        ||
         nSpellID == SPELL_MORDENKAINENS_DISJUNCTION ||
         nSpellID == POWER_DISPELPSIONICS
         )                                                                 &&
       !bTouch     // And the spell/power is not touch range
       )
        return oCaster;

    if(GetLocalInt(oBWTarget, "PRC_SPELL_TURNING") &&
        !(nSpellID == SPELL_LESSER_DISPEL             ||                        // And the spell/power is not a dispelling one
                 nSpellID == SPELL_DISPEL_MAGIC              ||
                 nSpellID == SPELL_GREATER_DISPELLING        ||
                 nSpellID == SPELL_MORDENKAINENS_DISJUNCTION ||
                 nSpellID == POWER_DISPELPSIONICS) &&
        !bTouch
        )
    {
        int nSpellLevel = StringToInt(Get2DAString("spells", "Innate", nSpellID));//lookup_spell_innate(nSpellID));
        object oTarget = oBWTarget;
        int nLevels = GetLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS");
        int bCasterTurning = GetLocalInt(oCaster, "PRC_SPELL_TURNING");
        int nCasterLevels = GetLocalInt(oCaster, "PRC_SPELL_TURNING_LEVELS");
        if(!bCasterTurning)
        {
            if(nSpellLevel > nLevels)
            {
                if((Random(nSpellLevel) + 1) <= nLevels)
                    oTarget = oCaster;
            }
            else
                oTarget = oCaster;
        }
        else
        {
            if((Random(nCasterLevels + nLevels) + 1) <= nLevels)
                oTarget = oCaster;
            nCasterLevels -= nSpellLevel;
            if(nCasterLevels < 0) nCasterLevels = 0;
            SetLocalInt(oCaster, "PRC_SPELL_TURNING_LEVELS", nCasterLevels);
        }
        nLevels -= nSpellLevel;
        if(nLevels < 0) nLevels = 0;
        SetLocalInt(oBWTarget, "PRC_SPELL_TURNING_LEVELS", nLevels);
        return oTarget;
    }

    // The rune always targets the one who activates it.
    if(GetResRef(oItem) == "prc_rune_1")
    {
        if(DEBUGGING) CSLDebug(GetName(oCaster) + " has cast a spell using a rune");
        // Making sure that the owner of the item is correct
        if (GetIsObjectValid(GetItemPossessor(oItem))) if(DEBUGGING) CSLDebug(GetName(oCaster) + " is the owner of the Spellcasting item");
        return GetItemPossessor(oItem);
    }

    return oBWTarget;
}

*/

/**
* @return The current Target Location of the spell.
* @replaces XXGetSpellTargetLocation
*/
location HkGetSpellTargetLocation()
{
	return GetSpellTargetLocation();
}

/* PRC version
//wrapper for HkGetSpellTargetLocation()
location HkGetSpellTargetLocation()
{
    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE))
        return GetLocalLocation(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE);

    object oItem     = GetSpellCastItem();
    // The rune always targets the one who activates it.
    if(GetResRef(oItem) == "prc_rune_1") return GetLocation(GetItemPossessor(oItem));

    return HkGetSpellTargetLocation();
}
*/


/**
* @param oCaster The caster of the current spell
* @return The caster of the spell
* @see
* @replaces
*/
object HkGetCaster( object oCaster = OBJECT_SELF )
{
	if (GetObjectType(oCaster) == OBJECT_TYPE_AREA_OF_EFFECT)
	{
		oCaster = GetAreaOfEffectCreator();
	}
	return oCaster;
}




/**
* Returns descriptors based on any modifiers
* @param iDescriptor The Descriptor for the current spell, if unused or set as -1 it will use the descriptor set in the pre cast
* @param oCaster The caster of the current spell
* @param isSpell = TRUE
* @param isEnergySubsValid = FALSE
* @return
* @see
* @replaces
*/
// * Takes a given element variable, and returns another based on it
int HkApplyDescriptorMods( int iDescriptor=-1, object oCaster = OBJECT_SELF, int isSpell = TRUE, int isEnergySubsValid = FALSE )
{
	//CSLResetSpellModifierVars( object oCaster  ); // make sure nothing is polluting things here
	if ( iDescriptor==-1 ) iDescriptor = HkGetDescriptor();
	
	// read any vars on the caster for special conditions, don't do this in AOE's sinc ethen
	/*
	if ( GetObjectType( OBJECT_SELF ) != OBJECT_TYPE_AREA_OF_EFFECT )
	{
		if ( GetLocalInt(oCaster, "SCMOD_VARSACTIVE") == TRUE )
		{
			iDescriptor = CSLReadSpellModifierVars( oCaster, oCaster, iDescriptor, int iSpellId = -1, int iClass = -1, int iSchool = -1, int iSubSchool = -1, string sDeity = ""   )
		}
		
		if ( GetLocalInt( GetArea(oCaster), "SCMOD_VARSACTIVE") == TRUE )
		{
			iDescriptor = CSLReadSpellModifierVars( GetArea(oCaster), oCaster, iDescriptor, int iSpellId = -1, int iClass = -1, int iSchool = -1, int iSubSchool = -1, string sDeity = ""   )
		}
	}
	
	*/
	
	/* Custom Code by Modders Here
	*/
	
	
	// this adds piercing to the bits of the iDescriptor
	// iDescriptor | SCMETA_DESCRIPTOR_PIERCING ;
	
	// this removes piercing to the bits of the iDescriptor
	// iDescriptor | ~SCMETA_DESCRIPTOR_PIERCING ;
	 // SCMETA_DESCRIPTOR_FIRE + SCMETA_DESCRIPTOR_COLD + SCMETA_DESCRIPTOR_ELECTRICAL + SCMETA_DESCRIPTOR_SONIC + SCMETA_DESCRIPTOR_ACID
	
	if ( CSLGetIsElementalDescriptor( iDescriptor ) && GetHasFeat(FEAT_ENERGY_SUBSTITUTION , oCaster) && isSpell && isEnergySubsValid )
	{
		if ( !( iDescriptor & SCMETA_DESCRIPTOR_ACID ) && GetHasSpellEffect( SPELLABILITY_ENERGY_SUBSTITUTION_ACID, oCaster ) )
		{
			iDescriptor = CSLBitSubGroup( iDescriptor, SCMETA_DESCRIPTOR_FIRE, SCMETA_DESCRIPTOR_COLD, SCMETA_DESCRIPTOR_ELECTRICAL, SCMETA_DESCRIPTOR_SONIC );
			iDescriptor = CSLBitAdd( iDescriptor, SCMETA_DESCRIPTOR_ACID );
		}
		else if ( !( iDescriptor & SCMETA_DESCRIPTOR_COLD ) && GetHasSpellEffect( SPELLABILITY_ENERGY_SUBSTITUTION_COLD, oCaster ) )
		{
			iDescriptor = CSLBitSubGroup( iDescriptor, SCMETA_DESCRIPTOR_FIRE, SCMETA_DESCRIPTOR_ELECTRICAL, SCMETA_DESCRIPTOR_SONIC, SCMETA_DESCRIPTOR_ACID );
			iDescriptor = CSLBitAdd( iDescriptor, SCMETA_DESCRIPTOR_COLD );
		}
		else if ( !( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL ) && GetHasSpellEffect( SPELLABILITY_ENERGY_SUBSTITUTION_ELEC, oCaster ) )
		{
			iDescriptor = CSLBitSubGroup( iDescriptor, SCMETA_DESCRIPTOR_FIRE, SCMETA_DESCRIPTOR_COLD, SCMETA_DESCRIPTOR_SONIC, SCMETA_DESCRIPTOR_ACID );
			iDescriptor = CSLBitAdd( iDescriptor, SCMETA_DESCRIPTOR_ELECTRICAL );
		}
		else if ( !( iDescriptor & SPELLABILITY_ENERGY_SUBSTITUTION_FIRE ) && GetHasSpellEffect( SPELLABILITY_ENERGY_SUBSTITUTION_FIRE, oCaster ) )
		{
			iDescriptor = CSLBitSubGroup( iDescriptor, SCMETA_DESCRIPTOR_COLD, SCMETA_DESCRIPTOR_ELECTRICAL, SCMETA_DESCRIPTOR_SONIC, SCMETA_DESCRIPTOR_ACID );
			iDescriptor = CSLBitAdd( iDescriptor, SPELLABILITY_ENERGY_SUBSTITUTION_FIRE );
		}
		else if ( !( iDescriptor & SCMETA_DESCRIPTOR_SONIC ) && GetHasSpellEffect( SPELLABILITY_ENERGY_SUBSTITUTION_SONIC, oCaster ) )
		{
			iDescriptor = CSLBitSubGroup( iDescriptor, SCMETA_DESCRIPTOR_FIRE, SCMETA_DESCRIPTOR_COLD, SCMETA_DESCRIPTOR_ELECTRICAL, SCMETA_DESCRIPTOR_ACID );
			iDescriptor = CSLBitAdd( iDescriptor, SCMETA_DESCRIPTOR_SONIC );
		}
	}
	
	//Handles Piercing Cold
	//if ( isSpell && ( iDescriptor & SCMETA_DESCRIPTOR_COLD ) && GetHasFeat( FEAT_FROSTMAGE_PIERCING_COLD , oCaster) )
	//{
		//iDescriptor = CSLBitAdd( iDescriptor, SCMETA_DESCRIPTOR_PIERCING );
	//}
	
	
	//SetLocalInt(oCaster, "SC_BITINGINT", iDescriptor );
	
	return iDescriptor;
}




/**
* Applies a slow effect which is designed not to stack with those of matching type
* @param oTarget The Target of the current spell
* @param oCaster The caster of the current spell
* @param fDuration
* @param BlockSpellID = 3805
* @see
* @replaces
*/
void HkNonStackingSlow( object oTarget, object oCaster, float fDuration, int BlockSpellID = 3805 )
{
	// This is to support AOE style effects, and to ensure the effects from multiple of the same effect do not stack
	// so it makes the effect have it's own unique spell id, which means the slowing can stack with other spells, but not from the same originating spell
	// A different BlockSpellID would have to be chosen if two different spells are allowed to stack.
	
	effect eSlow = EffectMovementSpeedDecrease(50);
	eSlow = SetEffectSpellId(eSlow, BlockSpellID);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, BlockSpellID ); // remove previous slow effects soas to replace the effect
//void HkApplyEffectToObject(int iDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, int iSpellId = -1, object oCaster = OBJECT_SELF, int iClass = 255);
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, fDuration );
}



/**
* Returns the correct caster level when dealing with item cast spells
* @param oItem
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetItemCasterLevel( object oItem, object oChar = OBJECT_SELF )
{

	if ( !CSLIsItemValid( oItem ) )
	{
		//SpeakString( "Item Invalid" );
		return 5; // nonsense, we already checked but being paranoid, just give a pretty low default value
	}
	else if ( GetBaseItemType(oItem)==BASE_ITEM_SPELLSCROLL )
	{
		//SpeakString( "Item Scroll" );
		return HkGetScrollLevel( oItem, oChar );
	}
	else if ( GetBaseItemType(oItem)==BASE_ITEM_MAGICSTAFF )
	{
		return HkGetScrollLevel( oItem, oChar );
	}
	else if ( GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_WAND )
	{
		return HkGetScrollLevel( oItem, oChar );
	}
	else if ( GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_SCROLL )
	{
		return HkGetScrollLevel( oItem, oChar );
	}
	else
	{
		//return HkGetScrollLevel( oItem, oChar );
		//SpeakString( "Item Other" );
		return GetCasterLevel(oChar);
	}
	// BASE_ITEM_MAGICSTAFF
	// BASE_ITEM_ENCHANTED_WAND
	// BASE_ITEM_MAGICWAND
	// BASE_ITEM_SCROLL
	// BASE_ITEM_ENCHANTED_SCROLL
	// BASE_ITEM_SPELLSCROLL
}






/**
* Boost to some warlock abilities
* @param oCaster The caster of the current spell
* @return
* @see
* @replaces
*/
int HkGetWarlockBonus( object oCaster )
{
	int iCasterLevel = HkGetCasterLevel(oCaster, CLASS_TYPE_WARLOCK); // added in hint since this is always called by a warlock, just to make sure it is always getting the correct thing
	int iCHA = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	return CSLGetMin(iCHA, iCasterLevel/3);
}

/**
* The level of the scroll being used
* @param oItem
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetScrollLevel( object oItem, object oChar = OBJECT_SELF )
{
	int iSpellLevel = HkGetSpellLevel( HkGetSpellId() , -1 ); // -1 to keep it from dealing with the class involved	

	return CSLGetMax( iSpellLevel * 2, 5 );
}

/**
* Applies touch attack damage to the target
* @param oTarget The Target of the current spell
* @param iTouch
* @param iDamage
* @param iAttackType = SC_TOUCH_UNKNOWN
* @param oAttacker = OBJECT_SELF
* @return
* @see
* @replaces
*/
int HkApplyTouchAttackDamage( object oTarget, int iTouch, int iDamage, int iAttackType = SC_TOUCH_UNKNOWN, object oAttacker = OBJECT_SELF )
{
	if (
		( iAttackType == SC_TOUCHSPELL_MELEE && GetHasFeat( FEAT_MELEE_TOUCH_SPELL_SPECIALIZATION, oAttacker ) ) ||
		( ( iAttackType == SC_TOUCHSPELL_RANGED || iAttackType == SC_TOUCHSPELL_RAY )  && GetHasFeat( FEAT_RANGED_TOUCH_SPELL_SPECIALIZATION, oAttacker ) )
	   )
	{
		// possibly add 2 per level of spell
		if ( CSLGetPreferenceSwitch("SpellsRaysAddSpecialistDamage",FALSE) )
		{
			iDamage += CSLGetMin( HkGetSpellLevel( HkGetSpellId() ) * 2, 2 );
		}
		else
		{
			iDamage += 2;
		}
	}

	if ( ( iAttackType == SC_TOUCHSPELL_RANGED || iAttackType == SC_TOUCHSPELL_RAY )  && GetHasFeat( FEAT_POINT_BLANK_SHOT, oAttacker ) )
	{
		if(  GetDistanceToObject(oTarget) <= 9.144f ) // this is in point blank range
		{
			iDamage += 1;
		}
	}
	
	
	int nDMage = GetLevelByClass(CLASS_DAGGERSPELL_MAGE, oAttacker);
	if (nDMage > 0)
	{
		if ( iAttackType == SC_TOUCHSPELL_MELEE || ( ( iAttackType == SC_TOUCHSPELL_RANGED || iAttackType == SC_TOUCHSPELL_RAY ) && nDMage > 7 ) )
		{
			object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oAttacker);
			if (GetIsObjectValid(oWeapon1) && (GetBaseItemType(oWeapon1) == BASE_ITEM_DAGGER) )
			{
				iDamage += d4(1) + CSLGetWeaponEnhancementBonus(oWeapon1);
			}	
			if (nDMage > 4 && iAttackType == SC_TOUCHSPELL_MELEE )
			{
				object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oAttacker);
				if (GetIsObjectValid(oWeapon2) && (GetBaseItemType(oWeapon2) == BASE_ITEM_DAGGER) )
				{
					iDamage += d4(1) + CSLGetWeaponEnhancementBonus(oWeapon2);
				}
			}
		}
	}
	
	if ( iAttackType == SC_TOUCHSPELL_MELEE )
	{
		int nDShaper = GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oAttacker);
		if (nDShaper > 0)
		{
			object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oAttacker);
			if (GetIsObjectValid(oWeapon1) && (GetBaseItemType(oWeapon1) == BASE_ITEM_DAGGER) )
			{
				iDamage += d4(1) + CSLGetWeaponEnhancementBonus(oWeapon1);
			}	
			if (nDShaper > 9)
			{
				object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oAttacker);
				if (GetIsObjectValid(oWeapon2) && (GetBaseItemType(oWeapon2) == BASE_ITEM_DAGGER) )
				{
					iDamage += d4(1) + CSLGetWeaponEnhancementBonus(oWeapon2);
				}
			}
		}
	}
	// the specialization damage is doubled here
	return iDamage;
}









/**
* Returns the owner or creator of the area of effect
* @param oAOE = OBJECT_SELF
* @return
* @see
* @replaces
*/
object HkGetAOEOwner( object oAOE = OBJECT_SELF )
{
	object oOwner = IntToObject( CSLGetAOETagInt( SCSPELLTAG_CASTERPOINTER, oAOE ) );
	if ( GetIsObjectValid(oOwner) )
	{
		return oOwner;
	}
	return OBJECT_INVALID;
}




/**
* Get the casters highest arcane levels
* @param oChar The character to get information from
* @return
* @see
* @replaces
*/
int HkGetArcaneLevel( object oChar )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iArcaneLevels" );
}

/**
* Get the casters highest divine levels
* @param oChar The character to get information from
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkGetDivineLevel( object oChar, int iClass )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	{
		oChar = GetMaster( oChar );
	}
	SCCacheStats( oChar );
	return GetLocalInt(oChar, "SC_iDivineLevels" );
}

/**
* Get the casters highest spell level
* @param oChar The character to get information from
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkGetCasterMaxSpellLevel( object oChar, int iClass = 255 )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	//if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	//{
	//	oChar = GetMaster( oChar );
	//}
	
	//SendMessageToPC( OBJECT_SELF, "Working on "+GetName(  oChar  ) );
	SCCacheStats( oChar );
	
	if ( iClass == 255 )
	{
		// this should try to figure out the correct class involved when there is an error
		iClass = HkGetSpellClass( oChar );
	}
	
	
	//if ( iClass == CLASS_TYPE_WARLOCK )
	//{
	//	return  10;
	//}	
	
	int iClassRow = HkPrepGetClassRowFromCache( oChar, iClass );
	if (DEBUGGING >= 7) { CSLDebug(  "Getting Caster Max Level on "+GetName(  oChar  )+"Class:"+CSLGetClassesDataName( iClass )+" row:"+IntToString( iClassRow ), OBJECT_SELF ); }
	
	if ( iClassRow > 0 )
	{
		//SendMessageToPC( OBJECT_SELF, "3Working on "+GetName(  oChar  )+IntToString( iClassRow ) );
		return GetLocalInt(oChar, "SC_iCurMaxSpellLevel"+IntToString(iClassRow) );
	}
	else
	{
		return 0;
	}
}


/**
* Get the level of slot being used by a particular spell
* @return
* @see
* @replaces
*/
int HkGetSpellSlotLevel()
{
	int iSpellSlotLevel;
	int iSpellId = HkGetSpellId();
	//SendMessageToPC(OBJECT_SELF, "spell="+IntToString(HkGetSpellLevel( iSpellId ))+"slot="+IntToString(CSLGetMetaMagicSlotLevelAdjust()) );
	iSpellSlotLevel = HkGetSpellLevel( iSpellId )+CSLGetMetaMagicSlotLevelAdjust();
	iSpellSlotLevel = CSLGetMin( iSpellSlotLevel, 9 );
	iSpellSlotLevel = CSLGetMax( iSpellSlotLevel, 0 );
	
	return iSpellSlotLevel;
}



/**
* Checks if the caster is following the rules for casting a spell, limited by class granted slot levels and by prime casting stat, used to block spirit shaman exploit
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return
* @see
* @replaces
*/
int HkCheckIfCanCastSpell( object oCaster = OBJECT_SELF, int iSpellId = -1, int iClass = 255 )
{
	if ( !GetIsObjectValid(oCaster) )
	{
			//SendMessageToPC( OBJECT_SELF, "Not Valid"  );
		return FALSE; // make sure it's only run on a valid object
	} 
	
	if ( GetLastSpellCastClass() == 255 )
	{
		return TRUE; // must be a feat, this should only block actual spells and not feats
	}
	
	// default high enough not to block certain folks
	// need a way of doing this
	int iCastingStat = 19;
	
	if ( CSLIsItemValid( GetSpellCastItem() ) )
	{
		// must be a scroll, a wand or someother item
		// only specifically cast by the caster should be affected by this
		return TRUE;
	}
	
	
	
	if ( iClass == 255 )
	{
		// this should try to figure out the correct class involved when there is an error
		iClass = HkGetSpellClass( oCaster );
	}
	
	
	if ( iSpellId == -1 )
	{
		iSpellId = HkGetSpellId();
	}
	
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		//SendMessageToPC( OBJECT_SELF, "We've got a familiar of"+GetName( GetMaster( oCaster ) ) );
		//return HkCheckIfCanCastSpell( GetMaster( oCaster ), iSpellId );
		oCaster = GetMaster( oCaster );
		iClass = HkGetSpellClass( oCaster );
		// we don't have the correct class, so get the best class of the master
		
	}
	
	//int nMaxLevelCanCast = HkGetCasterMaxSpellLevel(oCaster, iClass );
	int nSpellSlotLevel = HkGetSpellSlotLevel();
	//SendMessageToPC( OBJECT_SELF, "Class: "+IntToString( nSpellCasterClass )+" Max Level: "+IntToString( nMaxLevelCanCast )  );
	
	if ( CSLGetBaseCasterType( iClass ) == SC_SPELLTYPE_DIVINE )
	{
		if( CSLGetPreferenceSwitch("RequireDivineDeityAlign", FALSE ) )
		{
			string sDeityName = GetDeity( oCaster );
			int iDeity = GetLocalInt(oCaster, sDeityName);
			if ( iDeity == 0 )
			{
				iDeity = CSLGetDeityDataRowByFollower( oCaster );
				SetLocalInt(oCaster, sDeityName, iDeity );
			}
			if ( iDeity > 0 )
			{
				string sAlignment = CSLGetAlignmentToAbbrevString( CSLGetCreatureAlignment(oCaster) );
				string sAlignRestriction = GetLocalString(oCaster, "CSL_"+sAlignment+sDeityName);
				if ( sAlignRestriction == "" )
				{
					sAlignRestriction = Get2DAString("nwn2_deities",  sAlignment, iDeity );
					SetLocalString(oCaster, "CSL_"+sAlignment+sDeityName, sAlignRestriction );
				}
				
				if ( sAlignRestriction != "" &&  sAlignRestriction != "2" )
				{
					if ( sAlignment == "LG" && iClass == CLASS_TYPE_PALADIN )
					{
						// some deities allow paladins despite being non lawful good, paladin can fall into deities actual alignment though				
					}
					else
					{
						SetLocalString( oCaster, "CSL_ERRORSTRING", "You have fallen from the virtues required by your god, and as such are no longer granted spells" );
						return FALSE;
					}
				}
			}
		}
		
		if( CSLGetPreferenceSwitch("RequireHolyItems", FALSE ) && nSpellSlotLevel > 3 )
		{
			if ( !GetIsObjectValid(GetItemPossessedBy(oCaster, "HOLY_ITEM_"+GetName(oCaster))) )
			{
				SetLocalString( oCaster, "CSL_ERRORSTRING", "You have lost your holy symbol and without it your god will not answer your prayers" );
				return FALSE;
			}
			
		}
		
	}
	
	/* exploit was fixed by kaedrin, can put this back in if it's still needed
	
	
	if ( nMaxLevelCanCast < nSpellSlotLevel )
	{
		//SendMessageToPC( OBJECT_SELF, "Not Valid2"  );
		if (DEBUGGING >= 6) { CSLDebug(  "Spell is higher than can cast, max: "+IntToString( nMaxLevelCanCast )+" and spell slot level is "+IntToString( nSpellSlotLevel ), oCaster ); }
		
		SetLocalString( oCaster, "CSL_ERRORSTRING", "Spell is higher than can cast by class: max is "+IntToString( nMaxLevelCanCast )+" and spell slot level is "+IntToString( nSpellSlotLevel ) );
		
		return FALSE;
	}
	*/
	
	if ( iClass != CLASS_TYPE_WARLOCK ) // this does not apply to warlocks
	{
		int iPrimAbility = CSLGetMainStatByClass( iClass, "Spells" );
		if ( iPrimAbility == 0 )
		{
			iPrimAbility = ABILITY_INTELLIGENCE;
		}
		int iCastingStat = CSLGetNaturalAbilityScore( oCaster, iPrimAbility );
		
		int nMaxLevelCanCast = CSLGetMax( CSLGetMin( iCastingStat - 10, 10 ), 0 );
		
		if ( nMaxLevelCanCast < nSpellSlotLevel )
		{
		
			SetLocalString( oCaster, "CSL_ERRORSTRING", "Spell is higher than can cast with an unbuffed "+CSLAbilityStatToString(iPrimAbility, TRUE)+" of "+IntToString( iCastingStat )+": max is "+IntToString( nMaxLevelCanCast )+" and spell slot level is "+IntToString( nSpellSlotLevel ) );
			return FALSE;
		}
	}
	
	//if (DEBUGGING >= 8) { CSLDebug(  "Spell works, max: "+IntToString( nMaxLevelCanCast )+" and spell slot level is "+IntToString( nSpellSlotLevel ), oCaster ); }
	
	return TRUE;
	
}

/**
* Returns the AOE tag to be used for a given area of effect, with an option to destroy the previous AOE
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iSpellPower = 0
* @param fDuration = -1.0f
* @param iDestroyOldAOE = FALSE
* @param oOwner = OBJECT_INVALID
* @return
* @see CSLGetAOETagString
* @see CSLGetAOETagInt
* @see CSLGetTargetTagInt
* @see CSLGetTargetTagString
* @replaces
*/
string HkAOETag( object oCaster = OBJECT_SELF, int iSpellId = -1, int iSpellPower = 0, float fDuration = -1.0f, int iDestroyOldAOE = FALSE, object oOwner = OBJECT_INVALID )
{
	if ( iDestroyOldAOE == TRUE )
	{
		// This is a routing that makes sure we destroy an AOE, but we need to make sure we have the AOE string placed on the given AOE
		string sOldAOE = GetLocalString( oCaster, "SC_AOE"+IntToString( HkGetSpellId()) );
		if ( sOldAOE != "" )
		{
			object oOldAOE = GetNearestObjectByTag(sOldAOE);
			if (GetIsObjectValid(oOldAOE)) //We need to make sure that this AOE isn't stackable
			{
				DestroyObject(oOldAOE);
			}
		}
	}
	
	if ( !GetIsObjectValid( oOwner ) )
	{
		oOwner = oCaster;
	}
	
	if ( iSpellId == -1 )
	{
		iSpellId = HkGetSpellId();
	}
	
	// make sure the spell serial is set, this is global in scope and used for saving throws
	CSL_SPELLCAST_SERIALID = CSLGetRandomSerialNumber( CSL_SPELLCAST_SERIALID );
	
	int iDescriptor = HkGetDescriptor();
	int iDamageModType = CSLReadIntModifier( oCaster, "damagemodtype" );
	if ( iDamageModType ) // fix descriptor if they changed the damage type already, needed just for AOE's really
	{
		if (DEBUGGING >= 4) { CSLDebug(  "HkAOETag: iDescriptor = "+IntToString( iDescriptor ), oCaster ); }
		iDescriptor = CSLGetDescriptorModifiedByDamageType( iDescriptor, iDamageModType );
		if (DEBUGGING >= 4) { CSLDebug(  "HkAOETag: iDescriptor = "+IntToString( iDescriptor ), oCaster ); }
	}
	
	int iClass = HkGetSpellClass( oCaster );
	// creates a unique tag for a given spell which includes the various scores needed for it to work even with the original caster
	// will have to figure out how to extract the given values later

	//**********************************************//
	//              NAME and SPELLID = 2
	//**********************************************//
	string sAOETag = "SCAOE_"+IntToString( iSpellId ) + "_"  //2
	//**********************************************//
	//              CASTERPOINTER = 3
	//**********************************************//
	+ ObjectToString(oOwner) + "_"  //3
	//**********************************************//
	//              CASTERCLASS = 4
	//**********************************************//
	+ IntToString( HkGetSpellClass( oCaster ) ) + "_" //4
	//**********************************************//
	//              CASTERLEVEL = 5
	//**********************************************//
	 + IntToString( HkGetCasterLevel( oCaster, iClass ) ) + "_" //5
	//**********************************************//
	//              SPELLLEVEL = 6
	//**********************************************//
	+ IntToString( HkGetSpellLevel( iSpellId ) ) + "_"  //6
	//**********************************************//
	//              SPELLPOWER = 7
	//**********************************************//
	 + IntToString( iSpellPower ) + "_" // 7
	//**********************************************//
	//              METAMAGIC = 8
	//**********************************************//
	+ IntToString( HkGetMetaMagicFeat() ) + "_" //8
	//**********************************************//
	//              DESCRIPTOR = 9
	//**********************************************//
	+ IntToString( iDescriptor ) + "_" //9
	//**********************************************//
	//              SPELLSAVEDC = 10
	//**********************************************//
	+ IntToString(HkGetSpellSaveDC() ) + "_"  //10
	//**********************************************//
	//              SPELLRESISTDC = 11
	//**********************************************//
	+ IntToString(HkGetSpellPenetration(oCaster, iClass) ) + "_" //11
	//**********************************************//
	//              SPELLDISPELDC = 12
	//**********************************************//
	+ IntToString(HkDispelDC(oCaster, iClass ) ) + "_" // 12
	//**********************************************//
	//              SPELLSCHOOL = 13
	//**********************************************//
	+ IntToString( HkGetSpellSchool( oCaster ) ) + "_" // 13
	//**********************************************//
	//              ENDINGROUND = 14
	//**********************************************//
	+ IntToString( CSLEnviroGetExpirationRound( fDuration ) ) + "_" // 14
	//**********************************************//
	//              RANDOM = 14
	//**********************************************//
	+IntToString( CSL_SPELLCAST_SERIALID ); //15
	
	if ( iDestroyOldAOE )
	{
		// only need to keep track if we are destroying old AOE's
		SetLocalString( oCaster, "SC_AOE"+IntToString( HkGetSpellId() ), sAOETag );
	}
	
	// does the last AOE cast
	SetLocalString( oCaster, "SC_AOECurrentSpell", sAOETag );
	//int iDice = HkGetSpellPower(oCaster, 15);
	
	return sAOETag;
}

/**
* Applies a tag storing metadata about the current spell on the target for later use.
* @param oTarget The Target of the current spell
* @param oCaster The caster of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @param fDuration = -1.0f
* @see CSLGetAOETagString
* @see CSLGetAOETagInt
* @see CSLGetTargetTagInt
* @see CSLGetTargetTagString
* @replaces
*/
void HkApplyTargetTag( object oTarget, object oCaster = OBJECT_SELF, int iSpellId = -1, int iClass = 255 , float fDuration = -1.0f )
{
	if ( !GetIsObjectValid(oTarget) ) { return;} // Make sure it valid	
	if (DEBUGGING >= 4) { CSLDebug(  "HkApplyTargetTag: Target = "+GetName( oTarget )+" Spell="+IntToString( iSpellId ), oCaster ); }
	/*
	Effort to apply tags similar to the AOE tags useds, can comment out later those not being used, but attempting to implement more than are needed up front
	Will disable ones i don't need initially, since this is just being used for dispels right now
	*/
	
	//Prepatory information to get started
	
	if ( iSpellId == -1 )
	{
		iSpellId = HkGetSpellId();
	}
	
	if ( iSpellId == -1 )
	{
		// don't bother without a spellid of some sort, probably should put a debug message here since it indicates a bigger issue
		return; 
	}
	
	if ( iClass == 255 )
	{
		// this should try to figure out the correct class involved when there is an error
		iClass = HkGetSpellClass( oCaster );
	}
	
/*	
	// now lets save some things so we don't have to do a 2da lookup later, one time per use, and only on things that should last for a bit
	object oModule = GetModule();
	string sName = GetLocalString(oModule, "SC_SPELL_NAME_" + IntToString(iSpellId) );
	if ( sName == "" )
	{
		sName = Get2DAString("spells", "Label", iSpellId);
		string sSpellSchool = Get2DAString("spells", "School", iSpellId);
		
		sLevelInnate = Get2DAString("spells", "Innate", iSpellId);	
		SetLocalString(GetModule(), "SC_SPELL_NAME_" + IntToString(iSpellId), sName );

		SetLocalString(GetModule(), "SC_SPELL_LVLINNATE_" + IntToString(iSpellId), sLevelInnate );
		iSpellSchool = CSLGetSchoolByInitial(sSpellSchool);
		
		SetLocalInt(GetModule(), "SC_SPELL_SCHOOL_" + IntToString(iSpellId), iSpellSchool );	
	}
	
*/		
	//**********************************************//
	//              SPELLID = 2
	//**********************************************//
	SetLocalInt(oTarget, "SC_SPELLID", iSpellId); // last spell he was hit with
	string sPrefix = "SC_"+IntToString(iSpellId)+"_";
	
	SetLocalInt(oTarget, sPrefix+"SPELLID", iSpellId);
	
	//**********************************************//
	//              CASTERPOINTER = 3
	//**********************************************//
	SetLocalString(oTarget, sPrefix+"CASTERPOINTER", ObjectToString(oCaster) ); // use string here to match the other functions
	SetLocalString(oTarget, sPrefix+"CASTERTAG", GetName( oCaster ) ); // put name of caster here
	
	//**********************************************//
	//              CASTERCLASS = 4
	//**********************************************//
	SetLocalInt(oTarget, sPrefix+"CASTERCLASS", iClass);
	
	//**********************************************//
	//              CASTERLEVEL = 5
	//**********************************************//
	if ( iClass == 255 )
	{
		// move some of this logic into HkGetCasterLevel since it should be global and make it simpler.
		if ( CSLIsItemValid( GetSpellCastItem() ) )
		{
			SetLocalInt(oTarget, sPrefix+"CASTERLEVEL", HkGetItemCasterLevel( GetSpellCastItem(), oCaster ) ); // no class, so must be a feat, default to hit dice
		}
		else
		{
			SetLocalInt(oTarget, sPrefix+"CASTERLEVEL", GetHitDice( oCaster ) ); // no class, so must be a feat, default to hit dice
		}
	}
	else
	{
		SetLocalInt(oTarget, sPrefix+"CASTERLEVEL", HkGetCasterLevel( oCaster, iClass) );
	}
	
	//**********************************************//
	//              SPELLLEVEL = 6
	//**********************************************//
	SetLocalInt(oTarget, sPrefix+"SPELLLEVEL", HkGetSpellLevel( HkGetSpellId() ));
	
	//**********************************************//
	//              SPELLPOWER = 7
	//**********************************************//
	//SetLocalInt(oTarget, sPrefix+"SPELLPOWER",  iSpellPower  );
	 
	//**********************************************//
	//              METAMAGIC = 8
	//**********************************************//
	//SetLocalInt(oTarget, sPrefix+"METAMAGIC",  HkGetMetaMagicFeat()  );
	
	//**********************************************//
	//              DESCRIPTOR = 9
	//**********************************************//
	SetLocalInt(oTarget, sPrefix+"DESCRIPTOR", HkGetDescriptor()  );
	
	//**********************************************//
	//              SPELLSAVEDC = 10
	//**********************************************//
	//SetLocalInt(oTarget, sPrefix+"SPELLSAVEDC",  HkGetSpellSaveDC()  );
	
	//**********************************************//
	//              SPELLRESISTDC = 11
	//**********************************************//
	//SetLocalInt(oTarget, sPrefix+"SPELLRESISTDC", HkGetSpellPenetration(oCaster ) );
	
	//**********************************************//
	//              SPELLDISPELDC = 12
	//**********************************************//
	SetLocalInt(oTarget, sPrefix+"SPELLDISPELDC",  HkDispelDC(oCaster, HkGetSpellClass( oCaster ) ) );
	
	//**********************************************//
	//              SPELLSCHOOL = 13
	//**********************************************//
	SetLocalInt(oTarget, sPrefix+"SPELLSCHOOL", HkGetSpellSchool( oCaster ) );
	
	//**********************************************//
	//              ENDINGROUND = 14
	//**********************************************//
	SetLocalInt(oTarget, sPrefix+"ENDINGROUND",  CSLEnviroGetExpirationRound( fDuration ) );

	
}


void HkTransferTargetTag( object oFromTarget, object oToTarget, int iSpellId )
{
	// takes values from a given Target and transfers them to a second target
	string sPrefix = "SC_"+IntToString(iSpellId)+"_";	
	SetLocalInt(oToTarget, "SC_SPELLID", GetLocalInt(oFromTarget, "SC_SPELLID")); // last spell he was hit with	
	SetLocalInt(oToTarget, sPrefix+"SPELLID", GetLocalInt(oFromTarget, sPrefix+"SPELLID") );
	SetLocalString(oToTarget, sPrefix+"CASTERPOINTER", GetLocalString(oFromTarget, sPrefix+"CASTERPOINTER") );
	SetLocalString(oToTarget, sPrefix+"CASTERTAG", GetLocalString(oFromTarget, sPrefix+"CASTERTAG") );
	SetLocalInt(oToTarget, sPrefix+"CASTERCLASS", GetLocalInt(oFromTarget, sPrefix+"CASTERCLASS") );
	SetLocalInt(oToTarget, sPrefix+"CASTERLEVEL", GetLocalInt(oFromTarget, sPrefix+"CASTERLEVEL") );
	SetLocalInt(oToTarget, sPrefix+"SPELLLEVEL", GetLocalInt(oFromTarget, sPrefix+"SPELLLEVEL") );
	SetLocalInt(oToTarget, sPrefix+"DESCRIPTOR", GetLocalInt(oFromTarget, sPrefix+"DESCRIPTOR") );
	//SetLocalInt(oToTarget, sPrefix+"SPELLLEVEL", GetLocalInt(oFromTarget, sPrefix+"SPELLLEVEL") );
	SetLocalInt(oToTarget, sPrefix+"SPELLDISPELDC", GetLocalInt(oFromTarget, sPrefix+"SPELLDISPELDC") );
	SetLocalInt(oToTarget, sPrefix+"SPELLSCHOOL", GetLocalInt(oFromTarget, sPrefix+"SPELLSCHOOL") );
	SetLocalInt(oToTarget, sPrefix+"ENDINGROUND", GetLocalInt(oFromTarget, sPrefix+"ENDINGROUND") );
}

void HkDeleteTargetTag( object oTarget, int iSpellId )
{
	// takes values from a given Target and transfers them to a second target
	string sPrefix = "SC_"+IntToString(iSpellId)+"_";	
	DeleteLocalInt(oTarget, "SC_SPELLID");
	DeleteLocalInt(oTarget, sPrefix+"SPELLID");
	DeleteLocalString(oTarget, sPrefix+"CASTERPOINTER");
	DeleteLocalString(oTarget, sPrefix+"CASTERTAG");
	DeleteLocalInt(oTarget, sPrefix+"CASTERCLASS");
	DeleteLocalInt(oTarget, sPrefix+"CASTERLEVEL");
	//DeleteLocalInt(oTarget, sPrefix+"SPELLLEVEL");
	DeleteLocalInt(oTarget, sPrefix+"DESCRIPTOR");
	DeleteLocalInt(oTarget, sPrefix+"SPELLLEVEL");
	DeleteLocalInt(oTarget, sPrefix+"SPELLDISPELDC");
	DeleteLocalInt(oTarget, sPrefix+"SPELLSCHOOL");
	DeleteLocalInt(oTarget, sPrefix+"ENDINGROUND");
}




/**
* Part of Seeds dispel formula, implements diminishing returns as you rise in level
* @param iLevel = -1
* @return
* @see
* @replaces
*/
// * This returns a weighted level based on caster level where the number goes up less as the caster level goes up
int HkGetCreatorLevelSkew( int iLevel = -1 )
{
	//return FloatToInt( pow(-0.0859f * iLevel, 2) + ( 5.0047f * iLevel ) + 1.67f );
	return CSLQuadratic( iLevel, -0.0859f, 5.0047f, 1.67f ); // results in similar math to what is below
	
	/*
	const int SC_DISPEL_LEVELSKEW1TO5 = 5;
	const int SC_DISPEL_LEVELSKEW6TO10 = 4;
	const int SC_DISPEL_LEVELSKEW11TO15 = 2;
	const int SC_DISPEL_LEVELSKEW16TO20 = 2;
	const int SC_DISPEL_LEVELSKEW21TO25 = 1;
	const int SC_DISPEL_LEVELSKEW26TO30 = 1;
	const int SC_DISPEL_LEVELSKEW31TO35 = 0;
	const int SC_DISPEL_LEVELSKEW36TO40 = 0;
	const int SC_DISPEL_LEVELSKEW40PLUS = 0;

	int iResult = 0;
	
	if ( iLevel <= 5 )
	{
		iResult += iLevel * SC_DISPEL_LEVELSKEW1TO5;
	}
	else if ( iLevel <= 10 )
	{
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += (iLevel-5) * SC_DISPEL_LEVELSKEW6TO10;
	
	}
	else if ( iLevel <= 15 )
	{
	
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += (iLevel-10) * SC_DISPEL_LEVELSKEW11TO15;
	}
	else if ( iLevel <= 20 )
	{
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW11TO15 );
		iResult += (iLevel-15) * SC_DISPEL_LEVELSKEW16TO20;
	
	}
	else if ( iLevel <= 25 )
	{
	
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW11TO15 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW16TO20 );
		iResult += (iLevel-20) * SC_DISPEL_LEVELSKEW21TO25;
	}
	else if ( iLevel <= 30 )
	{
	
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW11TO15 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW16TO20 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW21TO25 );
		iResult += (iLevel-25) * SC_DISPEL_LEVELSKEW26TO30;
	}
	else if ( iLevel <= 35 )
	{
	
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW11TO15 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW16TO20 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW21TO25 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW26TO30 );
		iResult += (iLevel-30) * SC_DISPEL_LEVELSKEW31TO35;
	}
	else if ( iLevel <= 40 )
	{
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW11TO15 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW16TO20 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW21TO25 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW26TO30 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW31TO35 );
		iResult += (iLevel-35) * SC_DISPEL_LEVELSKEW36TO40;
	
	}
	else if ( iLevel > 40 )
	{
		iResult += ( 5 * SC_DISPEL_LEVELSKEW1TO5 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW6TO10 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW11TO15 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW16TO20 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW21TO25 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW26TO30 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW31TO35 );
		iResult += ( 5 * SC_DISPEL_LEVELSKEW36TO40 );
		iResult += (iLevel-40) * SC_DISPEL_LEVELSKEW40PLUS;
	}
	
	return iResult;
	*/
}




/**
* Helper function to get the correct cache storage row which has information on the given class
* @param oChar The character to get information from
* @param iClass The CLASS_TYPE_* constant with the current casters class, CLASS_TYPE_NONE if unknown, CLASS_TYPE_RACIAL if it's going to use the race to determine levels
* @return The row the cached information is stored in for the given class
* @see
* @replaces
*/
int HkGetClassRowFromCache( object oChar, int iClass )
{
	if ( !GetIsObjectValid(oChar) ) { return 0;} // make sure it's only run on a valid object
	
	//if ( GetAssociateType(oChar)==ASSOCIATE_TYPE_FAMILIAR )
	//{
	//	oChar = GetMaster( oChar );
	//}
	
	//SendMessageToPC( OBJECT_SELF, GetName(oChar)+" with Class: "+IntToString( iClass )+ " with stored class row of " +IntToString( GetLocalInt(oChar, "SC_Row"+IntToString(iClass) ) ) );
	// assuming we alread have the vars set up on the character
	// this should not be called by inside functions
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass();
	}
	return GetLocalInt(oChar, "SC_Row"+IntToString(iClass) );
}


int HkGetScaledDuration(int nActualDuration, object oTarget)
{

	int nDiff = GetGameDifficulty();
	int nNew = nActualDuration;
	if(GetIsPC(oTarget) && nActualDuration > 3)
	{
			if(nDiff == GAME_DIFFICULTY_VERY_EASY || nDiff == GAME_DIFFICULTY_EASY)
			{
				nNew = nActualDuration / 4;
			}
			else if(nDiff == GAME_DIFFICULTY_NORMAL)
			{
				nNew = nActualDuration / 2;
			}
			if(nNew == 0)
			{
				nNew = 1;
			}
	}
	return nNew;
}


effect HkGetScaledEffect(effect eStandard, object oTarget)
{
	int nDiff = GetGameDifficulty();
	effect eNew = eStandard;
	object oMaster = GetMaster(oTarget);
	if(GetIsPC(oTarget) || (GetIsObjectValid(oMaster) && GetIsPC(oMaster)) || GetLocalInt(oTarget, "BOSS"))
	{
			if(GetEffectType(eStandard) == EFFECT_TYPE_FRIGHTENED && nDiff == GAME_DIFFICULTY_VERY_EASY)
			{
				eNew = EffectAttackDecrease(-2);
				return eNew;
			}
			if(GetEffectType(eStandard) == EFFECT_TYPE_FRIGHTENED && nDiff == GAME_DIFFICULTY_EASY)
			{
				eNew = EffectAttackDecrease(-4);
				return eNew;
			}
			if(nDiff == GAME_DIFFICULTY_VERY_EASY &&
				(GetEffectType(eStandard) == EFFECT_TYPE_PARALYZE ||
				GetEffectType(eStandard) == EFFECT_TYPE_STUNNED ||
				GetEffectType(eStandard) == EFFECT_TYPE_CONFUSED))
			{
				eNew = EffectDazed();
				return eNew;
			}
			else if(GetEffectType(eStandard) == EFFECT_TYPE_CHARMED || ( GetEffectType(eStandard) == EFFECT_TYPE_DOMINATED && !GetLocalInt( oTarget, "SCSummon" ) ) )
			{
				eNew = EffectDazed();
				return eNew;
			}
	}
	return eNew;
}


void HkCacheAIProperties( object oChar = OBJECT_SELF, int iForce = FALSE )
{
	if ( !GetIsObjectValid(oChar) ) { return;} // make sure it's only run on a valid object
	
	
	int iHD = GetHitDice(oChar);
	
	if ( iForce == FALSE && iHD == GetLocalInt( oChar ,"SCAI_HitDice") )
	{
		// we already ran this, don't waste horse power, rerun on rest and other events to keep fresh
		return;
	}
	SCCacheStats(oChar);
	SetLocalInt(oChar, "SCAI_HitDice", iHD );
	SetLocalInt(oChar, "SCAI_sSneakDice", CSLGetTotalSneakDice(OBJECT_INVALID, oChar ) );
	
	int iBestCastingClass = HkGetBestCasterClass( oChar );
	SetLocalInt(oChar, "SCAI_sCasterClass", iBestCastingClass );
	SetLocalInt(oChar, "SCAI_sCasterPower", HkGetSpellPower( oChar, 60,  iBestCastingClass ) );
	SetLocalInt(oChar, "SCAI_sCasterSaveDC", HkGetSpellSaveDC( oChar, OBJECT_INVALID, -1, iBestCastingClass ) );
	SetLocalInt(oChar, "SCAI_sSpellPenetration", HkGetSpellPenetration( oChar, iBestCastingClass ) );
	
	SetLocalInt(oChar, "SCAI_sSneakDice", CSLGetTotalSneakDice(OBJECT_INVALID, oChar ) );
	
	
}



// FAST BUFF SELF
void HkAutoBuff( object oTarget = OBJECT_SELF, object oCaster = OBJECT_SELF, int bInstantSpell=FALSE, int iMaxEffects = 999, int bSummonSpell=FALSE, int bCheat=FALSE )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "HkAutoBuff Start", GetFirstPC() ); }
    /*
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    if(GetIsObjectValid(oPC) && GetDistanceToObject(oPC) <= fDistance)
    {
        if( !SCGetIsFighting(oTarget) )
        {
        */
        	//SCAIInitCachedCreatureInformation(oCaster);
        	//HkCacheAIProperties( oCaster );
        	CSLCacheCreatureItemInformation( oTarget );
        	
        	HkCacheAIProperties( oCaster );
        	
        	// don't want to use the actual caching stats code, this will try to use that value and if not there will use hit dice, it's not that important really more of a gravy feature.
        	int iSpellPower = GetLocalInt(oCaster, "SC_iCasterLevels" );
        	
        	
			AssignCommand(oTarget, ClearAllActions() );
			int bHasShades = FALSE;
			int bHasShadowShield = FALSE;
			
			if ( GetHasSpellEffect(SPELL_SHADES, oTarget) )
			{
				int bHasShades = TRUE;
			}
			
			if ( GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget) )
			{
				int bHasShadowShield = TRUE;
			}
			
			
			
			//Combat Protections
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHADES, SPELL_GREATER_VISAGE_OF_THE_DEITY, SPELL_PREMONITION, SPELL_GREATER_STONESKIN, SPELL_Nixies_Grace, SPELL_Visage_Deity, SPELL_STONESKIN, SPELL_PROTECTION_FROM_ARROWS  ) )
			{
				if( GetHasSpell(SPELL_SHADES, oCaster))
				{
					bHasShades = TRUE;
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SHADES_TARGET_CASTER, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_GREATER_VISAGE_OF_THE_DEITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_VISAGE_OF_THE_DEITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if( GetHasSpell(SPELL_PREMONITION, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_PREMONITION, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if( GetHasSpell(SPELL_GREATER_STONESKIN, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_STONESKIN, oTarget, METAMAGIC_NONE, bCheat, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_Nixies_Grace, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_Nixies_Grace, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_Visage_Deity, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_Visage_Deity, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_STONESKIN, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_STONESKIN, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_PROTECTION_FROM_ARROWS, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ARROWS, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			
			//Visage Protections
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHADOW_SHIELD, SPELL_ETHEREAL_VISAGE, SPELL_GHOSTLY_VISAGE ) )
			{
				if(GetHasSpell(SPELL_SHADOW_SHIELD, oCaster))
				{
					bHasShadowShield = TRUE;
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SHADOW_SHIELD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ETHEREAL_VISAGE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ETHEREAL_VISAGE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_GHOSTLY_VISAGE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GHOSTLY_VISAGE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_FREEDOM_OF_MOVEMENT, oCaster) && !GetHasSpellEffect(SPELL_FREEDOM_OF_MOVEMENT, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_FREEDOM_OF_MOVEMENT, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DEATH_WARD, SPELL_MASS_DEATH_WARD ) )
			{
				if(GetHasSpell(SPELL_DEATH_WARD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_DEATH_WARD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_MASS_DEATH_WARD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MASS_DEATH_WARD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}

			
			
			if ( iMaxEffects < 1 ) { return; }
			if( !bHasShades && GetHasSpell(SPELL_PROTECTION_FROM_SPELLS, oCaster) && !GetHasSpellEffect(SPELL_PROTECTION_FROM_SPELLS, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_PROTECTION_FROM_SPELLS, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			// displacement miss percentage and invisibility
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_GREATER_INVISIBILITY, SPELL_DISPLACEMENT, SPELL_ENTROPIC_SHIELD, SPELL_INVISIBILITY ) )
			{
				if(GetHasSpell(SPELL_GREATER_INVISIBILITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_INVISIBILITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_DISPLACEMENT, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_DISPLACEMENT, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ENTROPIC_SHIELD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENTROPIC_SHIELD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_INVISIBILITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_INVISIBILITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			// Energy Immunity
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_ENERGY_IMMUNITY, SPELL_ENERGY_IMMUNITY_ACID, SPELL_ENERGY_IMMUNITY_SONIC, SPELL_ENERGY_IMMUNITY_COLD,SPELL_ENERGY_IMMUNITY_ELECTRICAL, SPELL_ENERGY_IMMUNITY_FIRE, SPELLR_ENERGY_BUFFER, SPELL_PROTECTION_FROM_ENERGY, SPELL_RESIST_ENERGY, SPELL_ENDURE_ELEMENTS ) )
			{
				if(GetHasSpell(SPELL_ENERGY_IMMUNITY_ACID, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENERGY_IMMUNITY_ACID, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ENERGY_IMMUNITY_SONIC, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENERGY_IMMUNITY_SONIC, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ENERGY_IMMUNITY_COLD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENERGY_IMMUNITY_COLD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ENERGY_IMMUNITY_FIRE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENERGY_IMMUNITY_FIRE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELLR_ENERGY_BUFFER, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_ENERGY_BUFFER, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_PROTECTION_FROM_ENERGY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ENERGY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_RESIST_ENERGY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RESIST_ENERGY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_ENDURE_ELEMENTS, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ENDURE_ELEMENTS, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			
			// detection
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_TRUE_SEEING, SPELL_SEE_INVISIBILITY ) )
			{
				if(GetHasSpell(SPELL_TRUE_SEEING, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_TRUE_SEEING, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_SEE_INVISIBILITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SEE_INVISIBILITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_REGENERATE, oCaster) && !GetHasSpellEffect(SPELL_REGENERATE, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_REGENERATE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_WATER_BREATHING, oCaster) && !GetHasSpellEffect(SPELL_WATER_BREATHING, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_WATER_BREATHING, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_MIRROR_IMAGE, oCaster) && !GetHasSpellEffect(SPELL_MIRROR_IMAGE, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MIRROR_IMAGE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_JOYFUL_NOISE, oCaster) && !GetHasSpellEffect(SPELL_JOYFUL_NOISE, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_JOYFUL_NOISE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_SPELL_RESISTANCE, oCaster) && !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SPELL_RESISTANCE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_NIGHTSHIELD, oCaster) && !GetHasSpellEffect(SPELL_NIGHTSHIELD, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_NIGHTSHIELD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_RESISTANCE, oCaster) && !GetHasSpellEffect(SPELL_RESISTANCE, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RESISTANCE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_BATTLETIDE, oCaster) && !GetHasSpellEffect(SPELL_BATTLETIDE, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_BATTLETIDE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			
			
			// fear immunity aura
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_Cloak_Bravery, SPELL_AURAOFGLORY ) )
			if(GetHasSpell(SPELL_Cloak_Bravery, oCaster))
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_Cloak_Bravery, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			else if(GetHasSpell(SPELL_AURAOFGLORY, oCaster))
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_AURAOFGLORY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELLR_GREATER_SPELL_IMMUNITY, SPELLR_SPELL_IMMUNITY ) )
			{
				if(GetHasSpell(SPELLR_GREATER_SPELL_IMMUNITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_GREATER_SPELL_IMMUNITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELLR_SPELL_IMMUNITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_SPELL_IMMUNITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			if ( iMaxEffects < 1 ) { return; }
			if(GetHasSpell(SPELL_BLESS, oCaster) && !GetHasSpellEffect(SPELL_BLESS, oTarget) )
			{
				AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_BLESS, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				iMaxEffects--;
			}
			
			// Body Spells
			
			// natural ( shades gives +5, note elephant hide probably trumps all of these
			if ( iMaxEffects < 1 ) { return; }
			if ( !bHasShades && !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_BARKSKIN, SPELL_SPIDERSKIN, SPELL_RIGHTEOUS_MIGHT ) )
			{
				if(GetHasSpell(SPELL_BARKSKIN, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_BARKSKIN, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_SPIDERSKIN, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SPIDERSKIN, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_RIGHTEOUS_MIGHT, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RIGHTEOUS_MIGHT, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}	
			}
			
			// enhancement
			/*
			Improved Mage Armor: +6 AC ( nw_s0_impmagarm.NSS )
			Mage Armor: +4 AC ( nw_s0_magearm.NSS )
			Magic Vestments: +1/4 caster levels (max +5)
			*/
			
			// shield 
			/*
			Shield: +4 Shield
			Shades: +4 Shield ( nw_s0_shadescaster.NSS )
			Magic Vestments: +1/4 caster levels (max +5)
			*/
			
			// deflection
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHIELD_OF_FAITH, SPELL_Sirines_Grace, SPELL_PROTECTION_FROM_EVIL ) )
			{
				if(GetHasSpell(SPELL_SHIELD_OF_FAITH, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SHIELD_OF_FAITH, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_Sirines_Grace, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_Sirines_Grace, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_PROTECTION_FROM_EVIL, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_PROTECTION_FROM_EVIL, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			
			// Shielding
			if ( iMaxEffects < 1 ) { return; }
			int iACShield = GetLocalInt(oTarget, "SC_ITEM_AC_SHIELD" );
			if ( iACShield < 5 ) // 5 is max
			{
				if ( !bHasShades && !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHIELDIMPROVED, SPELL_SHIELD ) )
				{
					if(GetHasSpell(SPELL_SHIELDIMPROVED, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SHIELDIMPROVED, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if(GetHasSpell(SPELL_SHIELD, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SHIELD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( GetHasSpell(SPELL_MAGIC_VESTMENT, oCaster) )
					{
						object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
						int itemType = GetBaseItemType(oShield);
						if ((itemType == BASE_ITEM_TOWERSHIELD) || (itemType == BASE_ITEM_LARGESHIELD) || (itemType == BASE_ITEM_SMALLSHIELD))
						{
							AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_VESTMENT, oShield, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
							iMaxEffects--;
						}
					}
				}
			}
			
			
			// Armor AC
			if ( iMaxEffects < 1 ) { return; }
			int iACArmor = GetLocalInt(oTarget, "SC_ITEM_AC_ARMOR" );
			if ( iACArmor < 5 && !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_IMPROVED_MAGE_ARMOR, SPELL_MAGE_ARMOR, SPELL_MSC_MAGE_ARMOR, SPELL_SHADOW_CONJURATION_MAGE_ARMOR, SPELL_MAGIC_VESTMENT  ) )
			{
				if(GetHasSpell(SPELL_IMPROVED_MAGE_ARMOR, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_IMPROVED_MAGE_ARMOR, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_MAGE_ARMOR, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_MSC_MAGE_ARMOR, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MSC_MAGE_ARMOR, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_SHADOW_CONJURATION_MAGE_ARMOR, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SHADOW_CONJURATION_MAGE_ARMOR, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_MAGIC_VESTMENT, oCaster))
				{
					object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
					if ( GetBaseItemType(oArmor) == BASE_ITEM_ARMOR )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_VESTMENT, oArmor, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
				}
			}
			
			
			
			
			
			//Mantle Protections
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_GREATER_SPELL_MANTLE, SPELL_SPELL_MANTLE, SPELLR_SPELL_TURNING, SPELL_LESSER_SPELL_MANTLE, SPELL_LEAST_SPELL_MANTLE ) )
			{
				if(GetHasSpell(SPELL_GREATER_SPELL_MANTLE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_SPELL_MANTLE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_SPELL_MANTLE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELLR_SPELL_TURNING, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_SPELL_TURNING, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_LESSER_SPELL_MANTLE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_LESSER_SPELL_MANTLE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_LEAST_SPELL_MANTLE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_LEAST_SPELL_MANTLE, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			// Globes
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_GLOBE_OF_INVULNERABILITY, SPELL_LESSER_GLOBE_OF_INVULNERABILITY ) )
			{
				if(GetHasSpell(SPELL_GLOBE_OF_INVULNERABILITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GLOBE_OF_INVULNERABILITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			//Misc Protections
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_ELEMENTAL_SHIELD, SPELLR_MESTILS_ACID_SHEATH, SPELLR_WOUNDING_WHISPERS, SPELL_DEATH_ARMOR ) )
			{
				if(GetHasSpell(SPELL_ELEMENTAL_SHIELD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if (GetHasSpell(SPELLR_MESTILS_ACID_SHEATH, oCaster) )
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_MESTILS_ACID_SHEATH, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELLR_WOUNDING_WHISPERS, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_WOUNDING_WHISPERS, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if (GetHasSpell(SPELL_DEATH_ARMOR, oCaster) )
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
			
			
			//Mental Protections
			if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_MIND_BLANK, SPELL_LESSER_MIND_BLANK, SPELL_HOLY_AURA, SPELL_CLARITY  ) )
			{
				if(GetHasSpell(SPELL_MIND_BLANK, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MIND_BLANK, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_LESSER_MIND_BLANK, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_LESSER_MIND_BLANK, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_HOLY_AURA, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_HOLY_AURA, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_CLARITY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_CLARITY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			/*
			
			*/
			
			// weapon buffs
			if ( iMaxEffects < 1 ) { return; }
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			if ( GetIsObjectValid(oWeapon) )
			{
				int iEnhancementBonus = CSLGetWeaponEnhancementBonus(oWeapon);
				
				if ( CSLItemGetIsRangedWeapon(oWeapon) )
				{
					if ( iMaxEffects < 1 ) { return; }
					if(  GetHasSpell(SPELL_GREATER_MAGIC_WEAPON, oCaster) && iEnhancementBonus < HkCapAB( iSpellPower / 4 ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( iEnhancementBonus < 1 && GetHasSpell(SPELL_MAGIC_WEAPON, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
				}
				else if ( CSLItemGetIsMeleeWeapon(oWeapon) )
				{
					if ( iMaxEffects < 1 ) { return; }
					if(GetHasSpell(SPELLR_DARKFIRE, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_DARKFIRE, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					
					if ( iMaxEffects < 1 ) { return; }
					if(GetHasSpell(SPELL_KEEN_EDGE, oCaster) && CSLItemGetIsSlashingWeapon( oWeapon ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_KEEN_EDGE, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( GetHasSpell(SPELL_WEAPON_OF_IMPACT, oCaster) && CSLItemGetIsBludgeoningWeapon( oWeapon ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_WEAPON_OF_IMPACT, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					
					
					if ( iMaxEffects < 1 ) { return; }
					if( GetBaseItemType(oWeapon) == BASE_ITEM_QUARTERSTAFF && GetHasSpell(SPELL_BLACKSTAFF, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_BLACKSTAFF, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					
					if ( iMaxEffects < 1 ) { return; }
					if( GetHasSpell(SPELL_GREATER_MAGIC_WEAPON, oCaster) && iEnhancementBonus < HkCapAB( iSpellPower / 4 ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( iEnhancementBonus < 1 && GetHasSpell(SPELL_MAGIC_WEAPON, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
				}
			}
			
			if ( iMaxEffects < 1 ) { return; }
			oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
			if ( GetIsObjectValid(oWeapon) )
			{
				int iEnhancementBonus = CSLGetWeaponEnhancementBonus(oWeapon);
				
				if ( CSLItemGetIsRangedWeapon(oWeapon) )
				{
					if ( iMaxEffects < 1 ) { return; }
					if(  GetHasSpell(SPELL_GREATER_MAGIC_WEAPON, oCaster) && iEnhancementBonus < HkCapAB( iSpellPower / 4 ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( iEnhancementBonus < 1 && GetHasSpell(SPELL_MAGIC_WEAPON, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
				}
				else if ( CSLItemGetIsMeleeWeapon(oWeapon) )
				{
					if ( iMaxEffects < 1 ) { return; }
					if(GetHasSpell(SPELLR_DARKFIRE, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELLR_DARKFIRE, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					
					if ( iMaxEffects < 1 ) { return; }
					if(GetHasSpell(SPELL_KEEN_EDGE, oCaster) && CSLItemGetIsSlashingWeapon( oWeapon ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_KEEN_EDGE, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( GetHasSpell(SPELL_WEAPON_OF_IMPACT, oCaster) && CSLItemGetIsBludgeoningWeapon( oWeapon ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_WEAPON_OF_IMPACT, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					
					
					if ( iMaxEffects < 1 ) { return; }
					if( GetBaseItemType(oWeapon) == BASE_ITEM_QUARTERSTAFF && GetHasSpell(SPELL_BLACKSTAFF, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_BLACKSTAFF, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					
					if ( iMaxEffects < 1 ) { return; }
					if( GetHasSpell(SPELL_GREATER_MAGIC_WEAPON, oCaster) && iEnhancementBonus < HkCapAB( iSpellPower / 4 ) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_GREATER_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
					else if( iEnhancementBonus < 1 && GetHasSpell(SPELL_MAGIC_WEAPON, oCaster))
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_WEAPON, oWeapon, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
						iMaxEffects--;
					}
				}
			}
			
			//Summon Ally
			// TODO add these epic feats as well!!!!
			//FEAT_EPIC_SPELL_MUMMY_DUST
			// FEAT_EPIC_SPELL_DRAGON_KNIGHT
			//SPELL_EPIC_DRAGON_KNIGHT
			// SPELL_EPIC_MUMMY_DUST
			
			// need to make sure we don't already have a summon here.
			if ( iMaxEffects < 1 ) { return; }
			if ( bSummonSpell == TRUE  && 1 == 2 )
			{
				if ( GetHasSpell(SPELL_GATE, oCaster) && GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oCaster) || GetHasSpell(SPELL_PROTECTION_FROM_EVIL, oCaster) )
				{
					if ( !GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oCaster) )
					{
						AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_PROTECTION_FROM_EVIL, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					}
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_GATE, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELLABILITY_SUMMON_PLANETAR, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLABILITY_SUMMON_PLANETAR, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELLR_BLACK_BLADE_OF_DISASTER, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLR_BLACK_BLADE_OF_DISASTER, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_BAATEZU, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_BAATEZU, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_ELEMENTAL_SWARM, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_ELEMENTAL_SWARM, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_IX, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IX, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_CREATE_GREATER_UNDEAD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_CREATE_GREATER_UNDEAD, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_GREATER_PLANAR_BINDING, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_GREATER_PLANAR_BINDING, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_VIII, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VIII, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_MORDENKAINENS_SWORD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_MORDENKAINENS_SWORD, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_VII, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VII, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_CREATE_UNDEAD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_CREATE_UNDEAD, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_PLANAR_BINDING, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_PLANAR_BINDING, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_VI, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VI, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_V, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_V, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELLABILITY_SUMMON_SLAAD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLABILITY_SUMMON_SLAAD, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELLABILITY_SUMMON_TANARRI, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLABILITY_SUMMON_TANARRI, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELLABILITY_SUMMON_MEPHIT, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLABILITY_SUMMON_MEPHIT, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELLABILITY_SUMMON_CELESTIAL, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLABILITY_SUMMON_CELESTIAL, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_ANIMATE_DEAD, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_ANIMATE_DEAD, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_IV, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IV, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_III, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_III, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_II, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_II, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell( SPELLR_SHELGARNS_PERSISTENT_BLADE, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELLR_SHELGARNS_PERSISTENT_BLADE, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				else if(GetHasSpell(SPELL_SUMMON_CREATURE_I, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_I, GetLocation(oTarget), METAMAGIC_NONE, bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
				}
				/*
				SPELL_LIVEOAK
				SPELL_PHANTOMBEAR
				SPELL_PHANTOMWOLF
				*/
				
				
				
            }
            
            
            if ( iMaxEffects < 1 ) { return; }
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
			{
				if(GetHasSpell(SPELL_IRON_BODY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_IRON_BODY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
				else if(GetHasSpell(SPELL_STONE_BODY, oCaster))
				{
					AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_STONE_BODY, oTarget, METAMAGIC_NONE, bCheat, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstantSpell) );
					iMaxEffects--;
				}
			}
			
            /*
            return TRUE;
        }
    }
    return FALSE;
    */
}