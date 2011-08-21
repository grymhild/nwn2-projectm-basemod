/*
Divine Agility
Sean Harrington
11/11/07
#1373
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
int			nDuration 		= nCasterLevel;
effect		eDex			= EffectAbilityIncrease(ABILITY_DEXTERITY,10);


if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) return;
if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) return;
if (GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL) return;


if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}


HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, RoundsToSeconds(nDuration));







}