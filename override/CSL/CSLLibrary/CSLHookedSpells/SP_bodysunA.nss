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
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 18, 2006
//:://////////////////////////////////////////////


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
	int iSpellId = SPELL_BODY_OF_THE_SUN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------


	object oTarget     = GetEnteringObject();
	object oCaster     = GetAreaOfEffectCreator();
	int    nDamageDice = CSLGetMin(10, HkGetSpellPower(oCaster)) / 2; // CAP CASTERLEVEL AT 10
	int    nDamValue   = HkApplyMetamagicVariableMods(d4(nDamageDice), 4 * nDamageDice);
	string sAOETag     = "AOE_"+ ObjectToString(oCaster) + "_" + IntToString(GetSpellId());

	// Validate entering object, force it to save, and then burn it
	if (GetIsObjectValid(oTarget))
	{
		if (GetLocalInt(oTarget, sAOETag)) return; // ALREADY ENTERED THIS AOE THIS ROUND, CAN'T BE DAMAGED TWICE
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) { // && (oTarget!=oCaster)) { HOW CAN I BE HOSTILE TO MYSELF??
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BODY_OF_THE_SUN, TRUE));
			if (!HkResistSpell(oCaster, oTarget))
			{
				nDamValue = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDamValue, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, oCaster);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamValue, DAMAGE_TYPE_FIRE), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_FIRE), oTarget);
				SetLocalInt(oTarget, sAOETag, TRUE);
				DelayCommand(6.0f, DeleteLocalInt(oTarget, sAOETag));
			}
		}
	}
	HkPostCast(oCaster);
}