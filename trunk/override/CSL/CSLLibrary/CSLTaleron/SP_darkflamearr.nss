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
	
	object 		oPC 		= OBJECT_SELF;
int			nDuration 	= HkGetCasterLevel(oPC);

	if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
			{	nDuration	= nDuration * 2;}

object oTarget = GetSpellTargetObject();

/////Make sure we target an arrow or bolt////////////////////
if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM) return;
if (GetBaseItemType(oTarget) != BASE_ITEM_ARROW && GetBaseItemType(oTarget) != BASE_ITEM_BOLT)return;
////////////////////////////////////////////////////////////


if (GetBaseItemType(oTarget) == BASE_ITEM_ARROW)
{

SetItemStackSize(oTarget,GetItemStackSize(oTarget) -1);
oTarget = CreateItemOnObject("sh_mi_darkflame_arrow",oPC,1,"",TRUE);
}
else
{

SetItemStackSize(oTarget,GetItemStackSize(oTarget) -1);
oTarget = CreateItemOnObject("sh_mi_darkflame_bolt",oPC,1,"",TRUE);
}



DelayCommand(RoundsToSeconds(nDuration),DestroyObject(oTarget));

SetItemCursedFlag(oTarget,TRUE);
}