/*
Alegro
Sean Harrington
11/11/07
#1342
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
	
	int nDuration = HkGetCasterLevel(OBJECT_SELF); //1 Turn / Level
	if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
	{nDuration = nDuration *2;}

object oPC = OBJECT_SELF;
effect eMovement = EffectMovementSpeedIncrease(30);
effect eDur = EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT );
effect eLink = EffectLinkEffects(eMovement, eDur);
location lLocation = GetLocation(OBJECT_SELF);


object oItem = GetItemPossessedBy(oPC,"sh_i_tail_feather_bop");
/*if (!GetIsObjectValid(oItem))
	{
	SendMessageToPC(oPC,"You must possess a tail feather from a bird of prey to cast this spell");
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

object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,7.0,lLocation,FALSE,OBJECT_TYPE_CREATURE);

while (GetIsObjectValid(oTarget))
{
if(!GetHasSpellEffect(1342, oTarget) )//Prevent stacking
{
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}
oTarget = GetNextObjectInShape(SHAPE_SPHERE,7.0,lLocation,FALSE,OBJECT_TYPE_CREATURE);
}
}