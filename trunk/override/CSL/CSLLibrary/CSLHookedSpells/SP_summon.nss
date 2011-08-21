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
#include "_SCInclude_Summon"

void main()
{
	//scSpellMetaData = SCMeta_SP_summon();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iRealSpellId = GetSpellId(); 
	int iSpellId = SCSummonGetMainSpellId( iRealSpellId );
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_SUMMONING;
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	
	// note sDescriptors="Air/Chaos/Earth/Evil/Fire/Good/Law/Water" will send casting to a sub table
	
	if ( iRealSpellId == SPELL_SUMMON_FIENDISH_LEGACY )
	{
		// Fiendish Legacy
		iClass = CLASS_TYPE_RACIAL;
		iDescriptor = SCMETA_DESCRIPTOR_EVIL;
	}
	else if ( iRealSpellId == SPELL_SHADES_TARGET_GROUND )
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	else if ( iRealSpellId == SPELL_BG_Summon_Creature_III )
	{
		iClass = CLASS_TYPE_BLACKGUARD;
		iDescriptor = SCMETA_DESCRIPTOR_EVIL;
	}
	
	
	
	int iSpellLevel = SCSummonGetLevel( iRealSpellId );
	location lTarget = HkGetSpellTargetLocation();
	string sSummonTable = SCSummonGetTable( "Magic", iRealSpellId, lTarget, HkGetSpellClass(oCaster), oCaster );
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

	//int nLvl = GetSummonLevel(iSpellId); // FIND THE EFFECTIVE SPELL LEVEL CONSIDERING FOCUS AND AUGMENTS
	int iSpellColumn = SCSummonGetColumn( iRealSpellId ); // gets the radial column requested for the given spell
	
	int iDuration = HkGetSpellDuration(oCaster) + 3; //( 5 * nLvl ); // WAS +3, GIVING SMALL GIFT HERE
	int iPower = HkGetSpellPower(oCaster);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	//int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
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
	
	
	
	//if ( GetHasFeat(FEAT_ASHBOUND, oCaster) )
	//{
	//	fDuration = fDuration * 2;	
	//}
	
	int iSummonBonus = SCGetSummonBonus( oCaster, sSummonTable );
	// VFX_FNF_SUMMON_MONSTER_1
	
	
	SCSummonCreature( oCaster, sSummonTable, iSpellLevel+iSummonBonus, iPower, fDuration, lTarget, iSpellId, iSpellColumn);

	
	
	// need to reimplement the following
	
	//string sSummon = GetSummonResRef(nLvl);
	//string sTag = GetTag( GetSpellCastItem() );
	//if (sTag=="gem_tunnelborer") sSummon = "tunnelborer";
	//effect eSummon = EffectSummonCreature(sSummon, GetEffectID(iSpellId));
	
	//int nElemental = 0;

	//if (iSpellId == SPELL_SUMMON_CREATURE_VII || iSpellId == SPELL_SUMMON_CREATURE_VIII || iSpellId == SPELL_SUMMON_CREATURE_IX)
	//{
	//	nElemental = 1;
	//}

	//int nAshbound = 0;
	//if (iSpellId >= SPELL_SUMMON_CREATURE_I && iSpellId <= SPELL_SUMMON_CREATURE_IX)
	//{
	//	nAshbound = 1;
	//}

	//if ( GetHasFeat(FEAT_ASHBOUND, OBJECT_SELF) )
	//{
	//	iDuration = iDuration * 2;	
	//}
	
	

		
	//HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(),fDuration);
	//DelayCommand(6.0f, BuffSummons(OBJECT_SELF, nElemental, nAshbound ));
	
	//if (nLvl>9) DelayCommand(8.0f, BoostSummon(OBJECT_SELF, nLvl-9, sSummon));
	//HkApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster), oCaster );
	
	HkPostCast(oCaster);
}