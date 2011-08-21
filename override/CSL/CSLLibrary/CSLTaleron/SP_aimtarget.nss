/*
Aiming at the target
Sean Harrington
11/10/07
#1341
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
	
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	int nDuration = GetSkillRank(SKILL_CONCENTRATION,OBJECT_SELF,FALSE);



	if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
	{nDuration = nDuration *2;} //40 minutes
	if (HkGetMetaMagicFeat() == METAMAGIC_PERSISTENT)
	{nDuration = 24*60;}



effect eDur = EffectVisualEffect( VFX_DUR_SPELL_OWL_INSIGHT );
effect eConcentrate = EffectSkillIncrease(SKILL_CONCENTRATION,6);
effect eLink = EffectLinkEffects(eConcentrate, eDur);

//if(!GetHasSpellEffect(1341, oTarget) )//Prevent stacking
//{
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink, OBJECT_SELF, TurnsToSeconds(nDuration));
//}







}