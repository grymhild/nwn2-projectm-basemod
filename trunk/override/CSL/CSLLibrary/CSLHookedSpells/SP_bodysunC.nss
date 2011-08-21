//::///////////////////////////////////////////////
//:: Body of the Sun
//:: nw_s0_bodysun.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_bodysun();
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_BODY_OF_THE_SUN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int    nDamageDice = CSLGetMin(10, HkGetSpellPower(oCaster)) / 2; // CAP CASTERLEVEL AT 10
	int    nDamValue;
	
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget)) {
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{ // && (oTarget!=oCaster)) { HOW CAN I BE HOSTILE TO MYSELF??
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BODY_OF_THE_SUN));
		if (!HkResistSpell(oCaster, oTarget))
		{
			nDamValue = HkApplyMetamagicVariableMods(d4(nDamageDice), 4 * nDamageDice);
			nDamValue = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDamValue, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, oCaster);
			if ( nDamValue )
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamValue, DAMAGE_TYPE_FIRE), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_FIRE), oTarget);
			}
		}
	}
	oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}