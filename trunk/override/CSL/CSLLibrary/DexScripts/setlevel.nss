void SetLevel(object oPC, int Level);
int GetXPReq(int Level, int ECL=0, int RaceID=0);
int GetLevelFromXP (int PCXP, int ECL=0, int RaceID=0);
int GetRaceECL(int RaceID);

//****************************************

void SetLevel(object oPC, int Level)
{
    object oPC=GetPCSpeaker();
    effect eLevel;
    int PCXP, XP;

    PCXP=GetXP(oPC);
	XP=GetXPReq(Level, 0, GetSubRace(oPC));

    if (PCXP>=XP)
        {
        eLevel=EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY,FALSE);
        }
    else if (PCXP<XP)
        {
        eLevel=EffectVisualEffect(VFX_IMP_RESTORATION_GREATER,FALSE);
        }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLevel, oPC, 0.5);
    SetXP(oPC, XP);
}

//****************************************

int GetXPReq(int Level, int ECL=0, int RaceID=0)
{
	int xxx, XP=1;

	if (ECL>0)
	{
		Level+=ECL;
	}
	else if (RaceID>0)
	{
		Level+=GetRaceECL(RaceID);
	}
	
	for (xxx=1; xxx<Level; xxx++)
	{
		XP+=xxx*1000;
	}
	
	return XP;
}

//****************************************

int GetLevelFromXP (int PCXP, int ECL=0, int RaceID=0)
{
	int XP=0, Level=1;

	while (XP<=PCXP)
	{
		XP+=Level*1000;
		Level++;
	}
	Level--;

	if (ECL>0)
	{
		Level-=ECL;
		if (Level<1) Level=1;
	}
	else if (RaceID>0)
	{
		Level-=GetRaceECL(RaceID);
		if (Level<1) Level=1;
	}

	return Level;
}

//****************************************

int GetRaceECL(int RaceID)
{
	int ECL;

	switch (RaceID)
	{
		case RACIAL_SUBTYPE_AASIMAR:
			ECL+=1;
			break;
		case RACIAL_SUBTYPE_TIEFLING:
			ECL=1;
			break;
		case RACIAL_SUBTYPE_GRAY_DWARF:
			ECL=2;
			break;
		case RACIAL_SUBTYPE_DROW:
			ECL=2;
			break;
		case RACIAL_SUBTYPE_GITHYANKI:
			ECL=2;
			break;
		case RACIAL_SUBTYPE_GITHZERAI:
			ECL=2;
			break;
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			ECL=3;
			break;
	}
	
	return ECL;
}

//****************************************