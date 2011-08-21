//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a globe of darkness around those in the area
	of effect.
	
	Darkness
	Evocation [Darkness]
	Level:	Brd 2, Clr 2, Sor/Wiz 2
	Components:	V, M/DF
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	This spell causes an object to radiate shadowy illumination out to a
	20-foot radius. All creatures in the area gain concealment (20% miss
	chance). Even creatures that can normally see in such conditions (such
	as with darkvision or low-light vision) have the miss chance in an area
	shrouded in magical darkness.
	
	Normal lights (torches, candles, lanterns, and so forth) are incapable
	of brightening the area, as are light spells of lower level. Higher
	level light spells are not affected by darkness.
	
	If darkness is cast on a small object that is then placed inside or
	under a lightproof covering, the spell’s effect is blocked until the
	covering is removed.
	
	Darkness counters or dispels any light spell of equal or lower spell
	level.
	
	Arcane Material Component A bit of bat fur and either a drop of pitch
	or a piece of coal.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_FIRSTONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_I_DARKNESS, SPELLABILITY_DARKNESS, SPELL_ASN_Darkness, SPELL_ASN_Spellbook_2, SPELL_BG_Darkness );
}