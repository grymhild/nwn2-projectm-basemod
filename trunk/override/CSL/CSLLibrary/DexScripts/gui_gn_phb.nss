/*
	PLAYER'S HANDBOOK
	gui_gn_phb.nss
	
	gaoneng
	February 25th, 2007

	source code for Player's Handbook
*/

// constants
const string GN_SCREEN_PHB = "SCREEN_PLAYERSHANDBOOK";

const string GN_PANE_SUBMENU_RACE  = "SUBMENU_RC_PANE";
const string GN_PANE_SUBMENU_CLASS = "SUBMENU_CL_PANE";
const string GN_PANE_SUBMENU_STAT  = "SUBMENU_ST_PANE";
const string GN_PANE_SUBMENU_FEAT  = "SUBMENU_FT_PANE";
const string GN_PANE_SUBMENU_SPELL = "SUBMENU_SP_PANE";

const string GN_PANE_RIGHTPAGE = "DETAILS_PANE";

const string GN_PANE_FILTER_ALPHA  = "FILTER_ALP_PANE";
const string GN_PANE_FILTER_NUM    = "FILTER_NUM_PANE";

const string GN_BUTTON_PG_PREV     = "FILTER_PG_PREV";
const string GN_BUTTON_PG_NEXT     = "FILTER_PG_NEXT";
const string GN_BUTTON_SPELLTOGGLE = "FILTER_SPELLTOGGLE";

const string GN_ICO_RACE  = "MAINICON_RACE";        // temporary main icon constants
const string GN_ICO_CLASS = "MAINICON_CLASS";
const string GN_ICO_STAT  = "MAINICON_STAT";
const string GN_ICO_FEAT  = "MAINICON_FEAT";
const string GN_ICO_SPELL = "MAINICON_SPELL";

const string GN_ICO_FTBG  = "MAINICON_FTBG";
const string GN_ICO_FTCL  = "MAINICON_FTCL";
const string GN_ICO_FTDV  = "MAINICON_FTDV";
const string GN_ICO_FTGN  = "MAINICON_FTGN";
const string GN_ICO_FTHI  = "MAINICON_FTHI";
const string GN_ICO_FTIT  = "MAINICON_FTIT";
const string GN_ICO_FTMM  = "MAINICON_FTMM";
const string GN_ICO_FTPF  = "MAINICON_FTPF";
const string GN_ICO_FTRC  = "MAINICON_FTRC";
const string GN_ICO_FTSK  = "MAINICON_FTSK";
const string GN_ICO_FTSP  = "MAINICON_FTSP";

const string GN_ICO_SPBD  = "MAINICON_SPBD";
const string GN_ICO_SPCL  = "MAINICON_SPCL";
const string GN_ICO_SPDR  = "MAINICON_SPDR";
const string GN_ICO_SPPD  = "MAINICON_SPPD";
const string GN_ICO_SPRG  = "MAINICON_SPRG";
const string GN_ICO_SPSC  = "MAINICON_SPSC";
const string GN_ICO_SPWL  = "MAINICON_SPWL";
const string GN_ICO_SPWZ  = "MAINICON_SPWZ";

const string GN_ICO_STSK  = "MAINICON_STSK";
const string GN_ICO_STAB  = "MAINICON_STAB";

const string GN_ICO_CLBC  = "MAINICON_CLBC";
const string GN_ICO_CLPC  = "MAINICON_CLPC";

const string GN_ICO_RCRC  = "MAINICON_RCRC";
const string GN_ICO_RCRS  = "MAINICON_RCRS";


// updates the text field and the icon in left page top bar
// pre 1.06 temp
void gn_UpdateTopLeftBar(object pc, int strref, string icon, string text="");

// hides all icons in left page top bar
// pre 1.06 temp
void gn_UpdateMainIcon(object pc, string icontoshow);

// opens up the appropriate submenu, e.g. feat categories for FEAT
void gn_UpdateSubMenu(object pc, string submenutoshow);

// switches between main icon and main menu bar
void gn_ToggleMainIcon(object pc, int show=TRUE);

// switches between spell level filter and alphabetical filter
void gn_ToggleSpellToggle(object pc, string sortbyalpha);

// disables empty filters
void gn_UpdateFilter(object pc, string category);

//  disables empty filters for spells, also show/hide spell toggle button if necessary
void gn_UpdateFilterForSpells(object pc, string category, string sortbyalpha);

// hides filter panel, including alphas, nums, and spell toggle button
void gn_HideFilter(object pc);

