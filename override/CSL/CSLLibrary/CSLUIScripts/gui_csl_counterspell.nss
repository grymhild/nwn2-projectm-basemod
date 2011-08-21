#include "_HkSpell"

void main( string sInput )
{
	object oCaster = OBJECT_SELF;
	object oTarget = GetPlayerCurrentTarget( oCaster );
	
	if ( GetIsObjectValid( oTarget ) && GetHasFeat( FEAT_COUNTERSPELL, oCaster) ) // do a selection if it's not valid and rerun this script
	{
		// ActionCounterSpell(oTarget);
		// Only DM's can use this while it's in development.
		//if ( CSLGetIsDM(oCaster) )
		//{
			if ( sInput == "off" )
			{
				HkCounterSpellTargetingEnd( oCaster );
			}
			else
			{
				HkCounterSpellTargetingStart( oTarget, oCaster );
			}
		//}
	}
}