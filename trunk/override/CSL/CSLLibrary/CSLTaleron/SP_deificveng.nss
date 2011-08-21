/*
Deific Vengeance
Sean Harrington
11/10/07
#1369
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
effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);


if (HkResistSpell(oPC, oTarget)) return;
////////////////////////Damage Declaration//////////////////////////

int 		nDice 			= nCasterLevel /2;
	if (nDice > 5) nDice = 5;

if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
	{
	nDice = nCasterLevel;
	if (nDice > 10) nDice = 10;
	}


int	nDamage			= d6 (nDice);


if (HkGetMetaMagicFeat() == METAMAGIC_EMPOWER)
	{
	nDamage			= nDamage + (nDamage /2);
	}
if (HkGetMetaMagicFeat() == METAMAGIC_MAXIMIZE)
	{
	nDamage			=	6 * nDice;
	}

if (HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DIVINE,oPC))
{
nDamage = nDamage /2;
}
effect eDamage	= EffectDamage(nDamage,DAMAGE_TYPE_DIVINE,DAMAGE_POWER_NORMAL,FALSE);
///////////////////////////////////////////////////////////////////////

HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);



}