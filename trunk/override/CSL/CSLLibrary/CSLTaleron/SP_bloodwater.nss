/*
blood to water
Sean Harrington
11/10/07
#1354
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
object 		oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE);
int			oCasterLevel	= HkGetCasterLevel(oPC);
int			nDuration 		= oCasterLevel;
int 		nDamage;
effect		eConDamage;
effect 		eVis 			= EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
int			nCounter		= 1;


while (GetIsObjectValid(oTarget))
{
if(!HkResistSpell(OBJECT_SELF, oTarget))
{
if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT
	&& GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL && GetSubRace(oTarget) != RACIAL_SUBTYPE_FIRE_GENASI
	&& GetSubRace(oTarget) != RACIAL_SUBTYPE_WATER_GENASI)
{
	if (nCounter == 6) return;
	nDamage			= d6(2);
	if (HkGetMetaMagicFeat() == METAMAGIC_EMPOWER) nDamage 	= nDamage + d6(1);
	if (HkGetMetaMagicFeat() == METAMAGIC_MAXIMIZE) nDamage 	= 12;
	if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)	nDuration	= nDuration *2;
	if (HkSavingThrow	(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))nDamage = nDamage /2;

			eConDamage		= EffectAbilityDecrease(ABILITY_CONSTITUTION,nDamage);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eConDamage,oTarget,HoursToSeconds(24));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}}
nCounter = nCounter +1;
oTarget 		= GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE);
}



}