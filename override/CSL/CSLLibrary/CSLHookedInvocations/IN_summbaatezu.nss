//::///////////////////////////////////////////////
//:: Summon Baatezu
//:: x2_s1_summbaatez
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons an Erinyes to aid the caster in combat
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-24
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//:: Update creature blueprints.
//:: Change duration to 10 minutes.
#include "_HkSpell"


////////////////////////////////////////////////
// SelectDemon() - Randomly Selects which demon
// 				   to summon.
////////////////////////////////////////////////
string SelectDemon()
{
	int nRandom = Random(100);
	//SpeakString(IntToString(nRandom));
	string sTag;
	
	if ( nRandom < 5)
	{
		sTag="csl_sum_baat_neeshka";
	}	
	else if ( nRandom < 30)
	{
		sTag = "csl_sum_baat_mephasm";
	}	
	else if ( nRandom < 60)
	{
		sTag = "csl_sum_baat_devilhorn2";
	}
	else if ( nRandom < 70)
	{
		sTag = "csl_sum_baat_pitfiend";
	}
	else if ( nRandom < 99)
	{
		sTag = "csl_sum_baat_erinyes2";
	}	
	else
	{
		sTag = "csl_sum_baat_chicken";
	}
	return sTag;
}

////////////////////////////////////////////////
// IsDevilStillActive(oDevil) -hack hack hack
////////////////////////////////////////////////
int IsDevilStillActive(object oDevil)
{
	if ( oDevil == OBJECT_INVALID )
	{
		return FALSE;
	}
	object oTest = GetFirstObjectInArea();	
	while(TRUE)
	{
		if (oTest == oDevil)
		{
			return TRUE;
		}
		oTest = GetNextObjectInArea();
	}	
	return FALSE;
}

////////////////////////////////////////////////
// GetDevilObject() -hack hack hack
////////////////////////////////////////////////
object GetDevilObject(string sTag)
{
	int i = 0;
	object oTest = GetObjectByTag(sTag, i);
	while (GetIsObjectValid(oTest))
	{
		//Debug(oTest);
		if (GetMaster(oTest) == OBJECT_SELF)
		{
			return oTest;
		}
		++i;
		oTest = GetObjectByTag(sTag, i);	
	}
	return OBJECT_INVALID;	
}
////////////////////////////////////////////////
// UhOh() - You be dead, now, warlock!
////////////////////////////////////////////////
void UhOh(string sTag, object oDevil, int nDamage)
{
	location lLocation = GetLocation(OBJECT_SELF);
	string sNewTag = sTag + IntToString(Random(100)); // Just in case!
	string sDisp = GetName(oDevil)+ " " + GetStringByStrRef(233589);
	FloatingTextStringOnCreature(sDisp, OBJECT_SELF); // turns on the party.
	object oBadDevil = CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocation, TRUE, sNewTag);	
	effect eDam = EffectDamage(nDamage);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oBadDevil);
	
}

////////////////////////////////////////////////
// CheckArea() - logic to see if 
// 				 the area is ok to go hostile
// make sure the devil doesn't respawn someplace
// like a city where the NPC's will freak out.
////////////////////////////////////////////////
int CheckArea(object oDevil)
{
	// make sure devil is still alive!
	if (!IsDevilStillActive(oDevil))
	{
		return 0;	
	}
	// make sure we're not on the overland map :D
	if (GetIsOverlandMap(GetArea(oDevil)))
	{
		return 0;
	}
	// make sure we're in a hostile area!
	object oObject = GetFirstObjectInArea();
	while (GetIsObjectValid(oObject))
	{
		if (GetIsReactionTypeHostile(oObject))
		{
			//FloatingTextStringOnCreature("Hostile!: "+GetName(oObject), OBJECT_SELF);
			if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
				return 1;
		}
		oObject = GetNextObjectInArea();
	}	
	return 0;
}

////////////////////////////////////////////////
// CheckHostile() - logic to see if 
// 				 demon goes away or turns.
////////////////////////////////////////////////
void CheckHostile(object oDevil)
{
	if (CheckArea(oDevil) == 0)
	{
		return;
	}	
	string sTag = GetTag(oDevil);
	int nCurrHP = GetCurrentHitPoints(oDevil);
	int nTotalHP = GetMaxHitPoints(oDevil);
	int nDiffHP = nTotalHP - nCurrHP;
	// these two never turn on you.
	if ( (sTag == "csl_sum_baat_neeshka" || sTag == "csl_sum_baat_mephasm") )
	{
		
		FloatingTextStringOnCreature(GetName(oDevil)+ " " + GetStringByStrRef(233588), OBJECT_SELF); // returns to the nine hells.
			
	}
	else  // uh-oh! Should have unsummoned the big devil! EPIC FAIL!
	{
		UhOh(sTag, oDevil, nDiffHP);
	}
}

////////////////////////////////////////////////
// CalcRounds() - how long do we get the devil for
////////////////////////////////////////////////
int CalcRounds(int nHellfireLevel, int nCharBonus)
{
	// minimum rounds
	int nMin = nHellfireLevel + nCharBonus; 
	// 10
	
	// maximum rounds
	int nMax = nMin + d8();
	//  10 + 1 or 8 assume 11
	
	
	int nRounds = Random(nMax);
	// completely random assume 1 or min
	
	
	nRounds += nMin;
	// adds 10 + 1 = 11, max is 11
	
	if ( nRounds > nMax )
	{
		nRounds = nMax;
	}
	return nRounds;
}


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nHellfireLevel = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK);
	int nCharBonus = GetAbilityModifier(ABILITY_CHARISMA);
	// calculate rounds
	int nTotalRounds = CalcRounds(nHellfireLevel, nCharBonus);
	float nSeconds = RoundsToSeconds(nTotalRounds);
	// Choose Demon
	string sTag = SelectDemon();
	
	// Summon the Creature
	effect eSummon = EffectSummonCreature(sTag, VFX_FNF_SUMMON_UNDEAD);
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), nSeconds);
	
	// Grab ahold of the Devil's Object ID
	object oDevil = GetDevilObject(sTag);
	
	// Delay the CheckHostile command until the "friendly" despawns.
	DelayCommand(nSeconds, CheckHostile(oDevil)); 
}