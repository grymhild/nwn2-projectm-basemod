/*
Draconic Might
Sean Harrington
11/11/07
#1375
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
if (GetLevelByClass(CLASS_TYPE_SORCERER,oPC) > 0) nCasterLevel = nCasterLevel +1; //sorcs cast at +1 level
int			nDuration 		= nCasterLevel*60;
if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}
effect 		eStr			= EffectAbilityIncrease(ABILITY_STRENGTH,4);
effect 		eCon			= EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
effect 		eCha			= EffectAbilityIncrease(ABILITY_CHARISMA,4);
effect		ePara			= EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
effect		eSleep			= EffectImmunity(IMMUNITY_TYPE_SLEEP);
effect 		eAC				= EffectACIncrease(4,AC_NATURAL_BONUS);
effect		eLink			= EffectLinkEffects(eStr,eCon);
			eLink			= EffectLinkEffects(eLink,eCha);
			eLink			= EffectLinkEffects(eLink,ePara);
			eLink			= EffectLinkEffects(eLink,eSleep);
			eLink			= EffectLinkEffects(eLink,eAC);

HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,IntToFloat(nDuration));




}