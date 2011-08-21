//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Carries out the summoning of the appropriate
	creature for the Summon Monster Series of spells
	1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 05/30/2006:
//::  Changed summon animals.
//::  Changed duration from 24 hours to 3 + 1 round/lvl.
//:://////////////////////////////////////////////
//:: BDF-OEI 06/27/2006:
//::  Added support for SPELL_SHADES_TARGET_GROUND in GetCreatureAnimalDomain
//::  Modified to allow

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
//#include "_SCInclude_Encounter"
#include "_CSLCore_Config"
#include "_SCInclude_Class"

void BoostSummon(object oMaster, int iBonus, string sResRef)
{
	object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster);
	int nDamBonus = 0;
	if      (iBonus==1) nDamBonus = DAMAGE_BONUS_1;
	else if (iBonus==2) nDamBonus = DAMAGE_BONUS_2;
	else if (iBonus==3) nDamBonus = DAMAGE_BONUS_3;
	else if (iBonus==4) nDamBonus = DAMAGE_BONUS_4;
	else if (iBonus==5) nDamBonus = DAMAGE_BONUS_5;
	int nElement = DAMAGE_TYPE_ACID;
	if      (CSLStringStartsWith(sResRef, "c_elefire"))  nElement = DAMAGE_TYPE_FIRE;
	else if (CSLStringStartsWith(sResRef, "c_eleair"))   nElement = DAMAGE_TYPE_SONIC;
	else if (CSLStringStartsWith(sResRef, "c_elewater")) nElement = DAMAGE_TYPE_COLD;
	else if (CSLStringStartsWith(sResRef, "c_eleearth")) nElement = DAMAGE_TYPE_ACID;

	FloatingTextStringOnCreature("Summon AC/Damage Bonus +" + IntToString(iBonus), oMaster, FALSE);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(nDamBonus, nElement ), oSum);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(iBonus), oSum);
}

string GetElementType(string sAir, string sWater, string sFire, string sEarth) {
	string dom1 = "";
	string dom2 = "";
	if (GetHasFeat(FEAT_AIR_DOMAIN_POWER))   if (dom1=="") dom1=sAir  ; else dom2=sAir;   //return sAir;
	if (GetHasFeat(FEAT_WATER_DOMAIN_POWER)) if (dom1=="") dom1=sWater; else dom2=sWater; //return sWater;
	if (GetHasFeat(FEAT_FIRE_DOMAIN_POWER))  if (dom1=="") dom1=sFire ; else dom2=sFire;  //return sFire;
	if (GetHasFeat(FEAT_EARTH_DOMAIN_POWER)) if (dom1=="") dom1=sEarth; else dom2=sEarth; //return sEarth;
	if (dom1!="") return CSLPickOne(dom1, dom2); // IF THEY ARE SPECIAL, PICK ONE OF THE SPECIALTIES
	return CSLPickOne(sAir, sWater, sFire, sEarth); // OTHERWISE, RANDOMIZE!
}

int GetEffectID( int iSpellId ) {
	return VFX_HIT_SPELL_SUMMON_CREATURE;
}

int GetSummonLevel(int iSpellId) { // MAX OF 14 WITH ALL FEATS
	int nLvl = 1;
	if      (iSpellId==SPELL_SUMMON_CREATURE_I)    nLvl = 1;
	else if (iSpellId==SPELL_SUMMON_CREATURE_II)   nLvl = 2;
	else if (iSpellId==SPELL_SUMMON_CREATURE_III)  nLvl = 3;
	else if (iSpellId==SPELL_BG_Summon_Creature_III)  nLvl = 3;
	else if (iSpellId==SPELL_SUMMON_CREATURE_IV)   nLvl = 4;
	else if (iSpellId==SPELL_SUMMON_CREATURE_V)    nLvl = 5;
	else if (iSpellId==SPELL_SUMMON_CREATURE_VI)   nLvl = 6;
	else if (iSpellId==SPELL_SUMMON_CREATURE_VII)  nLvl = 7;
	else if (iSpellId==SPELL_SHADES_TARGET_GROUND) nLvl = 7; // SPECIAL
	else if (iSpellId==SPELL_SUMMON_CREATURE_VIII) nLvl = 8;
	else if (iSpellId==SPELL_SUMMON_CREATURE_IX)   nLvl = 9;

	int iBonus = 0;
	if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION))         iBonus++;
	if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION)) iBonus++;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION))    iBonus++;
	if (GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))             iBonus++; //WITH THE ANIMAL DOMAIN
	if (GetHasFeat(FEAT_AUGMENT_SUMMONING))               iBonus+=2; //WITH THE SUMMON AUGMENTATION FEAT
	if (nLvl<9 && iBonus) FloatingTextStringOnCreature("Summon boosted to level " + IntToString(CSLGetMin(9, nLvl+iBonus)), OBJECT_SELF, FALSE);
	return nLvl+iBonus;
}

