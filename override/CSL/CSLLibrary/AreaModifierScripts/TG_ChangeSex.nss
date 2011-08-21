/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC =  GetEnteringObject(); // only works if it's in a trigger or an AOE
	if( !GetIsObjectValid( oPC ) ) // this is to make it runnable via rs command or execute as well
	{
		if ( GetObjectType(OBJECT_SELF)==OBJECT_TYPE_CREATURE )
		{
			oPC == OBJECT_SELF;
		}
	}
	
	if (  GetIsObjectValid( oPC ) && ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC ) )  )
	{
		int iPrevAppearance = GetAppearanceType(oPC);
		int nSubRace = GetSubRace(oPC);
		int nGender = GetGender(oPC); // GENDER_MALE = 0 = male, GENDER_FEMALE = 1 = female
		int nFakeGender = -1;
		int iNewAppearance = -1;
		
		int iRealAppearance = GetLocalInt( oPC, "OriginalAppearance" ); // this is offset by one because non values are 0 and 0 is a valid appearance in the game.
		// nFakeGender = CSLGetFakeGender( iPrevAppearance );
		
		if ( iRealAppearance == 0 && nFakeGender == -1  )
		{
			if ( nFakeGender == -1 && nGender == GENDER_MALE )
			{
				iNewAppearance = CSLGetAppearanceBySubrace( nSubRace );
			}
			else if ( nFakeGender == -1 && nGender == GENDER_FEMALE )
			{
				iNewAppearance = CSLGetAppearanceBySubrace( nSubRace );
			}
			
			SetCreatureAppearanceType( oPC, iNewAppearance);
			//if ( GetLocalInt( oPC, "APPEARANCECHANGE" ) )
		
			SetLocalInt( oPC, "OriginalAppearance", iPrevAppearance+1 );
			
			
			SendMessageToPC( oPC, "Your appearance changes from "+CSLGetStringByAppearance( iPrevAppearance )+"("+IntToString(iPrevAppearance)+") to "+CSLGetStringByAppearance( iNewAppearance )+"("+IntToString(iNewAppearance)+")"  );
		}
		else
		{
			SetCreatureAppearanceType( oPC, iRealAppearance-1);
			//SetLocalInt( oPC, "OriginalAppearance", 0 );
			DeleteLocalInt( oPC, "OriginalAppearance" );
		}
	}
}