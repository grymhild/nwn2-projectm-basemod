//::///////////////////////////////////////////////
//:: Flash
//:: SG_S0_Flash.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Creates a flash of blinding light.  Creatures
     must make reflex save or be blinded for 1d3
     rounds.

     Light sensitive creatures add +5 to DC and are
     blinded 1 additional round.

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
//     SGSetSpellInfo( );
// 
//
//     object  oTarget;         //= HkGetSpellTarget();
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
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
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkApplyMetamagicVariableMods( d3(1), 3 ) ) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);	
    float   fDelay;
    float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	int iDC;
	
	//--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eBlind   = EffectBlindness();
    effect eVis     = EffectVisualEffect(VFX_FNF_WORD);
    effect eImp     = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        iDC = HkGetSpellSaveDC(oCaster, oTarget);
        if(CSLGetIsLightSensitiveCreature(oTarget))
        {
            iDC+=5;
            fDuration+=HkApplyDurationCategory(1);
        }
        SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_FLASH));
        if(!HkResistSpell(oCaster,oTarget) && oTarget!=oCaster)
        {
            if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC))
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDuration);
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
    }

    HkPostCast(oCaster);
}

