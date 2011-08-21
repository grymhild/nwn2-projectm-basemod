//::///////////////////////////////////////////////
//:: Greater Magic Fang
//:: x0_s0_gmagicfang.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:


// JLR - OEI 08/24/05 -- Metamagic changes

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Transmutation"


void main()
{
	//scSpellMetaData = SCMeta_SP_grtfang();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_MAGIC_FANG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	int nPower = CSLGetMin( CSLGetPreferenceInteger("MagicFangMax",5), ( HkGetSpellPower(oCaster) + 1 ) / 3 );
	int nDamagePower = DAMAGE_POWER_PLUS_ONE;

	switch (nPower) 
	{
			case 1: nDamagePower = DAMAGE_POWER_PLUS_ONE; break;
			case 2: nDamagePower = DAMAGE_POWER_PLUS_TWO; break;
			case 3: nDamagePower = DAMAGE_POWER_PLUS_THREE; break;
			case 4: nDamagePower = DAMAGE_POWER_PLUS_FOUR; break;
			case 5: nDamagePower = DAMAGE_POWER_PLUS_FIVE; break;
	}
	SCDoMagicFang(nPower, VFX_DUR_SPELL_GREATER_MAGIC_FANG);
	
	HkPostCast(oCaster);
}