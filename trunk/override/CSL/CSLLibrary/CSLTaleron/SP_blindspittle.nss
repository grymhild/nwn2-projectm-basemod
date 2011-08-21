/*
Blinding Spittle
Sean Harrington
11/10/07
#1353
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
effect 		eVis 			= EffectVisualEffect(VFX_HIT_SPELL_ACID);
effect 		eRay			= EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_CHEST);
effect 	eBlind			= EffectBlindness();
int 		nTouch 		= TouchAttackRanged(oTarget,TRUE,-4);


HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5);


if (nTouch != TOUCH_ATTACK_RESULT_MISS)
{
if(!HkResistSpell(OBJECT_SELF, oTarget))
{
if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT
	|| GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL || GetRacialType(oTarget) == RACIAL_TYPE_OOZE)
{
SendMessageToPC(oPC,"Target Cannot Be Blinded");
return;
}

HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);




}}}