//#include "pm_spellfeats_i"

void main()
{
	if (!GetLocalInt(OBJECT_SELF, "FEAT_FAM_IMPINTIMIDATE"))
	{
		effect e = ExtraordinaryEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 3));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, e, OBJECT_SELF);
		SetLocalInt(OBJECT_SELF, "FEAT_FAM_IMPINTIMIDATE", 1);
	}
	//AddFeatSkillBonusToSkin("FEAT_FAM_IMPAPPRAISE", SKILL_APPRAISE, 3);
}