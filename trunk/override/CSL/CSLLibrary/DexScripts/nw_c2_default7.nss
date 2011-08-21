#include "give_custom_exp" // note this is a custom script for handling dex specific xp rewards
#include "_SCInclude_Encounter"

#include "_HkSpell"
#include "_SCInclude_Evocation"
#include "_SCInclude_Necromancy"
#include "_SCInclude_Summon"
#include "_SCInclude_Events"


void main()
{
	object oDead = OBJECT_SELF;
	//string sDeathScript = GetLocalString(OBJECT_SELF, "DeathScript");
	if ( GetTag(oDead) == "dexc_bombbunny")
	{
		//ActionCastSpellAtLocation(SPELL_FIREBALL, GetLocation( oDead )	
		//ExecuteScript("cr_bunnybomb", oDead);
		//SendMessageToAllDMs("Bunny Died");
		//ActionCastSpellAtLocation(SPELL_GREATER_FIREBURST, GetLocation(oDead), METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE);
		effect e2 = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oDead);
		SCEffectFireBall( GetLocation( oDead ), 5, DAMAGE_TYPE_FIRE, oDead );
	}
	//if (DEBUGGING >= 6) { CSLDebug(  "Death: 1", GetLastKiller() ); }
	//
   DecSpawnCount(oDead);
   //if (DEBUGGING >= 6) { CSLDebug(  "Death: 2", GetLastKiller() ); }
   if (CSLStringStartsWith(GetTag(oDead), "PLID_"))
   {
      //CSLDontDropGear(oDead, TRUE); 
      if (!GetLocalInt(oDead, "DONTDROP")) SDB_LogMsg("DONTDROP", "Deleted inventory on " + GetTag(oDead));
   }   
	//if (DEBUGGING >= 6) { CSLDebug(  "Death: 3", GetLastKiller() ); }
   if ( !GetIsPC(oDead) )
	{
		if ( GetLocalInt( GetArea(oDead), "SC_AREABASH" ) == 1  )
		{
			CSLDontDropGear(oDead, TRUE);
		}
	}
	//if (DEBUGGING >= 6) { CSLDebug(  "Death: 4", GetLastKiller() ); }
	
	
   object oKiller = GetLastKiller();
   DEXRewardXP(oKiller, oDead);
	//if (DEBUGGING >= 6) { CSLDebug(  "Death: 5", GetLastKiller() ); }
	// Call to allies to let them know we're dead
	SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);
	//if (DEBUGGING >= 6) { CSLDebug(  "Death: 6", GetLastKiller() ); }
	//Shout Attack my target, only works with the On Spawn In setup
	SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	//if (DEBUGGING >= 6) { CSLDebug(  "Death: 7", GetLastKiller() ); }
	
	HkCounterSpellRemoveEffect( oDead );

	if ( GetLocalInt( oDead, "SCSummon") != 0 ) 
	{
		SetLocalInt( oDead, "DIED", TRUE );
		ExecuteScript("_mod_onunsummoncreature", oDead );
	}
	
	/*	
	if ( GetLocalInt( oDead, "CSL_INCIRCLE" ) 
	{
		ExecuteScript("TG_KingCircle_OnCircleLost", oDead );
	}
	*/
	
	
	if ( GetLocalInt( oDead, "SCLastSummonSpell") != 0 )
	{
	   DelayCommand(1.0f, SCDestroyUndead(oDead, TRUE) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
	   DelayCommand(0.5f, SCSummonsExecuteScript(oDead) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
	}
	
	string sDeathScript = GetLocalString(oDead, "ondeath_script");
	if (sDeathScript != "")
	{
		ExecuteScript(sDeathScript, oDead);
	}
}