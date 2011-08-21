#include "elu_skills_i"

void main()
{
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	int nClass = GetLocalInt(oControlledChar, LAST_SELECTED_CLASS);
	string packageline = Get2DAString("classes", "Package", nClass);

	if (packageline != "****" && packageline != "")
	{
		string skillpackage = Get2DAString("packages", "SkillPref2DA", StringToInt(packageline));
		if (skillpackage != "****" && skillpackage != "")
		{
			AllocateSkillPointsByPackage(oControlledChar, skillpackage, nClass);
			return;
		}
	}
	WriteTimestampedLogEntry("WARNING: There is no skill package associated with ClassID:" + IntToString(nClass));
	AllocateSkillPoints(oControlledChar, nClass);
}