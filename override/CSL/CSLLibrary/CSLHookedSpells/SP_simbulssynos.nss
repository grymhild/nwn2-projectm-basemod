//::///////////////////////////////////////////////
//:: The Simbul's Synostodweomer
//:: sg_s0_simsynost.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Transmutation
     Level: Sor/Wiz 7
     Components: V, S
     Casting Time: 1 full round
     Range: Personal
     Target: One of your spells
     Duration: 1 round
     Saving Throw: None
     Spell Resistance: Yes

     You channel the spell energy from a spell you know
     into healing magic.  After you cast this spell, on
     your next turn you cast another spell, which is
     converted to positive energy. On the round you cast
     the second spell, you may touch yourself or another
     creature, curing 1d6 hit points of damage for every
     spell level of the spell you cast.  If the spell
     you cast was prepared with a metamagic feat, you
     use the level of the spell slot the spell occupied.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 9, 2004
//:://////////////////////////////////////////////

//#include "sg_i0_spconst"
//
//
//
// 
// void main()
// {
// 
//     SGSetSpellInfo( );
// 
//
//     object  oTarget         = oCaster;
//
//
//     int     iMetamagic      = ;
// 
//     /* Although the duration states 1 round, I want to make sure the player can fire off another
//        spell, so I set it to 2.  The function in sg_i0_spells removes the spell effect from the caster,
//        so they would not be able to do this multiple times without recasting this spell. */
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
    effect eDur     = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_SIMBULS_SYNOSTODWEOMER, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration);
    SetLocalInt(oCaster, "SIMBULS_SYNOST_MM", HkGetMetaMagicFeat());

    HkPostCast(oCaster);
}


