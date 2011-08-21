///////////////////////////////////////////////////
//::Bless Water Spell
//::By Sean Harrington on Oct 23, 2007
///////////////////////////////////////////////////
//::Turns Purified Water into Holy water
//::Costs 25 gold
///////////////////////////////////////////////////
//#include "nwn2_inc_spells"
//#include "x2_inc_spellhook"



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
object oTarget = GetSpellTargetObject();


if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
{
SendMessageToPC(OBJECT_SELF,"This spell will not work for you because of your alignment");
return;
}




if (GetTag(oTarget) != "sh_i_flask_water")
	{
	SendMessageToPC(oPC,"Invalid Target, spell fizzled");
	return;
	}

object oItem = GetItemPossessedBy(oPC,"n2_alc_powsilver");
/*if (!GetIsObjectValid(oItem))
	{
	SendMessageToPC(oPC,"You must possess powdered silver to cast this spell");
	return;
	}
else
{
	if (GetItemStackSize(oItem) > 1)
	{ SetItemStackSize(oItem,GetItemStackSize(oItem)-1);}
	else
	{DestroyObject(oItem);}
}
*/

TakeGoldFromCreature(25,oPC,TRUE,TRUE);
SetItemStackSize(oTarget,GetItemStackSize(oTarget) -1);


CreateItemOnObject("x1_wmgrenade005",oPC,1);
}