string InterpretAlignmentConstants(int nGood, int nLawful);

void main()
{
    object oPlayer;
    int nLawful, nGood, nLawValue, nGoodValue;

    oPlayer = GetPCSpeaker();
	nGood=GetAlignmentGoodEvil(oPlayer);
	nLawful=GetAlignmentLawChaos(oPlayer);
	nGoodValue=GetGoodEvilValue(oPlayer);
	nLawValue=GetLawChaosValue(oPlayer);

	SetCustomToken(500,InterpretAlignmentConstants(nGood, nLawful) + " - " + IntToString(nLawValue) + "% Lawful / " + IntToString(nGoodValue) + "% Good");
}

string InterpretAlignmentConstants(int nGood, int nLawful)
{
	string Alignment;

	switch (nLawful)
	{
		case ALIGNMENT_CHAOTIC:
			Alignment="Chaotic";
			break;
		case ALIGNMENT_LAWFUL:
			Alignment="Lawful";
			break;
		case ALIGNMENT_NEUTRAL:
			Alignment="Neutral";
			break;
	}

	switch (nGood)
	{
		case ALIGNMENT_GOOD:
			Alignment+=" Good";
			break;
		case ALIGNMENT_EVIL:
			Alignment+=" Evil";
			break;
		case ALIGNMENT_NEUTRAL:
			if (nLawful>1) Alignment+=" Neutral";
			break;
	}
	return Alignment;
}