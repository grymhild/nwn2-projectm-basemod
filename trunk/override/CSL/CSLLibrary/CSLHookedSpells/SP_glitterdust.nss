//::///////////////////////////////////////////////
//:: Glitterdust
//:: SG_S0_GltDust.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Conjuration (Creation)
	Level: Brd 2, Sor/Wiz 2
	Components: V,S
	Casting Time: 1 action
	Range: Medium (100 ft + 10 ft/level)
	Area: Creatures and objects within a 10-ft spread
	Duration: 1 round/level
	Saving Throw: Will negates (Blinding Only )
	Spell Resistance: No
	
	A cloud of golden particles covers everyone and everything in the area, blinding creatures and
	visibly outlining invisible things for the duration of the spell.  All within the area are covered
	by the dust, which cannot be removed and continues to sparkle until it fades.
	
	From SRD
	A cloud of golden particles covers everyone and everything in the area, causing creatures to become
	blinded and visibly outlining invisible things for the duration of the spell. All within the area
	are covered by the dust, which cannot be removed and continues to sparkle until it fades.
	
	Any creature covered by the dust takes a -40 penalty on Hide checks.
	
	This does not affect Ethereal, Astral, or Incorporeal Creature

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GLITTERDUST; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, -1.0f, FALSE  );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_GLITTERDUST, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

    HkPostCast(oCaster);
}


