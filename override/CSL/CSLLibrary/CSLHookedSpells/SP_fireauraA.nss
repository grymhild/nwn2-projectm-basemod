//::///////////////////////////////////////////////
//:: Fire Aura (A) - OnEnter
//:: sg_s0_FireAuraA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Abjuration
Level: Sor/Wiz 4
Components: V,S
Casting Time: 1 action
Range: Personal
Duration: 1 round/level
Saving Throw: Special (see text)
Spell Resistance: No

By means of this spell, you surround your body with an
aura of magical green fire. The fire aura extends 1 foot
from your body and provides illumination in a 10-foot
radius. The fire aura provides protection 20 from both
natural and magical fire; the flames can be extinguished
only by dispel magic or a similar spell. Those touching
the fire aura suffer 2d4 hit points of fire damage; additionally,
if the touched victim fails to make his Reflex saving throw,
his body is set afire with green flames.
A victim's flames persist for a maximum of 10 rounds. Each round the
victim is engulfed in these flames, he suffers an additional
1-6 hit points of fire damage; the victim's attack rolls are made
with a -2 penalty during this time.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 10, 2004
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iDescriptor = HkGetDescriptor(); // This is stored in the AOE tag of the AOE, and after that it's stored in a var on the AOE
	int iSaveType = SAVING_THROW_TYPE_FIRE;
	int iHitEffect = VFX_HIT_SPELL_FIRE;
	int iShapeEffect = VFXSC_DUR_COMBUSTION_GREEN; 
	int iDamageType = CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_FIRE, iDescriptor );
	if ( iDamageType != DAMAGE_TYPE_FIRE )
	{
		iHitEffect = CSLGetHitEffectByDamageType( iDamageType );
		iSaveType = CSLGetSaveTypeByDamageType( iDamageType );
		iShapeEffect = VFXSC_DUR_COMBUSTION_GREEN; 
	}
	

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 4;
	int 	iNumDice 		= 2;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	int iRemainingRounds = GetLocalInt(OBJECT_SELF,"REMAINING_ROUNDS");

	if(iRemainingRounds>10) iRemainingRounds=10;
	
	
	
	
	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
	int iSpellPower = HkGetSpellPower( oCaster );
	//object  oTarget = HkGetSpellTarget();
	float fDuration = HkApplyDurationCategory(iRemainingRounds);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE, oTarget  );
	effect eAOE = EffectAreaOfEffect(AOE_CUSTOM_SMALL,"****","SP_fireauraD","****", sAOETag);
	eAOE = EffectLinkEffects(eAOE, EffectVisualEffect( iShapeEffect ) );
	eAOE = EffectLinkEffects(eAOE, EffectAttackDecrease(2) );
	
	effect eHitEffect = EffectDamage(iDamage, iDamageType);
	effect eVisualEffect = EffectVisualEffect(iHitEffect);
	

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(oTarget!=oCaster)
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FIRE_AURA, TRUE));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHitEffect, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
		if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_FIRE, oCaster))
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration );
		}
	}
}