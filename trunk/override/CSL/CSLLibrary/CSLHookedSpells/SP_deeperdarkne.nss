//::///////////////////////////////////////////////
//:: Deeper Darkness
//:: sg_s0_deepdark.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation [Darkness]
     Level: Clr 3
     Components: V,S
     Casting Time: 1 action
     Range: Touch
     Target: Object touched
     Duration: 1 day (24 hours)/level
     Saving Throw: None
     Spell Resistance: No

     The spell causes the object touched to shed absolute
     darkness in a 60 foot radius.  Even creatures who can
     normally see in the dark cannot see through this
     magical darkness.

     Deeper Darkness counters or dispels any light spell of
     equal or lower level, including Daylight or Light.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 4, 2004
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_DAYS) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_MOB_DEEPER_DARKNESS, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(!CSLEnviroGetIsHigherLevelLightEffectsInArea( lImpactLoc, iSpellLevel ) )
	{
		if ( CSLEnviroRemoveLowerLevelLightEffectsInArea( lImpactLoc, iSpellLevel ) )
		{
			SendMessageToPC( oCaster, "The Light Was Extinguished By Darkness");
		}

        HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lImpactLoc, fDuration);
	}
	else
	{
		SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Light");
	}

    HkPostCast(oCaster);
}