//::///////////////////////////////////////////////
//:: Azuth's Spell Shield
//:: sg_s0_azspshld.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration
     Level: Clr 7 (Azuth)
     Components: V,S,DF
     Casting Time: 1 action
     Range: Close (25 ft + 5 ft/2 levels)
     Targets: Up to one creature/level, maximum of 17,
        in a 15' radius from the initial target.
     Duration: 1 round/level (see text)
     Saving Throw: Will negates (harmless)
     Spell Resistance: Yes (harmless)

     Each targeted creature gains spell resistance equal
     to 12 + caster level.  Divide the duration evenly
     among all the targeted creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 19, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int     iNumTargets;
    switch(iSpellId)
    {
        case SPELL_AZUTH_SPELL_SHIELD:
        case SPELL_AZUTH_SPSH1:
            iNumTargets=1;
            break;
        case SPELL_AZUTH_SPSH3:
            iNumTargets=3;
            break;
        case SPELL_AZUTH_SPSH5:
            iNumTargets=5;
            break;
        case SPELL_AZUTH_SPSH10:
            iNumTargets=10;
            break;
        case SPELL_AZUTH_SPSH15:
            iNumTargets=15;
            break;
    }
    if( iNumTargets > iCasterLevel )
    {
        iNumTargets=iCasterLevel;
    }
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 )/iNumTargets;
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
    int     iSpellResist    = 12+iCasterLevel;
    int     iTotalDuration  = iCasterLevel;
    float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
    
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


    
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eSpellResist = EffectSpellResistanceIncrease(iSpellResist);
    effect eVis         = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink        = EffectLinkEffects(eSpellResist, eVis);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget) && iNumTargets>0) {
        if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_ALLALLIES,oCaster)) {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_AZUTH_SPELL_SHIELD, FALSE));
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
        iNumTargets--;
    }

    HkPostCast(oCaster);
}


