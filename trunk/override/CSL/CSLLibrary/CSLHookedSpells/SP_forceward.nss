//::///////////////////////////////////////////////
//:: Forceward
//:: sg_s0_forceward.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration
     Level: Clr 3 (Helm), Pal 3
     Components: V, S
     Casting Time: 1 full round
     Range: 10 ft.
     Area: 10-ft-radius emanation centered on you
     Duration: 1 minute/level
     Saving Throw: Will negates
     Spell Resistance: Yes

     You create an unmoving, transparent sphere of
     force sentered on your location.  The sphere
     illuminates its interior and everything within
     5 feer of its edge.  You and your allies may
     enter the sphere at will.
     Any other creature that tries to enter the sphere
     must make a Will saving throw, otherwise it cannot
     pass into the area defined by the sphere.  A
     creature may leave the area freely, although it
     must make a Will save to enter again, even if the
     creature is you or one of your allies.  Creatures
     within the area when the spell is cast are not
     forced out.
     The forceward does not prevent spells or objects
     from entering the forceward, so it is possible for
     two creatures on opposite sides of the forceward's
     edge to fight without penalties.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 3, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//     location lTarget        = GetLocation(oCaster);
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
//     //int     iDieType        = 0;
//     //int     iNumDice        = 0;
//     //int     iBonus          = 0;
//     //int     iDamage         = 0;
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	//int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	location lTarget = GetLocation(oCaster);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	string sAOETag = HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_FORCEWARD, "", "", "", sAOETag);
    eAOE = EffectLinkEffects(eAOE, EffectVisualEffect(VFX_DUR_LIGHT_WHITE_15) );

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

    HkPostCast(oCaster);
}


