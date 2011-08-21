//::///////////////////////////////////////////////
//:: User Defined Henchmen Script
//:: gb_assoc_usrdef
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The most complicated script in the game.
    ... ever
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2002
//:://////////////////////////////////////////////

//#include "x2_inc_spellhook"

#include "_SCInclude_AI"
#include "_CSLCore_Magic_c"


void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " user defined " + IntToString(GetUserDefinedEventNumber()));
    switch (GetUserDefinedEventNumber())
	{
		case 20001: // 20000 + ACTION_MODE_STEALTH
	        if (!SCGetIsFighting(OBJECT_SELF) && !SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE))
	        {
	            int bStealth = GetActionMode(GetMaster(), ACTION_MODE_STEALTH);
	            SCRelayModeToAssociates(ACTION_MODE_STEALTH, bStealth);
	        }
			break;
		case 20000: // 20000 + ACTION_MODE_DETECT
	        if (!SCGetIsFighting(OBJECT_SELF))
	        {
	            int bDetect = GetActionMode(GetMaster(), ACTION_MODE_DETECT);
	            SCRelayModeToAssociates(ACTION_MODE_DETECT, bDetect);
	        }
			break;
		
		    // * If a creature has the integer variable X2_L_CREATURE_NEEDS_CONCENTRATION set to TRUE
	    // * it may receive this event. It will unsummon the creature immediately
	    case SC_EVENT_CONCENTRATION_BROKEN:
		    {
		        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
		        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(OBJECT_SELF));
		        FloatingTextStrRefOnCreature(84481,GetMaster(OBJECT_SELF));
		        DestroyObject(OBJECT_SELF,0.1f);
		    }
			break;
			
		case EVENT_SAW_TRAP:
			SCHenchPauseForTraps();
			SCHenchTrapDetected();
		case HENCH_EVENT_PARTY_SAW_TRAP:
			SCHenchCheckArea(TRUE);
			break;
		case HENCH_EVENT_ATTACK_NEAREST:
			SCHenchAttackNearest();
			break;
		case HENCH_EVENT_FOLLOW_MASTER:
			SCHenchFollowMaster();
			break;
		case HENCH_EVENT_GUARD_MASTER:
			SCHenchGuardMaster();
			break;
		case HENCH_EVENT_STAND_GROUND:
			SCHenchStandGround();
			break;
	}
}