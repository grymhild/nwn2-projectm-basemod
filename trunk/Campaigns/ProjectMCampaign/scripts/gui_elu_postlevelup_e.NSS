#include "elu_skills_i"
#include "elu_feats_i"
#include "elu_spells_i"

void main()
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	int bPreLevelUpFlag = GetLocalInt(oChar, PRELEVELUP_FLAG);
	if (!bPreLevelUpFlag)
	{
		string sLogMsg = "WARNING: " + GetPCPlayerName(OBJECT_SELF) + " " + GetName(oChar) + " reached OnPostLevelUp without having PreLevelUp flag set.";
		h2_LogMessage(H2_LOG_DEBUG, sLogMsg);
		return;
	}
	DeleteLocalInt(oChar, PRELEVELUP_FLAG);
	AssignPuchasedSkillLevels(oChar);
	AssignPurchasedFeats(oChar);
	DelayCommand(0.1, AssignPurchasedSpells(oChar));

	SCCacheStats( oChar );

	//Do additional OnPostLevelUp work here

	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_postlevelup_e");
}