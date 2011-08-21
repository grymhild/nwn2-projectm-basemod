//::///////////////////////////////////////////////
//:: Fire Aura
//:: sg_s0_FireAura.nss
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
aura of magical green fire.  The fire aura extends 1 foot
from your body and provides illumination in a 10-foot
radius.  The fire aura provides a resistance of 20 to both
natural and magical fire; the flames can be extinguished
only by dispel magic or a similar spell.  Those touching
the fire aura suffer 2d4 hit points of fire damage; additionally,
if the touched victim failes to make his Reflex saving throw,
his body is set afire with green flames.
The flames persist for a maximum of 10 rounds.  Each round the
victim is engulfed in these flames, he suffers an additional
1-6 hit points of fire damage;  the victim's attack rolls are made
with a -2 penalty during this time.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 10, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
// 
//
//     object  oTarget         = oCaster;
//
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
    //--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFXSC_DUR_COMBUSTION_GREEN, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	effect eAOE = EffectAreaOfEffect( AOE_MOB_FIRE_AURA, "", "", "", sAOETag );
	eAOE = EffectLinkEffects(eAOE, EffectDamageResistance(iDamageType, 20) );
	eAOE = EffectLinkEffects(eAOE, EffectVisualEffect( iShapeEffect ) );
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_FIRE_AURA, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);

    HkPostCast(oCaster);
}


