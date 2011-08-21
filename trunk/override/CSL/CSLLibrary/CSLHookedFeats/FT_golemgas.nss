//::///////////////////////////////////////////////
//:: Golem Breath
//:: NW_S1_GolemGas
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Iron Golem spits out a cone of poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget;
	effect ePoison = EffectPoison(POISON_IRON_GOLEM);
	effect eCone = EffectVisualEffect( VFX_CONE_ACID_BREATH );
	
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GOLEM_BREATH_GAS));
				//Determine effect delay
				float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				//Apply poison effect
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
	
	HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, 3.0f );
}