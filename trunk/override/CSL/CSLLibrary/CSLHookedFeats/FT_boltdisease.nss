//::///////////////////////////////////////////////
//:: Bolt: Disease
//:: NW_S1_BltDisease
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature must make a ranged touch attack to infect
	the target with a disease.  The disease used
	is chosen based upon the racial type of the
	caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "_HkSpell" 
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nRacial = GetRacialType(OBJECT_SELF);
	int nDisease;
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_DISEASE));

	//Here we use the racial type of the attacker to select an
	//appropriate disease.
	switch (nRacial)
	{
			case RACIAL_TYPE_VERMIN:
				nDisease = DISEASE_VERMIN_MADNESS;
			break;
			case RACIAL_TYPE_UNDEAD:
				nDisease = DISEASE_FILTH_FEVER;
			break;
			case RACIAL_TYPE_OUTSIDER:
				if(GetTag(OBJECT_SELF) == "NW_SLAADRED")
				{
					nDisease = DISEASE_RED_SLAAD_EGGS;
				}
				else
				{
					nDisease = DISEASE_DEMON_FEVER;
				}
			break;
			case RACIAL_TYPE_MAGICAL_BEAST:
				nDisease = DISEASE_SOLDIER_SHAKES;
			break;
			case RACIAL_TYPE_ABERRATION:
				nDisease = DISEASE_BLINDING_SICKNESS;
			break;
			default:
				nDisease = DISEASE_SOLDIER_SHAKES;
			break;
	}
	//Assign effect and chosen disease
	effect eBolt = SupernaturalEffect(EffectDisease(nDisease));
	//Make the ranged touch attack.
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		//Apply the VFX impact and effects
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget);
	}
}