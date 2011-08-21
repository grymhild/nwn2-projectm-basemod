//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: TB_divinespirit								//
//	Description: Expend a turn undead use while in	//
//	a Devoted Spirit Stance to regain 3 + CHA HP.	//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------

	if ( !HkSwiftActionIsActive(oPC) && GetHasFeat(FEAT_TURN_UNDEAD) )
	{
		if ( hkStanceGetHasActive( oPC, STANCE_AURA_OF_CHAOS, STANCE_AURA_OF_PERFECT_ORDER, STANCE_AURA_OF_TRIUMPH, STANCE_AURA_OF_TYRANNY, STANCE_IMMORTAL_FORTITUDE, STANCE_IRON_GUARDS_GLARE, STANCE_MARTIAL_SPIRIT, STANCE_THICKET_OF_BLADES ))
		{
			int nMyCHA;

			if (GetAbilityModifier(ABILITY_CHARISMA) < 1)
			{
				nMyCHA = 0;
			}
			else nMyCHA = GetAbilityModifier(ABILITY_CHARISMA);

			effect eHeal = EffectHeal(3 + nMyCHA);

			DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
			TOBRunSwiftAction(214, "F");
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		}
	}
}
