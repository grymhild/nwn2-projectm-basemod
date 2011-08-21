//::///////////////////////////////////////////////
//:: Disappear
//:: sg_s0_Disappear.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Caster disappears in a blue puff of smoke

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
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
#include "_HkSpell"
#include "_SCInclude_Invisibility"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	object oTarget = oCaster;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	///int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTarget        = GetLocation(oCaster);



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    //effect eInvis   = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    //effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    //effect eLink    = EffectLinkEffects(eInvis, eDur);
    effect eSmoke   = EffectVisualEffect(VFXSC_FNF_BURST_MEDIUM_SMOKEPUFF);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SCApplyInvisibility( oTarget, oCaster, fDuration, SPELL_DISAPPEAR, 0 );
	
	//location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	//effect eImpactVis = EffectVisualEffect( iImpactSEF );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //SignalEvent(oCaster, EventSpellCastAt(OBJECT_SELF, SPELL_DISAPPEAR, FALSE));
   /// HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSmoke, lTarget);

    HkPostCast(oCaster);
}


