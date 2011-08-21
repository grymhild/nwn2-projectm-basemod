/*
Burning Sword
Sean Harrington
11/10/07
#1357
*/
//#include "nw_i0_spells"
//#include "x2_i0_spells"
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
int			nDuration 		= nCasterLevel*60;
int nNormalDamage = IP_CONST_DAMAGEBONUS_1d6;
int nCriticalDamage = 	IP_CONST_DAMAGEBONUS_1d6;


if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
	{nDuration = nDuration *2;}

if (HkGetMetaMagicFeat() == METAMAGIC_PERSISTENT)
	{nDuration = FloatToInt(HoursToSeconds(24));}

/*if (HkGetMetaMagicFeat() == METAMAGIC_MAXIMIZE)
{
	nNormalDamage = IP_CONST_DAMAGEBONUS_6;
	nCriticalDamage = 	IP_CONST_DAMAGEBONUS_10;
}

if (HkGetMetaMagicFeat() == METAMAGIC_EMPOWER)
{
	nNormalDamage = IP_CONST_DAMAGEBONUS_1d10;
	nCriticalDamage = 	IP_CONST_DAMAGEBONUS_2d8;
}

*/


object oMyWeapon 	= IPGetTargetedOrEquippedMeleeWeapon();

	if(GetIsObjectValid(oMyWeapon) )
	{


		if (nDuration > 0)
		{
			itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nNormalDamage);
			CSLSafeAddItemProperty(oMyWeapon, ipFlame, IntToFloat(nDuration), SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
						ipFlame = ItemPropertyMassiveCritical(nCriticalDamage);
			CSLSafeAddItemProperty(oMyWeapon, ipFlame, IntToFloat(nDuration), SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
						ipFlame	= ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT,IP_CONST_LIGHTCOLOR_RED);
			CSLSafeAddItemProperty(oMyWeapon, ipFlame, IntToFloat(nDuration), SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
		return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	}
}