//#include "_SCUtility"
#include "_SCInclude_Summon"

void main()
{
   object oSummon = OBJECT_SELF;
	if ( !GetIsObjectValid( oSummon) )
	{
		return;
	}
	
	if ( GetLocalInt( oSummon, "DIED" ) ) // this is set in the default creature death event
	{
		string sChainRemaining = GetLocalString(oSummon, "CSLSUMMON_CHAIN_REMAINING" );
		if ( sChainRemaining != "" )
		{
			// SetLocalInt(oTarget, sPrefix+"ENDINGROUND",  CSLEnviroGetExpirationRound( fDuration ) );
			int iSpellId = GetLocalInt( oSummon, "SCSummon" );
			int iEndingRound = CSLGetTargetTagInt( SCSPELLTAG_ENDINGROUND, oSummon, iSpellId );
			float fRemainingDuration = CSLEnviroGetRemainingDuration( iEndingRound );
			if ( fRemainingDuration > 0.0f )
			{
				
				sChainRemaining = CSLNth_Shift(sChainRemaining, "|"); // gets first item from the given array and puts into CSLNth_GetLast, and returns the array with that first item removed
				string sResRef = CSLNth_GetLast();
				
				object oNewSummon = SCSummonCreateCreature( sResRef, sChainRemaining, GetLocation( oSummon ), fRemainingDuration, 
					GetLocalObject(oSummon, "MASTER"), CSLGetTargetTagInt( SCSPELLTAG_CASTERCLASS, oSummon, iSpellId ),  
					GetLocalString(oSummon, "CSLSUMMON_SUMMON_EFFECT"), GetLocalString(oSummon, "CSLSUMMON_UNSUMMON_EFFECT"), 
					GetLocalString(oSummon, "CSLSUMMON_SUMMON_SCRIPT"), GetLocalString(oSummon, "CSLSUMMON_UNSUMMON_SCRIPT"), 
					GetLocalString(oSummon, "CSLSUMMON_DURATION_EFFECT"), iSpellId ); 
				// need to transfer some values from target tag at this point as well
					//HkApplyTargetTag( oNewSummon, GetLocalObject(oSummon, "MASTER"), iSpellId, CSLGetTargetTagInt( SCSPELLTAG_CASTERCLASS, oSummon, iSpellId ), fRemainingDuration );
					
					
			}
		}
	}
	
	string sOnUnSummonScript = GetLocalString(oSummon, "CSLSUMMON_UNSUMMON_SCRIPT" );
	if ( sOnUnSummonScript != "" )
	{
		ExecuteScript(sOnUnSummonScript, oSummon );
	}
	SCSummonRemove( oSummon );
}