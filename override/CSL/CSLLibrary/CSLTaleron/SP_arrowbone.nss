/*
Arrow Of Bone
Sean Harrington
11/10/07
#1345
*/
//#include "sh_custom_functions"
//#include "nwn2_inc_spells"
//#include "x2_inc_spellhook"
//#include "nw_i0_spells"
//champions of ruin

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oPC = OBJECT_SELF;
float fDuration = IntToFloat(HkGetCasterLevel(oPC)) * 3600.0 ; //1 hour per level
fDuration = HkApplyMetamagicDurationMods(fDuration);
int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

object oTarget = GetSpellTargetObject();
//////////////////////Components//////////////////////////////////////
object oItem = GetItemPossessedBy(oPC,"sh_i_bone_sliver");
object oItem2 = GetItemPossessedBy(oPC,"sh_i_oil_of_magic_weapon");
/*if (!GetIsObjectValid(oItem)|| !GetIsObjectValid(oItem2))
	{
	SendMessageToPC(oPC,"You must possess a bone sliver & oil of magic weapon to cast this spell");
	return;
	}
else
{
	if (GetItemStackSize(oItem) > 1)
	{ SetItemStackSize(oItem,GetItemStackSize(oItem)-1);}
	else
	{DestroyObject(oItem);}

	if (GetItemStackSize(oItem2) > 1)
	{ SetItemStackSize(oItem2,GetItemStackSize(oItem2)-1);}
	else
	{DestroyObject(oItem2);}


}
*/
////////////////////////////////////////////////////////////////////////////
if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM) return;
if (GetBaseItemType(oTarget) != BASE_ITEM_ARROW && GetBaseItemType(oTarget) != BASE_ITEM_BOLT)return;
SetItemStackSize(oTarget,GetItemStackSize(oTarget) -1);

oTarget = CreateItemOnObject("nw_wamar001",oPC,1,"arrow_of_bone",TRUE);

AddItemProperty(nDurType,ItemPropertyOnHitProps(IP_CONST_ONHIT_SLAYALIGNMENTGROUP,14,IP_CONST_ALIGNMENTGROUP_ALL),oTarget,fDuration);
AddItemProperty(nDurType,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING,IP_CONST_DAMAGEBONUS_4),oTarget,fDuration);
SetItemCursedFlag(oTarget,TRUE);


}