
#include "_HkSpell"

void main()
{	
	
object oPC = OBJECT_SELF;
location 	lLocation		= GetSpellTargetLocation();
object 		oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_SMALL,lLocation,FALSE,OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE);



object oArea = GetArea(oPC);
if (!GetObjectType(oTarget) == OBJECT_TYPE_DOOR || !GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE) //check to make sure its either a door or a placable
{
SendMessageToPC(oPC,"Not a valid target");
return;
}
//SendMessageToPC(oPC,IntToString(GetObjectType(oTarget)));
if (GetIsOpen(oTarget)==TRUE)
{
//SendMessageToPC(oPC,"Its Open");
//close it
AssignCommand(oTarget,ActionCloseDoor(oTarget));
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_CRAFT_MAGIC), oTarget,3.0);//little vfx on the target
return;
}

else if (GetIsOpen(oTarget)== FALSE&&GetLocked(oTarget)==FALSE)
{
//SendMessageToPC(oPC,"Its Closed");
//open it
AssignCommand(oTarget,ActionOpenDoor(oTarget));
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_CRAFT_MAGIC), oTarget,3.0);//little vfx on the target
return;
}

else if (GetLocked(oTarget)==TRUE)
{
SendMessageToPC(oPC,"This spell does not open locked, barred, or held doors.");
return;
}

SendMessageToPC(oPC,"Nothing happened, there is an error with the spell, please report it to S_H");
}