// set up the specified entry with the specified data
void gn_SetListBoxEntry(object pc, string index, int strref, string rownumber="");

// populate list box based on selected filter and category
void gn_UpdateListBox(object pc, string category, string column, int page=0);

// populate list box for abilities
void gn_UpdateListBoxForAbilities(object pc);

// hides all entries in list box, and arrows too
void gn_ClearListBox(object pc);

// fills up the right hand page with proper details
// pre 1.06 - to add dynamic icon
void gn_UpdateRightPage(object pc, string category, string column, string page, string row);

// fills up the right hand page for abilities (no 2da for base abilities, so this is hardcoded)
void gn_UpdateRightPageForAbilities(object pc, string row);

/*
// locals index
index 0 = current category, e.g. FTSK, FTBG
index 1 = current alphabet
index 2 = current page
index 3 = spell toggle on/off
*/

void main(string instruction, string arg1, string arg2, string arg3, string arg4)
{
	object self = OBJECT_SELF;

	switch (StringToInt(GetStringRight(instruction, 2)))
	{
		case 99 : // start button - pop up main menu
		{
			gn_ToggleMainIcon(self, FALSE);
			break;
		}
		case 1 : // main menu
		{
			int strref; string icon; string submenu;
			if      (arg1 == "MMRC") { strref=481;  icon=GN_ICO_RACE;  submenu=GN_PANE_SUBMENU_RACE; }
			else if (arg1 == "MMCL") { strref=7471; icon=GN_ICO_CLASS; submenu=GN_PANE_SUBMENU_CLASS; }
			else if (arg1 == "MMST") { strref=7379; icon=GN_ICO_STAT;  submenu=GN_PANE_SUBMENU_STAT; }
			else if (arg1 == "MMFT") { strref=326;  icon=GN_ICO_FEAT;  submenu=GN_PANE_SUBMENU_FEAT; }
			else                     { strref=2295; icon=GN_ICO_SPELL; submenu=GN_PANE_SUBMENU_SPELL; }
			gn_ToggleMainIcon(self);
			gn_UpdateSubMenu(self, submenu);
			gn_UpdateTopLeftBar(self, strref, icon);
			gn_HideFilter(self);
			gn_ClearListBox(self);
			SetGUIObjectHidden(self, GN_SCREEN_PHB, GN_PANE_RIGHTPAGE, TRUE);
			break;
		}
		case 21 : // filter pane
		{
			gn_ToggleMainIcon(self);
			gn_UpdateListBox(self, arg1, arg2);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 1, arg2);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 2, "P0");
			break;
		}
		case 26 : // prev/next button
		{
			int page = StringToInt(GetStringRight(arg3, GetStringLength(arg3) - 1));
			if (arg4 == "PREV") gn_UpdateListBox(self, arg1, arg2, --page);
			else                gn_UpdateListBox(self, arg1, arg2, ++page);
			gn_ToggleMainIcon(self);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 2, "P" + IntToString(page));
			break;
		}
		case 31 : // entries list
		{
			gn_ToggleMainIcon(self);
			gn_UpdateRightPage(self, arg1, arg2, arg3, arg4);
			break;
		}
		case 11 : // sub menu - feat
		{
			int strref; string icon;
			if      (arg1 == "FTBG") { strref=112975; icon=GN_ICO_FTBG; }
			else if (arg1 == "FTCL") { strref=112977; icon=GN_ICO_FTCL; }
			else if (arg1 == "FTDV") { strref=112972; icon=GN_ICO_FTDV; }
			else if (arg1 == "FTGN") { strref=112967; icon=GN_ICO_FTGN; }
			else if (arg1 == "FTHI") { strref=112974; icon=GN_ICO_FTHI; }
			else if (arg1 == "FTIT") { strref=112971; icon=GN_ICO_FTIT; }
			else if (arg1 == "FTMM") { strref=112970; icon=GN_ICO_FTMM; }
			else if (arg1 == "FTPF") { strref=112968; icon=GN_ICO_FTPF; }
			else if (arg1 == "FTRC") { strref=112976; icon=GN_ICO_FTRC; }
			else if (arg1 == "FTSK") { strref=112973; icon=GN_ICO_FTSK; }
			else                     { strref=112969; icon=GN_ICO_FTSP; }
			gn_ToggleMainIcon(self);
			gn_ClearListBox(self);
			gn_UpdateTopLeftBar(self, strref, icon);
			gn_UpdateFilter(self, arg1);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 0, arg1 );
			break;
		}
		case 12 : // sub menu - spell
		{
			int strref; string icon;
			if      (arg1 == "SPBD") { strref=2; icon=GN_ICO_SPBD; }
			else if (arg1 == "SPCL") { strref=4; icon=GN_ICO_SPCL; }
			else if (arg1 == "SPDR") { strref=6; icon=GN_ICO_SPDR; }
			else if (arg1 == "SPPD") { strref=12; icon=GN_ICO_SPPD; }
			else if (arg1 == "SPRG") { strref=14; icon=GN_ICO_SPRG; }
			else if (arg1 == "SPWZ") { strref=20; icon=GN_ICO_SPWZ; }
			else if (arg1 == "SPWL") { strref=112060; icon=GN_ICO_SPWL; }
			else                     { strref=18; icon=GN_ICO_SPSC; arg1 = "SPWZ"; }
			gn_ToggleMainIcon(self);
			gn_ClearListBox(self);
			gn_UpdateTopLeftBar(self, strref, icon);
			gn_UpdateFilterForSpells(self, arg1, arg2);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 0, arg1);
			break;
		}
		case 27 : // spell toggle button
		{
			gn_ToggleMainIcon(self);
			gn_ToggleSpellToggle(self, arg1);
			break;
		}
		case 15 : // sub menu - subrace/prestige class
		{
			int strref; string icon, text;
			if (arg1 == "CLPC") { strref=-1; icon=GN_ICO_CLPC; text="Prestige Classes";}
			else                { strref=-1; icon=GN_ICO_RCRS; text="Subraces";}
			gn_ToggleMainIcon(self);
			gn_ClearListBox(self);
			gn_UpdateTopLeftBar(self, strref, icon, text);
			gn_UpdateFilter(self, arg1);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 0, arg1 );
			break;
		}
		case 14 : // sub menu - base race/class
		{
			int strref; string icon;
			if (arg1 == "CLBC") { strref=7471; icon=GN_ICO_CLBC; }
			else                { strref=481;  icon=GN_ICO_RCRC; }
			gn_UpdateListBox(self, arg1, "A0");
			gn_ToggleMainIcon(self);
			gn_UpdateTopLeftBar(self, strref, icon);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 0, arg1 );
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 1, "A0");
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 2, "P0");
			SetGUIObjectHidden(self, GN_SCREEN_PHB, GN_PANE_FILTER_ALPHA, TRUE);
			break;
		}
		case 13 : // sub menu - statistics
		{
			int strref; string icon;
			if (arg1 == "STSK")
			{
				strref=327; icon=GN_ICO_STSK;
				gn_UpdateListBox(self, arg1, "A0");
				SetLocalGUIVariable(self, GN_SCREEN_PHB, 1, "A0");
				SetLocalGUIVariable(self, GN_SCREEN_PHB, 2, "P0");
			}
			else
			{
				strref=113689; icon=GN_ICO_STAB;
				gn_UpdateListBoxForAbilities(self);
			}
			gn_ToggleMainIcon(self);
			gn_UpdateTopLeftBar(self, strref, icon);
			SetLocalGUIVariable(self, GN_SCREEN_PHB, 0, arg1);
			break;
		}
		default :
		{
			SendMessageToPC(self, "Hello, you have selected a button that does nothing. This is a bug. Please submit bug report quoting Error " + instruction + "_" + arg1 + "_" + arg2 + " and provide steps to replicate this error."); break;
		}
	}
	// debug
	// SendMessageToPC(self, instruction + " : " + arg1 + " : " + arg2 + " : " + arg3 + " : " + arg4);
}

