//::///////////////////////////////////////////////
//:: Ballista Fireball
//:: x2_p1_ballista
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball fired from a ballista is a burst of flame
// that detonates with a low roar and inflicts 2d6 points
// of damage to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 6/02
//:://////////////////////////////////////////////
//

#include "_HkSpell" 
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables

	int iDamage;
	float fDelay;
	effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eDam;
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();

	//Apply the fireball explosion at the location captured above.
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_CUBE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
			//if(!GetIsReactionTypeFriendly(oTarget))
		//{
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

					//Roll damage for each target
					iDamage = d6(2);
					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, 20, SAVING_THROW_TYPE_FIRE);
					//Set the damage effect
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
					if(iDamage > 0)
					{
							// Apply effects to the currently selected target.
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							//This visual effect is applied to the target object not the location as above.  This visual effect
							//represents the flame that erupts on the target not on the ground.
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}


			//}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_CUBE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}