#include "elu_skills_i"

void main(int nSkillID, string sClassSkill, string sSkillName)
{
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	string sSkillID = IntToString(nSkillID);

	int nUnallocatedPoints = GetGUIAvailableSkillPoints(oControlledChar);
	int nSpentPoints = GetLocalInt(oControlledChar, SPENT_SKILL_POINTS);
	if (nSpentPoints == 0)
		return;
	int nSkillLevelsBought = GetLocalInt(oControlledChar, SKILL_LEVELS_BOUGHT + sSkillID);
	if (nSkillLevelsBought == 0)
		return;
	int nPointCost = -1;
	int bHasAbleLearner = GetHasFeat(1774, oControlledChar);
	if (sClassSkill == "0" && !bHasAbleLearner)
		nPointCost = -2;
	PlaySound("gui_button");
	AdjustGUISkillRank(oControlledChar, nSkillID, nSkillLevelsBought, nSpentPoints, nPointCost);
	SetGUIUnAllocatedSkillPoints(nUnallocatedPoints - nPointCost);
}