void gn_ToggleMainIcon(object pc, int show=TRUE)
{
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, "START_PANE", !show);
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, "MAINMENU_PANE", show);
}

void gn_ToggleSpellToggle(object pc, string sortbyalpha)
{
	int i; string s;
	if (sortbyalpha == "") { i = TRUE ;  s = "X" ;}
	else                   { i = FALSE ; s = "" ; }
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_NUM, i);
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_ALPHA, !i);
	SetLocalGUIVariable(pc, GN_SCREEN_PHB, 3, s);
}

void gn_UpdateTopLeftBar(object pc, int strref, string icontoshow, string text="")
{
	SetGUIObjectText(pc, GN_SCREEN_PHB, "START_TEXT", strref, text);
	gn_UpdateMainIcon(pc, icontoshow);
}

void gn_UpdateMainIcon(object pc, string icontoshow)
{
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_RACE, (icontoshow != GN_ICO_RACE));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_CLASS, (icontoshow != GN_ICO_CLASS));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_STAT, (icontoshow != GN_ICO_STAT));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FEAT, (icontoshow != GN_ICO_FEAT));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPELL, (icontoshow != GN_ICO_SPELL));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTBG, (icontoshow != GN_ICO_FTBG));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTCL, (icontoshow != GN_ICO_FTCL));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTDV, (icontoshow != GN_ICO_FTDV));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTGN, (icontoshow != GN_ICO_FTGN));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTHI, (icontoshow != GN_ICO_FTHI));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTIT, (icontoshow != GN_ICO_FTIT));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTMM, (icontoshow != GN_ICO_FTMM));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTPF, (icontoshow != GN_ICO_FTPF));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTRC, (icontoshow != GN_ICO_FTRC));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTSK, (icontoshow != GN_ICO_FTSK));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_FTSP, (icontoshow != GN_ICO_FTSP));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPBD, (icontoshow != GN_ICO_SPBD));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPCL, (icontoshow != GN_ICO_SPCL));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPDR, (icontoshow != GN_ICO_SPDR));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPPD, (icontoshow != GN_ICO_SPPD));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPRG, (icontoshow != GN_ICO_SPRG));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPSC, (icontoshow != GN_ICO_SPSC));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPWL, (icontoshow != GN_ICO_SPWL));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_SPWZ, (icontoshow != GN_ICO_SPWZ));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_STSK, (icontoshow != GN_ICO_STSK));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_STAB, (icontoshow != GN_ICO_STAB));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_CLBC, (icontoshow != GN_ICO_CLBC));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_CLPC, (icontoshow != GN_ICO_CLPC));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_RCRC, (icontoshow != GN_ICO_RCRC));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_ICO_RCRS, (icontoshow != GN_ICO_RCRS));
}

