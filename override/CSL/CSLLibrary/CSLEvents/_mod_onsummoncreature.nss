//#include "_SCUtility"
#include "_SCInclude_Summon"

void main()
{
	object oSummon = OBJECT_SELF;
	if ( !GetIsObjectValid(oSummon) )
	{
		return;
	}
	object oMaster = GetLocalObject(oSummon, "MASTER" );
	if ( !GetIsObjectValid(oMaster) )
	{
		oMaster = GetMaster(oSummon);
		if ( !GetIsObjectValid(oMaster) )
		{
			return;
		}
	}
	
	
	
	int iBonus = SCGetSummonBonus( oMaster);
	int nAshbound = FALSE;
	
	SCSummonBoost(oSummon, oMaster, iBonus );
}