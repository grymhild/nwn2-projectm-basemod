//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "seed_db_inc"
#include "_SCInclude_MagicStone"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	sParameters = GetStringUpperCase(sParameters);
	
	if ( sParameters == "RANDOM" )
	{
		sParameters = CSLPickOne("MAGICAL", "DIVINE", "POSITIVE", "NEGATIVE"); // PICK A RARE ONE
		sParameters = CSLPickOne("BLUDGEONING", "PIERCING", "SLASHING", "SONIC", sParameters); // PICK A RARE ONE
		sParameters = CSLPickOne("ACID", "ELECTRICAL", "FIRE", "COLD", sParameters); // THEN GIVE SMALL CHANCE OF ACTUALLY DROPPING IT
    }
    
    if ( sParameters == "MAGICAL" || sParameters == "DIVINE" || sParameters == "POSITIVE" || sParameters == "NEGATIVE" || sParameters == "BLUDGEONING" || sParameters == "PIERCING" || sParameters == "SLASHING" || sParameters == "SONIC" || sParameters == "ACID" || sParameters == "ELECTRICAL" || sParameters == "FIRE" || sParameters == "COLD" )
    {
    	if( !GetIsObjectValid(oTarget) )
    	{
    		oTarget = oDM;
    	}
    	StoneCreate(oTarget, "stone_damage", "Stone of " + CSLInitCap(sParameters) + " Damage", "SMS_DAMAGE_" + sParameters);
    }
    else
    {
    	SendMessageToPC( oDM, "Use DM_GiveStone followed by the following parameters: Random, Magical, Divine, Positive, Negative, Bludgeoning, Piercing, Slashing, Sonic, Acid, Electrlcal, Fire, or Cold and a stone will be given to the selected target. Please notify pain upon any usage with justification, and do not give out more than a few.");
    }
}