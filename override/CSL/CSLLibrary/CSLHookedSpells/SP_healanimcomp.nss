//::///////////////////////////////////////////////
//:: Heal Animal Companion
//:: nx_s0_healanimal.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Heal Animal Companion
	Conjuration (Healing)
	Level: Druid 5, ranger 3
	Components: V, S
	Range: Touch
	Target: Your animal companion touched
	
	Heals an animal companion of 10 points per caster
	level and removes the wounded effect.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Healing"





void main()
{
	//scSpellMetaData = SCMeta_SP_healanimcomp();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HEAL_ANIMAL_COMPANION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();

	if (GetIsObjectValid(oTarget)) {
		if (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION)==oTarget) {
			SCHealHarmTarget(oTarget, iSpellPower, SPELL_HEAL, TRUE );
		} else {
			FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
			return;
		}
	}
	HkPostCast(oCaster);
}

