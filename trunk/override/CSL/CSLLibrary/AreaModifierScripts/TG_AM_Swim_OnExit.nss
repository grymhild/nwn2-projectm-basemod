/*
This is a basic trigger or area script, to allow underwater events to work properly
*/
#include "_CSLCore_Environment"
#include "_CSLCore_Appearance"

void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	int iSpellId = -155;
	object oTrigger;
	//object oArea;
	object oPC;
	
	int iSelfType = GetObjectType( OBJECT_SELF );
	if ( iSelfType == OBJECT_TYPE_CREATURE )
	{
		// this is fired from the area on enter for the entire area, the area is basically the trigger
		oPC = OBJECT_SELF;
		oTrigger = GetArea(oPC);
		//oArea = GetArea(oPC);

	}
	else if ( iSelfType == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		oTrigger = GetAreaOfEffectCreator();
		oPC = GetExitingObject();
		//oArea = GetArea(oPC);
	}
	else if ( iSelfType == OBJECT_TYPE_TRIGGER )
	{
		oTrigger = OBJECT_SELF;
		oPC = GetExitingObject();
		//oArea = GetArea(oPC);
	}
	else
	{
		oPC = GetExitingObject();
	
	}
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTONLYCREATOR, oTrigger, oPC, iSpellId );
	
	if ( !CSLHasSpellIdGroup( oPC, iSpellId ) ) 
	{
		CSLStoreTrueAppearance(oPC);
		CSLAnimationOverride(oPC, CSL_ANIMATEOVERRIDE_NONE );
	
		SetCollision(oPC, TRUE);
	}
	//CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId);
}