/*
Delusions Of Grandeur
Sean Harrington
11/10/07
#1370
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
int 		nDuration		= nCasterLevel*600;
effect		eAttack			= EffectAttackDecrease(2);
effect		eSave			= EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
effect		eSkill			= EffectSkillDecrease(SKILL_ALL_SKILLS,2);
effect		eWisdom			= EffectAbilityDecrease(ABILITY_WISDOM,2);
effect		eLink			= EffectLinkEffects(eAttack,eSave);
			eLink			= EffectLinkEffects(eLink,eSkill);
			eLink			= EffectLinkEffects(eLink,eWisdom);
effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE );


if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration * 2;
}


if (HkResistSpell(oPC, oTarget))return;


if (HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS,oPC))return;

HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,IntToFloat(nDuration));
HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);



}