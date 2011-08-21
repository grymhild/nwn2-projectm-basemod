//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

/*
Test case to show the effect of applying a con bonus to a caster while he already has a con item equpped that should prevent stacking.

You can specify an item as a paramter. By default i_conitem will be used if no parameters provided. ( need to get another item which is in the vanilla game instead. )

You can select a creature in most talk modes, or send a tell to do the same thing.

*/

#include "_SCInclude_Chat"


void finishTest( object oPC, object oTarget )
{
	SendMessageToPC( oPC, "Currently target has these items equipped");
	SendMessageToPC( oPC, CSLListItemProperties( oTarget ) );
	
	SendMessageToPC( oPC, "Currently target has these effects applied");
	SendMessageToPC( oPC, CSLAllEffectsToString( oTarget ) );
	
	int nSR = GetSpellResistance(oTarget);
	int nResistType = ResistSpell(oPC, oTarget);
	if ( nResistType )
	{
		SendMessageToPC( oPC, GetName(oTarget)+" Succeeded ResistSpell() Check ("+IntToString(nResistType)+")");
	}
	else
	{
		SendMessageToPC( oPC, GetName(oTarget)+" Failed ResistSpell() Check ("+IntToString(nResistType)+")");
	}
	int nNewSR = GetSpellResistance(oTarget);
	
	
	// now show the results of this test case.
	if ( nSR != nNewSR )
	{
		SendMessageToPC( oPC, "Spell Resistance Changed from "+IntToString(nSR)+" to "+IntToString( nNewSR ) );
		SendMessageToPC( oPC, CSLColorText("**** TEST FAILED ****",COLOR_RED) );
	}
	else
	{
		SendMessageToPC( oPC, "Spell Resistance ("+IntToString(nSR)+") did not change" );
		SendMessageToPC( oPC, CSLColorText("**** THIS IS WORKING CORRRECTLY ****", COLOR_GREEN) );
	}

}


void main()
{
	object oPC = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLTrim( CSLGetChatParameters() );
	string sResRef = "c_succubus"; // resref of creature with SR on it's hide
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
    
    if ( sParameters != "" )
    {
    	sResRef = sParameters;
    }
    
    SendMessageToPC( oPC, CSLColorText( "**** TEST CASE: SR stripped by usage of SpellResist() function! ****" , COLOR_GREEN) );
    SendMessageToPC( oPC, "Parameters:");
	SendMessageToPC( oPC, "Need target with SR property on it's hide, if not selected will spawn one based on parameter or the default one");
    SendMessageToPC( oPC, "The Targets SR should not change from before and after using the SpellResist() function.");
    
    if ( !GetIsObjectValid( oTarget ) )
	{
		// oTarget = oPC;
		// Spawn a creature now
		SendMessageToPC( oPC, "No creature selected, a "+sResRef+" will be spawned for a few seconds. You can specify another creature as a parameter to this command.");
				
		location lLoc = CSLGetLocationAboveAndInFrontOf( oPC, 7.0f, 0.0f); //GetStartingLocation();
		oTarget = CreateObject( OBJECT_TYPE_CREATURE, sResRef, lLoc );
		SendMessageToPC( oPC, "Spawning "+sResRef+" "+GetName(oTarget) );
		
		// lock the summon up
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oTarget, 0.0f);

		
		DelayCommand( 5.0f, DestroyObject(oTarget, 1.0f, FALSE ) );
	}
	
	DelayCommand( 1.0f, finishTest( oPC, oTarget ) );
}