void gn_UpdateSubMenu(object pc, string submenutoshow)
{
        SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_SUBMENU_RACE, (submenutoshow != GN_PANE_SUBMENU_RACE));
        SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_SUBMENU_CLASS, (submenutoshow != GN_PANE_SUBMENU_CLASS));
        SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_SUBMENU_STAT, (submenutoshow != GN_PANE_SUBMENU_STAT));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_SUBMENU_FEAT, (submenutoshow != GN_PANE_SUBMENU_FEAT));
        SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_SUBMENU_SPELL, (submenutoshow != GN_PANE_SUBMENU_SPELL));
}

void gn_UpdateFilter(object pc, string category)
{
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_ALPHA, FALSE);
	string twoda = "gn_phb_" + category ;
	int i;
	string s;
	for (i=0; i<27; i++)
	{
		s = IntToString(i);
		SetGUIObjectDisabled(pc, GN_SCREEN_PHB, "FILTER_ALP_" + s, (Get2DAString(twoda, "A" + s, 0) == ""));
	}
}

void gn_UpdateFilterForSpells(object pc, string category, string sortbyalpha)
{
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_SPELLTOGGLE, FALSE);
	if (sortbyalpha == "") SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_NUM, FALSE);
	else                   SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_ALPHA, FALSE);
	string twoda = "gn_phb_" + category ;
	int i;
	string s;
	for (i=0; i<37; i++)
	{
		s = IntToString(i);
		SetGUIObjectDisabled(pc, GN_SCREEN_PHB, "FILTER_ALP_" + s, (Get2DAString(twoda, "A" + s, 0) == ""));
	}
}

void gn_HideFilter(object pc)
{
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_ALPHA, TRUE);
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_FILTER_NUM, TRUE);
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_SPELLTOGGLE, TRUE);
	SetLocalGUIVariable(pc, GN_SCREEN_PHB, 3, "");
}

void gn_SetListBoxEntry(object pc, string index, int strref, string rownumber="")
{
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, "ENTRIES_TXT" + index + "_PANE", FALSE);
	SetGUIObjectText(pc, GN_SCREEN_PHB, "ENTRIES_TXT_0" + index, strref, "");
	SetGUIObjectText(pc, GN_SCREEN_PHB, "ENTRIES_TXT_1" + index, -1, rownumber);
}

