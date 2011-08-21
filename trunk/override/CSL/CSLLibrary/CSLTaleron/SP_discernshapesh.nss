/*
Discern Shapeshifter
Sean Harrington
11/10/07
#1371
*/
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
	
	object 		oPC 			= OBJECT_SELF;
location 	lLocation		= GetSpellTargetLocation();
object 		oTarget 		= GetSpellTargetObject();
int			nCasterLevel	= HkGetCasterLevel(oPC);




object oItem = GetItemPossessedBy(oPC,"sh_i_honey_lotus_balm");
/*if (!GetIsObjectValid(oItem))
	{
	SendMessageToPC(oPC,"You must possess a balm of honey and lotus flower to cast this spell");
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

if (GetHasSpellEffect(SPELL_POLYMORPH_SELF,oTarget) || GetHasSpellEffect(SPELL_ENLARGE_PERSON,oTarget) ||
		GetHasSpellEffect(SPELL_SHAPECHANGE,oTarget) || GetHasSpellEffect(SPELL_POLYMORPH_SELF,oTarget) ||
		GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION,oTarget) || GetHasSpellEffect(SPELL_I_WORD_OF_CHANGING,oTarget) ||
		GetHasFeatEffect(FEAT_ELEMENTAL_SHAPE,oTarget) || GetHasFeatEffect(FEAT_ELEPHANTS_HIDE,oTarget) ||
		GetHasFeatEffect(FEAT_ENLARGE,oTarget) || GetHasFeatEffect(FEAT_EPIC_CONSTRUCT_SHAPE,oTarget) ||
		GetHasFeatEffect(FEAT_EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE,oTarget) || GetHasFeatEffect(FEAT_EPIC_DRUID_INFINITE_WILDSHAPE,oTarget) ||
		GetHasFeatEffect(FEAT_EPIC_OUTSIDER_SHAPE,oTarget) || GetHasFeatEffect(FEAT_EPIC_WILD_SHAPE_DRAGON,oTarget) ||
		GetHasFeatEffect(FEAT_EPIC_WILD_SHAPE_UNDEAD,oTarget) || GetHasFeatEffect(FEAT_GREATER_WILDSHAPE_1,oTarget) ||
		GetHasFeatEffect(FEAT_GREATER_WILDSHAPE_2,oTarget) || GetHasFeatEffect(FEAT_GREATER_WILDSHAPE_3,oTarget) ||
		GetHasFeatEffect(FEAT_GREATER_WILDSHAPE_4,oTarget) || GetHasFeatEffect(FEAT_OAKEN_RESILIENCE,oTarget) ||
		GetHasFeatEffect(FEAT_WILD_SHAPE,oTarget) || GetHasFeatEffect(FEAT_ELEMENTAL_SHAPE,oTarget)
		)
		{
		SendMessageToPC(oPC,"The target is not in its natural form!");
		}
else
		{
		SendMessageToPC(oPC,"The target is in its natural form");
		}

		if (GetRacialType(oTarget)== RACIAL_TYPE_SHAPECHANGER ||GetSubRace(oTarget) == RACIAL_SUBTYPE_SHAPECHANGER)
		{
		SendMessageToPC(oPC, "The target is a natural Shapeshifter!");
		}
	}