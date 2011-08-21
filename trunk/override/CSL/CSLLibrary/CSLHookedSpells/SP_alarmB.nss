//::///////////////////////////////////////////////
//:: Alarm - OnExit
//:: SG_S0_AlarmX.nss
//:: 2003 Karl Nickels
//:://////////////////////////////////////////////
/*

Alarm
Abjuration
Level:	Brd 1, Rgr 1, Sor/Wiz 1
Components:	V, S, F/DF
Casting Time:	1 standard action
Range:	Close (25 ft. + 5 ft./2 levels)
Area:	20-ft.-radius emanation centered on a point in space
Duration:	2 hours/level (D)
Saving Throw:	None
Spell Resistance:	No

Alarm sounds a mental or audible alarm each time a creature of Tiny or larger size enters the warded
area or touches it. A creature that speaks the password (determined by you at the time of casting)
does not set off the alarm. You decide at the time of casting whether the alarm will be mental or
audible.

Mental Alarm A mental alarm alerts you (and only you) so long as you remain within 1 mile of the
warded area. You note a single mental “ping” that awakens you from normal sleep but does not
otherwise disturb concentration. A silence spell has no effect on a mental alarm.

Audible Alarm An audible alarm produces the sound of a hand bell, and anyone within 60 feet of the
warded area can hear it clearly. Reduce the distance by 10 feet for each interposing closed door and
by 20 feet for each substantial interposing wall.

In quiet conditions, the ringing can be heard faintly as far as 180 feet away. The sound lasts for 1
round. Creatures within a silence spell cannot hear the ringing.

Ethereal or astral creatures do not trigger the alarm.

Alarm can be made permanent with a permanency spell.

Arcane Focus A tiny bell and a piece of very fine silver wire


// added ethereal to the script, not going to do an audbible alarm at this point in time ( subradial )

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
//:://////////////////////////////////////////////
//:: Edited On: October 6, 2003
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	
	if( GetIsObjectValid( oCaster ) && !CSLGetIsIncorporeal( oTarget ) )
	{
		SendMessageToPC(oCaster,"Creature has exited your alarm area");
	}
}