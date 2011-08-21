#include "elu_spells_i"

void main(int nSpellID)
{
	string sName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellID)));
	string sDesc = GetStringByStrRef(StringToInt(Get2DAString("spells","SpellDesc",nSpellID)));	
	string sImage = Get2DAString("spells", "IconResRef", nSpellID) + ".tga";
	SetGUITexture(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, "INFOPANE_IMAGE", sImage);
	SetGUIObjectText(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, "INFOPANE_TITLE", -1, sName);
	SetGUIObjectText(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, "INFOPANE_TEXT", -1, sDesc);
}