//::///////////////////////////////////////////////
//:: Flensing
//:: SG_S0_Flensing.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	You strip the flesh from a corporeal creature's
	body. Each round, the target suffers pain and
	psychological trauma that undermines the spirit.
	The assault deals 2d6 points of damage and 1d6
	points of temporary Charisma and Constitution
	damage. A fort save negates the ability damage
	and reduces the physical damage by half.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 5, 2003
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= HkGetAOEOwner();
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDuration 		= HkApplyDurationCategory(4);
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 6;
	int 	iNumDice 		= 2;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	int 	iChaDmg;
	int 	iConDmg;
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	fDuration = HkApplyMetamagicDurationMods( fDuration );
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, 1), iDieType )+iBonus;
	iChaDmg = HkApplyMetamagicVariableMods(CSLDieX( iDieType, 1), iDieType)+iBonus;
	iConDmg = HkApplyMetamagicVariableMods(CSLDieX( iDieType, 1), iDieType)+iBonus;
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis=EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
	effect eDamage;
	effect eLink;
	effect eCha=EffectAbilityDecrease(ABILITY_CHARISMA, iChaDmg);
	effect eCon=EffectAbilityDecrease(ABILITY_CONSTITUTION, iConDmg);
	effect eAbilityLink=EffectLinkEffects(eCha, eCon);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLENSING));
	
	int iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_ALL, OBJECT_SELF);
	iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
	int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
	if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
	{
		if( iDamage > 0 )
		{
			eLink=EffectLinkEffects(eVis,EffectDamage(iDamage));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}
	
		if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbilityLink, oTarget, fDuration);
		}
	}
}