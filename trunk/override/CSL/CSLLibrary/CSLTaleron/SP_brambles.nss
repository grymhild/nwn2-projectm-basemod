/*
Brambles
Sean Harrington
11/10/07
#1356
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
int			nCasterLevel	= HkGetCasterLevel(oPC);
int			nDuration 		= nCasterLevel*6;

if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}
if (HkGetMetaMagicFeat() == METAMAGIC_PERSISTENT)
{nDuration = nDuration * 10 * 60 * 24;}


if (!GetIsObjectValid(oTarget))return;
if (GetIsPC(oTarget))oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
if (!GetIsObjectValid(oTarget))return;
if(GetBaseItemType(oTarget) != BASE_ITEM_CLUB && GetBaseItemType(oTarget) != BASE_ITEM_QUARTERSTAFF)return;

int nDamage;
if (nCasterLevel < 6) nDamage = nCasterLevel;
if (nCasterLevel > 5) nDamage = nCasterLevel + 10;
if (nDamage > 20) nDamage = 20;



itemproperty ipMelee 	= ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_PIERCING);
itemproperty ipDamage	= ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING,nDamage);
itemproperty ipEnhance	= ItemPropertyEnhancementBonus(1);

AddItemProperty(DURATION_TYPE_TEMPORARY, ipMelee, oTarget, IntToFloat(nDuration));
AddItemProperty(DURATION_TYPE_TEMPORARY, ipDamage, oTarget, IntToFloat(nDuration));
AddItemProperty(DURATION_TYPE_TEMPORARY, ipEnhance, oTarget, IntToFloat(nDuration));
}