void gn_UpdateListBox(object pc, string category, string column, int page=0)
{
	string twoda = "gn_phb_" + category ;
	string prefix = GetStringLeft(category, 2);
	string maintwoda, label;

        if      (prefix == "FT") { maintwoda = "feat";           label = "FEAT" ;}
        else if (prefix == "SP") { maintwoda = "spells";         label = "Name" ;}
        else if (prefix == "ST") { maintwoda = "skills";         label = "Name" ;}
        else if (prefix == "CL") { maintwoda = "classes";        label = "Name" ;}
        else if (prefix == "RS") { maintwoda = "racialsubtypes"; label = "Name" ;}
        else                     { maintwoda = "racialtypes";    label = "Name" ;}

	int i;
	int startrow = 10*page;
	string rownumber, textpane, index;
	for (i = startrow; i < (startrow + 10); i++)
	{
		rownumber = Get2DAString(twoda, column, i);
		index = IntToString(i - startrow);
		textpane = "ENTRIES_TXT" + index + "_PANE" ;
		if (rownumber == "") SetGUIObjectHidden(pc, GN_SCREEN_PHB, textpane, TRUE);
		else                 gn_SetListBoxEntry(pc, index, StringToInt(Get2DAString(maintwoda, label, StringToInt(rownumber))), rownumber);
	}

	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_PG_PREV, (page == 0));
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_PG_NEXT, (Get2DAString(twoda, column, startrow + 10) == ""));
}

void gn_UpdateListBoxForAbilities(object pc)
{
	int i;
	string rownumber, textpane, index;
	for (i = 6; i < 10; i++)
	{
		SetGUIObjectHidden(pc, GN_SCREEN_PHB, "ENTRIES_TXT" + IntToString(i) + "_PANE", TRUE);
	}

	gn_SetListBoxEntry(pc, "0", 135); // strength
	gn_SetListBoxEntry(pc, "1", 133); // dexterity
	gn_SetListBoxEntry(pc, "2", 132); // constitution
	gn_SetListBoxEntry(pc, "3", 134); // intelligence
	gn_SetListBoxEntry(pc, "4", 136); // wisdom 
	gn_SetListBoxEntry(pc, "5", 131); // charisma

	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_PG_PREV, TRUE);
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_PG_NEXT, TRUE);
}

void gn_ClearListBox(object pc)
{
	int i;
	for (i = 0; i < 10; i++) SetGUIObjectHidden(pc, GN_SCREEN_PHB, "ENTRIES_TXT" + IntToString(i) + "_PANE", TRUE);

	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_PG_PREV, TRUE);
	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_BUTTON_PG_NEXT, TRUE);
}

void gn_UpdateRightPage(object pc, string category, string column, string page, string row)
{
	if (category == "STAB")
	{
		gn_UpdateRightPageForAbilities(pc, row);
		return;
	}

	int index = StringToInt(Get2DAString("gn_phb_" + category, column, StringToInt(GetStringRight(page, GetStringLength(page) - 1)) * 10 + StringToInt(GetStringRight(row, 1))));

	string prefix = GetStringLeft(category, 2);
	string maintwoda, label, description;

	if (prefix == "FT")      { maintwoda = "feat";           label = "FEAT" ; description = "DESCRIPTION" ;}
	else if (prefix == "SP") { maintwoda = "spells";         label = "Name" ; description = "SpellDesc" ;  }
	else if (prefix == "ST") { maintwoda = "skills";         label = "Name" ; description = "Description" ;}
	else if (prefix == "CL") { maintwoda = "classes";        label = "Name" ; description = "Description" ;}
	else if (prefix == "RS") { maintwoda = "racialsubtypes"; label = "Name" ; description = "Description" ;}
	else                     { maintwoda = "racialtypes";    label = "Name" ; description = "Description" ;}

	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_RIGHTPAGE, FALSE);
	SetGUIObjectText(pc, GN_SCREEN_PHB, "DETAILS_HEADER", StringToInt(Get2DAString(maintwoda, label, index)), "");
	SetGUIObjectText(pc, GN_SCREEN_PHB, "DETAILS_TEXT", StringToInt(Get2DAString(maintwoda, description, index)), "");
}

void gn_UpdateRightPageForAbilities(object pc, string row)
{
	int label, description;
	switch (StringToInt(GetStringRight(row, 1)))
	{
		case 0 : { label = 135; description = 459; break; }
		case 1 : { label = 133; description = 460; break; }
		case 2 : { label = 132; description = 461; break; }
		case 3 : { label = 134; description = 463; break; }
		case 4 : { label = 136; description = 462; break; }
		case 5 : { label = 131; description = 478; break; }
		default : { SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_RIGHTPAGE, TRUE); return; }
	}

	SetGUIObjectHidden(pc, GN_SCREEN_PHB, GN_PANE_RIGHTPAGE, FALSE);
	SetGUIObjectText(pc, GN_SCREEN_PHB, "DETAILS_HEADER", label, "");
	SetGUIObjectText(pc, GN_SCREEN_PHB, "DETAILS_TEXT", description, "");
}