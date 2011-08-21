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
float fDuration = IntToFloat(HkGetCasterLevel(oPC)) * 6.0 ; //1 round per level
fDuration = HkApplyMetamagicDurationMods(fDuration);
int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

object oTarget = GetSpellTargetObject();

if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM) return;
if (GetBaseItemType(oTarget) != BASE_ITEM_ARROW && GetBaseItemType(oTarget) != BASE_ITEM_BOLT)return;
SetItemStackSize(oTarget,GetItemStackSize(oTarget) -1);
oTarget = CreateItemOnObject("nw_wamar001",oPC,1,"",TRUE);

AddItemProperty(nDurType,ItemPropertyNoDamage(),oTarget,fDuration);
AddItemProperty(nDurType,ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN,IP_CONST_ONHIT_SAVEDC_14,IP_CONST_ABILITY_STR),oTarget,fDuration);

}