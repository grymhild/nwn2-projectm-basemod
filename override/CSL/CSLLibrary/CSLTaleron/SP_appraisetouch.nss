/*
Appraising Touch
Sean Harrington
11/10/07
#1344
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
int			nDuration		= nCasterLevel;

if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{nDuration = nDuration * 2;}
if (HkGetMetaMagicFeat() == METAMAGIC_PERSISTENT)
{nDuration = 24;}

effect		eSkill			= EffectSkillIncrease(SKILL_APPRAISE,10);
if(!GetHasSpellEffect(1344, oTarget) )
{
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSkill,oTarget, HoursToSeconds(nDuration));
}

effect eHit = EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);
HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);

}