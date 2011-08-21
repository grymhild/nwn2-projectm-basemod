#include "seed_db_inc"
#include "_SCInclude_faction"

//#include "_SCUtility"
#include "_SCInclude_Graves"
#include "_SCInclude_Arena"
//#include "inc_undead"
#include "_SCInclude_Necromancy"
//#include "m_inc_fight"
//#include "m_inc_itemprop"
#include "_SCInclude_Events"
// void trainerDeath( object oPlayer );



void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oKilled = GetLastPlayerDied();
	object oKiller = CSLGetKiller(oKilled);
	object oArea = GetArea(oKilled);
	
	//if ( GetIsSinglePlayer() )
	//{
	//	trainerDeath( oKilled );
	//	return;
	//}
	


	if ( SDB_GetARID(oArea)=="1" && !CSLGetIsDM( oKiller ) )  // LOFTENWOOD DEATH
	{ 
		SCRaise( oKilled );
		if ( oKiller==oKilled || SDB_GetMOID(oKiller)=="517" )
		{
			return;
		}
		object oPC = GetLocalObject(oKiller, "DOMINATED");
		if ( oPC != OBJECT_INVALID )
		{
			AssignCommand(oKilled, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
		}
		AssignCommand(oKilled, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oKiller));
	}   
	
	// EXPLODE THEM
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L.sef"), oKilled);
	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1.sef"), oKilled));
	
	SCDestroyUndead(oKilled); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
	
	if ( SCGetIsInArena(oKilled) )
	{ // NO PENALTY
		SCShowArenaDeathScreen(oKilled);
		return;
	}
	
	if ( GetLocalInt( oArea, "SC_AREABASH" ) == 1 )
	{ // NO PENALTY
		DelayCommand( 60.0f, SCRaise(oKilled) );
		SCShowBashDeathScreen(oKilled);
		return;
	}
	
	
	if ( GetLocalInt( oKilled, "CSL_INCIRCLE" ) )
	{
		SetLocalObject(oKilled, "CIRCLELASTKILLER", oKiller);
		ExecuteScript("TG_KingCircle_OnCircleLost", oKilled );
	}
	
	int nDeaths = SDB_OnPCDeath(oKilled, oKiller); // FUNCTION RECORDS THE DEATH AND RETURN THE NUMBER OF TIMES THEY DIED
	SDB_FactionOnPCDeath(oKilled, oKiller); // RECORD THE FACTION KILL
	
	SCKillShoutAndSpreeBonus(oKiller, oKilled); // SHOUTS AND SPREE BONUSES
	SetLocalObject(oKilled, "LASTKILLER", oKiller); // SAVE IT FOR LATER
	DropDeathGold(oKiller, oKilled);
	
	DelayCommand(2.5f, ShowDeathScreen(oKilled));
	
	if (d4()==1) SCStealItem(oKiller, oKilled);
	
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann201", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann202", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann203", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann204", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann205", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann206", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann207", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann208", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann209", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann210", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann211", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann212", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann213", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann214", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann215", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann216", oKilled, TRUE ) );

}