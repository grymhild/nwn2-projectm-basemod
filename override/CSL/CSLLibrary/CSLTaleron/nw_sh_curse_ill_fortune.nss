
/*
Curse of Ill Fortune
Sean Harrington
11/10/07
#1364
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
int			nDuration		= FloatToInt(TurnsToSeconds(nCasterLevel));
int 		nCurse			= 3;
effect		eAttack			= EffectAttackDecrease(nCurse);
effect		eSave			= EffectSavingThrowDecrease(SAVING_THROW_ALL,nCurse,SAVING_THROW_TYPE_ALL);
effect		eSkill			= EffectSkillDecrease(SKILL_ALL_SKILLS,nCurse);
effect 	eVis			= EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE );
effect		eCurse			= EffectCurse(0,0,0,0,0,0);
effect		eLink			= EffectLinkEffects(eAttack,eSkill);
			eLink			= EffectLinkEffects(eLink,eSave);
			eLink			= EffectLinkEffects(eLink,eVis);
			eLink			= EffectLinkEffects(eLink,eCurse);

if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration * 2;
}
if (HkGetMetaMagicFeat() == METAMAGIC_PERSISTENT)
{nDuration = FloatToInt(HoursToSeconds(24));}




if (!HkResistSpell(oPC, oTarget))
	{
	if (HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oPC))
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,IntToFloat(nDuration));
		}
	}
}