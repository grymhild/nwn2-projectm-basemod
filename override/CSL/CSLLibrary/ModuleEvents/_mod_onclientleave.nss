#include "_CSLCore_Nwnx"
#include "seed_db_inc"
//#include "_SCInclude_Chat"
//#include "_SCInclude_Saveuses"
#include "_SCInclude_Events"
#include "_SCInclude_Necromancy"
#include "_SCInclude_Playerlist"

void main()
{
   //DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   object oPC = GetExitingObject();
   
   CSLNWNX_SQLExecDirect("insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" +CSLDelimList(CSLInQs(SDB_GetSEID()), CSLInQs(SDB_GetPLID(oPC)), CSLInQs("O"), CSLInQs(CSLGetMyName(oPC)+" ("+CSLGetMyPlayerName(oPC)+") has logged out"), "0") + ")");
	
	CSLPlayerList_ClientExit(oPC);
	
   SDB_OnClientExit(oPC);
   
   //Speech_OnClientExit(oPC);
      
   SCDestroyUndead(oPC, TRUE); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
   
	if ( GetLocalInt( oPC, "CSL_INCIRCLE" )  )
	{
		ExecuteScript("TG_KingCircle_OnCircleLost", oPC );
	}
   //StoreUses(oPC);
}