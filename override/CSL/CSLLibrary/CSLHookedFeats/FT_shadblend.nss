//::///////////////////////////////////////////////
//:: Shadow Dragon: Blend into shadows
//:: x2_s1_shadblend
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

	The shadow dragons blend into shadows ability.
	Will give him 9/10th concealments


	If you set the variable X2_AREA_NO_SHADOWS
	TRUE on the area, the ability will not work

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-27
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "x2_inc_switches"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eVis = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eBlend = EffectConcealment(90);
	effect eLink = EffectLinkEffects(eVis, eBlend);
	eLink = EffectLinkEffects(eLink, eDur);
	int iDuration = 10; // 10 rounds

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	//Apply the VFX impact and effects
	if(!GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
	{
				// if we are under effect of continual flame, this does not work
			if(!GetHasSpellEffect(SPELL_CONTINUAL_FLAME,OBJECT_SELF))
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
			}
		}



}