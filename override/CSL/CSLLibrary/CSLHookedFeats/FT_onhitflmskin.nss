//::///////////////////////////////////////////////
//:: OnHit Burning Armor
//:: x2_s3_flameskin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

	An armor with this ability assigned will
	deal 1d6+1 points of fire damage to the
	attacker. Damage power is counted as magical
	thus can be resisted by magic resistance

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-31
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oItem;        // The item casting triggering this spellscript
	object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oSpellTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();
	int iLevel = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

	if (GetIsObjectValid(oItem))
	{
		if (GetIsObjectValid(oSpellTarget))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSpellTarget);
			if (!GetIsObjectValid(oWeapon))
			{
				oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oSpellTarget);
			}
			if (!GetWeaponRanged(oWeapon) || !GetIsObjectValid(oWeapon))
			{
				SignalEvent(oSpellTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
				int iDamage = d6(1)+ iLevel;
				effect eDamage = EffectDamage(iDamage,DAMAGE_TYPE_FIRE);
				effect eVis;
				if (iDamage<15)
				{
						eVis =EffectVisualEffect(VFX_IMP_FLAME_S);
				}
				else
				{
						eVis =EffectVisualEffect(VFX_IMP_FLAME_M);
				}
				HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oSpellTarget);
			}
		}
	}
}