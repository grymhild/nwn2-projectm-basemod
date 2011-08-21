//::///////////////////////////////////////////////
//:: Antilife Shell
//:: sg_s0_antilife.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration
     Level: Animal 6, Clr 6, Drd 6
     Components: V, S, DF
     Casting time: 1 Full Round
     Range: 10 ft
     Area: 10 ft radius centered on you
     Duration: 10 minutes/level
     Saving Throw: None
     Spell Resistance: Yes

     You bring into being a mobile, hemispherical energy
     field that prevents the entrance of most sorts of
     living creatures.  The effect hedges out animals,
     aberrations, beasts, magical beasts, dragons, fey,
     giants, humanoids, monstrous humanoids, oozes, plants,
     shapechangers, and vermin, but not constructs,
     elementals, outsiders, or undead.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 28, 2004
//:://////////////////////////////////////////////
// 
// //#include "sg_inc_elements"
//
// 
// 
// void main()
// {
// 
//
//     int     iMetamagic      = HkGetMetaMagicFeat();


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
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
	
	int iCasterLevel = HkGetCasterLevel(oCaster);

	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(10*iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_IMP_GOOD_HELP);  // Visible impact effect
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_ANTILIFE_SHELL, "", "", "", sAOETag);
    effect eLink    = EffectLinkEffects(eDur,eAOE);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster, EventSpellCastAt(oCaster,SPELL_ANTILIFE_SHELL,FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);

    HkPostCast(oCaster);
}