string GetSummonResRef(int nLvl) {
	string sSummon = "c_rat";
	if      (nLvl==1) sSummon = "c_dogwolf";
	else if (nLvl==2) sSummon = "c_badgerdire";
	else if (nLvl==3) sSummon = "c_dogwolfdire";
	else if (nLvl==4) sSummon = "c_boardire";
	else if (nLvl==5) sSummon = "c_dogshado";
	else if (nLvl==6) sSummon = "c_beardire";
	else if (nLvl==7) sSummon = GetElementType("c_elmairhuge",   "c_elmwaterhuge",   "c_elmfirehuge",   "c_elmearthhuge");
	else if (nLvl==8) sSummon = GetElementType("c_elmairgreater","c_elmwatergreater","c_elmfiregreater","c_elmearthgreater");
	else if (nLvl>=9) sSummon = GetElementType("c_elmairelder",  "c_elmwaterelder",  "c_elmfireelder",  "c_elmearthelder");
	return sSummon;
}

void main()
{
	//scSpellMetaData = SCMeta_SP_summon();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SUMMON_CREATURE_I;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_SUMMONING;
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	
	if (GetSpellId() == SPELL_SUMMON_CREATURE_V && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		// Fiendish Legacy
		iClass = CLASS_TYPE_RACIAL;
		iDescriptor = SCMETA_DESCRIPTOR_EVIL;
	}
	else if ( GetSpellId() == SPELL_SHADES_TARGET_GROUND )
	{
		iSpellId = SPELL_SHADES_TARGET_GROUND;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_I )
	{
		iSpellId = SPELL_SUMMON_CREATURE_I;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_II )
	{
		iSpellId = SPELL_SUMMON_CREATURE_II;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_III )
	{
		iSpellId = SPELL_SUMMON_CREATURE_III;
	}
	else if ( GetSpellId() == SPELL_BG_Summon_Creature_III )
	{
		iClass=CLASS_TYPE_BLACKGUARD;
		iSpellId = SPELL_BG_Summon_Creature_III;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_IV )
	{
		iSpellId = SPELL_SUMMON_CREATURE_IV;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_V )
	{
		iSpellId = SPELL_SUMMON_CREATURE_V;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_VI )
	{
		iSpellId = SPELL_SUMMON_CREATURE_VI;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_VII )
	{
		iSpellId = SPELL_SUMMON_CREATURE_VII;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_VIII )
	{
		iSpellId = SPELL_SUMMON_CREATURE_VIII;
	}
	else if ( GetSpellId() == SPELL_SUMMON_CREATURE_IX )
	{
		iSpellId = SPELL_SUMMON_CREATURE_IX;
	}
	// sDescriptors="Air/Chaos/Earth/Evil/Fire/Good/Law/Water";
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_INTERNAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	int nLvl = GetSummonLevel(iSpellId); // FIND THE EFFECTIVE SPELL LEVEL CONSIDERING FOCUS AND AUGMENTS
	//int iDuration;
	int iDuration = HkGetSpellDuration(oCaster) + 5 * nLvl; // WAS +3, GIVING SMALL GIFT HERE
	
	
	
	if (!GetIsPC(OBJECT_SELF))
	{
		// SEED EDIT - PUT THE RESREF OF THE CREATURE YOU WANT THE MONSTER TO SUMMON IN A STRING VARIABLE "SUMMON_PET"
		string sOverRide = GetLocalString(oCaster, "SUMMON_PET");
		if (sOverRide!="") { // OVERRIDE FOR MONSTER SUMMONS
			object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sOverRide, HkGetSpellTargetLocation(), TRUE);
			SetLocalInt(oMinion,"SEEDED",TRUE);
			// DelayCommand(200.0, Despawn(oMinion));
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE), GetLocation(oMinion));
			return;
		}
	}
	
	string sSummon = GetSummonResRef(nLvl);
	string sTag = GetTag(GetSpellCastItem());
	if (sTag=="gem_tunnelborer") sSummon = "tunnelborer";
	effect eSummon = EffectSummonCreature(sSummon, GetEffectID(iSpellId));
	
	int nElemental = 0;

	if (iSpellId == SPELL_SUMMON_CREATURE_VII || iSpellId == SPELL_SUMMON_CREATURE_VIII || iSpellId == SPELL_SUMMON_CREATURE_IX)
	{
		nElemental = 1;
	}

	int nAshbound = 0;
	if (iSpellId >= SPELL_SUMMON_CREATURE_I && iSpellId <= SPELL_SUMMON_CREATURE_IX)
	{
		nAshbound = 1;
	}

	if (GetHasFeat(FEAT_ASHBOUND, OBJECT_SELF))
	{
		iDuration = iDuration * 2;	
	}
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

		
	HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(),fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF, nElemental, nAshbound ));
	
	if (nLvl>9) DelayCommand(8.0f, BoostSummon(OBJECT_SELF, nLvl-9, sSummon));
	HkApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster), oCaster );
	
	HkPostCast(oCaster);
}

