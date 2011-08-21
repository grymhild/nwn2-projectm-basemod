/*
Close Wounds
Sean Harrington
11/10/07
#1360
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
int			nHeal			= d4(1);
int			nCurrent		= GetCurrentHitPoints(oTarget);


if (HkGetMetaMagicFeat() == METAMAGIC_MAXIMIZE)
{
nHeal = 4;
}
if (HkGetMetaMagicFeat() == METAMAGIC_EMPOWER)
{
nHeal = d6(1);
}

if (nCasterLevel > 5) nHeal = nHeal +5;
else
{
nHeal = nHeal + nCasterLevel;
}

if(nCurrent < 1)
{
nHeal = 1 - nCurrent;
}

/////////////////////if they are undead ////////////////////////////////////////
if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetSubRace(oTarget) == RACIAL_SUBTYPE_UNDEAD)
{

int nTouch = TouchAttackMelee(oTarget,TRUE);
if (nTouch == TOUCH_ATTACK_RESULT_MISS)return;
if(HkResistSpell(OBJECT_SELF, oTarget))return;
if (HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_POSITIVE))
{
nHeal = nHeal /2;
}
effect eHarm = EffectDamage(nHeal,DAMAGE_TYPE_POSITIVE,DAMAGE_POWER_NORMAL);
HkApplyEffectToObject(DURATION_TYPE_INSTANT,eHarm,oTarget);
return;
}
//////////////////////////////////////////////////////////////////////////////////////

else
{
effect eHeal = EffectHeal(nHeal);
HkApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oTarget);
return;
}
}