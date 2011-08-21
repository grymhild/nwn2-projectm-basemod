//::///////////////////////////////////////////////
//:: Blade Barrier, Wall: Heartbeat
//:: NW_S0_BladeBarWallC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a wall 10m long and 2m thick of whirling
	blades that hack and slice anything moving into
	them.  Anything caught in the blades takes
	2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_BLADE_BARRIER_WALL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iDice = HkGetSpellPower(oCaster, 15 );

	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
	while(GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLADE_BARRIER, TRUE ));
			if (!HkResistSpell(oCaster, oTarget)) {
				int iDamage = HkApplyMetamagicVariableMods(d6(iDice), 6 * iDice);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster);
				if (iDamage) {
					effect eDam = EffectLinkEffects(EffectDamage(iDamage, DAMAGE_TYPE_SLASHING), EffectVisualEffect(VFX_COM_BLOOD_REG_RED));
					SpawnBloodHit(oTarget, TRUE, OBJECT_INVALID);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
		}
		oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
	}
}