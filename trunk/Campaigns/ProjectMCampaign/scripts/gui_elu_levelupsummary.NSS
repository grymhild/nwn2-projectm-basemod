#include "elu_spells_i"
#include "elu_feats_i"
#include "elu_skills_i"

void main()
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	string sClassText = GetClassSummaryText(oChar);
	string sSkillText = GetSkillsSummaryText(oChar);
	string sFeatText = GetFeatSummaryText(oChar);
	string sSpellText = GetSpellSummaryText(oChar);
	string sText = sClassText + "\n" + sSkillText + "\n" + sFeatText + "\n" + sSpellText;
	SetGUIObjectText(OBJECT_SELF, "SCREEN_LEVELUP_FINISH", "INFOPANE_TEXT2", -1, sText);
}