/** @file
* @brief Include File for Effects and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_UI"
#include "_CSLCore_Player"


void SCEffects_Display( object oTargetToDisplay, object oPC = OBJECT_SELF, string sScreenName = SCREEN_EFFECTS )
{
	if ( !GetIsObjectValid( oTargetToDisplay) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}

	DisplayGuiScreen(oPC, sScreenName, FALSE, XML_EFFECTS);
}

object SCReadObjectModifier( string sModifierName, object oModifier = OBJECT_INVALID )
{
	if ( GetLocalObject( GetModule(), "SCTEMP_"+sModifierName ) != OBJECT_INVALID )
	{
		oModifier = GetLocalObject( GetModule(), "SCTEMP_"+sModifierName );
	}
	return oModifier;
}

int SCReadIntModifier( string sModifierName, int iModifier = 0 )
{
	if ( GetLocalInt( GetModule(), "SCTEMP_"+sModifierName ) != 0 )
	{
		iModifier = GetLocalInt( GetModule(), "SCTEMP_"+sModifierName );
	}
	return iModifier;
}

//location SCReadLocationModifier( object oChar, string sModifierName ) // , location lModifier
//{
//	return GetLocalLocation( oChar, "SCTEMP_"+sModifierName )
//}

object CSLGetEffectTargetObject(object oTarget = OBJECT_SELF)
{
	return oTarget;
}

int CSLGetEffectHitDice( int iHD = -1 )
{
	return iHD;
}


int CSLGetEffectDamageType( int iDamageType = DAMAGE_TYPE_FIRE )
{
	iDamageType = SCReadIntModifier( "Damagetype", iDamageType );
	return iDamageType;
}

location CSLGetEffectTargetLocation()
{
	return GetLocation( OBJECT_SELF );
}


void CSLPostEffect( )
{
	object oModule = GetModule();
	DeleteLocalInt( oModule, "SCTEMP_Damagetype" );
	DeleteLocalInt( oModule, "SCTEMP_Spell_Power" );
	DeleteLocalInt( oModule, "SCTEMP_Save_DC" );
	DeleteLocalInt( oModule, "SCTEMP_Radius" );
	DeleteLocalObject( oModule, "SCTEMP_Target" );
	DeleteLocalObject( oModule, "SCTEMP_Caster" );
	DeleteLocalLocation( oModule, "SCTEMP_Location" );
	
	// clean up here any vars on creating object
}