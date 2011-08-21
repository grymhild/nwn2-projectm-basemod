//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

/*
Test case to show the effect of applying a con bonus to a caster while he already has a con item equpped that should prevent stacking.

You can specify an item as a paramter. By default i_conitem will be used if no parameters provided. ( need to get another item which is in the vanilla game instead. )

You can select a creature in most talk modes, or send a tell to do the same thing.

*/

#include "_SCInclude_Chat"
#include "_HkSpell"

string ConStatsToString( object oTarget )
{
	string sMessage;
	
	sMessage +=   "      Con: "+IntToString( CSLGetNaturalAbilityScore(oTarget, ABILITY_CONSTITUTION ))+"/"+IntToString( GetAbilityScore(oTarget, ABILITY_CONSTITUTION, FALSE));
	sMessage += "\n Modifier: "+IntToString( GetAbilityModifier(ABILITY_CONSTITUTION, oTarget) );
	sMessage += "\n      Hps: Current "+IntToString(GetCurrentHitPoints(oTarget)) + " Max "+IntToString(GetMaxHitPoints(oTarget));
	return sMessage;
}


void finishTest( object oPC, object oTarget )
{
	SendMessageToPC( oPC, "Currently target has these stats for con and hit points");
	SendMessageToPC( oPC, ConStatsToString( oTarget ) );
	
	SendMessageToPC( oPC, "Currently target has these items equipped");
	SendMessageToPC( oPC, CSLListItemProperties( oTarget ) );
	
	SendMessageToPC( oPC, "Currently target has these effects applied");
	SendMessageToPC( oPC, CSLAllEffectsToString( oTarget ) );
	
	// for detecting an unwarranted increase i'll store the values now
	int nHP = GetCurrentHitPoints(oTarget);
	int nMaxHP = GetMaxHitPoints(oTarget);
	int nAbilityModifier = GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
	int nOrigCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION, FALSE);
	
	SendMessageToPC( oPC, "Applying Bears Endurance Buff Now ( EffectAbilityIncrease( ABILITY_CONSTITUTION, 4);) for 20 seconds");
	effect eStatBuff = EffectAbilityIncrease( ABILITY_CONSTITUTION, 4);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatBuff, oTarget, 20.0f);
	
	//now get the new values for comparison.
	int nNewHP = GetCurrentHitPoints(oTarget);
	int nNewMaxHP = GetMaxHitPoints(oTarget);
	int nNewAbilityModifier = GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
	int nNewCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION, FALSE);
	int iAllowedHPIncrease = CSLGetMax( 0 ,( nNewAbilityModifier - nAbilityModifier ) * GetHitDice(oTarget) );
	
	SendMessageToPC( oPC, "Results for target:"+GetName(oTarget) );
	SendMessageToPC( oPC, ConStatsToString( oTarget ) );
	SendMessageToPC( oPC, "In this test the Con Score Changed from "+IntToString(nOrigCon)+" to "+IntToString(nNewCon)+" for an increase of "+IntToString(nNewCon-nOrigCon) );
	
	SendMessageToPC( oPC, "Hit Points Changed from "+IntToString(nHP)+" to "+IntToString(nNewHP)+" for an increase of "+IntToString(nNewHP-nHP)+ " ( Note max Hit points should be "+IntToString(nMaxHP) );
	
	SendMessageToPC( oPC, "Hit Points Should have changed by "+IntToString(iAllowedHPIncrease)+" but instead changed by "+IntToString(nNewHP-nHP) );
	
	// now show the results of this test case.
	if ( iAllowedHPIncrease != nNewHP-nHP )
	{
		SendMessageToPC( oPC, CSLColorText("**** TEST FAILED ****",COLOR_RED) );
	}
	else
	{
		SendMessageToPC( oPC, CSLColorText("**** THIS IS WORKING CORRRECTLY ****", COLOR_GREEN) );
	}

}





void main()
{
	
	
	object oPC = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	
	//string sResRef = "x2_it_mneck003"; // Amulet of Vitaltiy +4
	
	if ( !GetIsObjectValid( oTarget ) )
	{
		oTarget = oPC;
	}
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
    
	string sResRef = CSLTrim( CSLGetChatParameters() );
	
    if ( sResRef == "" )
    {
    	sResRef = "x2_it_mneck002";
    }
    
    SendMessageToPC( oPC, CSLColorText( "TEST CASE: Constitution Buffs increase hit points even when stacking rules prevent a real con increase!" , COLOR_GREEN) );
    SendMessageToPC( oPC, "Parameters:");
	SendMessageToPC( oPC, "Equip Item with bonus to con higher than applied con Buff ( Amulet of Vitaltiy +4 )");
    SendMessageToPC( oPC, "The casters hit points should not change since the Con Does Not Change");
    if ( sResRef != "none" )
    {
		
		SendMessageToPC( oPC, "Should start with no items equipped, a "+sResRef+" will be equipped. You can specify another resref as a parameter to this command. To prevent anything from being equipped specify 'none' as a parameter.");
		SendMessageToPC( oPC, "Note: x2_it_mneck001 = Amulet of Vitaltiy +2, x2_it_mneck002 = Amulet of Vitaltiy +4, x2_it_mneck003 = Amulet of Vitaltiy +6");
		SendMessageToPC( oPC, "     Use '!test_conbuffwithitem x2_it_mneck001' to get a +2 amulet of vitality.");
		SendMessageToPC( oPC, "     Use 'none' to use what you have equipped.");
		AssignCommand(oTarget, ClearAllActions(TRUE));
		
		SendMessageToPC( oPC, ConStatsToString( oTarget ) );
		
		object oNewItem = CreateItemOnObject(sResRef, oTarget); // probably should add a tag which indicates this is for testing, just in case they get loose in a PW.
		SetIdentified(oNewItem, TRUE);
		AssignCommand( oPC, ActionEquipItem( oNewItem,INVENTORY_SLOT_NECK  ) );
		
		if (GetIsObjectValid(oNewItem))
		{
			SendMessageToPC(oPC, "<color=indianred>"+"You have created a "+ GetName(oNewItem) +" on "+ GetName(oTarget) + "!"+"</color>");
		}
		else
		{
			SendMessageToPC(oPC, "<color=indianred>"+"Invalid ResRef! Cannot create " + sResRef + " on " + GetName(oTarget)+"</color>");
		}
	}
	else
	{
		SendMessageToPC( oPC, "Not Equipping an Item and using what target currently has equipped.");
	}
	
	DelayCommand( 1.0f, finishTest( oPC, oTarget ) );
}