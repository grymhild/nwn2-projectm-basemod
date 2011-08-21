//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 7/22/2009						//
//	Title:	TB_bo_codeception				//
//	Description: When you initiate this //
//	maneuver, you turn invisible, as the//
//	greater invisibility spell			//
//////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
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

	if ( !HkSwiftActionIsActive(oPC) )
	{
		effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
		effect eInVis = EffectVisualEffect(VFX_TOB_FADE); // Doesn't play well with other effects in a link.
		effect eCover = EffectConcealment(50);
		effect eCloak = EffectLinkEffects(eInvis, eCover);
		eCloak = SupernaturalEffect(eCloak);
		eCloak = SetEffectSpellId(eCloak, 6551);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCloak, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInVis, oPC, 6.0f);
		TOBRunSwiftAction(121, "B");
		TOBExpendManeuver(121, "B");
	}
}
