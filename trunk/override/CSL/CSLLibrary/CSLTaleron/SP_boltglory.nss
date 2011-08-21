//#include "sh_custom_functions"
//#include "nwn2_inc_spells"
//#include "x2_inc_spellhook"
//#include "nw_i0_spells"


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
	
	object 	oPC 			= OBJECT_SELF;
object 	oTarget 		= GetSpellTargetObject();
//float 	fDuration 		= IntToFloat(HkGetCasterLevel(oPC)) * 600.0 ; //10 min per level
//int 	nDurType 		= HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
//		fDuration 		= HkApplyMetamagicDurationMods(fDuration);


if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
{
SendMessageToPC(OBJECT_SELF,"This spell will not work for you because of your alignment");
return;
}




//Set the damage based on race//////////////////////////////////////////////////////////////////
int		nDamageDice		= HkGetCasterLevel(oPC) /2;
if 		(nDamageDice > 7) nDamageDice = 7;
if 		(GetRacialType(oTarget) == 	RACIAL_TYPE_UNDEAD ) nDamageDice = nDamageDice *2;
if 		(GetRacialType(oTarget) == 	RACIAL_TYPE_OUTSIDER && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) nDamageDice = nDamageDice *2;
if 		(GetRacialType(oTarget) == 	RACIAL_TYPE_OUTSIDER && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) nDamageDice = 0;
if 		(GetSubRace(oTarget) == RACIAL_SUBTYPE_UNDEAD ) nDamageDice = nDamageDice *2;
if 		(GetSubRace(oTarget) == RACIAL_SUBTYPE_OUTSIDER && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) nDamageDice = nDamageDice *2;
if 		(GetSubRace(oTarget) == RACIAL_SUBTYPE_OUTSIDER && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) nDamageDice = 0;
if		(nDamageDice > 15) nDamageDice = 15;
///////////////////////////////////////////////////////////////////////////////////////////////////




// Ray spells require a ranged touch attack
if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS && !HkResistSpell(OBJECT_SELF, oTarget))
	{
effect 		eDamage 	= EffectDamage(d6(nDamageDice),DAMAGE_TYPE_POSITIVE);
effect 	eRay 		= EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	}









}