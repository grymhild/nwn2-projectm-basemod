/*
Ectoplasmic Armor
Sean Harrington
11/11/07
#1377
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
int			nDuration 		= nCasterLevel*3600;


if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}

int 		nAmount 		= 5 + (nCasterLevel /4);

effect eArmor = EffectACIncrease(nAmount,AC_DODGE_BONUS,DAMAGE_TYPE_ALL,TRUE);



HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eArmor,oTarget,IntToFloat(nDuration));


}