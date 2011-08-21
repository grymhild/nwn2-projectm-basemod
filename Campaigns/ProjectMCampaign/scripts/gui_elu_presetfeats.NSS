#include "elu_feats_i"

void AddCategoryHeaders(object oLB)
{
	string sCategoryText = GetStringByStrRef(112967); //General Feats
	CSLAddListBoxHeader(oLB, "GENERAL_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112968); //Proficiency Feats
	CSLAddListBoxHeader(oLB, "PROFICIENCY_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112969); //Spellcasting Feats
	CSLAddListBoxHeader(oLB, "SPELLCASTING_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112970); //Metamagic Feats
	CSLAddListBoxHeader(oLB, "METAMAGIC_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112971); //Item Creation Feats
	CSLAddListBoxHeader(oLB, "ITEMCREATION_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112972); //Divine Feats
	CSLAddListBoxHeader(oLB, "DIVINE_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112973); //Skill and Save Feats
	CSLAddListBoxHeader(oLB, "SKILLNSAVE_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(112977); //Class Ability Feats
	CSLAddListBoxHeader(oLB, "CLASSABILITY_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(185467); //Epic Feats
	CSLAddListBoxHeader(oLB, "EPIC_FT_CAT", sCategoryText);
	sCategoryText = GetStringByStrRef(225360); //Heritage Feats
	CSLAddListBoxHeader(oLB, "HERITAGE_FT_CAT", sCategoryText);
}

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_presetfeats");

	object oPC = GetControlledCharacter(OBJECT_SELF);
	int nLevel = CSLGetTotalClassLevels(oPC) + 1;
	int bShowBonusFeats = GetHasBonusFeatsThisLevel(oPC);
	int bShowNormalFeats = (nLevel % 3 == 0);
	int nSelectedClass = GetLocalInt(oPC, LAST_SELECTED_CLASS);
	int nPreSelectedClassLvl = GetLevelByClass(nSelectedClass, oPC);	
	int nNormalFeatCount = 1;
	if (nLevel > 21)
	{
		bShowNormalFeats = FALSE;
		if (nLevel % 2 == 1)
		{
			h2_LogMessage(H2_LOG_DEBUG, "Epic level, on odd level, normal feat.");		
			bShowNormalFeats = TRUE;
		}
		if (nPreSelectedClassLvl + 1 > 20)		
		{
			string sBFeats = Get2DAString("classes","BonusFeatsTable",nSelectedClass);
			string sEpicFeat = Get2DAString(sBFeats, "Normal", nPreSelectedClassLvl); //Don't add +1, cls_bfeat_* is zer o based.
			if (sEpicFeat != "0")
			{
				if (bShowNormalFeats)
					nNormalFeatCount++;
				else
					bShowNormalFeats = TRUE;
			}
		}
	}
	
	if (!bShowNormalFeats && !bShowBonusFeats)
	{
		h2_LogMessage(H2_LOG_DEBUG, "No normal or bonus feats to show at this level, aborting.");
		return; //Don't run the rest if no feats are to be selected during this level.
	}	
	h2_LogMessage(H2_LOG_DEBUG, "Preparing feat lists.");
	
	DeleteLocalInt(oPC, "BonusFeatCount");
	ClearAddedFeats(oPC);
	
	object oLB, oLBBonusAvailableFeats, oLBBonusAddedFeats, oLBNormalAvailableFeats, oLBNormalAddedFeats;
	
	if (bShowBonusFeats)
	{
		string sClsBFeat = Get2DAString("classes", "BonusFeatsTable", nSelectedClass);
		int nBonusFeatCount = StringToInt(Get2DAString(sClsBFeat, "Bonus", nPreSelectedClassLvl));
		SetLocalInt(oPC, "BonusFeatCount", nBonusFeatCount);

		oLB = CSLCreateListBoxObject(oPC, "SCREEN_LEVELUP_BONUS_FEATS", "CUSTOM_AVAILABLE_FEAT_LIST", "FEAT_ACTION,FEAT_TEXT,FEAT_IMAGE");
		CSLDefineListBoxHeaders(oLB, "FEAT_HEADER","b_col_closed1.tga","b_col_open1.tga");
		AddCategoryHeaders(oLB);

		oLB = CSLCreateListBoxObject(oPC, "SCREEN_LEVELUP_BONUS_FEATS", "CUSTOM_ADDED_FEAT_LIST", "FEAT_ACTION,FEAT_TEXT,FEAT_IMAGE");
		CSLDefineListBoxHeaders(oLB, "FEAT_HEADER","b_col_closed1.tga","b_col_open1.tga");
		AddCategoryHeaders(oLB);
		
		oLBBonusAvailableFeats = CSLGetListBoxObject(oPC, "SCREEN_LEVELUP_BONUS_FEATS", "CUSTOM_AVAILABLE_FEAT_LIST");
		oLBBonusAddedFeats = CSLGetListBoxObject(oPC, "SCREEN_LEVELUP_BONUS_FEATS", "CUSTOM_ADDED_FEAT_LIST");
	}
	else
		SetLocalInt(oPC, "BonusFeatCount", nNormalFeatCount);

	if (bShowNormalFeats) //show normal feats
	{
		oLB = CSLCreateListBoxObject(oPC, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_ADDED_FEAT_LIST", "FEAT_ACTION,FEAT_TEXT,FEAT_IMAGE");
		CSLDefineListBoxHeaders(oLB, "FEAT_HEADER","b_col_closed1.tga","b_col_open1.tga");
		AddCategoryHeaders(oLB);

		oLB = CSLCreateListBoxObject(oPC, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_AVAILABLE_FEAT_LIST", "FEAT_ACTION,FEAT_TEXT,FEAT_IMAGE");
		CSLDefineListBoxHeaders(oLB, "FEAT_HEADER","b_col_closed1.tga","b_col_open1.tga");
		AddCategoryHeaders(oLB);
		
		oLBNormalAvailableFeats = CSLGetListBoxObject(oPC, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_AVAILABLE_FEAT_LIST");
		oLBNormalAddedFeats = CSLGetListBoxObject(oPC, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_ADDED_FEAT_LIST");
	}

	int nClass1 = GetClassByPosition(1, oPC);
	int nClass2 = GetClassByPosition(2, oPC);
	int nClass3 = GetClassByPosition(3, oPC);
	int nClass4 = GetClassByPosition(4, oPC);
	if (nSelectedClass != nClass1)
	{
		if (nSelectedClass != nClass2)
		{
			if (nClass2 == 255)
				nClass2 = nSelectedClass;
			else if (nSelectedClass != nClass3)
			{
				if (nClass3 == 255)
					nClass3 = nSelectedClass;
			}
		}
	}

	int nClassLvl1 = GetLevelByClass(nClass1, oPC) + (nSelectedClass == nClass1);
	int nClassLvl2 = GetLevelByClass(nClass2, oPC) + (nSelectedClass == nClass2);
	int nClassLvl3 = GetLevelByClass(nClass3, oPC) + (nSelectedClass == nClass3);
	int nClassLvl4 = GetLevelByClass(nClass4, oPC) + (nSelectedClass == nClass4);

	int nBAB = GetAdjustedBAB(oPC, nSelectedClass, nPreSelectedClassLvl);

	string sSaveThrowTable = Get2DAString("classes", "SavingThrowTable", nSelectedClass);
	int nFortSave = GetAdjustedFortSave(oPC, nSelectedClass, nPreSelectedClassLvl, sSaveThrowTable);
	int nRefSave = GetAdjustedRefSave(oPC, nSelectedClass, nPreSelectedClassLvl, sSaveThrowTable);
	int nWillSave = GetAdjustedWillSave(oPC, nSelectedClass, nPreSelectedClassLvl, sSaveThrowTable);

	int nStatBonus = GetLocalInt(oPC, LVL_STATBUMP);
	int nStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) + (nStatBonus == 1);
	int nDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) + (nStatBonus == 2);
	int nCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) + (nStatBonus == 3);
	int nWis = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) + (nStatBonus == 4);
	int nInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) + (nStatBonus == 5);
	int nCha = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) + (nStatBonus == 6);


	int nCasterLevel = GetLocalInt(oPC, "SC_iCasterLevels");
	int nBestCasterClass = GetLocalInt(oPC, "SC_iBestCasterClass");

	int nAdj = GetCasterLevelAdjustment(oPC, nBestCasterClass, nLevel, nClass1, nClass2, nClass3, nClass4,
											  nClassLvl1, nClassLvl2, nClassLvl3, nClassLvl4, nSelectedClass);
	int nAdjBestCasterLvl = nCasterLevel + nAdj;
	int nSpellLevel = GetAdjustedSpellLevel(oPC, nAdjBestCasterLvl, nBestCasterClass, nWis, nInt, nCha);

	SetLocalInt(oPC, "SELECTED_FEAT", -1);
	
	int nStartIndex = 0;
	int nSegmentSize = 150; //183; //Could go higher. 200 is known to be too high for epic feats.
	DeleteLocalInt(GetModule(), "FEATSAREAVAILABLE");
	AddAvailableFeats(oPC, bShowBonusFeats, bShowNormalFeats, nLevel, 
		nClass1, nClass2, nClass3, nClass4, nClassLvl1, nClassLvl2, nClassLvl3, nClassLvl4, 
		nSpellLevel, nAdjBestCasterLvl, nSelectedClass, nPreSelectedClassLvl + 1,
		nBAB, nStr, nDex, nCon, nWis, nInt, nCha, nFortSave, nRefSave, nWillSave, 
		oLBBonusAvailableFeats, oLBBonusAddedFeats, oLBNormalAvailableFeats, oLBNormalAddedFeats, 
		nStartIndex, nSegmentSize);
}