#include "elu_spells_i"
#include "csl_listbox_i"

void main(int nClass)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	SetLocalInt(oChar, LAST_SELECTED_CLASS, nClass);
	DeleteLocalInt(oChar, LVL_STATBUMP);
	object oLB = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_BONUS_FEATS", "CUSTOM_ADDED_FEAT_LIST");
	DestroyObject(oLB);
	oLB = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_BONUS_FEATS", "CUSTOM_AVAILABLE_FEAT_LIST");
	DestroyObject(oLB);
	oLB = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_ADDED_FEAT_LIST");
	DestroyObject(oLB);
	oLB = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_AVAILABLE_FEAT_LIST");
	DestroyObject(oLB);
	
	int i;
	for (i = 0; i < 10; i++)
	{
		string sLevel = IntToString(i);
		object oLB = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_SPELLS", CUSTOM_ADDED_SPELL_LIST_ + sLevel);
		DestroyObject(oLB);
		oLB = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_SPELLS", CUSTOM_AVAILABLE_SPELL_LIST_ + sLevel);
		DestroyObject(oLB);
		DeleteLocalInt(oChar, SPELL_LEVEL + sLevel);
	}
	DeleteLocalInt(oChar, DONE_PROCESSING_SPELLS);
	ClearAddedSpells(oChar);
}