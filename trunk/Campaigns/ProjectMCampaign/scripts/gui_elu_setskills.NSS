#include "elu_skills_i"

void main()
{	
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_setskills");

	int i = 0;
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	SetLocalInt(oControlledChar, "SELECTED_SKILL", -1);
	int nClass = GetLocalInt(oControlledChar, LAST_SELECTED_CLASS);
	object oSDP =  GetObjectByTag(SKILL_DATA_POINT);
	int nBaseSkillPoints = StringToInt(Get2DAString("classes", "SkillPointBase", nClass));
	SetLocalInt(oControlledChar, BASE_SKILL_POINTS, nBaseSkillPoints);
	DeleteLocalInt(oControlledChar, SPENT_SKILL_POINTS);

	int nSkillPoints = GetGUIAvailableSkillPoints(oControlledChar);

	string sSkillPoints = IntToString(nSkillPoints);
	SetGUIObjectText(OBJECT_SELF, "SCREEN_LEVELUP_SKILLS", "POINT_POOL_TEXT", -1, sSkillPoints);
	int bDisabled = (nSkillPoints > 5);
	SetGUIObjectDisabled(OBJECT_SELF, "SCREEN_LEVELUP_SKILLS","CHOICE_NEXT", bDisabled);
	string sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));

	while (sSkillValues != "")
	{
		int n1 = FindSubString(sSkillValues, ":");
		string sSkillName = GetStringLeft(sSkillValues, n1);
		int n2 = FindSubString(sSkillValues, ":", n1+1);
		string sSkillID = GetSubString(sSkillValues, n1+1, n2-(n1+1));
		int n3 = FindSubString(sSkillValues, ";");
		string sImage = GetSubString(sSkillValues, n2+1, n3-(n2+1));
		string sSkillRank = IntToString(GetSkillRank(StringToInt(sSkillID), oControlledChar, TRUE));
		int n = FindSubString(sSkillValues, ";" + IntToString(nClass) + ";");
		string sTextFields;
		string sHideUnhide;
		string cs = "0";
		if (n == -1)
		{
			sTextFields = "SKILL_TEXT_CC=" + sSkillName + ";SKILL_RANK=" + sSkillRank;
			sHideUnhide ="SKILL_TEXT_CS=hide;SKILL_TEXT_CC=unhide;SKILL_TEXT_NA=hide";
		}
		else
		{
			cs = "1";
			sTextFields = "SKILL_TEXT_CS=" + sSkillName + ";SKILL_RANK=" + sSkillRank;
			sHideUnhide ="SKILL_TEXT_CS=unhide;SKILL_TEXT_CC=hide;SKILL_TEXT_NA=hide";
		}
		string sVariables = "0=" + sSkillID + ";1=" + cs + ";2=" + sSkillName;
		string sTextures = "SKILL_IMAGE=" + sImage;
		DeleteLocalInt(oControlledChar,SKILL_LEVELS_BOUGHT + sSkillID);

		//WriteTimestampedLogEntry(sSkillID + " " + sTextFields + " " + sVariables);

		AddListBoxRow(OBJECT_SELF, "SCREEN_LEVELUP_SKILLS", "CUSTOM_SKILLPANE_LIST", sSkillID, sTextFields, sTextures, sVariables, sHideUnhide);
		i++;
		sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	}
	h2_LogMessage(H2_LOG_DEBUG, "Finshed gui_elu_setskills");
}