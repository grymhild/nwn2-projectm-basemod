//::///////////////////////////////////////////////
//:: Cone: Disease
//:: NW_S1_ConeDisea
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature spits out a cone of disease that cannot
	be avoided unless a Reflex save is made.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

#include "_HkSpell" 
void main()
{
	//scSpellMetaData = SCMeta_FT_conedisease();
	//Declare major variables
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget;
	float fDelay;
	int iHD = GetHitDice(OBJECT_SELF);
	int nRacial = GetRacialType(OBJECT_SELF);
	int nDisease;
	//Determine the disease type based on the Racial Type and HD
	switch (nRacial)
	{
			case RACIAL_TYPE_OUTSIDER:
				nDisease = DISEASE_DEMON_FEVER;
			break;
			case RACIAL_TYPE_VERMIN:
				nDisease = DISEASE_VERMIN_MADNESS;
			break;
			case RACIAL_TYPE_UNDEAD:
				if(iHD <= 3)
				{
					nDisease = DISEASE_ZOMBIE_CREEP;
				}
				else if (iHD > 3 && iHD <= 10)
				{
					nDisease = DISEASE_GHOUL_ROT;
				}
				else if(iHD > 10)
				{
					nDisease = DISEASE_MUMMY_ROT;
				}
			default:
				if(iHD <= 3)
				{
					nDisease = DISEASE_MINDFIRE;
				}
				else if (iHD > 3 && iHD <= 10)
				{
					nDisease = DISEASE_RED_ACHE;
				}
				else if(iHD > 10)
				{
					nDisease = DISEASE_SHAKES;
				}


			break;
	}
	//Set disease effect
	effect eCone = SupernaturalEffect(EffectDisease(nDisease));
	effect eVis = EffectVisualEffect(VFX_DUR_CONE_POISON);
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	//Get first target in spell area
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_CONE_DISEASE));
				//Get the delay time
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				//Apply the VFX impact and effects
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oTarget));
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);

	}
}


