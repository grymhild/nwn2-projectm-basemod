//::///////////////////////////////////////////////
//:: Generic On Pressed Respawn Button
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////


#include "_SCInclude_Graves"
#include "_SCInclude_Arena"
#include "_SCInclude_faction"

void main()
{
	//SCSpeakIt(OBJECT_SELF, "respawning");
	object oPC = OBJECT_SELF;
	if ( !GetIsDead(oPC) )
	{
		CloseGUIScreen(oPC, GUI_DEATH);
		CloseGUIScreen( oPC, GUI_DEATH_HIDDEN );
		return;
	}
	object oModule = GetModule();
	CSLRemoveAllNegativeEffects(oPC); // need to review this but it's what it was doing before
	CloseGUIScreen(oPC, GUI_DEATH);
	CloseGUIScreen( oPC, GUI_DEATH_HIDDEN );
	
	if (GetObjectByTag("DROW_ARENA")!=OBJECT_INVALID)
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
		CloseGUIScreen( oPC, GUI_DEATH );
   		CloseGUIScreen( oPC, GUI_DEATH_HIDDEN );
		return;   
	}
	
	SDB_FactionOnPCRespawn(oPC);
	if (SCGetIsInArena(oPC))   // NO PENALTY
	{
		DelayCommand(2.0, SCPortToArenaStart(oPC)); // MOVE TO ETHEREAL
		return;
	}
	
	MakeGrave(oPC); // CREATES A GRAVE AND GIVES THE XP HIT
	DelayCommand(2.0, PortToEthereal(oPC)); // MOVE TO ETHEREAL
	int iGhostCount = CSLGetMax( 1, GetLocalInt(oModule, "GHOSTCOUNT") );
	int i = (GetLocalInt(oModule, "GHOSTCURRENT") + 1) % iGhostCount;
	SetLocalInt(oModule, "GHOSTCURRENT", i);
	SetFirstName(GetObjectByTag("LOSTSOUL", i), "Ghost of " + GetName(oPC));
	
 }