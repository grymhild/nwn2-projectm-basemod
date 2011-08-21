/*
Blessings Of Bahamut
Sean Harrington
11/10/07
#1352
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
object 		oTarget 		= GetSpellTargetObject();
location 	lLocation		= GetSpellTargetLocation();
int			oCasterLevel	= HkGetCasterLevel(oPC);
int			nDuration 		= oCasterLevel*6;

if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
{
SendMessageToPC(oPC,"This spell will not work for you because of your alignment");
return;

}

if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}


object oItem = GetItemPossessedBy(oPC,"sh_i_canary_feather");
/*if (!GetIsObjectValid(oItem))
	{
	SendMessageToPC(oPC,"You must possess a canary feather to cast this spell");
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

effect		eDamageReduct 	= EffectDamageReduction(10,DAMAGE_TYPE_MAGICAL,0,DR_TYPE_DMGTYPE);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamageReduct, oPC, IntToFloat(nDuration));






}