//::///////////////////////////////////////////////
//:: Create Greater Undead
//:: NW_S0_CrGrUnd.nss
//:: Copyright (c) 2005 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Summons an undead type pegged to the character's
	level.
	8TH LEVEL SPELL IS RECEIVED AT LVL 15
	http://www.d20srd.org/srd/spells/createUndead.htm
	Create Undead
	Necromancy [Evil]
	Level:	Clr 6, Death 6, Evil 6, Sor/Wiz 6
	Components:	V, S, M
	Casting Time:	1 hour
	Range:	Close (25 ft. + 5 ft./2 levels)
	Target:	One corpse
	Duration:	Instantaneous
	Saving Throw:	None
	Spell Resistance:	No
	Caster Level	Undead Created
	11th or lower	Ghoul
	12th-14th	Ghast
	15th-17th	Mummy
	18th or higher	Mohrg
	A much more potent spell than animate dead, this evil 
	spell allows you to create more powerful sorts of undead: 
	ghouls, ghasts, mummies, and mohrgs. The type or types 
	of undead you can create is based on your caster level, 
	as shown on the table below
	
	You may create less powerful undead than your level would 
	allow if you choose. Created undead are not automatically 
	under the control of their animator. If you are capable of 
	commanding undead, you may attempt to command the undead 
	creature as it forms.
	
	This spell must be cast at night.
	
	Material Component
	A clay pot filled with grave dirt and another filled with brackish water. The spell must be cast on a dead body. You must place a black onyx gem worth at least 50 gp per HD of the undead to be created into the mouth or eye socket of each corpse. The magic of the spell turns these gems into worthless shells.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

////#include "_inc_helper_functions"
//#include "_SCUtility"
#include "_SCInclude_Necromancy"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CREATE_GREATER_UNDEAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_ANIMATE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	string sResRef = "";
	
	int iCasterLevel = CSLGetMin(19, HkGetSpellPower(oCaster)) + UndeadLevelBonus(oCaster);
	float fDuration = UndeadDuration(oCaster);
	if      (iCasterLevel<=19) sResRef = "csl_sum_undead_vampire3";   // CR 15
	else if (iCasterLevel<=22) sResRef = "csl_sum_undead_vampire4";   // CR 17
	else if (iCasterLevel<=25) sResRef = "csl_sum_undead_vampire5";   // CR 19
	else                     sResRef = "csl_sum_undead_vampire6";   // CR 21
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sResRef, VFX_HIT_SPELL_SUMMON_CREATURE), HkGetSpellTargetLocation(), fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}

