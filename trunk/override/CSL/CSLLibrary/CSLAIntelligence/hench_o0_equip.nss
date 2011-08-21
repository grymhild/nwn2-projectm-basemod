/*

    Companion and Monster AI

    Equips best weapon in general (not against specific target, used for weapon equipping outside of combat

*/

#include "_SCInclude_AI"


void main()
{
	int bShowStatus = GetLocalInt(OBJECT_SELF, "HenchShowWeaponStatus");
	if (bShowStatus)
	{
		DeleteLocalInt(OBJECT_SELF, "HenchShowWeaponStatus");
	}
    if (!SCHenchEquipAppropriateWeapons(OBJECT_INVALID, -5., bShowStatus, CSLGetHasEffectType(OBJECT_SELF,EFFECT_TYPE_POLYMORPH)))
    {
        ActionDoCommand(SCActionContinueEquip(OBJECT_INVALID, bShowStatus, 2));
    }
}